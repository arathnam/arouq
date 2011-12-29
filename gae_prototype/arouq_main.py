import cgi
import datetime
import os
import urllib
import wsgiref.handlers

from google.appengine.ext import db
from google.appengine.api import users
from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app
from google.appengine.ext.webapp import template

from utils import pretty_date

class Greeting(db.Model):
  """Models an individual Guestbook entry with an author, content, and date."""
  author = db.StringProperty()
  author_email = db.StringProperty()
  content = db.StringProperty(multiline=True)
  date = db.DateTimeProperty(auto_now_add=True)


def guestbook_key(guestbook_name=None):
  """Constructs a datastore key for a Guestbook entity with guestbook_name."""
  return db.Key.from_path('Guestbook', guestbook_name or 'DefaultGuestbook')


class MainPage(webapp.RequestHandler):
  def get(self):
    guestbook_name = self.request.get('guestbook_name')
    greetings_query = Greeting.all().ancestor(
      guestbook_key(guestbook_name)).order('-date')
    greetings = greetings_query.fetch(10)

    # Set the pretty date.
    for greeting in greetings:
      greeting.pretty_date = pretty_date(greeting.date)

    template_values = {
      'greetings' : greetings,
    }

    path = os.path.join(os.path.dirname(__file__), 'index.html')
    self.response.out.write(template.render(path, template_values))


class Guestbook(webapp.RequestHandler):
  def post(self):
    # We set the same parent key on the 'Greeting' to ensure each greeting is in
    # the same entity group. Queries across the single entity group will be
    # consistent. However, the write rate to a single entity group should
    # be limited to ~1/second.
    guestbook_name = self.request.get('guestbook_name')
    greeting = Greeting(parent=guestbook_key(guestbook_name))

    greeting.author = self.request.get('guestbook_author')
    greeting.author_email = self.request.get('guestbook_author_email')
    greeting.content = self.request.get('guestbook_comment')
    greeting.put()
    self.redirect('/?' + urllib.urlencode({'guestbook_name' : guestbook_name}))


application = webapp.WSGIApplication([
  ('/', MainPage),
  ('/sign', Guestbook)
], debug=True)


def main():
  run_wsgi_app(application)


if __name__ == '__main__':
  main()
