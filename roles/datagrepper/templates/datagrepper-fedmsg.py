# Configuration for the datagrepper webapp.
config = {
    # We don't actually want to run the datanommer consumer on this machine.
    'datanommer.enabled': False,

    # Note that this is connecting to db02.  That's fine for now, but we want to
    # move the db for datanommer to a whole other db host in the future.  We
    # expect the amount of data it generates to grow pretty steadily over time
    # and we don't want *read* operations on that database to slow down all our
    # other apps.
    {% if environment == "staging" %}
    'datanommer.sqlalchemy.url': 'postgresql://{{ datanommerDBUser }}:{{ datanommerDBPassword }}@db-datanommer01.stg.phx2.fedoraproject.org/datanommer',
    {% else %}
    'datanommer.sqlalchemy.url': 'postgresql://{{ datanommerDBUser }}:{{ datanommerDBPassword }}@db-datanommer01.phx2.fedoraproject.org/datanommer',
    {% endif %}
    'fedmsg.consumers.datagrepper-runner.enabled': True,
}

