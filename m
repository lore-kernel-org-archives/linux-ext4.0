From: "crosslonelyover" <crosslonelyover@gmail.com>
Subject: [PATCH & RESEND] avoid NULL deference in ext2_xattr_get
Date: Sun, 11 Jul 2010 10:16:04 +0800
Message-ID: <201007111016021569718@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "kernel-janitors" <kernel-janitors@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"linux-ext4" <linux-ext4@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Dan Carpenter,

     Thanks for your instructions. I regenerated the patch.
Please check it.

>From 3149865e0d118b939c27659a4e4c884eaa6b3a4c Mon Sep 17 00:00:00 2001
From: Wang Sheng-Hui <crosslonelyover@gmail.com>
Date: Sat, 10 Jul 2010 22:07:37 -0400
Subject: [PATCH] avoid NULL deference in ext2_xattr_get


Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>
---
 fs/ext2/xattr.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 7c39157..81ec1c6 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -156,11 +156,12 @@ ext2_xattr_get(struct inode *inode, int name_index, const char *name,
 	char *end;
 	int error;
 
+	if (name == NULL)
+		return -EINVAL;
+
 	ea_idebug(inode, "name=%d.%s, buffer=%p, buffer_size=%ld",
 		  name_index, name, buffer, (long)buffer_size);
 
-	if (name == NULL)
-		return -EINVAL;
 	down_read(&EXT2_I(inode)->xattr_sem);
 	error = -ENODATA;
 	if (!EXT2_I(inode)->i_file_acl)
-- 
1.7.1.1
