import web

db = web.database(dbn='sqlite',db='wishlist.dat')

def add_user(uuid,name,sex):
    db.insert('user',uuid=uuid,name=name,sex=sex)

def add_wish(uid,title,cost):
    db.insert('wish',uid=uid,title=title,cost=cost)

def wish(wid):
    result = list(db.select('wish',where='id=$wid',vars=locals()))
    if len(result):
        return {'wid':result[0].id,'title':result[0].title}
    else:
        return

def wishlist(uid):
    wishlist = []
    result = db.select('wish',where='uid=$uid',vars=locals())
    for r in result:
        wishlist.append({'wid':r.id,'title':r.title,'cost':r.cost,'created':r.created,'uptodate':r.uptodate})
    return wishlist

   
def public_wish(wid):
    db.update('wish',where='id=$wid',public='Y',_test=True)

def support_wish(wid):
    db.update('wish',where='id=$wid',support='support+1',_test=True)

def own_wish(uid,wid):
    result = list(db.select('wish',where='id=$wid',vars=locals()))
    if len(result) > 0:
        db.update('wish',where='id=$wid',support='own+1',_test=True)
        db.insert('wish',uid=uid,origin=wid,title=result[0].title)
