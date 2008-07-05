From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 08/52] ext4: miscellaneous error checks and coding cleanups for mballoc
Date: Sat,  5 Jul 2008 13:35:34 -0400
Message-ID: <1215279378-30504-9-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
 <1215279378-30504-8-git-send-email-tytso@mit.edu>
Cc: Shen Feng <shen@cn.fujitsu.com>, Mingming Cao <cmm@us.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33105 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756009AbYGERge (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2008 13:36:34 -0400
In-Reply-To: <1215279378-30504-8-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Shen Feng <shen@cn.fujitsu.com>

ext4_mb_seq_history_open(): check if sbi->s_mb_history is NULL

ext4_mb_history_init(): replace kmalloc and memset with kzalloc

ext4_mb_init_backend(): remove memset since kzalloc is used

ext4_mb_init(): the return value of ext4_mb_init_backend is int,
	but i is unsigned, replace it with a new int variable.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 49c1d1c..37ac13d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1979,6 +1979,8 @@ static int ext4_mb_seq_history_open(struct inode *inode, struct file *file)
 	int rc;
 	int size;
 
+	if (unlikely(sbi->s_mb_history == NULL))
+		return -ENOMEM;
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (s == NULL)
 		return -ENOMEM;
@@ -2181,9 +2183,7 @@ static void ext4_mb_history_init(struct super_block *sb)
 	sbi->s_mb_history_cur = 0;
 	spin_lock_init(&sbi->s_mb_history_lock);
 	i = sbi->s_mb_history_max * sizeof(struct ext4_mb_history);
-	sbi->s_mb_history = kmalloc(i, GFP_KERNEL);
-	if (likely(sbi->s_mb_history != NULL))
-		memset(sbi->s_mb_history, 0, i);
+	sbi->s_mb_history = kzalloc(i, GFP_KERNEL);
 	/* if we can't allocate history, then we simple won't use it */
 }
 
@@ -2297,7 +2297,6 @@ static int ext4_mb_init_backend(struct super_block *sb)
 			i++;
 			goto err_freebuddy;
 		}
-		memset(meta_group_info[j], 0, len);
 		set_bit(EXT4_GROUP_INFO_NEED_INIT_BIT,
 			&(meta_group_info[j]->bb_state));
 
@@ -2352,6 +2351,7 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 	unsigned i;
 	unsigned offset;
 	unsigned max;
+	int ret;
 
 	if (!test_opt(sb, MBALLOC))
 		return 0;
@@ -2386,12 +2386,12 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 	} while (i <= sb->s_blocksize_bits + 1);
 
 	/* init file for buddy data */
-	i = ext4_mb_init_backend(sb);
-	if (i) {
+	ret = ext4_mb_init_backend(sb);
+	if (ret != 0) {
 		clear_opt(sbi->s_mount_opt, MBALLOC);
 		kfree(sbi->s_mb_offsets);
 		kfree(sbi->s_mb_maxs);
-		return i;
+		return ret;
 	}
 
 	spin_lock_init(&sbi->s_md_lock);
-- 
1.5.6.rc3.1.g36b7.dirty

