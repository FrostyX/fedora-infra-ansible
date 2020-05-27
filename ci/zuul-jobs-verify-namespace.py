#!/usr/bin/env python3

import sys
import traceback

import yaml


errors_found = False

for zuul_yaml_file in sys.argv[1:]:
    print(f"Processing {zuul_yaml_file!r}...", flush=True)
    with open(zuul_yaml_file, "r") as yaml_stream:
        for doc_no, yaml_doc in enumerate(yaml.safe_load_all(yaml_stream), 1):
            print(f"Verifying YAML doc #{doc_no}...", flush=True)
            yaml_doc_errors_found = False
            try:
                for item in yaml_doc:
                    if "job" in item:
                        job = item["job"]
                        if not job["name"].startswith("fi-ansible--"):
                            yaml_doc_errors_found = errors_found = True
                            print(
                                f"Locally defined Zuul job {job['name']!r} must be named"
                                " 'fi-ansible-...'"
                            )
            except Exception:
                yaml_doc_errors_found = errors_found = True
                traceback.print_exc()

            if yaml_doc_errors_found:
                print(f"Verification failed.", flush=True)
            else:
                print(f"Verification passed.", flush=True)

sys.exit(errors_found)
