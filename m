From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Don't set s_buddy_cache->i_ino to EXT4_BAD_INO
Date: Wed, 17 Aug 2011 16:20:22 +0800
Message-ID: <1313569222-5079-1-git-send-email-tm@tao.ma>
Cc: Yu Jian <yujian@whamcloud.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:36672 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750853Ab1HQIV4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Aug 2011 04:21:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

In 85fe4025, Christoph removed get_next_ino() from new_inode() and
do s_buddy_cache->i_ino = get_next_ino();
And then 48e6061b gives EXT4_BAD_INO to this inode. But actually
s_buddy_cache is used directly and we never get it from an inode number.
So it should be safe for us to not set i_ino at all and I guess that
is the case Christoph described in his commit log of 85fe4025
"For a few more filesystems we can avoid assigning any inode number given
that they aren't user visible".

Cc: Yu Jian <yujian@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/mballoc.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 17a5a57..982f783 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2342,11 +2342,6 @@ static int ext4_mb_init_backend(struct super_block *sb)
 		ext4_msg(sb, KERN_ERR, "can't get new inode");
 		goto err_freesgi;
 	}
-	/* To avoid potentially colliding with an valid on-disk inode number,
-	 * use EXT4_BAD_INO for the buddy cache inode number.  This inode is
-	 * not in the inode hash, so it should never be found by iget(), but
-	 * this will avoid confusion if it ever shows up during debugging. */
-	sbi->s_buddy_cache->i_ino = EXT4_BAD_INO;
 	EXT4_I(sbi->s_buddy_cache)->i_disksize = 0;
 	for (i = 0; i < ngroups; i++) {
 		desc = ext4_get_group_desc(sb, i, NULL);
-- 
1.7.0.4

