From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [PATCH] ext4/ioctl.c: copy_{from,to}_user expect __user pointers
Date: Fri, 23 Sep 2011 15:25:54 -0700
Message-ID: <201109231525.54301.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This quiets the sparse noise:

warning: incorrect type in argument 2 (different address spaces)
   expected void const [noderef] <asn:1>*from
   got struct fstrim_range *<noident>
warning: incorrect type in argument 1 (different address spaces)
   expected void [noderef] <asn:1>*to
   got struct fstrim_range *<noident>

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>

---

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index f18bfe3..43759b1 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -348,7 +348,7 @@ mext_out:
 		if (!blk_queue_discard(q))
 			return -EOPNOTSUPP;
 
-		if (copy_from_user(&range, (struct fstrim_range *)arg,
+		if (copy_from_user(&range, (struct fstrim_range __user *)arg,
 		    sizeof(range)))
 			return -EFAULT;
 
@@ -358,7 +358,7 @@ mext_out:
 		if (ret < 0)
 			return ret;
 
-		if (copy_to_user((struct fstrim_range *)arg, &range,
+		if (copy_to_user((struct fstrim_range __user *)arg, &range,
 		    sizeof(range)))
 			return -EFAULT;
 
