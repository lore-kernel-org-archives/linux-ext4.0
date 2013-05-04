From: Radek Pazdera <rpazdera@redhat.com>
Subject: [PATCH 2/3] libext2fs: Adding inode flag for itree
Date: Sat,  4 May 2013 23:35:09 +0200
Message-ID: <1367703310-3842-3-git-send-email-rpazdera@redhat.com>
References: <1367703310-3842-1-git-send-email-rpazdera@redhat.com>
Cc: lczerner@redhat.com, kasparek@fit.vutbr.cz,
	Radek Pazdera <rpazdera@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758847Ab3EDVfh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 May 2013 17:35:37 -0400
In-Reply-To: <1367703310-3842-1-git-send-email-rpazdera@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This commit reserves an inode flag for the itree.

    EXT4_ITREE_FL 0x20000000

Signed-off-by: Radek Pazdera <rpazdera@redhat.com>
---
 lib/e2p/pf.c         | 1 +
 lib/ext2fs/ext2_fs.h | 1 +
 2 files changed, 2 insertions(+)

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
index be711ce..7bdae5e 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -320,6 +320,7 @@ struct ext2_dx_tail {
 #define EXT4_SNAPFILE_DELETED_FL	0x04000000  /* Snapshot is being deleted */
 #define EXT4_SNAPFILE_SHRUNK_FL		0x08000000  /* Snapshot shrink has completed */
 #define EXT4_INLINE_DATA_FL		0x10000000 /* Inode has inline data */
+#define EXT4_ITREE_FL			0x20000000 /* Directory has itree */
 #define EXT2_RESERVED_FL		0x80000000 /* reserved for ext2 lib */
 
 #define EXT2_FL_USER_VISIBLE		0x004BDFFF /* User visible flags */
-- 
1.7.11.7

