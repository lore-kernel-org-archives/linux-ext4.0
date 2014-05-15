From: Seunghun Lee <waydi1@gmail.com>
Subject: [PATCH 1/2] ext2: fix type of return value ext2_fill_super()
Date: Thu, 15 May 2014 21:26:15 +0900
Message-ID: <1400156776-3412-1-git-send-email-waydi1@gmail.com>
Cc: lczerner@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Seunghun Lee <waydi1@gmail.com>
To: jack@suse.cz
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch fixes type of return value ext2_fill_super().

Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 fs/ext2/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 3750031..e3fc51e 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -770,7 +770,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	unsigned long logic_sb_block;
 	unsigned long offset = 0;
 	unsigned long def_mount_opts;
-	long ret = -EINVAL;
+	int ret = -EINVAL;
 	int blocksize = BLOCK_SIZE;
 	int db_count;
 	int i, j;
-- 
1.7.9.5
