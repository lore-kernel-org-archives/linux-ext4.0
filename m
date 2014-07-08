From: Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: ext4: first write to large ext3 filesystem takes 96 seconds
Date: Tue, 8 Jul 2014 10:53:53 -0400
Message-ID: <20140708145353.GE12478@kvack.org>
References: <20140707211349.GA12478@kvack.org> <20140708001655.GI8254@thunk.org> <20140708013510.GB12478@kvack.org> <20140708035405.GA27440@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:53937 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbaGHOxy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jul 2014 10:53:54 -0400
Content-Disposition: inline
In-Reply-To: <20140708035405.GA27440@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 07, 2014 at 11:54:05PM -0400, Theodore Ts'o wrote:
> On Mon, Jul 07, 2014 at 09:35:11PM -0400, Benjamin LaHaise wrote:
> > 
> > Sure -- I put a copy at http://www.kvack.org/~bcrl/mb_groups as it's a bit 
> > too big for the mailing list.  The filesystem in question has a couple of 
> > 11GB files on it, with the remainder of the space being taken up by files 
> > 7200016 bytes in size.  
> 
> Right, so looking at mb_groups we see a bunch of the problems.  There
> are a large number block groups which look like this:
> 
> #group: free  frags first [ 2^0   2^1   2^2   2^3   2^4   2^5   2^6   2^7   2^8   2^9   2^10  2^11  2^12  2^13  ]
> #288  : 1540  7     13056 [ 0     0     1     0     0     0     0     0     6     0     0     0     0     0     ]
> 
> It would be very interesting to see what allocation pattern resulted
> in so many block groups with this layout.  Before we read in
> allocation bitmap, all we know from the block group descriptors is
> that there are 1540 free blocks.  What we don't know is that they are
> broken up into 6 256 block free regions, plus a 4 block region.

I did have to make a change to the ext4 inode allocator to bias things 
towards allocating inodes at the beginning of the disk (see below).  
Without that change the allocation pattern of writes to the filesystem 
resulted in a significant performance regression relative to ext3, 
owing mostly to the fact that fallocate() on ext4 is unimplemented for 
indirect style metadata.  (Note that we mount the filesystem with this 
noorlov mount option.)

With that change, the workload essentially consists of writing 7200016 
files in one write() operation rotating between 100 subdirectories off 
the root of the filesystem.

> If we try to allocate a 1024 block region, we'll end up searching a
> large number of these block groups before find one which is suitable.
> 
> Or there is a large collection of block groups that look like this:
> 
> #834  : 4900  39    514   [ 0     20    5     5     16    6     4     8     6     1     1     0     0     0     ]
> 
> Similarly, we could try to look for a contiguous 2048 range, but even
> though there is 4900 blocks available, we can't tell the difference
> between something a free block layout which looks like like the above,
> versus one that looks like this:
> 
> #834  : 4900  39    514   [ 0      6    0     1     3    5     1     4     0     0     0     2     0     0     ]
> 
> We could try going straight for the largely empty block groups, but
> that's more likely to fragment the file system more quickly, and then
> once those largely empty block groups are partially used, then we'll
> end up taking a long time while we scan all of the block groups.

Fragmentation is not a significant concern for the workload in question.  
Write performance is much more important to us than read performance, and 
read performance tends to degrade to random reads owing to the fact that 
the system can have many queues (~16k) issuing reads.  Hence, getting the 
block allocator to make writes get allocated as close to sequential on 
disk as possible is an important corner of performance.  Ext4 with indirect 
blocks has a tendency to leave gaps between files, which degrades 
performance for this workload, since files tend not to be packed as closely 
together as they were with ext3.  Ext4 with extents + fallocate() packs 
files on disk without any gaps, but turning on extents is not an option 
(unfortunately, as a 20+ minute fsck time / outage as part of an upgrade is 
not viable).

		-ben

>        	      	     	  	   	- Ted
> 

-- 
"Thought is the essence of where you are now."

diff -pu ./fs/ext4/ext4.h /opt/cvsdirs/blahaise/kernel34-d35/fs/ext4/ext4.h
--- ./fs/ext4/ext4.h	2014-03-12 16:32:21.077386952 -0400
+++ /opt/cvsdirs/blahaise/kernel34-d35/fs/ext4/ext4.h	2014-07-03 14:05:14.000000000 -0400
@@ -962,6 +962,7 @@ struct ext4_inode_info {
 
 #define EXT4_MOUNT2_EXPLICIT_DELALLOC	0x00000001 /* User explicitly
 						      specified delalloc */
+#define EXT4_MOUNT2_NO_ORLOV		0x00000002 /* Disable orlov */
 
 #define clear_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt &= \
 						~EXT4_MOUNT_##opt
diff -pu ./fs/ext4/ialloc.c /opt/cvsdirs/blahaise/kernel34-d35/fs/ext4/ialloc.c
--- ./fs/ext4/ialloc.c	2014-03-12 16:32:21.078386958 -0400
+++ /opt/cvsdirs/blahaise/kernel34-d35/fs/ext4/ialloc.c	2014-05-26 14:22:23.000000000 -0400
@@ -517,6 +517,9 @@ static int find_group_other(struct super
 	struct ext4_group_desc *desc;
 	int flex_size = ext4_flex_bg_size(EXT4_SB(sb));
 
+	if (test_opt2(sb, NO_ORLOV))
+		goto do_linear;
+
 	/*
 	 * Try to place the inode is the same flex group as its
 	 * parent.  If we can't find space, use the Orlov algorithm to
@@ -589,6 +592,7 @@ static int find_group_other(struct super
 			return 0;
 	}
 
+do_linear:
 	/*
 	 * That failed: try linear search for a free inode, even if that group
 	 * has no free blocks.
@@ -655,7 +659,7 @@ struct inode *ext4_new_inode(handle_t *h
 		goto got_group;
 	}
 
-	if (S_ISDIR(mode))
+	if (!test_opt2(sb, NO_ORLOV) && S_ISDIR(mode))
 		ret2 = find_group_orlov(sb, dir, &group, mode, qstr);
 	else
 		ret2 = find_group_other(sb, dir, &group, mode);
diff -pu ./fs/ext4/super.c /opt/cvsdirs/blahaise/kernel34-d35/fs/ext4/super.c
--- ./fs/ext4/super.c	2014-03-12 16:32:21.080386971 -0400
+++ /opt/cvsdirs/blahaise/kernel34-d35/fs/ext4/super.c	2014-05-26 14:22:23.000000000 -0400
@@ -1191,6 +1201,7 @@ enum {
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
 	Opt_dioread_nolock, Opt_dioread_lock,
 	Opt_discard, Opt_nodiscard, Opt_init_itable, Opt_noinit_itable,
+	Opt_noorlov
 };
 
 static const match_table_t tokens = {
@@ -1210,6 +1221,7 @@ static const match_table_t tokens = {
 	{Opt_debug, "debug"},
 	{Opt_removed, "oldalloc"},
 	{Opt_removed, "orlov"},
+	{Opt_noorlov, "noorlov"},
 	{Opt_user_xattr, "user_xattr"},
 	{Opt_nouser_xattr, "nouser_xattr"},
 	{Opt_acl, "acl"},
@@ -1376,6 +1388,7 @@ static const struct mount_opts {
 	int	token;
 	int	mount_opt;
 	int	flags;
+	int	mount_opt2;
 } ext4_mount_opts[] = {
 	{Opt_minix_df, EXT4_MOUNT_MINIX_DF, MOPT_SET},
 	{Opt_bsd_df, EXT4_MOUNT_MINIX_DF, MOPT_CLEAR},
@@ -1444,6 +1457,7 @@ static const struct mount_opts {
 	{Opt_jqfmt_vfsold, QFMT_VFS_OLD, MOPT_QFMT},
 	{Opt_jqfmt_vfsv0, QFMT_VFS_V0, MOPT_QFMT},
 	{Opt_jqfmt_vfsv1, QFMT_VFS_V1, MOPT_QFMT},
+	{Opt_noorlov, 0, MOPT_SET, EXT4_MOUNT2_NO_ORLOV},
 	{Opt_err, 0, 0}
 };
 
@@ -1562,6 +1576,7 @@ static int handle_mount_opt(struct super
 			} else {
 				clear_opt(sb, DATA_FLAGS);
 				sbi->s_mount_opt |= m->mount_opt;
+				sbi->s_mount_opt2 |= m->mount_opt2;
 			}
 #ifdef CONFIG_QUOTA
 		} else if (m->flags & MOPT_QFMT) {
@@ -1585,10 +1600,13 @@ static int handle_mount_opt(struct super
 				WARN_ON(1);
 				return -1;
 			}
-			if (arg != 0)
+			if (arg != 0) {
 				sbi->s_mount_opt |= m->mount_opt;
-			else
+				sbi->s_mount_opt2 |= m->mount_opt2;
+			} else {
 				sbi->s_mount_opt &= ~m->mount_opt;
+				sbi->s_mount_opt2 &= ~m->mount_opt2;
+			}
 		}
 		return 1;
 	}
@@ -1736,11 +1754,15 @@ static int _ext4_show_options(struct seq
 		if (((m->flags & (MOPT_SET|MOPT_CLEAR)) == 0) ||
 		    (m->flags & MOPT_CLEAR_ERR))
 			continue;
-		if (!(m->mount_opt & (sbi->s_mount_opt ^ def_mount_opt)))
+		if (!(m->mount_opt & (sbi->s_mount_opt ^ def_mount_opt)) &&
+		    !(m->mount_opt2 & sbi->s_mount_opt2))
 			continue; /* skip if same as the default */
-		if ((want_set &&
-		     (sbi->s_mount_opt & m->mount_opt) != m->mount_opt) ||
-		    (!want_set && (sbi->s_mount_opt & m->mount_opt)))
+		if (want_set &&
+		    (((sbi->s_mount_opt & m->mount_opt) != m->mount_opt) ||
+		     ((sbi->s_mount_opt2 & m->mount_opt2) != m->mount_opt2)))
+			continue; /* select Opt_noFoo vs Opt_Foo */
+		if (!want_set && ((sbi->s_mount_opt & m->mount_opt) ||
+		                  (sbi->s_mount_opt2 & m->mount_opt2)))
 			continue; /* select Opt_noFoo vs Opt_Foo */
 		SEQ_OPTS_PRINT("%s", token2str(m->token));
 	}
