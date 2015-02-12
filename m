From: Kevin Mulvey <kevin@kevinmulvey.net>
Subject: [PATCH] fix spacing in ext4/super.c
Date: Thu, 12 Feb 2015 07:51:47 -0500
Message-ID: <1423745507-31967-1-git-send-email-kmulvey@linux.com>
Cc: Kevin Mulvey <kmulvey@linux.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a patch to super.c that fixes some spacing errors found by
checkpatch.pl

Signed-off-by: Kevin Mulvey <kmulvey@linux.com>
---
 fs/ext4/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ac64edb..6fa3d5b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2569,7 +2569,7 @@ static ssize_t sbi_deprecated_show(struct ext4_attr *a,
 	return snprintf(buf, PAGE_SIZE, "%d\n", a->u.deprecated_val);
 }
 
-#define EXT4_ATTR_OFFSET(_name,_mode,_show,_store,_elname) \
+#define EXT4_ATTR_OFFSET(_name, _mode, _show, _store, _elname) \
 static struct ext4_attr ext4_attr_##_name = {			\
 	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.show	= _show,					\
@@ -2579,7 +2579,7 @@ static struct ext4_attr ext4_attr_##_name = {			\
 	},							\
 }
 
-#define EXT4_ATTR_OFFSET_ES(_name,_mode,_show,_store,_elname)		\
+#define EXT4_ATTR_OFFSET_ES(_name, _mode, _show, _store, _elname)		\
 static struct ext4_attr ext4_attr_##_name = {				\
 	.attr = {.name = __stringify(_name), .mode = _mode },		\
 	.show	= _show,						\
@@ -4114,7 +4114,7 @@ no_journal:
 	}
 
 	block = ext4_count_free_clusters(sb);
-	ext4_free_blocks_count_set(sbi->s_es, 
+	ext4_free_blocks_count_set(sbi->s_es,
 				   EXT4_C2B(sbi, block));
 	err = percpu_counter_init(&sbi->s_freeclusters_counter, block,
 				  GFP_KERNEL);
-- 
2.1.0
