From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [RFC PATCH V2 3/6] ext4: add operations on delayed extent tree
Date: Thu, 29 Sep 2011 16:36:38 +0800
Message-ID: <CAGBYx2ah80bNjUyhd-ta3JfDJm7yDnNxUiHntPFgoHWaOFLM3Q@mail.gmail.com>
References: <1317272926-13303-1-git-send-email-xiaoqiangnk@gmail.com>
	<1317272926-13303-4-git-send-email-xiaoqiangnk@gmail.com>
	<4E8426E5.5010002@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, jeff.liu@oracle.com,
	achender@linux.vnet.ibm.com, adityakali@google.com
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43173 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754Ab1I2Igk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Sep 2011 04:36:40 -0400
Received: by gyg10 with SMTP id 10so309793gyg.19
        for <linux-ext4@vger.kernel.org>; Thu, 29 Sep 2011 01:36:39 -0700 (PDT)
In-Reply-To: <4E8426E5.5010002@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 29, 2011 at 4:05 PM, Tao Ma <tm@tao.ma> wrote:
> Hi yongqiang,
> On 09/29/2011 01:08 PM, Yongqiang Yang wrote:
>> This patch adds operations on a delayed extent tree.
>>
>> Signed-off-by; Yongqiang Yang <xiaoqiangnk@gmail.com>
>> ---
>> =A0fs/ext4/Makefile =A0 =A0 =A0 =A0 =A0| =A0 =A02 +-
>> =A0fs/ext4/delayed_extents.c | =A0412 ++++++++++++++++++++++++++++++=
+++++++++++++++
>> =A0fs/ext4/delayed_extents.h | =A0 18 ++
>> =A03 files changed, 431 insertions(+), 1 deletions(-)
>> =A0create mode 100644 fs/ext4/delayed_extents.c
>>
>> diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
>> index 56fd8f86..ee16ad3 100644
>> --- a/fs/ext4/Makefile
>> +++ b/fs/ext4/Makefile
>> @@ -7,7 +7,7 @@ obj-$(CONFIG_EXT4_FS) +=3D ext4.o
>> =A0ext4-y =A0 =A0 =A0 :=3D balloc.o bitmap.o dir.o file.o fsync.o ia=
lloc.o inode.o page-io.o \
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ioctl.o namei.o super.o symlink.o hash.o=
 resize.o extents.o \
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_jbd2.o migrate.o mballoc.o block_va=
lidity.o move_extent.o \
>> - =A0 =A0 =A0 =A0 =A0 =A0 mmp.o indirect.o
>> + =A0 =A0 =A0 =A0 =A0 =A0 mmp.o indirect.o delayed_extents.o
>>
>> =A0ext4-$(CONFIG_EXT4_FS_XATTR) =A0 =A0 =A0 =A0 +=3D xattr.o xattr_u=
ser.o xattr_trusted.o
>> =A0ext4-$(CONFIG_EXT4_FS_POSIX_ACL) =A0 =A0 +=3D acl.o
>> diff --git a/fs/ext4/delayed_extents.c b/fs/ext4/delayed_extents.c
>> new file mode 100644
>> index 0000000..8da7b78
>> --- /dev/null
>> +++ b/fs/ext4/delayed_extents.c
> <snip>
>> +/*
>> + * search through the tree for an delayed_extent with a given offse=
t. =A0If
>> + * it can't be found, try to find next extent.
>> + */
>> +static struct delayed_extent * __de_tree_search(struct rb_root *roo=
t,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 ext4_lblk_t offset)
>> +{
>> + =A0 =A0 struct rb_node *node =3D root->rb_node;
>> + =A0 =A0 struct delayed_extent *de =3D NULL;
>> +
>> + =A0 =A0 while (node) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 de =3D rb_entry(node, struct delayed_exten=
t, rb_node);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (offset < de->start)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 node =3D node->rb_left;
>> + =A0 =A0 =A0 =A0 =A0 =A0 else if (offset >=3D delayed_extent_end(de=
))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 node =3D node->rb_right;
>> + =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return de;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 if (de && offset < de->start)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return de;
>> +
>> + =A0 =A0 if (de && offset >=3D delayed_extent_end(de))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rb_entry(rb_next(&de->rb_node),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct del=
ayed_extent, rb_node);
> what if the de is the most right one? rb_next should return NULL in t=
his
> case I guess? What is more, you will return a non-NULL value and use =
it
> later in the caller. The kernel will panic. Or do I miss something he=
re?
Yes, it returns NULL if de is the most right one.  Callers should
check the return value.

>> +
>> + =A0 =A0 return NULL;
>> +}
>> +
>> +/*
>> + * ext4_de_first_extent_since: find the 1st delayed extent covering=
 @start
>> + * if it exists, otherwise, the next extent after @start.
> This comment seems to be unrelated to the below function.
Sorry, the function name is changed in version2, however comment is not=
 changed.
>> + *
>> + * @inode: the inode which owns delayed extents
>> + * @offset: logic block
>> + *
>> + * Returns next block beyond the found extent.
>> + * Delayed extent is returned via @de.
>> + */
>> +ext4_lblk_t ext4_de_find_extent(struct inode *inode, struct delayed=
_extent *de)
>> +{
>> + =A0 =A0 struct ext4_de_tree *tree;
>> + =A0 =A0 struct delayed_extent *de1;
>> + =A0 =A0 struct rb_node *node;
>> +
>> + =A0 =A0 de->len =3D 0;
>> + =A0 =A0 tree =3D &EXT4_I(inode)->i_de_tree;
>> + =A0 =A0 de1 =3D __de_tree_search(&tree->root, de->start);
>> + =A0 =A0 if (de1) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 de->start =3D de1->start;
>> + =A0 =A0 =A0 =A0 =A0 =A0 de->len =3D de1->len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 node =3D rb_next(&de1->rb_node);
> Sorry, but I don't understand what you are going to do here. In
> __de_tree_search, you have already use rb_next to get the next de if
> start < del->start. why we still need a rb_next here?
This function is supposed to be used by fiemap and bigalloc. The
former one needs next block of the returned extent.  You can have a
loot at the 6th patch which implements fiemap based on delayed extent
tree.

rb_next in __de_tree_search is used if no extent covering given offset =
exists.

>> + =A0 =A0 =A0 =A0 =A0 =A0 if (node) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 de1 =3D rb_entry(node, str=
uct delayed_extent, rb_node);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return de1->start;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +
>> + =A0 =A0 return EXT_MAX_BLOCKS;
>> +}
>> +
>> +static struct delayed_extent *
>> +ext4_de_alloc_extent(ext4_lblk_t start, ext4_lblk_t len)
>> +{
>> + =A0 =A0 struct delayed_extent *de;
>> + =A0 =A0 de =3D kmem_cache_alloc(ext4_de_cachep, GFP_NOFS);
>> + =A0 =A0 if (de =3D=3D NULL)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
>> + =A0 =A0 de->start =3D start;
>> + =A0 =A0 de->len =3D len;
>> + =A0 =A0 return de;
>> +}
>> +
>> +static void ext4_de_free_extent(struct delayed_extent *de)
>> +{
>> + =A0 =A0 kmem_cache_free(ext4_de_cachep, de);
>> +}
>> +
>> +static void ext4_de_try_to_merge_left(struct ext4_de_tree *tree,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 struct delayed_extent *de)
>> +{
>> + =A0 =A0 struct delayed_extent *de1;
>> + =A0 =A0 struct rb_node *node;
>> +
>> + =A0 =A0 node =3D rb_prev(&de->rb_node);
>> + =A0 =A0 if (!node)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return;
>> +
>> + =A0 =A0 de1 =3D rb_entry(node, struct delayed_extent, rb_node);
>> + =A0 =A0 if (delayed_extent_end(de1) =3D=3D de->start) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 de1->len +=3D de->len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 rb_erase(&de->rb_node, &tree->root);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (de =3D=3D tree->cache_de)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tree->cache_de =3D de1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_de_free_extent(de);
>> + =A0 =A0 }
>> +}
>> +
>> +static void ext4_de_try_to_merge_right(struct ext4_de_tree *tree,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0struct delayed_extent *de)
>> +{
>> + =A0 =A0 struct delayed_extent *de1;
>> + =A0 =A0 struct rb_node *node;
>> +
>> + =A0 =A0 node =3D rb_next(&de->rb_node);
>> + =A0 =A0 if (!node)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return;
>> +
>> + =A0 =A0 de1 =3D rb_entry(node, struct delayed_extent, rb_node);
>> + =A0 =A0 if (de1->start =3D=3D delayed_extent_end(de)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 de->len +=3D de1->len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 rb_erase(node, &tree->root);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (de1 =3D=3D tree->cache_de)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tree->cache_de =3D de;
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_de_free_extent(de1);
>> + =A0 =A0 }
>> +}
>> +
>> +/*
>> + * ext4_de_add_space adds a space to a delayed extent tree.
>> + * Caller holds inode->i_data_sem.
>> + *
>> + * ext4_de_add_space is callyed by ext4_dealyed_write_begin and
>> + * ext4_de_remove_space.
>> + *
>> + * Return 0 on success, error code on failure.
>> + */
>> +int ext4_de_add_space(struct inode *inode, ext4_lblk_t offset, ext4=
_lblk_t len)
>> +{
>> + =A0 =A0 struct ext4_de_tree *tree =3D &EXT4_I(inode)->i_de_tree;
>> + =A0 =A0 struct rb_node **p =3D &tree->root.rb_node;
>> + =A0 =A0 struct rb_node *parent =3D NULL;
>> + =A0 =A0 struct delayed_extent *de;
>> + =A0 =A0 ext4_lblk_t end =3D offset + len;
>> +
>> + =A0 =A0 BUG_ON(end <=3D offset);
>> +
>> + =A0 =A0 de =3D tree->cache_de;
>> + =A0 =A0 de_debug("add [%u/%u) to delayed extent list of inode %lu\=
n",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0offset, len, inode->i_ino);
>> +
>> + =A0 =A0 if (de && delayed_extent_end(de) =3D=3D offset) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 de->len +=3D len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_de_try_to_merge_right(tree, de);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 } else if (de && de->start =3D=3D end) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 de->start =3D offset;
>> + =A0 =A0 =A0 =A0 =A0 =A0 de->len +=3D len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_de_try_to_merge_left(tree, de);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 } else if (de && de->start <=3D offset &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0delayed_extent_end(de) >=3D end)
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> +
>> + =A0 =A0 while (*p) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 parent =3D *p;
>> + =A0 =A0 =A0 =A0 =A0 =A0 de =3D rb_entry(parent, struct delayed_ext=
ent, rb_node);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (offset < de->start) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (end =3D=3D de->start) =
{
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 de->len +=3D=
 len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 de->start =
=3D offset;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 p =3D &(*p)->rb_left;
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else if (offset > delayed_extent_end(de)=
) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (delayed_extent_end(de)=
 =3D=3D offset) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 de->len +=3D=
 len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 p =3D &(*p)->rb_right;
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
> is the above what =A0__de_tree_search try to do?
> btw, we'd better have a BUG_ON when we meet with an intersection sinc=
e
> you only check the offset in your rb_tree search. So what if offset <
> de->start while offset + len > de->start? It would cause your algorit=
hm
> not work I guess.
Yes.  ext4_de_add_space is used in 2 cases: 1. delayed allocation, in
this case len always equals one.  2. ext4_de_remove_space, in this
case, if ext4_de_remove_space does right thing, no intersection
happens.

In version 1, there was BUG_ON here, and I found we can not guarantee
no intersection exists in case1.  If copy_from_user fails with 0 bytes
copied, then page is not dirtied and i_size is not changed as well,
rewrite on the page can introduce intersection.

>> +
>> + =A0 =A0 de =3D ext4_de_alloc_extent(offset, len);
>> + =A0 =A0 if (!de)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 rb_link_node(&de->rb_node, parent, p);
>> + =A0 =A0 rb_insert_color(&de->rb_node, &tree->root);
>> +
>> +out:
>> + =A0 =A0 tree->cache_de =3D de;
>> + =A0 =A0 ext4_de_print_tree(inode);
>> +
>> + =A0 =A0 return 0;
>> +}
>> +
>> +/*
>> + * ext4_de_remove_space() removes a space from a delayed extent tre=
e.
>> + * Caller holds inode->i_data_sem.
>> + *
>> + * Return 0 on success, error code on failure.
>> + */
>> +int ext4_de_remove_space(struct inode *inode, ext4_lblk_t offset,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_lblk_t len)
>> +{
>> + =A0 =A0 struct rb_node *node;
>> + =A0 =A0 struct ext4_de_tree *tree;
>> + =A0 =A0 struct delayed_extent *de;
>> + =A0 =A0 struct delayed_extent orig_de;
>> + =A0 =A0 ext4_lblk_t len1, len2, end;
>> +
>> + =A0 =A0 de_debug("remove [%u/%u) from delayed extent list of inode=
 %lu\n",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0offset, len, inode->i_ino);
>> +
>> + =A0 =A0 end =3D offset + len;
>> + =A0 =A0 BUG_ON(end <=3D offset);
>> + =A0 =A0 tree =3D &EXT4_I(inode)->i_de_tree;
>> + =A0 =A0 de =3D __de_tree_search(&tree->root, offset);
>> + =A0 =A0 if (!de)
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> +
>> + =A0 =A0 orig_de.start =3D de->start;
>> + =A0 =A0 orig_de.len =3D de->len;
>> + =A0 =A0 len1 =3D offset > de->start ? offset - de->start : 0;
>> + =A0 =A0 len2 =3D delayed_extent_end(de) > end ?
>> + =A0 =A0 =A0 =A0 =A0 =A0delayed_extent_end(de) - end : 0;
>> + =A0 =A0 if (len1 > 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 de->len =3D len1;
>> + =A0 =A0 if (len2 > 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (len1 > 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int err;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_de_add_space(=
inode, end, len2);
> I don't find any error in your ext4_de_add_space.
ENOMEM could be returned.

Thank you for review.

Yongqiang.

>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 de->start =
=3D orig_de.start;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 de->len =3D=
 orig_de.len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return err=
;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 de->start =3D end;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 de->len =3D len2;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>
> Thanks
> Tao
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
