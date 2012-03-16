From: Joe Perches <joe@perches.com>
Subject: [PATCH 5/9] ext4: Avoid output message interleaving in ext4_error_<foo>
Date: Thu, 15 Mar 2012 17:07:33 -0700
Message-ID: <32524e1c6f17ec482a90cb0066934c1955704561.1331856300.git.joe@perches.com>
References: <cover.1331856299.git.joe@perches.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1331856299.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Using pr_cont means that messages from multiple threads
may be interleaved.  Avoid this by using a single pr_<level>
call in ext4_error_inode and ext4_error_file.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ext4/super.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4e1d656..ac77a95 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -517,11 +517,14 @@ void ext4_error_inode(struct inode *inode, const char *function,
 	va_start(args, fmt);
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	pr_crit("error (device %s): %s:%d: inode #%lu: ",
-		inode->i_sb->s_id, function, line, inode->i_ino);
 	if (block)
-		pr_cont("block %llu: ", block);
-	pr_cont("comm %s: %pV\n", current->comm, &vaf);
+		pr_crit("error (device %s): %s:%d: inode #%lu: block %llu: comm %s: %pV\n",
+			inode->i_sb->s_id, function, line, inode->i_ino,
+			block, current->comm, &vaf);
+	else
+		pr_crit("error (device %s): %s:%d: inode #%lu: comm %s: %pV\n",
+			inode->i_sb->s_id, function, line, inode->i_ino,
+			current->comm, &vaf);
 	va_end(args);
 
 	ext4_handle_error(inode->i_sb);
@@ -543,14 +546,17 @@ void ext4_error_file(struct file *file, const char *function,
 	path = d_path(&(file->f_path), pathname, sizeof(pathname));
 	if (IS_ERR(path))
 		path = "(unknown)";
-	pr_crit("error (device %s): %s:%d: inode #%lu: ",
-		inode->i_sb->s_id, function, line, inode->i_ino);
-	if (block)
-		pr_cont("block %llu: ", block);
 	va_start(args, fmt);
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	pr_cont("comm %s: path %s: %pV\n", current->comm, path, &vaf);
+	if (block)
+		pr_crit("error (device %s): %s:%d: inode #%lu: block %llu: comm %s: path %s: %pV\n",
+			inode->i_sb->s_id, function, line, inode->i_ino,
+			block, current->comm, path, &vaf);
+	else
+		pr_crit("error (device %s): %s:%d: inode #%lu: comm %s: path %s: %pV\n",
+			inode->i_sb->s_id, function, line, inode->i_ino,
+			current->comm, path, &vaf);
 	va_end(args);
 
 	ext4_handle_error(inode->i_sb);
-- 
1.7.8.111.gad25c.dirty
