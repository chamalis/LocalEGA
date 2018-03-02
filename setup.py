from setuptools import setup
from lega import __version__

setup(name='lega',
      version=__version__,
      url='http://lega.nbis.se',
      license='Apache License 2.0',
      author='NBIS System Developers',
      author_email='ega@nbis.se',
      description='Local EGA',
      long_description='''\
LocalEGA ingests into its vault, files that are dropped in some inbox.

The program is divided into several components interconnected via a
message broker and a database.

Users are handled throught Central EGA, directly.
''',
      packages=['lega', 'lega/utils', 'lega/conf'],
      include_package_data=False,
      package_data={ 'lega': ['conf/loggers/*.yaml', 'conf/defaults.ini'] },
      zip_safe=False,
      entry_points={
          'console_scripts': [
              'ega-ingest = lega.ingest:main',
              'ega-fs = lega.fs:main',
              'ega-vault = lega.vault:main',
              'ega-verify = lega.verify:main',
              'ega-monitor = lega.monitor:main',
              'ega-keyserver = lega.keyserver:main',
              'ega-conf = lega.conf.__main__:main',
              #'ega-pgp-decrypt = lega.openpgp.__main__:main',
          ]
      },
      platforms = 'any',
      # install_requires=[
      #     'pika==0.11.0',
      #     'aiohttp==2.3.8',
      #     'pycryptodomex==3.4.7',
      #     'aiopg==0.13.0',
      #     'colorama==0.3.7',
      #     'aiohttp-jinja2==0.13.0',
      #     'fusepy',
      # ],
)
