From: Theodore Ts'o <tytso@mit.edu>
Subject: [FOR-STABLE 04/20] ext4: add missing unlock in ext4_check_descriptors() on error path
Date: Sun, 16 Nov 2008 11:05:24 -0500
Message-ID: <1226851540-8032-5-git-send-email-tytso@mit.edu>
References: <1226851540-8032-1-git-send-email-tytso@mit.edu>
 <1226851540-8032-2-git-send-email-tytso@mit.edu>
 <1226851540-8032-3-git-send-email-tytso@mit.edu>
 <1226851540-8032-4-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Li Zefan <lizf@cn.fujitsu.com>, "Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:44685 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752768AbYKPQfj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Nov 2008 11:35:39 -0500
In-Reply-To: <1226851540-8032-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Li Zefan <lizf@cn.fujitsu.com>

If there group descriptors are corrupted we need unlock the block
group lock before returning from the function; else we will oops when
freeing a spinlock which is still being held.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 7ee1ec4ca30c6df8e989615cdaacb75f2af4fa6b)
---
 fs/ext4/super.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 062b7c5..f98f9bb 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1626,8 +1626,10 @@ static int ext4_check_descriptors(struct super_block *sb)
 			       "Checksum for group %lu failed (%u!=%u)\n",
 			       i, le16_to_cpu(ext4_group_desc_csum(sbi, i,
 			       gdp)), le16_to_cpu(gdp->bg_checksum));
-			if (!(sb->s_flags & MS_RDONLY))
+			if (!(sb->s_flags & MS_RDONLY)) {
+				spin_unlock(sb_bgl_lock(sbi, i));
 				return 0;
+			}
 		}
 		spin_unlock(sb_bgl_lock(sbi, i));
 		if (!flexbg_flag)
-- 
1.6.0.4.8.g36f27.dirty

