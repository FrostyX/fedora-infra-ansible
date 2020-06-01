config = dict(
    irc=[
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fedmsg-stg',
            channel='fedora-fedmsg-stg',
            {% else %}
            nickname='fedmsg-bot',
            channel='fedora-fedmsg',
            {% endif %}

            filters=dict(
                topic=[
                    # Ignore some of the koji spamminess
                    'buildsys.package.list.change',
                    'buildsys.repo.init',
                    'buildsys.repo.done',
                    'buildsys.untag',
                    'buildsys.tag',
                    # And some of the FAF/ABRT spamminess
                    'faf.report.threshold1',
                    'faf.problem.threshold1',
                    # And some resultsdb spam
                    'resultsdb.result.new',
                ],
                body=[],
            ),
        ),

        # For fedora-admin
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fm-stg-admin',
            {% else %}
            nickname='fm-admin',
            {% endif %}
            channel='fedora-admin',
            filters=dict(
                topic=[
                    '^((?!(pagure)).)*$',
                ],
                body=[
                    "^((?!(fedora-infrastructure)).)*$",
                ],
            ),
        ),

        # For fedora-apps
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fm-stg-apps',
            {% else %}
            nickname='fm-apps',
            {% endif %}
            channel='fedora-apps',
            filters=dict(
                topic=[
                    '^((?!(github\.create|github\.issue\.|github\.pull_request|github\.commit_comment|github\.star|pagure)).)*$',
                ],
                body=[
                    "^((?!fedora-infra).)*$",
                ],
            ),
        ),

        # For that commops crew!
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='commops-bot-s',
            {% else %}
            nickname='commops-bot',
            {% endif %}
            channel='fedora-commops',
            filters=dict(
                topic=[
                    '^((?!(happinesspacket|fedora_elections|meetbot\.meeting\.item\.help|fedocal\.meeting\.new|fedocal\.meeting\.update|fedocal\.calendar|anitya\.distro\.add)).)*$',
                ],
            ),
        ),
        # A second bot for that commops crew that watches for the term "commops"
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='commops-watch-s',
            {% else %}
            nickname='commops-watch',
            {% endif %}
            channel='fedora-commops',
            filters=dict(
                topic=[
                    '^((?!(pagure.pull-request.new|pagure.issue.new)).)*$',
                ],
                body=['^((?!fedora-commops).)*$'],
            ),
        ),
        # A third one to listen for new Community Blog posts
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fm-commblog-s',
            {% else %}
            nickname='fm-commblog',
            {% endif %}
            channel='fedora-commops',
            filters=dict(
                topic=[
                    '^((?!(planet)).)*$',
                ],
                body=['^((?!communityblog.fedoraproject.org).)*$'],
            ),
        ),
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fm-planet-s',
            {% else %}
            nickname='fm-planet',
            {% endif %}
            channel='fedora-planet',
            filters=dict(
                topic=[
                    '^((?!(planet)).)*$',
                ],
            ),
        ),

        # For that python3 porting fad.  AMAZING!
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fedmsg-python-s',
            {% else %}
            nickname='fedmsg-python',
            {% endif %}
            channel='fedora-python',
            filters=dict(
                topic=[
                    '^((?!(github\.create|github\.issue\.open|github\.pull_request\.open)).)*$',
                ],
                body=[
                    '^((?!(fedora-python)).)*$',
                ],
            ),
        ),

        # Just for the Ask Fedora crew in #fedora-ask
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fm-stg-ask',
            {% else %}
            nickname='fm-ask',
            {% endif %}
            channel='fedora-ask',
            # Only show AskFedora messages
            filters=dict(
                topic=['^((?!(askbot.post.edit|askbot.flag_offensive.add)).)*$'],
            ),
        ),

        # Show only compose msgs to the releng crew.
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fm-stg-releng',
            {% else %}
            nickname='fm-releng',
            {% endif %}
            channel='fedora-releng',
            filters=dict(
                topic=[
                    '^((?!(bodhi.mashtask.complete|pungi.compose.status.change|compose.branched.complete|compose.branched.start|compose.rawhide.complete|compose.rawhide.start|bodhi.updates.|pagure)).)*$',
                ],
                body=[
                    "^((?!(u'success': False|u'status': u'DOOMED'|u'status': u'Retired'|u'prev_status': u'Retired'|compose|bodhi\.updates\.|\/srv\/git\/releng|'name': 'releng'|'name': 'pungi-fedora')).)*$",
                ],
            ),
        ),

        # The proyectofedora crew wants trac messages.
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fm-stg-pfi',
            {% else %}
            nickname='fm-pfi',
            {% endif %}
            channel='#proyecto-fedora',
            # If the word proyecto appears in any message, forward it.
            filters=dict(
                body=['^((?!proyecto).)*$'],
            ),
        ),

        # Similarly for #fedora-latam.
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fm-stg-latam',
            {% else %}
            nickname='fm-latam',
            {% endif %}
            channel='#fedora-latam',
            # If the word fedora-latam appears in any message, forward it.
            filters=dict(
                body=['^((?!fedora-latam).)*$'],
            ),
        ),

        # And for #fedora-g11n
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fm-stg-g11n',
            {% else %}
            nickname='fm-g11n',
            {% endif %}
            channel='#fedora-g11n',
            # If the word i18n/g11n appears in any of below topic message, forward it.
            filters=dict(
                topic=[
                    '^((?!(trac|pagure|planet|mailman|meetbot\.meeting\.complete)).)*$',
                ],
                body=['^((?!(i18n|g11n)).)*$'],
            ),
        ),

        # And #ipsilon
        {% if env == "production" %}
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            nickname='fm-ipsilon',
            channel='#ipsilon',
            # If the word ipsilon appears in any message, forward it.
            filters=dict(
                topic=[
                    '^((?!(pagure)).)*$',
                ],
                body=['^((?!ipsilonpagure).)*$'],
            ),
        ),
        {% endif %}

        # For pagure
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fm-stg-pagure',
            {% else %}
            nickname='fm-pagure',
            {% endif %}
            channel='#pagure',
            filters=dict(
                topic=[
                    '^((?!(github\.star|pagure)).)*$',
                ],
                body=[
                    "^((?!(u'name': u'pagure'|u'name': u'pagure-importer')).)*$",
                ],
            ),
        ),

        # Hook up the design-team
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fm-stg-design',
            {% else %}
            nickname='fm-design',
            {% endif %}
            channel='#fedora-design',
            filters=dict(
                topic=[
                    '^((?!(mailman|pagure.(issue|pull-request).new)).)*$',
                ],
                body=[
                    "^((?!(u'name': u'design')).)*$",
                ],
            ),
        ),

        # And #fedora-docs wants in on the action
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,
            make_short=True,

            {% if env == 'staging' %}
            nickname='fm-stg-docs',
            {% else %}
            nickname='fm-docs',
            {% endif %}
            channel='#fedora-docs',
            filters=dict(
                body=['^((?!\/srv\/git\/docs).)*$'],
            ),
        ),

        # And #fedora-websites
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fm-stg-web',
            {% else %}
            nickname='fm-web',
            {% endif %}
            channel='#fedora-websites',
            # If the word fedora-websites appears in any message, forward it.
            filters=dict(
                topic=[
                    '^((?!(pagure)).)*$',
                ],
                body=['^((?!fedora-websites).)*$'],
            ),
        ),

        # And #fedora-mktg
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fm-stg-mktg',
            {% else %}
            nickname='fm-mktg',
            {% endif %}
            channel='#fedora-mktg',
            # If the word fedora-mktg appears in any pagure message, forward it.
            filters=dict(
                topic=[
                    '^((?!(pagure)).)*$',
                ],
                body=['^((?!fedora-mktg).)*$'],
            ),
        ),

        # And #fedora-modularity-bots
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fm-stg-mod',
            {% else %}
            nickname='fm-mod',
            {% endif %}
            channel='#fedora-modularity-bots',
            # If the word modularity appears in any message, forward it.
            filters=dict(
                topic=[
                    # Ignore some of the ansible and copr spamminess
                    'org.fedoraproject.*.copr.*',
                    'org.fedoraproject.*.ansible.*',
                    # Oh, and koji builds.  We have a lot of those now...
                    'org.fedoraproject.*.buildsys.*',
                ],
                body=['^((?!(modularity|Modularity)).)*$'],
            ),
        ),

        # And #fedora-diversity
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fm-stg-diversity',
            {% else %}
            nickname='fm-diversity',
            {% endif %}
            channel='#fedora-diversity',
            # If the word diversity appears in a new Pagure issue, pull
            # request, or comment, forward it.
            filters=dict(
                topic=['^((?!('
                       'pagure.pull-request.new|'
                       'pagure.issue.new|'
                       'pagure.issue.comment.added)).)*$',
                       ],
                body=['^((?!(diversity|Diversity)).)*$'],
            ),
        ),

        # And #fedora-magazine
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fm-stg-magazine',
            {% else %}
            nickname='fm-magazine',
            {% endif %}
            channel='#fedora-magazine',
            # If the word magazine appears in any message, forward it.
            filters=dict(
                topic=[
                    '^((?!(pagure|planet|badges|fas.group|mailman|meetbot\.meeting)).)*$',
                ],
                body=['^((?!(magazine|Magazine)).)*$',
                      '((?!(fedoramagazine-tips)).)*$',
                      "u'namespace': u'Fedora-Council'"],
            ),
        ),

        # And #fedora-rust
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fm-stg-rust',
            {% else %}
            nickname='fm-rust',
            {% endif %}
            channel='fedora-rust',
            filters=dict(
                topic=[
                    '^((?!(pagure)).)*$',
                ],
                body=[
                    "^((?!((u)?'namespace': (u)?'fedora-rust')).)*$",
                ],
            ),
        ),

        # And #rit-foss
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fm-stg-rit',
            {% else %}
            nickname='fm-rit',
            {% endif %}
            channel='rit-foss',
            filters=dict(
                topic=[
                    '^((?!(mailman)).)*$',
                ],
                body=[
                    "^((?!(fossrit)).)*$",
                ],
            ),
        ),

        # For #fedora-workstation
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fm-stg-workstation',
            {% else %}
            nickname='fm-workstation',
            {% endif %}
            channel='#fedora-workstation',
            filters=dict(
                topic=[
                    '^((?!(pagure)).)*$',
                ],
                body=[
                    "^((?!(fedora-workstation)).)*$",
                ],
            ),
        ),

        # For #koji
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fm-stg-koji',
            {% else %}
            nickname='fm-koji',
            {% endif %}
            channel='koji',
            filters=dict(
                topic=[
                    '^((?!(pagure)).)*$',
                ],
                body=['^((?!(koji)).)*$',
                      "u'fullname': u'koji'"],
            ),
        ),

        # For #fedora-join
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fm-stg-join',
            {% else %}
            nickname='fm-join',
            {% endif %}
            channel='fedora-join',
            filters=dict(
                topic=[
                    '^((?!(pagure)).)*$',
                ],
                body=['^((?!(fedora-join)).)*$',
                ],
            ),
        ),

        # For #fedora-neuro
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fm-stg-neuro',
            {% else %}
            nickname='fm-neuro',
            {% endif %}
            channel='fedora-neuro',
            filters=dict(
                topic=[
                    '^((?!(pagure)).)*$',
                ],
                body=['^((?!(neuro)).)*$',
                ],
            ),
        ),

        # Hook up #fedora-badges with badges messages
        dict(
            network='chat.freenode.net',
            port=6667,
            make_pretty=True,
            make_terse=True,

            {% if env == 'staging' %}
            nickname='fm-stg-badges',
            {% else %}
            nickname='fm-badges',
            {% endif %}
            channel='#fedora-badges',
            filters=dict(
                topic=[
                    '^((?!(pagure.*(new|added)|mailman)).)*$',
                ],
                body=['^((?!(fedora-badges|badges)).)*$'],
            ),
        ),

    ],

    ### Possible colors are ###
    # "white",
    # "black",
    # "blue",
    # "green",
    # "red",
    # "brown",
    # "purple",
    # "orange",
    # "yellow",
    # "light green",
    # "teal",
    # "light cyan",
    # "light blue",
    # "pink",
    # "grey",
    # "light grey",
    irc_color_lookup = {
        "fas": "light blue",
        "bodhi": "green",
        "git": "red",
        "wiki": "purple",
        "logger": "orange",
        "buildsys": "yellow",
        "fedoraplanet": "light green",
        "trac": "pink",
        "askbot": "light cyan",
        "fedbadges": "brown",
        "fedocal": "purple",
        "copr": "red",
        "anitya": "light cyan",
        "fmn": "light blue",
        "hotness": "light green",
    },

    # This may be 'notice' or 'msg'
    irc_method='msg',
)
