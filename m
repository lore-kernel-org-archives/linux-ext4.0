From: "crosslonelyover" <crosslonelyover@gmail.com>
Subject: [PATCH] check name_len before down_read xattr_sem and sb_read in ext2_xattr_get
Date: Mon, 12 Jul 2010 22:29:09 +0800
Message-ID: <201007122229025316610@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "linux-ext4" <linux-ext4@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"kernel-janitors" <kernel-janitors@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,
       I walked through ext2_xattr_get, and felt that we can
do some optimization on it. For name_len check, it's done
after down xattr_sem and sb_read, both of which are time
consuming operation compared with strlen:
         down_read(&EXT2_I(inode)->xattr_sem);
 ...
         bh = sb_bread(inode->i_sb, EXT2_I(inode)->i_file_acl);
 ...
         /* find named attribute */
         name_len = strlen(name);

         error = -ERANGE;
         if (name_len > 255)
                 goto cleanup;

       Most of the case, you'll get one valid block, but if the
name len > 255, then the xattr_sem down and sb_bread operation
can be seen as a waste of time. So I think we'd better do
name len check as early as possible.
       Following is my patch, and it's against 2.6.35-rc4.
Please check it.

Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>
---
 fs/ext2/xattr.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 7c39157..0b94d61 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -161,6 +161,13 @@ ext2_xattr_get(struct inode *inode, int name_index, const char *name,
 
 	if (name == NULL)
 		return -EINVAL;
+
+	/* find named attribute */
+	name_len = strlen(name);
+	error = -ERANGE;
+	if (name_len > 255)
+		goto cleanup;
+
 	down_read(&EXT2_I(inode)->xattr_sem);
 	error = -ENODATA;
 	if (!EXT2_I(inode)->i_file_acl)
@@ -181,12 +188,7 @@ bad_block:	ext2_error(inode->i_sb, "ext2_xattr_get",
 		error = -EIO;
 		goto cleanup;
 	}
-	/* find named attribute */
-	name_len = strlen(name);
 
-	error = -ERANGE;
-	if (name_len > 255)
-		goto cleanup;
 	entry = FIRST_ENTRY(bh);
 	while (!IS_LAST_ENTRY(entry)) {
 		struct ext2_xattr_entry *next =
-- 
1.7.1.1
