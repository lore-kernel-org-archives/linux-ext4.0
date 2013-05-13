From: Radek Pazdera <rpazdera@redhat.com>
Subject: [PATCH v2 1/2] libext2fs: Adding itree feature and inode flags
Date: Mon, 13 May 2013 17:43:49 +0200
Message-ID: <1368459830-3651-2-git-send-email-rpazdera@redhat.com>
References: <1368459830-3651-1-git-send-email-rpazdera@redhat.com>
Cc: lczerner@redhat.com, kasparek@fit.vutbr.cz,
	Radek Pazdera <rpazdera@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab3EMQoD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 May 2013 12:44:03 -0400
In-Reply-To: <1368459830-3651-1-git-send-email-rpazdera@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The 'itree' feature adds an auxiliary tree that should help with indexing
directories. The tree resides on the file system along with the original
HTree (althought it is placed outside of the directory file).

It is a B+tree that contains directory entries sorted in inode order and
it is used to implement the getdents/readdir system calls. The inodes
are then returned in the optimal order, which improves the performance of
directory traversal.

This commit reserves a flag for the itree read-only compatible feature
and also an inode flag to indicate a directory has the inode tree
available.

Feature flag:    EXT4_FEATURE_RO_COMPAT_ITREE 0x1000
Inode flag:      EXT4_ITREE_FL 0x20000000

Signed-off-by: Radek Pazdera <rpazdera@redhat.com>
---
 lib/e2p/feature.c    |    2 ++
 lib/e2p/pf.c         |    1 +
 lib/ext2fs/ext2_fs.h |    2 ++
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 70815ef..9b15679 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -66,6 +66,8 @@ static struct feature feature_list[] = {
 			"metadata_csum"},
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_REPLICA,
 			"replica" },
+	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_ITREE,
+			"itree" },
 
 	{	E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_COMPRESSION,
 			"compression" },
diff --git a/lib/e2p/pf.c b/lib/e2p/pf.c
index f116ac3..c70b710 100644
--- a/lib/e2p/pf.c
+++ b/lib/e2p/pf.c
@@ -51,6 +51,7 @@ static struct flags_name flags_array[] = {
 	{ EXT4_HUGE_FILE_FL, "h", "Huge_file" },
 	{ FS_NOCOW_FL, "C", "No_COW" },
 	{ EXT4_INLINE_DATA_FL, "N", "Inline_Data" },
+	{ EXT4_ITREE_FL, "r", "Has_Itree" },
 	{ 0, NULL, NULL }
 };
 
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 0c0bbcb..7bdae5e 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -320,6 +320,7 @@ struct ext2_dx_tail {
 #define EXT4_SNAPFILE_DELETED_FL	0x04000000  /* Snapshot is being deleted */
 #define EXT4_SNAPFILE_SHRUNK_FL		0x08000000  /* Snapshot shrink has completed */
 #define EXT4_INLINE_DATA_FL		0x10000000 /* Inode has inline data */
+#define EXT4_ITREE_FL			0x20000000 /* Directory has itree */
 #define EXT2_RESERVED_FL		0x80000000 /* reserved for ext2 lib */
 
 #define EXT2_FL_USER_VISIBLE		0x004BDFFF /* User visible flags */
@@ -739,6 +740,7 @@ struct ext2_super_block {
  */
 #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
 #define EXT4_FEATURE_RO_COMPAT_REPLICA		0x0800
+#define EXT4_FEATURE_RO_COMPAT_ITREE		0x1000
 
 #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
-- 
1.7.7.6

