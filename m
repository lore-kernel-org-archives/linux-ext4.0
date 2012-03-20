From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: [PATCH v1 5/9] VFS: remove unused superblock helpers
Date: Tue, 20 Mar 2012 16:41:25 +0200
Message-ID: <1332254489-2300-6-git-send-email-dedekind1@gmail.com>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Remove the 'sb_mark_dirty()', 'sb_mark_clean()' and 'sb_is_dirty()' helpers
which are not used. I introduced them 2 years and the intention was to make
all file-systems use them in order to be able to optimize 'sync_supers()'.
However, Al Viro vetoed my patches at the end and asked me to push superblock
management down to file-systems and get rid of the 's_dirt' flag completely,
as well as kill 'sync_supers()' altogether. Thus, remove the helpers.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
---
 include/linux/fs.h |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 69cd5bb..68387e9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1870,19 +1870,6 @@ extern struct dentry *mount_pseudo(struct file_system_type *, char *,
 	const struct dentry_operations *dops,
 	unsigned long);
 
-static inline void sb_mark_dirty(struct super_block *sb)
-{
-	sb->s_dirt = 1;
-}
-static inline void sb_mark_clean(struct super_block *sb)
-{
-	sb->s_dirt = 0;
-}
-static inline int sb_is_dirty(struct super_block *sb)
-{
-	return sb->s_dirt;
-}
-
 /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
 #define fops_get(fops) \
 	(((fops) && try_module_get((fops)->owner) ? (fops) : NULL))
-- 
1.7.7.6
