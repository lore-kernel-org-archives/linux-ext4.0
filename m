From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libext2fs, libe2p: Reserve RO_COMPAT_REPLICA feature
Date: Fri, 17 Feb 2012 14:06:42 -0500
Message-ID: <1329505602-28446-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, Aditya Kali <adityakali@google.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49293 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061Ab2BQTGo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Feb 2012 14:06:44 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The replica is a feature which stores multiple copies of the key
metadata blocks so a single block failure in failure-prone media
(read: certain types of flash storage) doesn't take out the entire
file system.

Discussion on the upstream list proved not to be very positive on this
feature; the arguments were that it added complexity that wasn't
warrented, since common practice in industry is to insist on reliable
media, and if media is unreliable, you're kind of toast anyway (unless
the file system is being used as the back-end store of a cluster file
system where checksuming and data replication is happening above the
local disk file system level.)  So, this feature is being developed
out of tree.

We reserve the code points so that other people won't accidentally
step on them.  Since it's not upstream, it's a soft reservation, but
it's not like we have any shortage of RO_COMPAT features.  We are a
bit more tight on reserved inodes, but EXT2_BOOT_LOADER_INO and
EXT2_UNDEL_DIR_INO are not currently used anywhere, and
EXT2_EXCLUDE_INO is a reservation for another out-of-tree feature.
There are no features currently being discussed which require a
reserved inode, but if a need were to arise, we can claw back code
point reservations that were never used or not in tree, as those will
always be considered lower priority than in-tree features.

Cc: Aditya Kali <adityakali@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/e2p/feature.c    |    2 ++
 lib/ext2fs/ext2_fs.h |    2 ++
 lib/ext2fs/ext2fs.h  |    2 +-
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 63486f3..19e6f0c 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -64,6 +64,8 @@ static struct feature feature_list[] = {
 			"bigalloc"},
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_METADATA_CSUM,
 			"metadata_csum"},
+	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_REPLICA,
+			"replica" },
 
 	{	E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_COMPRESSION,
 			"compression" },
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 0f8cde8..3b01285 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -51,6 +51,7 @@
 #define EXT2_RESIZE_INO		 7	/* Reserved group descriptors inode */
 #define EXT2_JOURNAL_INO	 8	/* Journal inode */
 #define EXT2_EXCLUDE_INO	 9	/* The "exclude" inode, for snapshots */
+#define EXT4_REPLICA_INO	10	/* Used by non-upstream feature */
 
 /* First non-reserved inode for old ext2 filesystems */
 #define EXT2_GOOD_OLD_FIRST_INO	11
@@ -707,6 +708,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_RO_COMPAT_QUOTA		0x0100
 #define EXT4_FEATURE_RO_COMPAT_BIGALLOC		0x0200
 #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
+#define EXT4_FEATURE_RO_COMPAT_REPLICA		0x0800
 
 #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 68afdff..682f0cd 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -610,7 +610,7 @@ typedef struct ext2_icount *ext2_icount_t;
  * to ext2fs_openfs()
  */
 #define EXT2_LIB_SOFTSUPP_INCOMPAT	(0)
-#define EXT2_LIB_SOFTSUPP_RO_COMPAT	(EXT4_FEATURE_RO_COMPAT_BIGALLOC)
+#define EXT2_LIB_SOFTSUPP_RO_COMPAT	(EXT4_FEATURE_RO_COMPAT_REPLICA)
 
 
 /* Translate a block number to a cluster number */
-- 
1.7.9.107.g97f9a

