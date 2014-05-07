From: Seunghun Lee <waydi1@gmail.com>
Subject: [PATCH] ext2: super: remove unnecessary goto statement
Date: Thu,  8 May 2014 01:08:03 +0900
Message-ID: <1399478883-2897-1-git-send-email-waydi1@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Seunghun Lee <waydi1@gmail.com>
To: jack@suse.cz
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch removes unnecessary goto failed,
and moves kfree to failed.

Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 fs/ext2/super.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 3750031..7d20a50 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -777,17 +777,15 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	__le32 features;
 	int err;
 
-	err = -ENOMEM;
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
-		goto failed;
+		return -ENOMEM;
 
 	sbi->s_blockgroup_lock =
 		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
-	if (!sbi->s_blockgroup_lock) {
-		kfree(sbi);
+	if (!sbi->s_blockgroup_lock)
 		goto failed;
-	}
+
 	sb->s_fs_info = sbi;
 	sbi->s_sb_block = sb_block;
 
@@ -1138,8 +1136,8 @@ failed_mount:
 failed_sbi:
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
-	kfree(sbi);
 failed:
+	kfree(sbi);
 	return ret;
 }
 
-- 
1.7.9.5
