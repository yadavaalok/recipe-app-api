FROM python:3.9-alpine3.13
LABEL maintainer="yadavaalok"

ENV PYTHONBUFFERED 1

# Copy requirements files
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./scripts /scripts

# create app directory and copy the code
RUN mkdir /app
COPY ./app /app

# set the working directory
WORKDIR /app

# expose port
EXPOSE 8080

# Install dependencies
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip setuptools && \
    apk add --update --no-cache postgresql-client jpeg-dev && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev zlib zlib-dev linux-headers && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    mkdir -p /vol/web/media && \
    mkdir -p /vol/web/static && \
    chmod -R +x /scripts


# set the path
ENV PATH="/scripts:/py/bin:$PATH"

CMD ["run.sh"]