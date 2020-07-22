import socket

config = dict(
    sign_messages=True,
    active=True,
    cert_prefix="greenwave",
    certnames={
      "greenwave." + socket.gethostname(): "greenwave",
    },

    logging={
      "loggers": {
          "greenwave": {
              "handlers": ["console"], "propagate": True, "level": "DEBUG"},
          "fedora_messaging": {
              "handlers": ["console"], "propagate": False, "level": "DEBUG"},
          "moksha": {
              "handlers": ["console"], "propagate": False, "level": "DEBUG"},
          "requests": {
              "handlers": ["console"], "propagate": False, "level": "DEBUG"},
          "resultsdb_handler": {
              "handlers": ["console"], "propagate": False, "level": "DEBUG"},
          "waiverdb_handler": {
              "handlers": ["console"], "propagate": False, "level": "DEBUG"},
          "fedora_messaging_consumer": {
              "handlers": ["console"], "propagate": False, "level": "DEBUG"},
      },
      "handlers": {
          "console": {
              "formatter": "bare",
              "class": "logging.StreamHandler",
              "stream": "ext://sys.stdout",
              "level": "DEBUG"
          }
      },
    },

    greenwave_cache={
      'backend': 'dogpile.cache.memcached',
      'expiration_time': 3600, # 3600 is 1 hour
      'arguments': {
          'url': 'greenwave-memcached:11211',
          'distributed_lock': True
      }
    },
    resultsdb_topic_suffix="resultsdb.result.new",

    {% if env == 'staging' %}
    environment='stg',
    relay_inbound=["tcp://busgateway01.stg.iad2.fedoraproject.org:9941"],
    greenwave_api_url='https://greenwave.stg.fedoraproject.org/api/v1.0',
    # STG greenwave should listen to the STG bus.
    endpoints=dict(
        staging_gateway=[
            'tcp://stg.fedoraproject.org:9940',
        ],
    ),
    {% else %}
    environment='prod',
    relay_inbound=["tcp://busgateway01.iad2.fedoraproject.org:9941"],
    greenwave_api_url='https://greenwave.fedoraproject.org/api/v1.0'
    {% endif %}
)
