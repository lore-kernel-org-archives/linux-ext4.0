From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] ext4: do not unnecessarily null-terminate encrypted symlink data
Date: Thu, 22 Sep 2016 13:31:47 -0700
Message-ID: <1474576309-86917-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        tytso@mit.edu, jaegeuk@kernel.org,
        Eric Biggers <ebiggers@google.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Null-terminating the fscrypt_symlink_data on read is unnecessary because
it is not string data --- it contains binary ciphertext.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/symlink.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index 0a26cbd..fdf1c61 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -30,7 +30,6 @@ static const char *ext4_encrypted_get_link(struct dentry *dentry,
 	char *caddr, *paddr = NULL;
 	struct fscrypt_str cstr, pstr;
 	struct fscrypt_symlink_data *sd;
-	loff_t size = min_t(loff_t, i_size_read(inode), PAGE_SIZE - 1);
 	int res;
 	u32 max_size = inode->i_sb->s_blocksize;
 
@@ -49,7 +48,6 @@ static const char *ext4_encrypted_get_link(struct dentry *dentry,
 		if (IS_ERR(cpage))
 			return ERR_CAST(cpage);
 		caddr = page_address(cpage);
-		caddr[size] = 0;
 	}
 
 	/* Symlink is encrypted */
-- 
2.8.0.rc3.226.g39d4020

