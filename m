From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1 linux-next] ext4: use swap() in memswap()
Date: Fri, 12 Jun 2015 18:58:54 +0200
Message-ID: <1434128334-10302-1-git-send-email-fabf@skynet.be>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
	Fabian Frederick <fabf@skynet.be>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Use kernel.h macro definition.

Thanks to Julia Lawall for Coccinelle scripting support.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext4/ioctl.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 7ce8582..cb84512 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -31,14 +31,11 @@
 static void memswap(void *a, void *b, size_t len)
 {
 	unsigned char *ap, *bp;
-	unsigned char tmp;
 
 	ap = (unsigned char *)a;
 	bp = (unsigned char *)b;
 	while (len-- > 0) {
-		tmp = *ap;
-		*ap = *bp;
-		*bp = tmp;
+		swap(*ap, *bp);
 		ap++;
 		bp++;
 	}
-- 
2.4.2
