From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 09/14] crc32: Optimize loop counter for x86
Date: Thu, 01 Dec 2011 12:14:44 -0800
Message-ID: <20111201201444.5876.78886.stgit@elm3c44.beaverton.ibm.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111201201341.5876.83743.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add two changes that improve the performance of x86 systems
	1. replace main loop with incrementing counter
	   this change improves the performance of the selftest
	   by about 5-6% on Nehalem CPUs. The apparent
	   reason is that the compiler can use the loop index
	   to perform an indexed memory access. This is
	   reported to make the performance of PowerPC CPUs
	   to get worse.
	2. replace the rem_len loop with incrementing counter
	   this change improves the performance of the selftest,
	   which has more than the usual number of occurances,
	   by about 1-2% on x86 CPUs. In actual work loads
	   the length is most often a multiple of 4 bytes and
	   this code does not get executed as often if at all.
	   Again this change is reported to make the performance
	   of PowerPC get worse.

From: Bob Pearson <rpearson@systemfabricworks.com>
Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
[djwong@us.ibm.com: Minor changelog tweaks]
Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/crc32.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)


diff --git a/lib/crc32.c b/lib/crc32.c
index 6311712..2c8e8c0 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -66,6 +66,9 @@ crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 # endif
 	const u32 *b;
 	size_t rem_len;
+# ifdef CONFIG_X86
+	size_t i;
+# endif
 	const u32 *t0 = tab[0], *t1 = tab[1], *t2 = tab[2], *t3 = tab[3];
 	const u32 *t4 = tab[4], *t5 = tab[5], *t6 = tab[6], *t7 = tab[7];
 	u32 q;
@@ -86,7 +89,12 @@ crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 # endif
 
 	b = (const u32 *)buf;
+# ifdef CONFIG_X86
+	--b;
+	for (i = 0; i < len; i++) {
+# else
 	for (--b; len; --len) {
+# endif
 		q = crc ^ *++b; /* use pre increment for speed */
 # if CRC_LE_BITS == 32
 		crc = DO_CRC4;
@@ -100,9 +108,14 @@ crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 	/* And the last few bytes */
 	if (len) {
 		u8 *p = (u8 *)(b + 1) - 1;
+# ifdef CONFIG_X86
+		for (i = 0; i < len; i++)
+			DO_CRC(*++p); /* use pre increment for speed */
+# else
 		do {
 			DO_CRC(*++p); /* use pre increment for speed */
 		} while (--len);
+# endif
 	}
 	return crc;
 #undef DO_CRC
