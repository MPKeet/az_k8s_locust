FROM python:3.8

COPY locust-tasks /locust-tasks
COPY run.sh .

RUN pip install -r /locust-tasks/requirements.txt


EXPOSE 5557 5558 8089

RUN chmod 755 run.sh
RUN pwd

ENTRYPOINT ["bash", "./run.sh"]
# turn off python output buffering
ENV PYTHONUNBUFFERED=1
