

from locust import HttpUser, TaskSet, task, between
from locust.contrib.fasthttp import FastHttpUser
import json
from random import randint 
from faker import Faker

    
class EHClient(TaskSet):
    
    @task
    def on_start(self):   

        fake=Faker('en_US')
    
        sb_name={service-bus-name}
        eh_name={event-hub-name}

        #randomized data package for testing to avoid false fail nums
        data=json.dumps({'age':randint(0,100), 'name':fake.name()})

        tokt= {
        'Authorization': 'SharedAccessSignature sr={signature}',
        'Content-Type':'application/atom+xml;type=entry;charset=utf-8',
        'Host':{host-uri}
        }


        #Host URL for connection
        URL=("https://{}.servicebus.windows.net/{}/messages").format(sb_name,eh_name)

        
        self.client.post(path=URL,headers=tokt,data=data)

        
        
class WebsiteUser(FastHttpUser):
    sb_name={service-bus-name}
    eh_name={event-hub-name}
    wait_time=between(0,0)
    host=("https://{}.servicebus.windows.net/{}/messages").format(sb_name,eh_name)
    
    tasks = [EHClient]
