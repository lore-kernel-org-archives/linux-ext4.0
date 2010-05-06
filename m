From: =?GB2312?B?IsXLzsDGvShQZXRlciBQYW4pIg==?= <wppan@redflag-linux.com>
Subject: [PATCH] ext2/ext3:useless code for return value
Date: Thu, 06 May 2010 21:36:21 +0800
Message-ID: <4BE2C5D5.2050207@redflag-linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: tj@kernel.org, Christoph Lameter <cl@linux-foundation.org>,
	hch@lst.de, akpm@linux-foundation.org, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.redflag-linux.com ([219.237.229.196]:54944 "EHLO
	mail.redflag-linux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab0EFODH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 May 2010 10:03:07 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


When rsv is the right hand side of goal, we should return NULL,
because now rsv's prev is NULL, or we return rsv.

Signed-off-by: Peter Pan(=C5=CB=CE=C0=C6=BD) <wppan@redflag-linux.com>

---
 fs/ext2/balloc.c |    6 +-----
 fs/ext3/balloc.c |    6 +-----
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 3cf038c..023990f 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -323,11 +323,7 @@ search_reserve_window(struct rb_root *root,
ext2_fsblk_t goal)
 	 * side of the interval containing the goal.  If it's the RHS,
 	 * we need to back up one.
 	 */
-	if (rsv->rsv_start > goal) {
-		n =3D rb_prev(&rsv->rsv_node);
-		rsv =3D rb_entry(n, struct ext2_reserve_window_node, rsv_node);
-	}
-	return rsv;
+    return (rsv->rsv_start < goal) ? rsv : NULL;
 }

 /*
diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index a177122..bfa62e9 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -310,11 +310,7 @@ search_reserve_window(struct rb_root *root,
ext3_fsblk_t goal)
 	 * side of the interval containing the goal.  If it's the RHS,
 	 * we need to back up one.
 	 */
-	if (rsv->rsv_start > goal) {
-		n =3D rb_prev(&rsv->rsv_node);
-		rsv =3D rb_entry(n, struct ext3_reserve_window_node, rsv_node);
-	}
-	return rsv;
+    return (rsv->rsv_start < goal) ? rsv : NULL;
 }

 /**
--=20
1.6.6


--=20
Peter Pan(=C5=CB=CE=C0=C6=BD)
Red Flag Software Co.,Ltd
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
