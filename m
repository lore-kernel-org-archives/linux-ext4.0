From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH] fix an endianness bug in ext4_encrypted_follow_link()
Date: Thu, 26 Nov 2015 15:27:28 +0000
Message-ID: <20151126152728.GT22011@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

applying le32_to_cpu() to 16bit value is a bad idea...
    
Cc: stable@vger.kernel.org # v4.1+
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---

diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index abe2401..e8e7af6 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -52,7 +52,7 @@ static const char *ext4_encrypted_follow_link(struct dentry *dentry, void **cook
 	/* Symlink is encrypted */
 	sd = (struct ext4_encrypted_symlink_data *)caddr;
 	cstr.name = sd->encrypted_path;
-	cstr.len  = le32_to_cpu(sd->len);
+	cstr.len  = le16_to_cpu(sd->len);
 	if ((cstr.len +
 	     sizeof(struct ext4_encrypted_symlink_data) - 1) >
 	    max_size) {
