From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH, RFC] ext4: Remove i_ext_generation from ext4_inode_info structure
Date: Tue, 04 Nov 2008 18:47:57 -0500
Message-ID: <E1KxVcr-0005hL-Qy@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:40114 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759249AbYKDXsA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Nov 2008 18:48:00 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


ext4_inode_info.i_ext_generation isn't used by anything.  Was there an
intent to use it for something in the future?

       	      	     	       	      - Ted

commit 51972792db1397cddd97e1ab9c8d2604453f5b4c
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Tue Nov 4 18:46:03 2008 -0500

    ext4: Remove i_ext_generation from ext4_inode_info structure
    
    The i_ext_generation was incremented, but never used.  Remove it to
    slim down the ext4_inode_info structure.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index bec7ce5..18cb67b 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -194,11 +194,6 @@ static inline unsigned short ext_depth(struct inode *inode)
 	return le16_to_cpu(ext_inode_hdr(inode)->eh_depth);
 }
 
-static inline void ext4_ext_tree_changed(struct inode *inode)
-{
-	EXT4_I(inode)->i_ext_generation++;
-}
-
 static inline void
 ext4_ext_invalidate_cache(struct inode *inode)
 {
diff --git a/fs/ext4/ext4_i.h b/fs/ext4/ext4_i.h
index 5c124c0..acc0b72 100644
--- a/fs/ext4/ext4_i.h
+++ b/fs/ext4/ext4_i.h
@@ -117,7 +117,6 @@ struct ext4_inode_info {
 	struct inode vfs_inode;
 	struct jbd2_inode jinode;
 
-	unsigned long i_ext_generation;
 	struct ext4_ext_cache i_cached_extent;
 	/*
 	 * File creation time. Its function is same as that of
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ea2ce3c..501952f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1622,7 +1622,6 @@ cleanup:
 		ext4_ext_drop_refs(npath);
 		kfree(npath);
 	}
-	ext4_ext_tree_changed(inode);
 	ext4_ext_invalidate_cache(inode);
 	return err;
 }
@@ -2233,7 +2232,6 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
 		}
 	}
 out:
-	ext4_ext_tree_changed(inode);
 	ext4_ext_drop_refs(path);
 	kfree(path);
 	ext4_journal_stop(handle);
