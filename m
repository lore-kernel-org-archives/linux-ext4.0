From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 20/42] ext4: add missing unlock in ext4_check_descriptors() on error path
Date: Thu,  9 Oct 2008 00:05:38 -0400
Message-ID: <1223525160-9887-21-git-send-email-tytso@mit.edu>
References: <1223525160-9887-1-git-send-email-tytso@mit.edu>
 <1223525160-9887-2-git-send-email-tytso@mit.edu>
 <1223525160-9887-3-git-send-email-tytso@mit.edu>
 <1223525160-9887-4-git-send-email-tytso@mit.edu>
 <1223525160-9887-5-git-send-email-tytso@mit.edu>
 <1223525160-9887-6-git-send-email-tytso@mit.edu>
 <1223525160-9887-7-git-send-email-tytso@mit.edu>
 <1223525160-9887-8-git-send-email-tytso@mit.edu>
 <1223525160-9887-9-git-send-email-tytso@mit.edu>
 <1223525160-9887-10-git-send-email-tytso@mit.edu>
 <1223525160-9887-11-git-send-email-tytso@mit.edu>
 <1223525160-9887-12-git-send-email-tytso@mit.edu>
 <1223525160-9887-13-git-send-email-tytso@mit.edu>
 <1223525160-9887-14-git-send-email-tytso@mit.edu>
 <1223525160-9887-15-git-send-email-tytso@mit.edu>
 <1223525160-9887-16-git-send-email-tytso@mit.edu>
 <1223525160-9887-17-git-send-email-tytso@mit.edu>
 <1223525160-9887-18-git-send-email-tytso@mit.edu>
 <1223525160-9887-19-git-send-email-tytso@mit.edu>
 <1223525160-9887-20-git-send-email-tytso@mit.edu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54541 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757613AbYJIEGO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2008 00:06:14 -0400
In-Reply-To: <1223525160-9887-20-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Li Zefan <lizf@cn.fujitsu.com>

If there group descriptors are corrupted we need unlock the block
group lock before returning from the function; else we will oops when
freeing a spinlock which is still being held.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 64e1c21..8175318 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1623,8 +1623,10 @@ static int ext4_check_descriptors(struct super_block *sb)
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
1.5.6.1.205.ge2c7.dirty

