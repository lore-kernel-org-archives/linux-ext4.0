From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] ext4/jbd2: fix race condition when initializing the crc32c
 "key"
Date: Thu, 4 Dec 2014 19:55:39 -0800
Message-ID: <20141205035539.GF10059@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: "Theodore Ts'o" <tytso@mit.edu>, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35700 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933269AbaLED4A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Dec 2014 22:56:00 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In the patch "ext4: use the shash api correctly for crc32c", we
attempted to correct for the mis-use of crc32c driver internals by
using the crypto shash API.  Unfortunately, the setkey function
modifies state (the key) in the shared s_chksum_driver; then this key
initializes the on-stack checksum descriptor, which means that we have
introduced a race condition that corrupts filesystems.

Therefore, duplicate s_chksum_driver on the stack so that we can set
the key in our own private copy.  The guard for the shash context size
is a little hacky, but it'll do.  A more "proper" fix would be just to
put a spinlock around setkey/init, but that seems silly to initialize
a local context.

(You could also just revert the two cleanup patches, since every other
caller of crc32c makes layout and size assumptions.)

Test case: run xfstests generic/011 over and over with metadata_csum
enabled until you hit it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h       |   16 +++++++++++++---
 include/linux/jbd2.h |   11 +++++++++--
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index da83f20..3e73450 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1777,19 +1777,29 @@ static inline __le16 ext4_rec_len_to_disk(unsigned len, unsigned blocksize)
 #define DX_HASH_HALF_MD4_UNSIGNED	4
 #define DX_HASH_TEA_UNSIGNED		5
 
+#define EXT4_MAX_CHECKSUM_SIZE		4
+
 static inline u32 ext4_chksum(struct ext4_sb_info *sbi, u32 crc,
 			      const void *address, unsigned int length)
 {
 	struct {
 		struct shash_desc shash;
-		char ctx[4];
+		char ctx[EXT4_MAX_CHECKSUM_SIZE];
 	} desc;
+	struct {
+		struct crypto_shash tfm;
+		char ctx[EXT4_MAX_CHECKSUM_SIZE];
+	} shash;
 	__le32 out_crc;
 	int err;
 
-	BUG_ON(crypto_shash_descsize(sbi->s_chksum_driver)!=sizeof(desc.ctx));
+	BUG_ON(sbi->s_chksum_driver->base.__crt_alg->cra_ctxsize >
+	       sizeof(shash.ctx));
+	BUG_ON(crypto_shash_descsize(sbi->s_chksum_driver) >
+	       sizeof(desc.ctx));
 
-	desc.shash.tfm = sbi->s_chksum_driver;
+	shash.tfm = *sbi->s_chksum_driver;
+	desc.shash.tfm = &shash.tfm;
 	desc.shash.flags = 0;
 	out_crc = cpu_to_le32(crc);
 	crypto_shash_setkey(desc.shash.tfm, (u8 *)&out_crc, sizeof(out_crc));
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index ae365ca..a1ff27c 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1374,13 +1374,20 @@ static inline u32 jbd2_chksum(journal_t *journal, u32 crc,
 		struct shash_desc shash;
 		char ctx[JBD_MAX_CHECKSUM_SIZE];
 	} desc;
+	struct {
+		struct crypto_shash tfm;
+		char ctx[JBD_MAX_CHECKSUM_SIZE];
+	} shash;
 	__le32 out_crc;
 	int err;
 
+	BUG_ON(journal->j_chksum_driver->base.__crt_alg->cra_ctxsize >
+	       sizeof(shash.ctx));
 	BUG_ON(crypto_shash_descsize(journal->j_chksum_driver) >
-		JBD_MAX_CHECKSUM_SIZE);
+	       sizeof(desc.ctx));
 
-	desc.shash.tfm = journal->j_chksum_driver;
+	shash.tfm = *journal->j_chksum_driver;
+	desc.shash.tfm = &shash.tfm;
 	desc.shash.flags = 0;
 	out_crc = cpu_to_le32(crc);
 	crypto_shash_setkey(desc.shash.tfm, (u8 *)&out_crc, sizeof(out_crc));
