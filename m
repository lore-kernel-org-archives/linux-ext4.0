From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] ext4: make es shrinker handle nr_to_scan correctly (Re: [RFC
 PATCH 2/2] ext4: improve ...)
Date: Tue, 31 Dec 2013 16:20:15 +0800
Message-ID: <20131231082015.GA24822@gmail.com>
References: <1387536165-15956-1-git-send-email-wenqing.lz@taobao.com>
 <1387536165-15956-3-git-send-email-wenqing.lz@taobao.com>
 <20131223085419.GB9199@quack.suse.cz>
 <20131225033448.GC23505@gmail.com>
 <20131230210917.GD5457@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:45318 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab3LaIQl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Dec 2013 03:16:41 -0500
Received: by mail-pa0-f54.google.com with SMTP id rd3so12495510pab.13
        for <linux-ext4@vger.kernel.org>; Tue, 31 Dec 2013 00:16:41 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131230210917.GD5457@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 30, 2013 at 10:09:17PM +0100, Jan Kara wrote:
> On Wed 25-12-13 11:34:48, Zheng Liu wrote:
> > On Mon, Dec 23, 2013 at 09:54:19AM +0100, Jan Kara wrote:
> > > On Fri 20-12-13 18:42:45, Zheng Liu wrote:
> > > > From: Zheng Liu <wenqing.lz@taobao.com>
> > > > 
> > > > The extents status tree shrinker will scan all inodes on sbi->s_es_lru
> > > > under heavy memory pressure, and try to reclaim the entry from extents
> > > > status tree.  During this process it couldn't reclaim the delayed entry
> > > > because ext4 needs to use these entries to do delayed allocation space
> > > > reservation, seek_data/hole, etc....  So if a system has done a huge
> > > > number of writes and these dirty pages don't be written out.  There will
> > > > be a lot of delayed entries on extents status tree.  If shrinker tries
> > > > to reclaim memory from the tree, it will burn some CPU time to iterate
> > > > on these non-reclaimable entries.  At some circumstances it could cause
> > > > excessive stall time.
> > > > 
> > > > In this commit a new list is used to track reclaimable entries of extent
> > > > status tree (e.g. written/unwritten/hole entries).  The shrinker will
> > > > scan reclaimable entry on this list.  So it won't encouter any delayed
> > > > entry and don't need to take too much time to spin.  But the defect is
> > > > that we need to cost extra 1/3 memory space for one entry.  Before this
> > > > commit, 'struct extent_status' occupies 48 bytes on a 64bits platform.
> > > > After that it will occupy 64 bytes. :(
> > >   This looks sensible. I was just wondering about one thing: One incorrect
> > > thing the old extent shrinker does is that it tries to reclaim 'nr_to_scan'
> > > objects. That is wrong - it should *scan* 'nr_to_scan' objects and reclaim
> > > objects it can find. Now we shouldn't always start scanning at the end of
> > > the LRU because if delayed extents accumulate there we would never reclaim
> > > anything. Rather we should cycle through the list of entries we have. But
> > > that doesn't play well with the fact we have LRU list and thus want to
> > > reclaim from the end of the list. In the end what you do might be the best
> > > we can do but I wanted to mention the above just in case someone has some
> > > idea.
> > 
> > Ah, thanks for pointing it out.  So maybe we can fix this issue before
> > we are sure that the new improvement is acceptable because it makes us
> > avoid scanning too many objects.  What do you think?
>   I'm sorry but I'm not sure I understand.  By 'fix this issue' do you mean
> using your patch or somehow fixing the problem that we try to reclaim
> 'nr_to_scan' objects instead of just trying to scan that many objects?

This patch tries to make es shrinker handle nr_to_scan properly.  After
applying this patch, es shrinker just scans nr_to_scan objects.  But
__ext4_es_shrink() couldn't guarantee that it can reclaim objects from
extent status tree because it doesn't scan all objects and it might only
scan nr_to_scan delayed objects.  So it could return ENOMEM error from
ext4_es_insert/remove_extent(), although there are some reclaimable
objects in the tree.

Another approach to solve above problem is that we add a new parameter
called 'nr_to_discard', which tells es shrinker to reclaim nr_to_discard
objects.  But it makes thing a bit complicated.  I am not sure whether
it is worthwhile because if we use a list to track all reclaimable
objects we no longer need nr_to_discard parameter.

Obviously, this patch is only a band-aid and it might be not very useful
for us to solve the problem that we faced.  But I attach it below in
case someone have some idea.

Regards,
                                                - Zheng

Subject: [PATCH] ext4: make es shrinker handle nr_to_scan correctly

From: Zheng Liu <wenqing.lz@taobao.com>

Nr_to_scan means that the shrinker needs to traverse nr_to_scan objects
rather than reclaim nr_to_scan objects.  This commit makes es shrinker
handle it correctly.  But after this __ext4_es_shrink() couldn't
guarantee that it can reclaim objects.  Hence we need to enlarge value
from 1 to 128 in ext4_es_insert/remove_extent() to avoid returning
ENOMEM error.  Before we use a list to track all reclaimable objects,
there is a tradeoff between returning ENOMEM and discarding too many
objects from extent status tree.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/extents_status.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index eb7ae61..87795d1 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -146,7 +146,7 @@ static int __es_insert_extent(struct inode *inode, struct extent_status *newes);
 static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 			      ext4_lblk_t end);
 static int __es_try_to_reclaim_extents(struct ext4_inode_info *ei,
-				       int nr_to_scan);
+				       int *nr_to_scan);
 static int __ext4_es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
 			    struct ext4_inode_info *locked_ei);
 
@@ -670,7 +670,7 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 		goto error;
 retry:
 	err = __es_insert_extent(inode, &newes);
-	if (err == -ENOMEM && __ext4_es_shrink(EXT4_SB(inode->i_sb), 1,
+	if (err == -ENOMEM && __ext4_es_shrink(EXT4_SB(inode->i_sb), 128,
 					       EXT4_I(inode)))
 		goto retry;
 	if (err == -ENOMEM && !ext4_es_is_delayed(&newes))
@@ -824,7 +824,7 @@ retry:
 				es->es_lblk = orig_es.es_lblk;
 				es->es_len = orig_es.es_len;
 				if ((err == -ENOMEM) &&
-				    __ext4_es_shrink(EXT4_SB(inode->i_sb), 1,
+				    __ext4_es_shrink(EXT4_SB(inode->i_sb), 128,
 						     EXT4_I(inode)))
 					goto retry;
 				goto out;
@@ -938,8 +938,6 @@ static int __ext4_es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
 
 retry:
 	list_for_each_safe(cur, tmp, &sbi->s_es_lru) {
-		int shrunk;
-
 		/*
 		 * If we have already reclaimed all extents from extent
 		 * status tree, just stop the loop immediately.
@@ -966,13 +964,11 @@ retry:
 			continue;
 
 		write_lock(&ei->i_es_lock);
-		shrunk = __es_try_to_reclaim_extents(ei, nr_to_scan);
+		nr_shrunk += __es_try_to_reclaim_extents(ei, &nr_to_scan);
 		if (ei->i_es_lru_nr == 0)
 			list_del_init(&ei->i_es_lru);
 		write_unlock(&ei->i_es_lock);
 
-		nr_shrunk += shrunk;
-		nr_to_scan -= shrunk;
 		if (nr_to_scan == 0)
 			break;
 	}
@@ -1003,8 +999,16 @@ retry:
 
 	spin_unlock(&sbi->s_es_lru_lock);
 
-	if (locked_ei && nr_shrunk == 0)
-		nr_shrunk = __es_try_to_reclaim_extents(locked_ei, nr_to_scan);
+	if (locked_ei && nr_shrunk == 0) {
+		/*
+		 * We try to reclaim objects from locked inode.  We don't
+		 * want to discard too many objects from this inode because
+		 * it might be accessed frequently.
+		 */
+		if (!nr_to_scan)
+			nr_to_scan = 8;
+		nr_shrunk = __es_try_to_reclaim_extents(locked_ei, &nr_to_scan);
+	}
 
 	return nr_shrunk;
 }
@@ -1085,7 +1089,7 @@ void ext4_es_lru_del(struct inode *inode)
 }
 
 static int __es_try_to_reclaim_extents(struct ext4_inode_info *ei,
-				       int nr_to_scan)
+				       int *nr_to_scan)
 {
 	struct inode *inode = &ei->vfs_inode;
 	struct ext4_es_tree *tree = &ei->i_es_tree;
@@ -1114,7 +1118,7 @@ static int __es_try_to_reclaim_extents(struct ext4_inode_info *ei,
 			rb_erase(&es->rb_node, &tree->root);
 			ext4_es_free_extent(inode, es);
 			nr_shrunk++;
-			if (--nr_to_scan == 0)
+			if (--(*nr_to_scan) == 0)
 				break;
 		}
 	}
-- 
1.7.9.7

