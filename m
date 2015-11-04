From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] fs-ext4: Delete unnecessary checks before the function call
 "iput"
Date: Wed, 4 Nov 2015 18:57:06 +0100
Message-ID: <563A46F2.4050908@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
 <530A086E.8010901@users.sourceforge.net>
 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net>
 <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 4 Nov 2015 18:48:38 +0100

The iput() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/ext4/resize.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index ad62d7a..7918012 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1942,10 +1942,10 @@ retry:
 		err = ext4_convert_meta_bg(sb, resize_inode);
 		if (err)
 			goto out;
-		if (resize_inode) {
-			iput(resize_inode);
-			resize_inode = NULL;
-		}
+
+		iput(resize_inode);
+		resize_inode = NULL;
+
 		if (n_blocks_count_retry) {
 			n_blocks_count = n_blocks_count_retry;
 			n_blocks_count_retry = 0;
@@ -2011,8 +2011,7 @@ retry:
 out:
 	if (flex_gd)
 		free_flex_gd(flex_gd);
-	if (resize_inode != NULL)
-		iput(resize_inode);
+	iput(resize_inode);
 	ext4_msg(sb, KERN_INFO, "resized filesystem to %llu", n_blocks_count);
 	return err;
 }
-- 
2.6.2
