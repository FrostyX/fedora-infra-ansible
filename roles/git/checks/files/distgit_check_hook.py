#!/usr/bin/python

"""
This script goes through all the git repos in dist-git and adjust their
git hook so they are always as expected.

"""
import argparse
import os
import sys
from pathlib import Path

import pagure


pagure_hookrunner = Path(pagure.__file__).parent / "hooks" / "files" / "hookrunner"

_base_path = Path('/srv/git/repositories/')

# hook name: link target (project), link target (fork, if different)
hook_defs = {
    "post-receive": (
        "/usr/share/git-core/post-receive-chained",
        "/usr/share/git-core/post-receive-chained-forks",
    ),
    "pre-receive": (pagure_hookrunner,),
    "update": (pagure_hookrunner,),
}

namespaces = ['rpms', 'container', 'forks', 'modules', 'tests']


def parse_args():
    """ Parses the command line arguments. """
    parser = argparse.ArgumentParser(
        description='Check the git hook situation for all repos in dist-git')
    parser.add_argument(
        'target', nargs='?', help='git repo to check')
    parser.add_argument(
        '--namespace', default=None,
        help="Only operate on a certain namespace, not all of them.")
    parser.add_argument(
        '--check', default=False, action="store_true",
        help='Only check the git hooks, do not fix them')

    return parser.parse_args()


def fix_link(hook: Path, target_link: Path):
    """ Remove the existing hook and replace it with a symlink to the desired
    one.
    """
    if hook.is_symlink() or hook.exists():
        hook.unlink()
    hook.symlink_to(target_link)


def is_valid_hook(hook: Path, target_link: Path) -> bool:
    """ Simple utility function checking if the specified hook is valid. """
    output = True
    if not hook.is_symlink():
        print('%s is not a symlink' % hook)
        output = False
    else:
        target = Path(os.readlink(hook))
        if target != target_link:
            print('%s is not pointing to the expected target: %s' % (
                hook, target_link))
            output = False
    return output


def test_and_fix_repo_hooks(repo_path, is_fork=False, check=False):
    hook_base = Path(repo_path) / "hooks"

    for hook, hook_def in hook_defs.items():
        if is_fork:
            link_target = Path(hook_def[-1])
        else:
            link_target = Path(hook_def[0])

        hook_path = hook_base / hook

        if not is_valid_hook(hook_path, link_target) and not check:
            fix_link(hook_path, link_target)


def process_namespace(namespace, check, walk=False):
    """ Process all the git repo in a specified namespace. """
    is_fork = namespace == "forks"

    print('Processing: %s' % namespace)
    path = _base_path / namespace
    if not path.is_dir():
        return

    if walk:
        for dirpath, dirnames, filenames in os.walk(path):
            # Don't go down the .git repos
            if dirpath.endswith(".git"):
                continue

            for repo in dirnames:
                repo_path = Path(dirpath, repo)
                if repo_path.suffix != '.git':
                    continue

                test_and_fix_repo_hooks(repo_path, is_fork=is_fork, check=check)
    else:
        for repo_path in path.iterdir():
            if repo_path.suffix != '.git':
                continue

            test_and_fix_repo_hooks(repo_path, is_fork=is_fork, check=check)


def main():
    """ This is the main method of the program.
    It parses the command line arguments. If a specific repo was specified
    it will only check and adjust that repo.
    Otherwise, it will check and adjust all the repos.
    """

    args = parse_args()
    if args.target:
        path = Path(args.target)
        # Update on repo
        print('Processing: %s' % path)

        is_fork = "forks" in path.parts

        # Don't prefix absolute paths with _base_path
        if not path.is_absolute():
            path = _base_path / path

        if path.suffix != ".git":
            path = path.with_name(path.name + ".git")

        if not path.is_dir():
            print('Git repo: %s not found on disk' % path)

        test_and_fix_repo_hooks(path, is_fork=is_fork, check=args.check)

    elif args.namespace:
        walk = False
        if args.namespace == 'forks':
            walk = True
        process_namespace(args.namespace, args.check, walk=walk)
    else:
        # Check all repos
        for namespace in namespaces:
            walk = False
            if namespace == 'forks':
                walk = True
            process_namespace(namespace, args.check, walk=walk)


if __name__ == '__main__':
    sys.exit(main())
