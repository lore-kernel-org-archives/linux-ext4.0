From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH] ext4: error processing and coding enhancement for mballoc
Date: Tue, 27 May 2008 16:34:30 +0800
Message-ID: <483BC796.9020402@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
To: alex@clusterfs.com, Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:51576 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756296AbYE0IhK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 May 2008 04:37:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

*ext4_mb_seq_history_open: check if sbi->s_mb_history is NULL
*ext4_mb_history_init: replace kmalloc and memset with kzalloc
*ext4_mb_init_backend: remove memset since kzalloc is used
*ext4_mb_init: the return value of ext4_mb_init_backend is int,
 but i is unsigned, replace it with a new int variable.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 fs/ext4/mballoc.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index add55f0..35c12db 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1963,6 +1963,8 @@ static int ext4_mb_seq_history_open(struct inode *inode, struct file *file)
 	int rc;
 	int size;
 
+	if (unlikely(sbi->s_mb_history == NULL))
+		return -ENOMEM;
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (s == NULL)
 		return -ENOMEM;
@@ -2165,9 +2167,7 @@ static void ext4_mb_history_init(struct super_block *sb)
 	sbi->s_mb_history_cur = 0;
 	spin_lock_init(&sbi->s_mb_history_lock);
 	i = sbi->s_mb_history_max * sizeof(struct ext4_mb_history);
-	sbi->s_mb_history = kmalloc(i, GFP_KERNEL);
-	if (likely(sbi->s_mb_history != NULL))
-		memset(sbi->s_mb_history, 0, i);
+	sbi->s_mb_history = kzalloc(i, GFP_KERNEL);
 	/* if we can't allocate history, then we simple won't use it */
 }
 
@@ -2281,7 +2281,6 @@ static int ext4_mb_init_backend(struct super_block *sb)
 			i++;
 			goto err_freebuddy;
 		}
-		memset(meta_group_info[j], 0, len);
 		set_bit(EXT4_GROUP_INFO_NEED_INIT_BIT,
 			&(meta_group_info[j]->bb_state));
 
@@ -2336,6 +2335,7 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 	unsigned i;
 	unsigned offset;
 	unsigned max;
+	int ret;
 
 	if (!test_opt(sb, MBALLOC))
 		return 0;
@@ -2370,12 +2370,12 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
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
1.5.4.5
