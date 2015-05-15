From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1 linux-next] ext4: fix incorrect type argument
Date: Fri, 15 May 2015 23:01:13 +0200
Message-ID: <1431723673-25450-1-git-send-email-fabf@skynet.be>
Cc: Fabian Frederick <fabf@skynet.be>, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fix sparse warning introduced in commit
9bd8212f981e
("ext4 crypto: add encryption policy and password salt support")

fs/ext4/ioctl.c:678:35: warning: incorrect type in argument 1
(different address spaces)
fs/ext4/ioctl.c:678:35:    expected void [noderef] <asn:1>*to
fs/ext4/ioctl.c:678:35:    got void *<noident>

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext4/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 2cb9e17..3c5e530 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -675,8 +675,8 @@ encryption_policy_out:
 			if (err)
 				return err;
 		}
-		if (copy_to_user((void *) arg, sbi->s_es->s_encrypt_pw_salt,
-				 16))
+		if (copy_to_user((void __user *) arg,
+				 sbi->s_es->s_encrypt_pw_salt, 16))
 			return -EFAULT;
 		return 0;
 	}
-- 
2.4.0
