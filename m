From: Tao Ma <tm@tao.ma>
Subject: Re: [RFC PATCH V2 3/6] ext4: add operations on delayed extent tree
Date: Thu, 29 Sep 2011 17:40:23 +0800
Message-ID: <4E843D07.9070400@tao.ma>
References: <1317272926-13303-1-git-send-email-xiaoqiangnk@gmail.com>	<1317272926-13303-4-git-send-email-xiaoqiangnk@gmail.com>	<4E8426E5.5010002@tao.ma> <CAGBYx2ah80bNjUyhd-ta3JfDJm7yDnNxUiHntPFgoHWaOFLM3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, jeff.liu@oracle.com,
	achender@linux.vnet.ibm.com, adityakali@google.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:42475 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755131Ab1I2Jkb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Sep 2011 05:40:31 -0400
In-Reply-To: <CAGBYx2ah80bNjUyhd-ta3JfDJm7yDnNxUiHntPFgoHWaOFLM3Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/29/2011 04:36 PM, Yongqiang Yang wrote:
> On Thu, Sep 29, 2011 at 4:05 PM, Tao Ma <tm@tao.ma> wrote:
>> Hi yongqiang,
>> On 09/29/2011 01:08 PM, Yongqiang Yang wrote:
>>> This patch adds operations on a delayed extent tree.
>>>
>>> Signed-off-by; Yongqiang Yang <xiaoqiangnk@gmail.com>
>>> ---
>>>  fs/ext4/Makefile          |    2 +-
>>>  fs/ext4/delayed_extents.c |  412 +++++++++++++++++++++++++++++++++++++++++++++
>>>  fs/ext4/delayed_extents.h |   18 ++
>>>  3 files changed, 431 insertions(+), 1 deletions(-)
>>>  create mode 100644 fs/ext4/delayed_extents.c
>>>
>>> diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
>>> index 56fd8f86..ee16ad3 100644
>>> --- a/fs/ext4/Makefile
>>> +++ b/fs/ext4/Makefile
>>> @@ -7,7 +7,7 @@ obj-$(CONFIG_EXT4_FS) += ext4.o
>>>  ext4-y       := balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o page-io.o \
>>>               ioctl.o namei.o super.o symlink.o hash.o resize.o extents.o \
>>>               ext4_jbd2.o migrate.o mballoc.o block_validity.o move_extent.o \
>>> -             mmp.o indirect.o
>>> +             mmp.o indirect.o delayed_extents.o
>>>
>>>  ext4-$(CONFIG_EXT4_FS_XATTR)         += xattr.o xattr_user.o xattr_trusted.o
>>>  ext4-$(CONFIG_EXT4_FS_POSIX_ACL)     += acl.o
>>> diff --git a/fs/ext4/delayed_extents.c b/fs/ext4/delayed_extents.c
>>> new file mode 100644
>>> index 0000000..8da7b78
>>> --- /dev/null
>>> +++ b/fs/ext4/delayed_extents.c
>> <snip>
>>> +/*
>>> + * search through the tree for an delayed_extent with a given offset.  If
>>> + * it can't be found, try to find next extent.
>>> + */
>>> +static struct delayed_extent * __de_tree_search(struct rb_root *root,
>>> +                                             ext4_lblk_t offset)
>>> +{
>>> +     struct rb_node *node = root->rb_node;
>>> +     struct delayed_extent *de = NULL;
>>> +
>>> +     while (node) {
>>> +             de = rb_entry(node, struct delayed_extent, rb_node);
>>> +             if (offset < de->start)
>>> +                     node = node->rb_left;
>>> +             else if (offset >= delayed_extent_end(de))
>>> +                     node = node->rb_right;
>>> +             else
>>> +                     return de;
>>> +     }
>>> +
>>> +     if (de && offset < de->start)
>>> +             return de;
>>> +
>>> +     if (de && offset >= delayed_extent_end(de))
>>> +             return rb_entry(rb_next(&de->rb_node),
>>> +                             struct delayed_extent, rb_node);
>> what if the de is the most right one? rb_next should return NULL in this
>> case I guess? What is more, you will return a non-NULL value and use it
>> later in the caller. The kernel will panic. Or do I miss something here?
> Yes, it returns NULL if de is the most right one.  Callers should
> check the return value.
No rb_next is NULL doesn't guarantee rb_entry(...) is NULL. ;)
You returns rb_entry(NULL, struct delayed_extent, rb_node) which depends
on the offset of rb_node in delayed_extent. Currently it is NULL because
your delayed_extent has rb_node as the first parameter.
But it is bug-prone to says that rb_entry(NULL,...) is also NULL.
And it may cause a kernel panic later if some guys change the layout of
delayed_extent. We'd better be careful here. :)
> 
>>> +
>>> +     return NULL;
>>> +}
>>> +
>>> +/*
>>> + * ext4_de_first_extent_since: find the 1st delayed extent covering @start
>>> + * if it exists, otherwise, the next extent after @start.
>> This comment seems to be unrelated to the below function.
> Sorry, the function name is changed in version2, however comment is not changed.
>>> + *
>>> + * @inode: the inode which owns delayed extents
>>> + * @offset: logic block
>>> + *
>>> + * Returns next block beyond the found extent.
>>> + * Delayed extent is returned via @de.
>>> + */
>>> +ext4_lblk_t ext4_de_find_extent(struct inode *inode, struct delayed_extent *de)
>>> +{
>>> +     struct ext4_de_tree *tree;
>>> +     struct delayed_extent *de1;
>>> +     struct rb_node *node;
>>> +
>>> +     de->len = 0;
>>> +     tree = &EXT4_I(inode)->i_de_tree;
>>> +     de1 = __de_tree_search(&tree->root, de->start);
>>> +     if (de1) {
>>> +             de->start = de1->start;
>>> +             de->len = de1->len;
>>> +             node = rb_next(&de1->rb_node);
>> Sorry, but I don't understand what you are going to do here. In
>> __de_tree_search, you have already use rb_next to get the next de if
>> start < del->start. why we still need a rb_next here?
> This function is supposed to be used by fiemap and bigalloc. The
> former one needs next block of the returned extent.  You can have a
> loot at the 6th patch which implements fiemap based on delayed extent
> tree.
> 
> rb_next in __de_tree_search is used if no extent covering given offset exists.
oh, so it is too tricky for the caller and the reviewer of course.

Some times you suppose the function can find one with a de which has
de->start <= offset && offset < de->start + de->end(situation 1).
Sometimes you suppose that we should find one de with offset <
de->start(situation 2). It is really a bit hard for us(the other reader)
to know from the very beginning.

In your case here, we may pass in a parameter to __de_tree_search to
describe explicitly whether we want a de suitable for 1 or 2, so that
__de_tree_search can find what we want or return NULL. Otherwise we(the
caller) have to check every time whether the returned de is OK for our need.

> 
>>> +             if (node) {
>>> +                     de1 = rb_entry(node, struct delayed_extent, rb_node);
>>> +                     return de1->start;
>>> +             }
>>> +     }
>>> +
>>> +     return EXT_MAX_BLOCKS;
>>> +}
>>> +
>>> +static struct delayed_extent *
>>> +ext4_de_alloc_extent(ext4_lblk_t start, ext4_lblk_t len)
>>> +{
>>> +     struct delayed_extent *de;
>>> +     de = kmem_cache_alloc(ext4_de_cachep, GFP_NOFS);
>>> +     if (de == NULL)
>>> +             return NULL;
>>> +     de->start = start;
>>> +     de->len = len;
>>> +     return de;
>>> +}
>>> +
>>> +static void ext4_de_free_extent(struct delayed_extent *de)
>>> +{
>>> +     kmem_cache_free(ext4_de_cachep, de);
>>> +}
>>> +
>>> +static void ext4_de_try_to_merge_left(struct ext4_de_tree *tree,
>>> +                                   struct delayed_extent *de)
>>> +{
>>> +     struct delayed_extent *de1;
>>> +     struct rb_node *node;
>>> +
>>> +     node = rb_prev(&de->rb_node);
>>> +     if (!node)
>>> +             return;
>>> +
>>> +     de1 = rb_entry(node, struct delayed_extent, rb_node);
>>> +     if (delayed_extent_end(de1) == de->start) {
>>> +             de1->len += de->len;
>>> +             rb_erase(&de->rb_node, &tree->root);
>>> +             if (de == tree->cache_de)
>>> +                     tree->cache_de = de1;
>>> +             ext4_de_free_extent(de);
>>> +     }
>>> +}
>>> +
>>> +static void ext4_de_try_to_merge_right(struct ext4_de_tree *tree,
>>> +                                    struct delayed_extent *de)
>>> +{
>>> +     struct delayed_extent *de1;
>>> +     struct rb_node *node;
>>> +
>>> +     node = rb_next(&de->rb_node);
>>> +     if (!node)
>>> +             return;
>>> +
>>> +     de1 = rb_entry(node, struct delayed_extent, rb_node);
>>> +     if (de1->start == delayed_extent_end(de)) {
>>> +             de->len += de1->len;
>>> +             rb_erase(node, &tree->root);
>>> +             if (de1 == tree->cache_de)
>>> +                     tree->cache_de = de;
>>> +             ext4_de_free_extent(de1);
>>> +     }
>>> +}
>>> +
>>> +/*
>>> + * ext4_de_add_space adds a space to a delayed extent tree.
>>> + * Caller holds inode->i_data_sem.
>>> + *
>>> + * ext4_de_add_space is callyed by ext4_dealyed_write_begin and
>>> + * ext4_de_remove_space.
>>> + *
>>> + * Return 0 on success, error code on failure.
>>> + */
>>> +int ext4_de_add_space(struct inode *inode, ext4_lblk_t offset, ext4_lblk_t len)
>>> +{
>>> +     struct ext4_de_tree *tree = &EXT4_I(inode)->i_de_tree;
>>> +     struct rb_node **p = &tree->root.rb_node;
>>> +     struct rb_node *parent = NULL;
>>> +     struct delayed_extent *de;
>>> +     ext4_lblk_t end = offset + len;
>>> +
>>> +     BUG_ON(end <= offset);
>>> +
>>> +     de = tree->cache_de;
>>> +     de_debug("add [%u/%u) to delayed extent list of inode %lu\n",
>>> +              offset, len, inode->i_ino);
>>> +
>>> +     if (de && delayed_extent_end(de) == offset) {
>>> +             de->len += len;
>>> +             ext4_de_try_to_merge_right(tree, de);
>>> +             goto out;
>>> +     } else if (de && de->start == end) {
>>> +             de->start = offset;
>>> +             de->len += len;
>>> +             ext4_de_try_to_merge_left(tree, de);
>>> +             goto out;
>>> +     } else if (de && de->start <= offset &&
>>> +                delayed_extent_end(de) >= end)
>>> +             goto out;
>>> +
>>> +     while (*p) {
>>> +             parent = *p;
>>> +             de = rb_entry(parent, struct delayed_extent, rb_node);
>>> +
>>> +             if (offset < de->start) {
>>> +                     if (end == de->start) {
>>> +                             de->len += len;
>>> +                             de->start = offset;
>>> +                             goto out;
>>> +                     }
>>> +                     p = &(*p)->rb_left;
>>> +             } else if (offset > delayed_extent_end(de)) {
>>> +                     if (delayed_extent_end(de) == offset) {
>>> +                             de->len += len;
>>> +                             goto out;
>>> +                     }
>>> +                     p = &(*p)->rb_right;
>>> +             } else
>>> +                     goto out;
>>> +     }
>> is the above what  __de_tree_search try to do?
>> btw, we'd better have a BUG_ON when we meet with an intersection since
>> you only check the offset in your rb_tree search. So what if offset <
>> de->start while offset + len > de->start? It would cause your algorithm
>> not work I guess.
> Yes.  ext4_de_add_space is used in 2 cases: 1. delayed allocation, in
> this case len always equals one.  2. ext4_de_remove_space, in this
> case, if ext4_de_remove_space does right thing, no intersection
> happens.
> 
> In version 1, there was BUG_ON here, and I found we can not guarantee
> no intersection exists in case1.  If copy_from_user fails with 0 bytes
> copied, then page is not dirtied and i_size is not changed as well,
> rewrite on the page can introduce intersection.
Sorry I don't quite get what's your meaning. Should it be handled by the
above codes(the merge and go out stuff) already? Or if as you said, the
user can give us with intersections, then what type of intersection?
IMHO, we should handle this in a grace way. Your codes seems not handle it.

Thanks
Tao

