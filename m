From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] ext4 crypto: type bug with encrypted symlinks
Date: Wed, 15 Apr 2015 12:21:33 +0300
Message-ID: <20150415092133.GA9264@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

sd->len is an __le16 and not an __le32.

Fixes: f1195c72c951 ('ext4 crypto: Add symlink encryption')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 69e12ee..5c82a3c 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3256,7 +3256,7 @@ static int ext4_symlink(struct inode *dir,
 		ext4_put_fname_crypto_ctx(&ctx);
 		if (err < 0)
 			goto err_drop_inode;
-		sd->len = cpu_to_le32(ostr.len);
+		sd->len = cpu_to_le16(ostr.len);
 		disk_link.name = (char *) sd;
 	}
 
