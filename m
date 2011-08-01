From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/5] ext4: use EXT4_BAD_INO for buddy cache to avoid colliding with valid inode #
Date: Mon,  1 Aug 2011 09:13:17 -0400
Message-ID: <1312204398-12460-5-git-send-email-tytso@mit.edu>
References: <A8CDAA23-61C6-4823-ADB1-7D36CBAFC025@whamcloud.com>
 <1312204398-12460-1-git-send-email-tytso@mit.edu>
Cc: Yu Jian <yujian@whamcloud.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40449 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab1HANNV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Aug 2011 09:13:21 -0400
In-Reply-To: <1312204398-12460-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Yu Jian <yujian@whamcloud.com>

Signed-off-by: Yu Jian <yujian@whamcloud.com>
Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 262fa47..8beccd8 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2342,7 +2342,11 @@ static int ext4_mb_init_backend(struct super_block *sb)
 		ext4_msg(sb, KERN_ERR, "can't get new inode");
 		goto err_freesgi;
 	}
-	sbi->s_buddy_cache->i_ino = get_next_ino();
+	/* To avoid potentially colliding with an valid on-disk inode number,
+	 * use EXT4_BAD_INO for the buddy cache inode number.  This inode is
+	 * not in the inode hash, so it should never be found by iget(), but
+	 * this will avoid confusion if it ever shows up during debugging. */
+	sbi->s_buddy_cache->i_ino = EXT4_BAD_INO;
 	EXT4_I(sbi->s_buddy_cache)->i_disksize = 0;
 	for (i = 0; i < ngroups; i++) {
 		desc = ext4_get_group_desc(sb, i, NULL);
-- 
1.7.4.1.22.gec8e1.dirty

