From: Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] configure.in: fix external libblkid test for static link
Date: Wed, 11 Jun 2014 13:08:33 +0300
Message-ID: <b52e76432fe23490b891884f3a66504101c2a5bd.1402481313.git.baruch@tkos.co.il>
Cc: linux-ext4@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:53842 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbaFKKLM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jun 2014 06:11:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

External libblkid needs -luuid when linking statically. Use pkg-config to
determine it correctly. Adding --static doesn't heart even for dynamic
linking.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 configure.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.in b/configure.in
index 448a2926776a..ec6068320878 100644
--- a/configure.in
+++ b/configure.in
@@ -551,7 +551,7 @@ then
 		[LIBBLKID=`$PKG_CONFIG --libs blkid`;
 		 STATIC_LIBBLKID=`$PKG_CONFIG --static --libs blkid`],
 		[AC_MSG_ERROR([external blkid library not found])],
-		[$LIBBLKID])
+		[`$PKG_CONFIG --static --libs blkid`])
 	BLKID_CMT=#
 	AC_MSG_RESULT([Disabling private blkid library])
 else
-- 
2.0.0

