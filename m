From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 4/4] crc32: Select an algorithm via kconfig
Date: Tue, 04 Oct 2011 16:54:29 -0700
Message-ID: <20111004235429.1560.89556.stgit@elm3c44.beaverton.ibm.com>
References: <20111004235357.1560.12602.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Joakim Tjernlund <joakim.tjernlund@transmode.se>,
	Bob Pearson <rpearson@systemfabricworks.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Theodore Tso <tytso@mit.edu>,
	David Miller <davem@davemloft.net>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45121 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933983Ab1JDXyd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Oct 2011 19:54:33 -0400
In-Reply-To: <20111004235357.1560.12602.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Allow the kernel builder to choose a crc32* algorithm for the kernel.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/Kconfig     |   35 +++++++++++++++++++++++++++++++++++
 lib/crc32defs.h |   18 ++++++++++++++++++
 2 files changed, 53 insertions(+), 0 deletions(-)


diff --git a/lib/Kconfig b/lib/Kconfig
index 477be04..9f08b64 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -70,6 +70,41 @@ config CRC32_SELFTEST
 	  and crc32_be over byte strings with random alignment and length
 	  and computes the total elapsed time and number of bytes processed.
 
+choice
+	prompt "CRC32 implementation"
+	depends on CRC32
+	default CRC32_SLICEBY8
+
+config CRC32_SLICEBY8
+	bool "Slice by 8 bytes"
+	help
+	  Calculate checksum 8 bytes at a time with a clever slicing algorithm.
+	  This is the fastest algorithm, but comes with a 8KiB lookup table.
+	  Most modern processors have enough cache that this shouldn't be
+	  a problem.
+
+	  If you don't know which to choose, choose this one.
+
+config CRC32_SLICEBY4
+	bool "Slice by 4 bytes"
+	help
+	  Calculate checksum 8 bytes at a time with a clever slicing algorithm.
+	  This is reasonably fast, but has a 4KiB lookup table.
+
+config CRC32_SARWATE
+	bool "Sarwate's Algorithm (one byte at a time)"
+	help
+	  Calculate checksum a byte at a time using Sarwate's algorithm.  This
+	  is not particularly fast, but has a small 256 byte lookup table.
+
+config CRC32_BIT
+	bool "Classic Algorithm (one bit at a time)"
+	help
+	  Calculate checksum one bit at a time.  This is VERY slow, but has
+	  no lookup table.  This is provided as a debugging option.
+
+endchoice
+
 config CRC7
 	tristate "CRC7 functions"
 	help
diff --git a/lib/crc32defs.h b/lib/crc32defs.h
index 6fd1917..64cba2c 100644
--- a/lib/crc32defs.h
+++ b/lib/crc32defs.h
@@ -13,6 +13,24 @@
  */
 #define CRC32C_POLY_LE 0x82F63B78
 
+/* Try to choose an implementation variant via Kconfig */
+#ifdef CONFIG_CRC32_SLICEBY8
+# define CRC_LE_BITS 64
+# define CRC_BE_BITS 64
+#endif
+#ifdef CONFIG_CRC32_SLICEBY4
+# define CRC_LE_BITS 32
+# define CRC_BE_BITS 32
+#endif
+#ifdef CONFIG_CRC32_SARWATE
+# define CRC_LE_BITS 8
+# define CRC_BE_BITS 8
+#endif
+#ifdef CONFIG_CRC32_BIT
+# define CRC_LE_BITS 1
+# define CRC_BE_BITS 1
+#endif
+
 /*
  * How many bits at a time to use.  Valid values are 1, 2, 4, 8, 32 and 64.
  * For less performance-sensitive, use 4 or 8 to save table size.

