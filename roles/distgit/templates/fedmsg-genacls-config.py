config = {
    'genacls.consumer.enabled': False,
    'genacls.consumer.delay': 5, # 5 seconds

    # New world
    'gitoliteprefix.consumer.enabled': True,
    'gitoliteprefix.consumer.delay': 5, # 5 seconds
    'gitoliteprefix.consumer.filename': '/var/tmp/gitolite-prefix.txt',
    'gitoliteprefix.consumer.fasurl': 'https://admin.fedoraproject.org/accounts',
    'gitoliteprefix.consumer.username': "{{ blockerbugs_fas_user }}",
    'gitoliteprefix.consumer.password': '{{ blockerbugs_fas_password }}',
}
