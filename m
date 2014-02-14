From: Benjamin LaHaise <bcrl@kvack.org>
Subject: [3.4 stable] ext4: protect group inode free counting with group lock
Date: Fri, 14 Feb 2014 14:20:35 -0500
Message-ID: <20140214192035.GA26763@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:40976 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbaBNTUg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Feb 2014 14:20:36 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Ted et al,

Commit 6f2e9f0e7d795214b9cf5a47724a273b705fd113 is missing from the 3.4 
stable tree.  I came across this during testing, and it's pretty easy to 
trigger under heavy load just by writing out 10,000 8MB files to a disk by 
way of 8 worker threads.  Are there any other significant commits like this 
that are missing from the 3.4 stable tree?  Please note that Tao's original 
patch doesn't apply entirely cleanly; my tested backport is at the bottom 
of this email.

		-ben
----snip----
[3.4 stable] ext4: protect group inode free counting with group lock

This patch is a straightforward backport of the following commit.  During
testing I encounted group descriptor corruption that matches Tao's original
report.  My testing consists of writing 10,000 8MB files to disk using 8
worker threads.  This workload manages to trigger the free inode count
corruption almost 100% of the time.

    commit 6f2e9f0e7d795214b9cf5a47724a273b705fd113
    Author: Tao Ma <boyu.mt@taobao.com>
    Date:   Mon May 28 18:20:59 2012 -0400

    ext4: protect group inode free counting with group lock
    
    Now when we set the group inode free count, we don't have a proper
    group lock so that multiple threads may decrease the inode free
    count at the same time. And e2fsck will complain something like:
    
    Free inodes count wrong for group #1 (1, counted=0).
    Fix? no
    
    Free inodes count wrong for group #2 (3, counted=0).
    Fix? no
    
    Directories count wrong for group #2 (780, counted=779).
    Fix? no
    
    Free inodes count wrong for group #3 (2272, counted=2273).
    Fix? no
    
    So this patch try to protect it with the ext4_lock_group.
    
    btw, it is found by xfstests test case 269 and the volume is
    mkfsed with the parameter
    "-O ^resize_inode,^uninit_bg,extent,meta_bg,flex_bg,ext_attr"
    and I have run it 100 times and the error in e2fsck doesn't
    show up again.
    
    Signed-off-by: Tao Ma <boyu.mt@taobao.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index c90ab78..30ac458 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -782,6 +782,8 @@ got:
 			ext4_itable_unused_set(sb, gdp,
 					(EXT4_INODES_PER_GROUP(sb) - ino));
 		up_read(&grp->alloc_sem);
+	} else {
+		ext4_lock_group(sb, group);
 	}
 	ext4_free_inodes_set(sb, gdp, ext4_free_inodes_count(sb, gdp) - 1);
 	if (S_ISDIR(mode)) {
@@ -794,8 +796,8 @@ got:
 	}
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
 		gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
-		ext4_unlock_group(sb, group);
 	}
+	ext4_unlock_group(sb, group);
 
 	BUFFER_TRACE(group_desc_bh, "call ext4_handle_dirty_metadata");
 	err = ext4_handle_dirty_metadata(handle, NULL, group_desc_bh);
