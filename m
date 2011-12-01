From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 01/14] crc32: removed two instances of trailing whitespaces
Date: Thu, 01 Dec 2011 12:13:50 -0800
Message-ID: <20111201201350.5876.11817.stgit@elm3c44.beaverton.ibm.com>
References: <20111201201341.5876.83743.stgit@elm3c44.beaverton.ibm.com>
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
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20111201201341.5876.83743.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

	- remove trailing whitespace from lib/crc32.c
	- remove trailing whitespace from lib/crc32defs.h

From: Bob Pearson <rpearson@systemfabricworks.com>
Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
[djwong@us.ibm.com: changelog tweaks]
Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/crc32.c     |    2 +-
 lib/crc32defs.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/lib/crc32.c b/lib/crc32.c
index a6e633a..23b08ba 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -316,7 +316,7 @@ EXPORT_SYMBOL(crc32_be);
  * in the correct multiple to subtract, we can shift a byte at a time.
  * This produces a 40-bit (rather than a 33-bit) intermediate remainder,
  * but again the multiple of the polynomial to subtract depends only on
- * the high bits, the high 8 bits in this case.  
+ * the high bits, the high 8 bits in this case.
  *
  * The multiple we need in that case is the low 32 bits of a 40-bit
  * value whose high 8 bits are given, and which is a multiple of the
diff --git a/lib/crc32defs.h b/lib/crc32defs.h
index 9b6773d..f5a5401 100644
--- a/lib/crc32defs.h
+++ b/lib/crc32defs.h
@@ -8,7 +8,7 @@
 
 /* How many bits at a time to use.  Requires a table of 4<<CRC_xx_BITS bytes. */
 /* For less performance-sensitive, use 4 */
-#ifndef CRC_LE_BITS 
+#ifndef CRC_LE_BITS
 # define CRC_LE_BITS 8
 #endif
 #ifndef CRC_BE_BITS

