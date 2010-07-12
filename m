From: Joe Perches <joe@perches.com>
Subject: [PATCH 25/36] fs/ext3: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:17 -0700
Message-ID: <dd90d7b9b09a3332ebe5c3578b5c90a657edbe02.1278967121.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Jiri Kosina <trivial@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ext3/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/dir.c b/fs/ext3/dir.c
index e2e72c3..d056787 100644
--- a/fs/ext3/dir.c
+++ b/fs/ext3/dir.c
@@ -337,7 +337,7 @@ int ext3_htree_store_dirent(struct file *dir_file, __u32 hash,
 	struct dir_private_info *info;
 	int len;
 
-	info = (struct dir_private_info *) dir_file->private_data;
+	info = dir_file->private_data;
 	p = &info->root.rb_node;
 
 	/* Create and allocate the fname structure */
-- 
1.7.1.337.g6068.dirty
