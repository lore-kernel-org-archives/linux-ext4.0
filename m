From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/2] ext2: remove pointless vars in inode allocators
Date: Thu, 07 Jun 2007 14:38:57 -0500
Message-ID: <46685ED1.5050100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965728AbXFGTmV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Jun 2007 15:42:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext2's find_group_dir tests whether best_desc is not set and if
so returns -1.  But if it was not set, best_group was not set either,
and it was initialized to -1.  So may as well just return best_group.
This matches ext3/4 too.

In find_group_orlov, best_desc is updated in a loop and eventually
assigned to "desc" but then we return without using either.  Looks like
it can just be removed.

Compiled & booted & lightly tested.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: linux-2.6.22-rc3/fs/ext2/ialloc.c
===================================================================
--- linux-2.6.22-rc3.orig/fs/ext2/ialloc.c
+++ linux-2.6.22-rc3/fs/ext2/ialloc.c
@@ -224,16 +224,13 @@ static int find_group_dir(struct super_b
 			continue;
 		if (le16_to_cpu(desc->bg_free_inodes_count) < avefreei)
 			continue;
-		if (!best_desc || 
+		if (!best_desc ||
 		    (le16_to_cpu(desc->bg_free_blocks_count) >
 		     le16_to_cpu(best_desc->bg_free_blocks_count))) {
 			best_group = group;
 			best_desc = desc;
 		}
 	}
-	if (!best_desc)
-		return -1;
-
 	return best_group;
 }
 
@@ -290,7 +287,6 @@ static int find_group_orlov(struct super
 
 	if ((parent == sb->s_root->d_inode) ||
 	    (EXT2_I(parent)->i_flags & EXT2_TOPDIR_FL)) {
-		struct ext2_group_desc *best_desc = NULL;
 		int best_ndir = inodes_per_group;
 		int best_group = -1;
 
@@ -309,10 +305,8 @@ static int find_group_orlov(struct super
 				continue;
 			best_group = group;
 			best_ndir = le16_to_cpu(desc->bg_used_dirs_count);
-			best_desc = desc;
 		}
 		if (best_group >= 0) {
-			desc = best_desc;
 			group = best_group;
 			goto found;
 		}
