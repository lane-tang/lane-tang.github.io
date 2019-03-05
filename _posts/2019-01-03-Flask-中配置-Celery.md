---
layout: post
title:  "Flask 中配置 Celery"
date:   2019-01-03 21:14:00 +0800
categories:
- Python
- Flask
comments: true
---
当服务器在处理需要长时间运行的任务或者定期运行任务的时候,比如处理上传的文件或是发送一份邮件,这种情况下一般是不会在一次请求的过程中等所有任务完成才返回的。而是在立即返回请求的同时，将需要处理的任务通过队列发送给另一个进程在后台处理，这时候 Celery 就派上用场了。
Celery 作为一个强大的异步任务队列处理框架,既支持任务实时执行,也支持任务调度；既能在单线程下，也可以在多线程下运行；既支持同步，也可以异步运行任务。
但是因为依赖于 RabbitMQ 或是 Redis 之类的消息分发程序， Celery 的搭建相对比较麻烦，这里以 Flask 为例，作一个简单的说明。

## 安装
使用 pip 可以很方便的安装 Celery 的包：
```shell
$ pip install celery
```

## 配置
有关在 Flask 中集成 Celery 的必要配置，可以在 Flask 的官方[文档](http://flask.pocoo.org/docs/1.0/patterns/celery/#configure)中找到：
```python
from celery import Celery

def make_celery(app):
  celery = Celery(
    app.import_name,
    backend=app.config['CELERY_RESULT_BACKEND'],
    broker=app.config['CELERY_BROKER_URL']
  )
  celery.conf.update(app.config)

  class ContextTask(celery.Task):
    def __call__(self, *args, **kwargs):
      with app.app_context():
        return self.run(*args, **kwargs)

  celery.Task = ContextTask
  return celery
```
上面的一段代码用 Flask 配置中描述的消息分发程序信息，实例化了一个 Celery 对象，之后用 Flask 的配置更新 Celery 的配置，最后将 Clery 的任务执行封装在 Flask 应用的环境中。

## 例子
写一个简单的 Flask 应用来模拟需要长时间运行的任务。
```python
from flask import Flask, jsonify

app = Flask(__name__)
app.config['CELERY_BROKER_URL'] = 'redis://localhost:6379'
app.config['CELERY_RESULT_BACKEND'] = 'redis://localhost:6379'

celery = make_celery(app)

@app.route('/longtask', methods=['POST'])
def longtask():
  task = long_task.apply_async()
  return jsonify({'task_id': task.id})

@app.route('/status/<task_id>')
def taskstatus(task_id):
  task = long_task.AsyncResult(task_id)

  if task.state == 'PENDING':
    response = {
      'state': task.state,
      'current': 0,
      'total': 100,
    }
  elif task.state != 'FAILURE':
    response = {
      'state': task.state,
      'current': task.info.get('current', 0),
      'total': task.info.get('total', 100),
    }
  else:
    response = {
      'state': task.state,
      'current': 100,
      'total': 100,
    }

  return jsonify(response)

@celery.task(name='app.long_task', bind=True)
def long_task(self):
  for i in range(100):
    self.update_state(state='PROGRESS', meta={'current': i, 'total': 100})
    time.sleep(1)

  return {'current': 100, 'total': 100}
```
