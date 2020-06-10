config = {
    # This is for *our* database
    "fmn.sqlalchemy.uri": "postgresql://{{notifs_db_user}}:{{notifs_db_password}}@db01.iad2.fedoraproject.org/notifications",
    # And this is for the datanommer database
    "datanommer.sqlalchemy.url": "postgresql://{{datanommerDBUser}}:{{datanommerDBPassword}}@db-datanommer01.iad2.fedoraproject.org/datanommer",

    {% if env == 'staging' %}
    "fmn.backends": ["email", "irc", "android"],
    {% else %}
    "fmn.backends": ["email", "irc"],  # android is disabled.
    {% endif %}

    "fmn.web.default_login": "fedora_login",

    {% if env == 'staging' %}
    "fas_credentials": {
        "username": "{{fedoraDummyUser}}",
        "password": "{{fedoraDummyUserPassword}}",
        "base_url": "https://admin.stg.fedoraproject.org/accounts",
    },
    {% else %}
    "fas_credentials": {
        "username": "{{fedoraDummyUser}}",
        "password": "{{fedoraDummyUserPassword}}",
    },
    {% endif %}

    # We need to know this to call VERFY to validate new addresses.
    "fmn.email.mailserver": "bastion01.phx2.fedoraproject.org:25",

    # Some configuration for the rule processors
    "fmn.rules.utils.use_pkgdb2": False,
    "fmn.rules.utils.use_pagure_for_ownership": True,
    {% if env == 'staging' %}
    "fmn.rules.utils.pagure_api_url": "https://src.stg.fedoraproject.org/api/",
    {% else %}
    'fmn.rules.utils.pagure_api_url': 'https://src.fedoraproject.org/api/',
    {% endif %}

    "fmn.rules.cache": {
        "backend": "dogpile.cache.memcached",
        "expiration_time": 3600,  # 3600 is 1 hour
        "arguments": {
            "url": "memcached01:11211",
        },
    },
}
