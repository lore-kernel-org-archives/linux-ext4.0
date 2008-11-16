From: Theodore Ts'o <tytso@mit.edu>
Subject: [FOR-STABLE 13/20] ext4: Do mballoc init before doing filesystem recovery
Date: Sun, 16 Nov 2008 11:05:33 -0500
Message-ID: <1226851540-8032-14-git-send-email-tytso@mit.edu>
References: <1226851540-8032-1-git-send-email-tytso@mit.edu>
 <1226851540-8032-2-git-send-email-tytso@mit.edu>
 <1226851540-8032-3-git-send-email-tytso@mit.edu>
 <1226851540-8032-4-git-send-email-tytso@mit.edu>
 <1226851540-8032-5-git-send-email-tytso@mit.edu>
 <1226851540-8032-6-git-send-email-tytso@mit.edu>
 <1226851540-8032-7-git-send-email-tytso@mit.edu>
 <1226851540-8032-8-git-send-email-tytso@mit.edu>
 <1226851540-8032-9-git-send-email-tytso@mit.edu>
 <1226851540-8032-10-git-send-email-tytso@mit.edu>
 <1226851540-8032-11-git-send-email-tytso@mit.edu>
 <1226851540-8032-12-git-send-email-tytso@mit.edu>
 <1226851540-8032-13-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:44713 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751910AbYKPQgs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Nov 2008 11:36:48 -0500
In-Reply-To: <1226851540-8032-13-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

During filesystem recovery we may be doing a truncate
which expects some of the mballoc data structures to
be initialized. So do ext4_mb_init before recovery.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
(cherry picked from commit c2774d84fd6cab2bfa2a2fae0b1ca8d8ebde48a2)
---
 fs/ext4/super.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index bf0d58c..e1255cc 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2449,6 +2449,21 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			"available.\n");
 	}
 
+	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
+		printk(KERN_WARNING "EXT4-fs: Ignoring delalloc option - "
+				"requested data journaling mode\n");
+		clear_opt(sbi->s_mount_opt, DELALLOC);
+	} else if (test_opt(sb, DELALLOC))
+		printk(KERN_INFO "EXT4-fs: delayed allocation enabled\n");
+
+	ext4_ext_init(sb);
+	err = ext4_mb_init(sb, needs_recovery);
+	if (err) {
+		printk(KERN_ERR "EXT4-fs: failed to initalize mballoc (%d)\n",
+		       err);
+		goto failed_mount4;
+	}
+
 	/*
 	 * akpm: core read_super() calls in here with the superblock locked.
 	 * That deadlocks, because orphan cleanup needs to lock the superblock
@@ -2468,16 +2483,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	       test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA ? "ordered":
 	       "writeback");
 
-	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
-		printk(KERN_WARNING "EXT4-fs: Ignoring delalloc option - "
-				"requested data journaling mode\n");
-		clear_opt(sbi->s_mount_opt, DELALLOC);
-	} else if (test_opt(sb, DELALLOC))
-		printk(KERN_INFO "EXT4-fs: delayed allocation enabled\n");
-
-	ext4_ext_init(sb);
-	ext4_mb_init(sb, needs_recovery);
