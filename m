From: Seunghun Lee <waydi1@gmail.com>
Subject: [PATCH 2/2] ext2: fix error handling in ext2_fill_super()
Date: Thu, 15 May 2014 21:26:16 +0900
Message-ID: <1400156776-3412-2-git-send-email-waydi1@gmail.com>
References: <1400156776-3412-1-git-send-email-waydi1@gmail.com>
Cc: lczerner@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Seunghun Lee <waydi1@gmail.com>
To: jack@suse.cz
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1400156776-3412-1-git-send-email-waydi1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext2_fill_super is using err variable, but it is not applied to return value.

This patch fixes it.

Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 fs/ext2/super.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index e3fc51e..7e36536 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -770,14 +770,13 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	unsigned long logic_sb_block;
 	unsigned long offset = 0;
 	unsigned long def_mount_opts;
-	int ret = -EINVAL;
+	int ret = -ENOMEM;
 	int blocksize = BLOCK_SIZE;
 	int db_count;
 	int i, j;
 	__le32 features;
-	int err;
+	int err = 0;
 
-	err = -ENOMEM;
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		goto failed;
@@ -793,6 +792,9 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 
 	spin_lock_init(&sbi->s_lock);
 
+	/* -EINVAL is default */
+	ret = -EINVAL;
+
 	/*
 	 * See what the current blocksize for the device is, and
 	 * use that as the blocksize.  Otherwise (or if the blocksize
@@ -1140,7 +1142,7 @@ failed_sbi:
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
 failed:
-	return ret;
+	return err ? err : ret;
 }
 
 static void ext2_clear_super_error(struct super_block *sb)
-- 
1.7.9.5
