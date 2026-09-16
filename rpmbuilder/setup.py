#! /usr/bin/env python

"""
Create spec files from guthub repos using a jinja2 template

This module installs github2spec as a binary.
"""

import codecs
import os
import re
import pathlib
from setuptools import find_packages
from setuptools import setup

# The directory containing this file
HERE = pathlib.Path(__file__).parent

# The text of the requirements file
INSTALL_REQUIREMENTS = (HERE / "requirements.txt").read_text().split('\n')

# The text of the README file
README = (HERE / "README.md").read_text()

with open(HERE / 'requirements.txt', encoding='utf-8') as reqfile:
    INSTALL_REQUIREMENTS = reqfile.read().split('\n')


def find_version():
    """Read the rpmbuilder version from github2spec/__init__.py."""
    here = os.path.abspath(os.path.dirname(__file__))
    with codecs.open(os.path.join(here, 'github2spec', '__init__.py'),
                     'r') as file_pointer:
        version_file = file_pointer.read()
    version_match = re.search(r"^__version__ = ['\"]([^'\"]*)['\"]",
                              version_file, re.M)
    if version_match:
        return version_match.group(1)
    raise RuntimeError("Unable to find version string.")


setup(
    name='github2spec',
    version=find_version(),
    description="A tool for building RPM's from github repo's with singleton "
                "binaries",
    long_description=README,
    long_description_content_type="text/markdown",
    url="https://github.com/pgvillage-build/rpmbuilder",
    author="Sebastiaan Mannem",
    author_email="sebas@mannem.nl",
    license="GPL-3.0-or-later",
    classifiers=[
        "License :: OSI Approved :: GNU General Public License v3 (GPLv3)",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
    ],
    include_package_data=True,
    packages=find_packages(exclude=['contrib', 'docs', 'tests']),
    install_requires=INSTALL_REQUIREMENTS,
    entry_points={
        'console_scripts': [
            'github2spec=github2spec.commandline:from_config',
        ]
    }
)
