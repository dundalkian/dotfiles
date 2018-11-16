from configparser import ConfigParser
import subprocess

import praw

def config(filename='config.ini', section='reddit_credentials'):
    parser = ConfigParser()
    parser.read(filename)

    creds = {}
    if parser.has_section(section):
        params = parser.items(section)
        for param in params:
            creds[param[0]] = param[1]
    else:
        raise Exception('Section {0} not found in the {1} file. Have you created a config file in the project folder?'.format(section, filename))
    return creds

creds = config()

reddit = praw.Reddit(client_id=creds['client_id'], client_secret=creds['client_secret'],
                     password=creds['password'],
                     user_agent='bg-fetch by /u/{0}'.format(creds['username']),
                     username=creds['username'])

submissions = reddit.subreddit('MinimalWallpaper').hot(limit=10)

subprocess.call(args=["rm /home/larry/.backgrounds/*"], shell=True)
for post in submissions:
    if ".jpg" in post.url or ".png" in post.url:
        subprocess.Popen(args=["wget", "{}".format(post.url), "-nc", "-o", "/dev/null", "-P", "/home/larry/.backgrounds"])
