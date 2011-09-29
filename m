From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [RFC PATCH V2 3/6] ext4: add operations on delayed extent tree
Date: Thu, 29 Sep 2011 21:12:39 +0800
Message-ID: <CAGBYx2Zm_M=1pqHH-6ptg27rYhxc94eozUOJmFuTNSQvwNojzQ@mail.gmail.com>
References: <1317272926-13303-1-git-send-email-xiaoqiangnk@gmail.com>
	<1317272926-13303-4-git-send-email-xiaoqiangnk@gmail.com>
	<4E8426E5.5010002@tao.ma>
	<CAGBYx2ah80bNjUyhd-ta3JfDJm7yDnNxUiHntPFgoHWaOFLM3Q@mail.gmail.com>
	<4E843D07.9070400@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, jeff.liu@oracle.com,
	achender@linux.vnet.ibm.com, adityakali@google.com
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:54925 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab1I2NMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Sep 2011 09:12:40 -0400
Received: by pzk1 with SMTP id 1so1539354pzk.1
        for <linux-ext4@vger.kernel.org>; Thu, 29 Sep 2011 06:12:40 -0700 (PDT)
In-Reply-To: <4E843D07.9070400@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 29, 2011 at 5:40 PM, Tao Ma <tm@tao.ma> wrote:
> On 09/29/2011 04:36 PM, Yongqiang Yang wrote:
>> On Thu, Sep 29, 2011 at 4:05 PM, Tao Ma <tm@tao.ma> wrote:
>>> Hi yongqiang,
>>> On 09/29/2011 01:08 PM, Yongqiang Yang wrote:
>>>> This patch adds operations on a delayed extent tree.
>>>>
>>>> Signed-off-by; Yongqiang Yang <xiaoqiangnk@gmail.com>
>>>> ---
>>>> =A0fs/ext4/Makefile =A0 =A0 =A0 =A0 =A0| =A0 =A02 +-
>>>> =A0fs/ext4/delayed_extents.c | =A0412 ++++++++++++++++++++++++++++=
+++++++++++++++++
>>>> =A0fs/ext4/delayed_extents.h | =A0 18 ++
>>>> =A03 files changed, 431 insertions(+), 1 deletions(-)
>>>> =A0create mode 100644 fs/ext4/delayed_extents.c
>>>>
>>>> diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
>>>> index 56fd8f86..ee16ad3 100644
>>>> --- a/fs/ext4/Makefile
>>>> +++ b/fs/ext4/Makefile
>>>> @@ -7,7 +7,7 @@ obj-$(CONFIG_EXT4_FS) +=3D ext4.o
>>>> =A0ext4-y =A0 =A0 =A0 :=3D balloc.o bitmap.o dir.o file.o fsync.o =
ialloc.o inode.o page-io.o \
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ioctl.o namei.o super.o symlink.o hash=
=2Eo resize.o extents.o \
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_jbd2.o migrate.o mballoc.o block_=
validity.o move_extent.o \
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 mmp.o indirect.o
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 mmp.o indirect.o delayed_extents.o
>>>>
>>>> =A0ext4-$(CONFIG_EXT4_FS_XATTR) =A0 =A0 =A0 =A0 +=3D xattr.o xattr=
_user.o xattr_trusted.o
>>>> =A0ext4-$(CONFIG_EXT4_FS_POSIX_ACL) =A0 =A0 +=3D acl.o
>>>> diff --git a/fs/ext4/delayed_extents.c b/fs/ext4/delayed_extents.c
>>>> new file mode 100644
>>>> index 0000000..8da7b78
>>>> --- /dev/null
>>>> +++ b/fs/ext4/delayed_extents.c
>>> <snip>
>>>> +/*
>>>> + * search through the tree for an delayed_extent with a given off=
set. =A0If
>>>> + * it can't be found, try to find next extent.
>>>> + */
>>>> +static struct delayed_extent * __de_tree_search(struct rb_root *r=
oot,
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 ext4_lblk_t offset)
>>>> +{
>>>> + =A0 =A0 struct rb_node *node =3D root->rb_node;
>>>> + =A0 =A0 struct delayed_extent *de =3D NULL;
>>>> +
>>>> + =A0 =A0 while (node) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 de =3D rb_entry(node, struct delayed_ext=
ent, rb_node);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (offset < de->start)
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 node =3D node->rb_left;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 else if (offset >=3D delayed_extent_end(=
de))
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 node =3D node->rb_right;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 else
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return de;
>>>> + =A0 =A0 }
>>>> +
>>>> + =A0 =A0 if (de && offset < de->start)
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 return de;
>>>> +
>>>> + =A0 =A0 if (de && offset >=3D delayed_extent_end(de))
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 return rb_entry(rb_next(&de->rb_node),
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct d=
elayed_extent, rb_node);
>>> what if the de is the most right one? rb_next should return NULL in=
 this
>>> case I guess? What is more, you will return a non-NULL value and us=
e it
>>> later in the caller. The kernel will panic. Or do I miss something =
here?
>> Yes, it returns NULL if de is the most right one. =A0Callers should
>> check the return value.
> No rb_next is NULL doesn't guarantee rb_entry(...) is NULL. ;)
> You returns rb_entry(NULL, struct delayed_extent, rb_node) which depe=
nds
> on the offset of rb_node in delayed_extent. Currently it is NULL beca=
use
> your delayed_extent has rb_node as the first parameter.
> But it is bug-prone to says that rb_entry(NULL,...) is also NULL.
> And it may cause a kernel panic later if some guys change the layout =
of
> delayed_extent. We'd better be careful here. :)
I see.  It's a bug:-)
>>
>>>> +
>>>> + =A0 =A0 return NULL;
>>>> +}
>>>> +
>>>> +/*
>>>> + * ext4_de_first_extent_since: find the 1st delayed extent coveri=
ng @start
>>>> + * if it exists, otherwise, the next extent after @start.
>>> This comment seems to be unrelated to the below function.
>> Sorry, the function name is changed in version2, however comment is =
not changed.
>>>> + *
>>>> + * @inode: the inode which owns delayed extents
>>>> + * @offset: logic block
>>>> + *
>>>> + * Returns next block beyond the found extent.
>>>> + * Delayed extent is returned via @de.
>>>> + */
>>>> +ext4_lblk_t ext4_de_find_extent(struct inode *inode, struct delay=
ed_extent *de)
>>>> +{
>>>> + =A0 =A0 struct ext4_de_tree *tree;
>>>> + =A0 =A0 struct delayed_extent *de1;
>>>> + =A0 =A0 struct rb_node *node;
>>>> +
>>>> + =A0 =A0 de->len =3D 0;
>>>> + =A0 =A0 tree =3D &EXT4_I(inode)->i_de_tree;
>>>> + =A0 =A0 de1 =3D __de_tree_search(&tree->root, de->start);
>>>> + =A0 =A0 if (de1) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 de->start =3D de1->start;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 de->len =3D de1->len;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 node =3D rb_next(&de1->rb_node);
>>> Sorry, but I don't understand what you are going to do here. In
>>> __de_tree_search, you have already use rb_next to get the next de i=
f
>>> start < del->start. why we still need a rb_next here?
>> This function is supposed to be used by fiemap and bigalloc. The
>> former one needs next block of the returned extent. =A0You can have =
a
>> loot at the 6th patch which implements fiemap based on delayed exten=
t
>> tree.
>>
>> rb_next in __de_tree_search is used if no extent covering given offs=
et exists.
> oh, so it is too tricky for the caller and the reviewer of course.
>
> Some times you suppose the function can find one with a de which has
> de->start <=3D offset && offset < de->start + de->end(situation 1).
> Sometimes you suppose that we should find one de with offset <
> de->start(situation 2). It is really a bit hard for us(the other read=
er)
> to know from the very beginning.
>
> In your case here, we may pass in a parameter to __de_tree_search to
> describe explicitly whether we want a de suitable for 1 or 2, so that
> __de_tree_search can find what we want or return NULL. Otherwise we(t=
he
> caller) have to check every time whether the returned de is OK for ou=
r need.
Accepted.
>
>>
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (node) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 de1 =3D rb_entry(node, s=
truct delayed_extent, rb_node);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return de1->start;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>>>> + =A0 =A0 }
>>>> +
>>>> + =A0 =A0 return EXT_MAX_BLOCKS;
>>>> +}
>>>> +
>>>> +static struct delayed_extent *
>>>> +ext4_de_alloc_extent(ext4_lblk_t start, ext4_lblk_t len)
>>>> +{
>>>> + =A0 =A0 struct delayed_extent *de;
>>>> + =A0 =A0 de =3D kmem_cache_alloc(ext4_de_cachep, GFP_NOFS);
>>>> + =A0 =A0 if (de =3D=3D NULL)
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
>>>> + =A0 =A0 de->start =3D start;
>>>> + =A0 =A0 de->len =3D len;
>>>> + =A0 =A0 return de;
>>>> +}
>>>> +
>>>> +static void ext4_de_free_extent(struct delayed_extent *de)
>>>> +{
>>>> + =A0 =A0 kmem_cache_free(ext4_de_cachep, de);
>>>> +}
>>>> +
>>>> +static void ext4_de_try_to_merge_left(struct ext4_de_tree *tree,
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 struct delayed_extent *de)
>>>> +{
>>>> + =A0 =A0 struct delayed_extent *de1;
>>>> + =A0 =A0 struct rb_node *node;
>>>> +
>>>> + =A0 =A0 node =3D rb_prev(&de->rb_node);
>>>> + =A0 =A0 if (!node)
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 return;
>>>> +
>>>> + =A0 =A0 de1 =3D rb_entry(node, struct delayed_extent, rb_node);
>>>> + =A0 =A0 if (delayed_extent_end(de1) =3D=3D de->start) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 de1->len +=3D de->len;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 rb_erase(&de->rb_node, &tree->root);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (de =3D=3D tree->cache_de)
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tree->cache_de =3D de1;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_de_free_extent(de);
>>>> + =A0 =A0 }
>>>> +}
>>>> +
>>>> +static void ext4_de_try_to_merge_right(struct ext4_de_tree *tree,
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0struct delayed_extent *de)
>>>> +{
>>>> + =A0 =A0 struct delayed_extent *de1;
>>>> + =A0 =A0 struct rb_node *node;
>>>> +
>>>> + =A0 =A0 node =3D rb_next(&de->rb_node);
>>>> + =A0 =A0 if (!node)
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 return;
>>>> +
>>>> + =A0 =A0 de1 =3D rb_entry(node, struct delayed_extent, rb_node);
>>>> + =A0 =A0 if (de1->start =3D=3D delayed_extent_end(de)) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 de->len +=3D de1->len;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 rb_erase(node, &tree->root);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (de1 =3D=3D tree->cache_de)
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tree->cache_de =3D de;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_de_free_extent(de1);
>>>> + =A0 =A0 }
>>>> +}
>>>> +
>>>> +/*
>>>> + * ext4_de_add_space adds a space to a delayed extent tree.
>>>> + * Caller holds inode->i_data_sem.
>>>> + *
>>>> + * ext4_de_add_space is callyed by ext4_dealyed_write_begin and
>>>> + * ext4_de_remove_space.
>>>> + *
>>>> + * Return 0 on success, error code on failure.
>>>> + */
>>>> +int ext4_de_add_space(struct inode *inode, ext4_lblk_t offset, ex=
t4_lblk_t len)
>>>> +{
>>>> + =A0 =A0 struct ext4_de_tree *tree =3D &EXT4_I(inode)->i_de_tree;
>>>> + =A0 =A0 struct rb_node **p =3D &tree->root.rb_node;
>>>> + =A0 =A0 struct rb_node *parent =3D NULL;
>>>> + =A0 =A0 struct delayed_extent *de;
>>>> + =A0 =A0 ext4_lblk_t end =3D offset + len;
>>>> +
>>>> + =A0 =A0 BUG_ON(end <=3D offset);
>>>> +
>>>> + =A0 =A0 de =3D tree->cache_de;
>>>> + =A0 =A0 de_debug("add [%u/%u) to delayed extent list of inode %l=
u\n",
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0offset, len, inode->i_ino);
>>>> +
>>>> + =A0 =A0 if (de && delayed_extent_end(de) =3D=3D offset) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 de->len +=3D len;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_de_try_to_merge_right(tree, de);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>>>> + =A0 =A0 } else if (de && de->start =3D=3D end) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 de->start =3D offset;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 de->len +=3D len;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_de_try_to_merge_left(tree, de);
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>>>> + =A0 =A0 } else if (de && de->start <=3D offset &&
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0delayed_extent_end(de) >=3D end)
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>>>> +
>>>> + =A0 =A0 while (*p) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 parent =3D *p;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 de =3D rb_entry(parent, struct delayed_e=
xtent, rb_node);
>>>> +
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 if (offset < de->start) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (end =3D=3D de->start=
) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 de->len =
+=3D len;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 de->star=
t =3D offset;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out=
;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 p =3D &(*p)->rb_left;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 } else if (offset > delayed_extent_end(d=
e)) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (delayed_extent_end(d=
e) =3D=3D offset) {
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 de->len =
+=3D len;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out=
;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 p =3D &(*p)->rb_right;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 } else
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>>>> + =A0 =A0 }
>>> is the above what =A0__de_tree_search try to do?
>>> btw, we'd better have a BUG_ON when we meet with an intersection si=
nce
>>> you only check the offset in your rb_tree search. So what if offset=
 <
>>> de->start while offset + len > de->start? It would cause your algor=
ithm
>>> not work I guess.
>> Yes. =A0ext4_de_add_space is used in 2 cases: 1. delayed allocation,=
 in
>> this case len always equals one. =A02. ext4_de_remove_space, in this
>> case, if ext4_de_remove_space does right thing, no intersection
>> happens.
>>
>> In version 1, there was BUG_ON here, and I found we can not guarante=
e
>> no intersection exists in case1. =A0If copy_from_user fails with 0 b=
ytes
>> copied, then page is not dirtied and i_size is not changed as well,
>> rewrite on the page can introduce intersection.
> Sorry I don't quite get what's your meaning. Should it be handled by =
the
> above codes(the merge and go out stuff) already? Or if as you said, t=
he
> user can give us with intersections, then what type of intersection?
Writes do as follows, allocating pages, mapping pages, copying bytes
from user space, dirtying page, changing i_size.  Errors could happen
in copying and the page could be released after.  so write on the same
block will introduce intersection.   Am I right?

Thank you for your review.

Yongqiang.

> IMHO, we should handle this in a grace way. Your codes seems not hand=
le it.
>
> Thanks
> Tao
>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
