From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 3/3] crc32c: Implement a self-test for CRC32c
Date: Tue, 27 Sep 2011 15:13:00 -0700
Message-ID: <20110927221300.21653.39618.stgit@elm3c44.beaverton.ibm.com>
References: <20110927221239.21653.17489.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Bob Pearson <rpearson@systemfabricworks.com>,
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110927221239.21653.17489.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a self-test for the CRC32c code.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 crypto/tcrypt.c  |    6 ++
 crypto/testmgr.c |   36 +++++++++--
 crypto/testmgr.h |  177 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 211 insertions(+), 8 deletions(-)


diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 2222617..73c10f8 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -64,7 +64,7 @@ static char *check[] = {
 	"cast6", "arc4", "michael_mic", "deflate", "crc32c", "tea", "xtea",
 	"khazad", "wp512", "wp384", "wp256", "tnepres", "xeta",  "fcrypt",
 	"camellia", "seed", "salsa20", "rmd128", "rmd160", "rmd256", "rmd320",
-	"lzo", "cts", "zlib", NULL
+	"lzo", "cts", "zlib", "crc32c-be", NULL
 };
 
 static int test_cipher_jiffies(struct blkcipher_desc *desc, int enc,
@@ -944,6 +944,10 @@ static int do_test(int m)
 		ret += tcrypt_test("rfc4309(ccm(aes))");
 		break;
 
+	case 46:
+		ret += tcrypt_test("crc32c-be");
+		break;
+
 	case 100:
 		ret += tcrypt_test("hmac(md5)");
 		break;
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index b6b93d4..738b79f 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1457,7 +1457,8 @@ static int alg_test_hash(const struct alg_test_desc *desc, const char *driver,
 }
 
 static int alg_test_crc32c(const struct alg_test_desc *desc,
-			   const char *driver, u32 type, u32 mask)
+			   const char *driver, u32 type, u32 mask,
+			   int big_endian)
 {
 	struct crypto_shash *tfm;
 	u32 val;
@@ -1484,7 +1485,10 @@ static int alg_test_crc32c(const struct alg_test_desc *desc,
 		sdesc.shash.tfm = tfm;
 		sdesc.shash.flags = 0;
 
-		*(u32 *)sdesc.ctx = le32_to_cpu(420553207);
+		if (big_endian)
+			*(u32 *)sdesc.ctx = be32_to_cpu(420553207);
+		else
+			*(u32 *)sdesc.ctx = le32_to_cpu(420553207);
 		err = crypto_shash_final(&sdesc.shash, (u8 *)&val);
 		if (err) {
 			printk(KERN_ERR "alg: crc32c: Operation failed for "
@@ -1505,6 +1509,18 @@ out:
 	return err;
 }
 
+static int alg_test_crc32c_be(const struct alg_test_desc *desc,
+			      const char *driver, u32 type, u32 mask)
+{
+	return alg_test_crc32c(desc, driver, type, mask, 1);
+}
+
+static int alg_test_crc32c_le(const struct alg_test_desc *desc,
+			      const char *driver, u32 type, u32 mask)
+{
+	return alg_test_crc32c(desc, driver, type, mask, 0);
+}
+
 static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
 			  u32 type, u32 mask)
 {
@@ -1707,12 +1723,22 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "crc32c",
-		.test = alg_test_crc32c,
+		.test = alg_test_crc32c_le,
+		.fips_allowed = 1,
+		.suite = {
+			.hash = {
+				.vecs = crc32c_le_tv_template,
+				.count = CRC32C_LE_TEST_VECTORS
+			}
+		}
+	}, {
+		.alg = "crc32c-be",
+		.test = alg_test_crc32c_be,
 		.fips_allowed = 1,
 		.suite = {
 			.hash = {
-				.vecs = crc32c_tv_template,
-				.count = CRC32C_TEST_VECTORS
+				.vecs = crc32c_be_tv_template,
+				.count = CRC32C_BE_TEST_VECTORS
 			}
 		}
 	}, {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 27adc92..8223738 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -10172,9 +10172,10 @@ static struct hash_testvec michael_mic_tv_template[] = {
 /*
  * CRC32C test vectors
  */
-#define CRC32C_TEST_VECTORS 14
+#define CRC32C_LE_TEST_VECTORS 14
+#define CRC32C_BE_TEST_VECTORS 14
 
-static struct hash_testvec crc32c_tv_template[] = {
+static struct hash_testvec crc32c_le_tv_template[] = {
 	{
 		.psize = 0,
 		.digest = "\x00\x00\x00\x00",
@@ -10346,4 +10347,176 @@ static struct hash_testvec crc32c_tv_template[] = {
 	},
 };
 
+static struct hash_testvec crc32c_be_tv_template[] = {
+	{
+		.psize = 0,
+		.digest = "\x00\x00\x00\x00",
+	},
+	{
+		.key = "\x87\xa9\xcb\xed",
+		.ksize = 4,
+		.psize = 0,
+		.digest = "\x78\x56\x34\x12",
+	},
+	{
+		.key = "\xff\xff\xff\xff",
+		.ksize = 4,
+		.plaintext = "\x01\x02\x03\x04\x05\x06\x07\x08"
+			     "\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10"
+			     "\x11\x12\x13\x14\x15\x16\x17\x18"
+			     "\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20"
+			     "\x21\x22\x23\x24\x25\x26\x27\x28",
+		.psize = 40,
+		.digest = "\x94\x8f\x5f\x9f",
+	},
+	{
+		.key = "\xff\xff\xff\xff",
+		.ksize = 4,
+		.plaintext = "\x29\x2a\x2b\x2c\x2d\x2e\x2f\x30"
+			     "\x31\x32\x33\x34\x35\x36\x37\x38"
+			     "\x39\x3a\x3b\x3c\x3d\x3e\x3f\x40"
+			     "\x41\x42\x43\x44\x45\x46\x47\x48"
+			     "\x49\x4a\x4b\x4c\x4d\x4e\x4f\x50",
+		.psize = 40,
+		.digest = "\xcf\x13\x15\xf9",
+	},
+	{
+		.key = "\xff\xff\xff\xff",
+		.ksize = 4,
+		.plaintext = "\x51\x52\x53\x54\x55\x56\x57\x58"
+			     "\x59\x5a\x5b\x5c\x5d\x5e\x5f\x60"
+			     "\x61\x62\x63\x64\x65\x66\x67\x68"
+			     "\x69\x6a\x6b\x6c\x6d\x6e\x6f\x70"
+			     "\x71\x72\x73\x74\x75\x76\x77\x78",
+		.psize = 40,
+		.digest = "\xe1\x9f\x51\x45",
+	},
+	{
+		.key = "\xff\xff\xff\xff",
+		.ksize = 4,
+		.plaintext = "\x79\x7a\x7b\x7c\x7d\x7e\x7f\x80"
+			     "\x81\x82\x83\x84\x85\x86\x87\x88"
+			     "\x89\x8a\x8b\x8c\x8d\x8e\x8f\x90"
+			     "\x91\x92\x93\x94\x95\x96\x97\x98"
+			     "\x99\x9a\x9b\x9c\x9d\x9e\x9f\xa0",
+		.psize = 40,
+		.digest = "\xa6\x83\x88\x73",
+	},
+	{
+		.key = "\xff\xff\xff\xff",
+		.ksize = 4,
+		.plaintext = "\xa1\xa2\xa3\xa4\xa5\xa6\xa7\xa8"
+			     "\xa9\xaa\xab\xac\xad\xae\xaf\xb0"
+			     "\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8"
+			     "\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc0"
+			     "\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc8",
+		.psize = 40,
+		.digest = "\x69\x84\x78\xe0",
+	},
+	{
+		.key = "\xff\xff\xff\xff",
+		.ksize = 4,
+		.plaintext = "\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0"
+			     "\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8"
+			     "\xd9\xda\xdb\xdc\xdd\xde\xdf\xe0"
+			     "\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8"
+			     "\xe9\xea\xeb\xec\xed\xee\xef\xf0",
+		.psize = 40,
+		.digest = "\xae\xea\x9b\xcc",
+	},
+	{
+		.key = "\x80\xea\xd3\xf1",
+		.ksize = 4,
+		.plaintext = "\x29\x2a\x2b\x2c\x2d\x2e\x2f\x30"
+			     "\x31\x32\x33\x34\x35\x36\x37\x38"
+			     "\x39\x3a\x3b\x3c\x3d\x3e\x3f\x40"
+			     "\x41\x42\x43\x44\x45\x46\x47\x48"
+			     "\x49\x4a\x4b\x4c\x4d\x4e\x4f\x50",
+		.psize = 40,
+		.digest = "\x3a\xde\xd7\xf0",
+	},
+	{
+		.key = "\xf3\x4a\x1d\x5d",
+		.ksize = 4,
+		.plaintext = "\x51\x52\x53\x54\x55\x56\x57\x58"
+			     "\x59\x5a\x5b\x5c\x5d\x5e\x5f\x60"
+			     "\x61\x62\x63\x64\x65\x66\x67\x68"
+			     "\x69\x6a\x6b\x6c\x6d\x6e\x6f\x70"
+			     "\x71\x72\x73\x74\x75\x76\x77\x78",
+		.psize = 40,
+		.digest = "\xa4\x9e\x8b\x7e",
+	},
+	{
+		.key = "\x2e\x80\x04\x59",
+		.ksize = 4,
+		.plaintext = "\x79\x7a\x7b\x7c\x7d\x7e\x7f\x80"
+			     "\x81\x82\x83\x84\x85\x86\x87\x88"
+			     "\x89\x8a\x8b\x8c\x8d\x8e\x8f\x90"
+			     "\x91\x92\x93\x94\x95\x96\x97\x98"
+			     "\x99\x9a\x9b\x9c\x9d\x9e\x9f\xa0",
+		.psize = 40,
+		.digest = "\x38\x90\xea\xc0",
+	},
+	{
+		.key = "\xa6\xcc\x19\x85",
+		.ksize = 4,
+		.plaintext = "\xa1\xa2\xa3\xa4\xa5\xa6\xa7\xa8"
+			     "\xa9\xaa\xab\xac\xad\xae\xaf\xb0"
+			     "\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8"
+			     "\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc0"
+			     "\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc8",
+		.psize = 40,
+		.digest = "\x37\x77\x50\x00",
+	},
+	{
+		.key = "\x41\xfc\xfe\x2d",
+		.ksize = 4,
+		.plaintext = "\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0"
+			     "\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8"
+			     "\xd9\xda\xdb\xdc\xdd\xde\xdf\xe0"
+			     "\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8"
+			     "\xe9\xea\xeb\xec\xed\xee\xef\xf0",
+		.psize = 40,
+		.digest = "\x15\x01\x15\xb6",
+	},
+	{
+		.key = "\xff\xff\xff\xff",
+		.ksize = 4,
+		.plaintext = "\x01\x02\x03\x04\x05\x06\x07\x08"
+			     "\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10"
+			     "\x11\x12\x13\x14\x15\x16\x17\x18"
+			     "\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20"
+			     "\x21\x22\x23\x24\x25\x26\x27\x28"
+			     "\x29\x2a\x2b\x2c\x2d\x2e\x2f\x30"
+			     "\x31\x32\x33\x34\x35\x36\x37\x38"
+			     "\x39\x3a\x3b\x3c\x3d\x3e\x3f\x40"
+			     "\x41\x42\x43\x44\x45\x46\x47\x48"
+			     "\x49\x4a\x4b\x4c\x4d\x4e\x4f\x50"
+			     "\x51\x52\x53\x54\x55\x56\x57\x58"
+			     "\x59\x5a\x5b\x5c\x5d\x5e\x5f\x60"
+			     "\x61\x62\x63\x64\x65\x66\x67\x68"
+			     "\x69\x6a\x6b\x6c\x6d\x6e\x6f\x70"
+			     "\x71\x72\x73\x74\x75\x76\x77\x78"
+			     "\x79\x7a\x7b\x7c\x7d\x7e\x7f\x80"
+			     "\x81\x82\x83\x84\x85\x86\x87\x88"
+			     "\x89\x8a\x8b\x8c\x8d\x8e\x8f\x90"
+			     "\x91\x92\x93\x94\x95\x96\x97\x98"
+			     "\x99\x9a\x9b\x9c\x9d\x9e\x9f\xa0"
+			     "\xa1\xa2\xa3\xa4\xa5\xa6\xa7\xa8"
+			     "\xa9\xaa\xab\xac\xad\xae\xaf\xb0"
+			     "\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8"
+			     "\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc0"
+			     "\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc8"
+			     "\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0"
+			     "\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8"
+			     "\xd9\xda\xdb\xdc\xdd\xde\xdf\xe0"
+			     "\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8"
+			     "\xe9\xea\xeb\xec\xed\xee\xef\xf0",
+		.psize = 240,
+		.np = 2,
+		.digest = "\x14\xbe\x65\xaf",
+		.tap = { 31, 209 }
+	},
+};
+
 #endif	/* _CRYPTO_TESTMGR_H */
