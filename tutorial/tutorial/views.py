from pyramid.view import view_config
from pyramid.response import Response

from .models import *

#from .models import (
#    DBSession,
#    User,
#    )

#@view_config(route_name='home', renderer='templates/mytemplate.pt')

@view_config(route_name='home')
def my_view(request):

    #get_news_feed()

    #remove_question(2)

    #add_answer(1, "Tiger Woods")    
    #add_question(4, 6, "Who is the best golfer ever?")

    #add_question(1, 12, "Who is the highest paid celebrity?")

    #add_answer(4, "Oprah")
    #add_question(

    #remove_answer(9)
    #remove_answer(10)
    
    #add_user('alan')
    
    #return {'one':'blah', 'project':'tutorial'}


    #userList = get_news_feed()

    

    return Response(get_news_feed())
    
#return Response('test')
