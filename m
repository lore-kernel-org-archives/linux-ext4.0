From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH FOR-STABLE-2.6.27 05/24] ext4: Widen type of ext4_sb_info.s_mb_maxs[]
Date: Tue, 17 Feb 2009 10:58:25 -0500
Message-ID: <1234886324-15105-6-git-send-email-tytso@mit.edu>
References: <1234886324-15105-1-git-send-email-tytso@mit.edu>
 <1234886324-15105-2-git-send-email-tytso@mit.edu>
 <1234886324-15105-3-git-send-email-tytso@mit.edu>
 <1234886324-15105-4-git-send-email-tytso@mit.edu>
 <1234886324-15105-5-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Yasunori Goto <y-goto@jp.fujitsu.com>,
	"Theodore Ts'o" <tytso@mit.edu>, Li Zefan <lizf@cn.fujitsu.com>,
	Miao Xie <miaox@cn.fujitsu.com>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35309 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbZBQP73 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Feb 2009 10:59:29 -0500
In-Reply-To: <1234886324-15105-5-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Yasunori Goto <y-goto@jp.fujitsu.com>

I chased the cause of following ext4 oops report which is tested on
ia64 box.

http://bugzilla.kernel.org/show_bug.cgi?id=12018

The cause is the size of s_mb_maxs array that is defined as "unsigned
short" in ext4_sb_info structure.  If the file system's block size is
8k or greater, an unsigned short is not wide enough to contain the
value fs->blocksize << 3.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: stable@kernel.org
(cherry picked from commit ff7ef329b268b603ea4a2303241ef1c3829fd574)
---
 fs/ext4/ext4_sb.h |    3 ++-
 fs/ext4/mballoc.c |    2 ++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ext4_sb.h b/fs/ext4/ext4_sb.h
index 0881b2c..f20df8a 100644
--- a/fs/ext4/ext4_sb.h
+++ b/fs/ext4/ext4_sb.h
@@ -103,7 +103,8 @@ struct ext4_sb_info {
 	struct list_head s_committed_transaction;
 	spinlock_t s_md_lock;
 	tid_t s_last_transaction;
-	unsigned short *s_mb_offsets, *s_mb_maxs;
+	unsigned short *s_mb_offsets;
+	unsigned int *s_mb_maxs;
 
 	/* tunables */
 	unsigned long s_stripe;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ba86b56..c30048f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2495,6 +2495,8 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 		clear_opt(sbi->s_mount_opt, MBALLOC);
 		return -ENOMEM;
 	}
+
+	i = (sb->s_blocksize_bits + 2) * sizeof(unsigned int);
 	sbi->s_mb_maxs = kmalloc(i, GFP_KERNEL);
 	if (sbi->s_mb_maxs == NULL) {
 		clear_opt(sbi->s_mount_opt, MBALLOC);
-- 
1.5.6.3

