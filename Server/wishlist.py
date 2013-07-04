import json
import web,model

urls = (
    '/v1/user','User',
    '/v1/wishlist','Wishlist',
    '/v1/wish/(.+)','Wish',
)

class User:
    def GET(self):
        web.header('Content-Type','application/json')
        return 'hello guys'

    def POST(self):
        data = web.data()#POST data
        model.add_user(uuid,name,sex)
        buf = json.dumps({'uid':uid})
        web.header('Content-Type','application/json')
        return buf

class Wishlist:
    def GET(self):
        data = web.input()
        wishlist = model.wishlist(data.uid)
        buf = json.dumps({'uid':data.uid,'wishlist':wishlist})
        web.header('Content-Type','application/json')
        return buf

class Wish:
    def GET(self,wid):
        wish = model.wish(wid)
        buf = json.dumps(wish)
        web.header('Content-Type','application/json')
        return buf
        
    def POST(self,func):
        data = web.data()#POST data
        if func == 'add':
            pass
        elif func == 'public':
            public_wish(data.wid)
        elif func == 'support':
            support_wish(data.wid)
        elif func == 'own':
            own_wish(data,uid,data.wid)
        buf = json.dumps({'success':TRUE})
        web.header('Content-Type','application/json')
        return buf

app = web.application(urls,globals())

if __name__ == '__main__':
    app.run()
