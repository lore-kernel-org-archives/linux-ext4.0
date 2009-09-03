From: Nick Dokos <nicholas.dokos@hp.com>
Subject: [PATCH] Fix ext2fs_set_gdt_csum() to use access functions.
Date: Wed, 02 Sep 2009 23:21:55 -0400
Message-ID: <12386.1251948115@gamaville.dokosmarshall.org>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Justin Maggard <jmaggard10@gmail.com>,
	Ric Wheeler <rwheeler@redhat.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vms173005pub.verizon.net ([206.46.173.5]:54357 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbZICDWO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Sep 2009 23:22:14 -0400
Received: from gamaville.dokosmarshall.org ([98.110.172.159])
 by vms173005.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008; 32bit))
 with ESMTPA id <0KPD00AYBLCHUZLA@vms173005.mailsrvcs.net> for
 linux-ext4@vger.kernel.org; Wed, 02 Sep 2009 22:21:59 -0500 (CDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Following Andreas's suggestion, I found that ext2fs_set_gdt_csum()
was the culprit: it used an ext2_group_desc pointer to access/set
fields and it did that directly, not through access functions.

I'm testing the patch now, but it'll take a while, so again I'm sending
it out for comments and to possibly try out. Even if it checks out, it
will need some additional care once the flags situation settles down.

Thanks,
Nick

>From 6a3b83cda1bcd1e3594515ee888f175bf5cc7906 Mon Sep 17 00:00:00 2001
From: Nick Dokos <nicholas.dokos@hp.com>
Date: Wed, 2 Sep 2009 23:00:23 -0400
Subject: [PATCH] Fix ext2fs_set_gdt_csum() to use access functions.

Replace all field accesses with calls to access functions.
Most importantly, get rid of the mis-declared group descriptor
pointer which caused the wrong fields to be updated.

Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>
---
 lib/ext2fs/csum.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index a0f25e3..def3ddd 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -105,7 +105,6 @@ static __u32 find_last_inode_ingrp(ext2fs_inode_bitmap bitmap,
 errcode_t ext2fs_set_gdt_csum(ext2_filsys fs)
 {
 	struct ext2_super_block *sb = fs->super;
-	struct ext2_group_desc *bg = fs->group_desc;
 	int dirty = 0;
 	dgrp_t i;
 
@@ -116,27 +115,32 @@ errcode_t ext2fs_set_gdt_csum(ext2_filsys fs)
 					EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
 		return 0;
 
-	for (i = 0; i < fs->group_desc_count; i++, bg++) {
-		int old_csum = bg->bg_checksum;
-		int old_unused = bg->bg_itable_unused;
-		int old_flags = bg->bg_flags;
+	for (i = 0; i < fs->group_desc_count; i++) {
+		unsigned int old_csum = ext2fs_bg_checksum(fs, i);
+                int old_unused = ext2fs_bg_itable_unused(fs, i);
+		unsigned int old_flags = ext2fs_bg_flags(fs, i);
+                int old_free_inodes_count = ext2fs_bg_free_inodes_count(fs, i);
+                
 
-		if (bg->bg_free_inodes_count == sb->s_inodes_per_group) {
-			bg->bg_flags |= EXT2_BG_INODE_UNINIT;
-			bg->bg_itable_unused = sb->s_inodes_per_group;
+		if (old_free_inodes_count == sb->s_inodes_per_group) {
+			ext2fs_bg_flags_set(fs, i, old_flags | EXT2_BG_INODE_UNINIT);
+			ext2fs_bg_itable_unused_set(fs, i, sb->s_inodes_per_group);
 		} else {
-			bg->bg_flags &= ~EXT2_BG_INODE_UNINIT;
-			bg->bg_itable_unused = sb->s_inodes_per_group -
+			int unused = sb->s_inodes_per_group -
 				find_last_inode_ingrp(fs->inode_map,
 						      sb->s_inodes_per_group,i);
+
+			ext2fs_bg_flags_set(fs, i, old_flags & ~EXT2_BG_INODE_UNINIT);
+			
+			ext2fs_bg_itable_unused_set(fs, i, unused);
 		}
 
 		ext2fs_group_desc_csum_set(fs, i);
-		if (old_flags != bg->bg_flags)
+		if (old_flags != ext2fs_bg_flags(fs, i))
 			dirty = 1;
-		if (old_unused != bg->bg_itable_unused)
+		if (old_unused != ext2fs_bg_itable_unused(fs, i))
 			dirty = 1;
-		if (old_csum != bg->bg_checksum)
+		if (old_csum != ext2fs_bg_checksum(fs, i))
 			dirty = 1;
 	}
 	if (dirty)
-- 
1.6.0.6

