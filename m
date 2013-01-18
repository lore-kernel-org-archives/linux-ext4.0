From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 7/7 v2] ext4: reclaim extents from extent status tree
Date: Fri, 18 Jan 2013 00:39:47 -0500
Message-ID: <20130118053947.GD13785@thunk.org>
References: <1357901627-3068-1-git-send-email-wenqing.lz@taobao.com>
 <1357901627-3068-8-git-send-email-wenqing.lz@taobao.com>
 <20130118051921.GC13785@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan kara <jack@suse.cz>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44128 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab3ARFjy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jan 2013 00:39:54 -0500
Content-Disposition: inline
In-Reply-To: <20130118051921.GC13785@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 18, 2013 at 12:19:21AM -0500, Theodore Ts'o wrote:
> I'm a bit concerned we might be too aggressive,
> because there are two ways that items can be freed from the
> extent_status tree.  One is if the inode is not used at all, and when
> we release the inode, we'll drop all of the entries in the
> extent_status_tree for that inode.  The second way is via the shrinker
> which we've registered.

If we use the sb->s_op->free_cached_objects() approach, something like
the following change to prune_super() in fs/super.c might address the
above concern:

diff --git a/fs/super.c b/fs/super.c
index 12f1237..fb57bd2 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -80,6 +80,7 @@ static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
 	if (sc->nr_to_scan) {
 		int	dentries;
 		int	inodes;
+		int	fs_to_scan = 0;
 
 		/* proportion the scan between the caches */
 		dentries = (sc->nr_to_scan * sb->s_nr_dentry_unused) /
@@ -87,7 +88,7 @@ static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
 		inodes = (sc->nr_to_scan * sb->s_nr_inodes_unused) /
 							total_objects;
 		if (fs_objects)
-			fs_objects = (sc->nr_to_scan * fs_objects) /
+			fs_to_scan = (sc->nr_to_scan * fs_objects) /
 							total_objects;
 		/*
 		 * prune the dcache first as the icache is pinned by it, then
@@ -96,8 +97,23 @@ static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
 		prune_dcache_sb(sb, dentries);
 		prune_icache_sb(sb, inodes);
 
-		if (fs_objects && sb->s_op->free_cached_objects) {
-			sb->s_op->free_cached_objects(sb, fs_objects);
+		/*
+		 * If as a result of pruning the icache, we released some
+		 * of the fs_objects, give credit to the fact and
+		 * reduce the number of fs objects that we should try
+		 * to release.
+		 */
+		if (fs_to_scan) {
+			int fs_objects_now = sb->s_op->nr_cached_objects(sb);
+
+			if (fs_objects_now < fs_objects)
+				fs_to_scan -= fs_objects - fs_objects_now;
+			if (fs_to_scan < 0)
+				fs_to_scan = 0;
+		}
+
+		if (fs_to_scan && sb->s_op->free_cached_objects) {
+			sb->s_op->free_cached_objects(sb, fs_to_scan);
 			fs_objects = sb->s_op->nr_cached_objects(sb);
 		}
 		total_objects = sb->s_nr_dentry_unused +

What do folks think?

						- Ted
