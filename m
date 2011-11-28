From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 04/14] Replace 2D array references by pointer references in
	loops.
Date: Mon, 28 Nov 2011 14:37:31 -0800
Message-ID: <20111128223731.28705.99216.stgit@elm3c44.beaverton.ibm.com>
References: <20111128223659.28705.56719.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Joakim Tjernlund <joakim.tjernlund@transmode.se>,
	Bob Pearson <rpearson@systemfabricworks.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50127 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab1K1WoK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Nov 2011 17:44:10 -0500
Received: from /spool/local
	by e2.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 28 Nov 2011 17:44:08 -0500
In-Reply-To: <20111128223659.28705.56719.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This change has no effect on X86 code but improves PPC
performance.

Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
---
 lib/crc32.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)


diff --git a/lib/crc32.c b/lib/crc32.c
index 7a0e5a9..c93c9ae 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -53,20 +53,21 @@ static inline u32
 crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 {
 # ifdef __LITTLE_ENDIAN
-#  define DO_CRC(x) crc = tab[0][(crc ^ (x)) & 255] ^ (crc >> 8)
-#  define DO_CRC4 crc = tab[3][(crc) & 255] ^ \
-		tab[2][(crc >> 8) & 255] ^ \
-		tab[1][(crc >> 16) & 255] ^ \
-		tab[0][(crc >> 24) & 255]
+#  define DO_CRC(x) (crc = t0[(crc ^ (x)) & 255] ^ (crc >> 8))
+#  define DO_CRC4 crc = t3[(crc) & 255] ^ \
+			t2[(crc >> 8) & 255] ^ \
+			t1[(crc >> 16) & 255] ^ \
+			t0[(crc >> 24) & 255]
 # else
-#  define DO_CRC(x) crc = tab[0][((crc >> 24) ^ (x)) & 255] ^ (crc << 8)
-#  define DO_CRC4 crc = tab[0][(crc) & 255] ^ \
-		tab[1][(crc >> 8) & 255] ^ \
-		tab[2][(crc >> 16) & 255] ^ \
-		tab[3][(crc >> 24) & 255]
+#  define DO_CRC(x) (crc = t0[((crc >> 24) ^ (x)) & 255] ^ (crc << 8))
+#  define DO_CRC4 crc = t0[(crc) & 255] ^ \
+			t1[(crc >> 8) & 255] ^ \
+			t2[(crc >> 16) & 255] ^ \
+			t3[(crc >> 24) & 255]
 # endif
 	const u32 *b;
 	size_t    rem_len;
+	const u32 *t0 = tab[0], *t1 = tab[1], *t2 = tab[2], *t3 = tab[3];
 
 	/* Align it */
 	if (unlikely((long)buf & 3 && len)) {

