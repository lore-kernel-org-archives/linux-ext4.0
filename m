From: Adir Kuhn <adirkuhn@gmail.com>
Subject: [PATCH] fs: ext3: super: fixed a space coding style issue
Date: Fri,  1 May 2015 03:25:27 +0000
Message-ID: <1430450727-13217-1-git-send-email-adirkuhn@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Adir Kuhn <adirkuhn@gmail.com>
To: jack@suse.cz
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fixed a coding style issue

Signed-off-by: Adir Kuhn <adirkuhn@gmail.com>
---
 fs/ext3/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index a9312f0..5ed0044 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1908,7 +1908,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	sbi->s_mount_state = le16_to_cpu(es->s_state);
 	sbi->s_addr_per_block_bits = ilog2(EXT3_ADDR_PER_BLOCK(sb));
 	sbi->s_desc_per_block_bits = ilog2(EXT3_DESC_PER_BLOCK(sb));
-	for (i=0; i < 4; i++)
+	for (i = 0; i < 4; i++)
 		sbi->s_hash_seed[i] = le32_to_cpu(es->s_hash_seed[i]);
 	sbi->s_def_hash_version = es->s_def_hash_version;
 	i = le32_to_cpu(es->s_flags);
-- 
2.1.4
