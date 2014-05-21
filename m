From: Giedrius Rekasius <giedrius.rekasius@gmail.com>
Subject: [PATCH] ext4: remove unused local variable "stored" from
 ext4_readdir(...)
Date: Wed, 21 May 2014 16:32:26 +0100
Message-ID: <20140521153226.GD8826@vaio>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Giedrius Rekasius <giedrius.rekasius@gmail.com>

Remove local variable "stored" from ext4_readdir(...). This variable 
gets initialized but is never used inside the function.

Signed-off-by: Giedrius Rekasius <giedrius.rekasius@gmail.com>
---
 fs/ext4/dir.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index d638c57..ef1bed6 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -105,7 +105,7 @@ int __ext4_check_dir_entry(const char *function, unsigned int line,
 static int ext4_readdir(struct file *file, struct dir_context *ctx)
 {
 	unsigned int offset;
-	int i, stored;
+	int i;
 	struct ext4_dir_entry_2 *de;
 	int err;
 	struct inode *inode = file_inode(file);
@@ -133,7 +133,6 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 			return ret;
 	}
 
-	stored = 0;
 	offset = ctx->pos & (sb->s_blocksize - 1);
 
 	while (ctx->pos < inode->i_size) {
