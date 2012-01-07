From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 17/23] jbd2: Grab a reference to the crc32c driver only when
	necessary
Date: Sat, 07 Jan 2012 00:29:46 -0800
Message-ID: <20120107082946.21970.61744.stgit@elm3c44.beaverton.ibm.com>
References: <20120107082751.21970.84856.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60468 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759512Ab2AGIae (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Jan 2012 03:30:34 -0500
Received: from /spool/local
	by e3.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 7 Jan 2012 03:30:31 -0500
In-Reply-To: <20120107082751.21970.84856.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Obtain a reference to the crc32c driver only when the journal needs it for
checksum v2.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/jbd2/Kconfig      |    2 ++
 fs/jbd2/journal.c    |   25 +++++++++++++++++++++++++
 include/linux/jbd2.h |   23 +++++++++++++++++++++++
 3 files changed, 50 insertions(+), 0 deletions(-)


diff --git a/fs/jbd2/Kconfig b/fs/jbd2/Kconfig
index f32f346..69a48c2 100644
--- a/fs/jbd2/Kconfig
+++ b/fs/jbd2/Kconfig
@@ -1,6 +1,8 @@
 config JBD2
 	tristate
 	select CRC32
+	select CRYPTO
+	select CRYPTO_CRC32C
 	help
 	  This is a generic journaling layer for block devices that support
 	  both 32-bit and 64-bit block numbers.  It is currently used by
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 300b46f..bb7f03f 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1284,6 +1284,17 @@ static int journal_get_superblock(journal_t *journal)
 		goto out;
 	}
 
+	/* Load the checksum driver */
+	if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_CSUM_V2)) {
+		journal->j_chksum_driver = crypto_alloc_shash("crc32c", 0, 0);
+		if (IS_ERR(journal->j_chksum_driver)) {
+			printk(KERN_ERR "JBD: Cannot load crc32c driver.\n");
+			err = PTR_ERR(journal->j_chksum_driver);
+			journal->j_chksum_driver = NULL;
+			goto out;
+		}
+	}
+
 	set_buffer_verified(bh);
 
 	return 0;
@@ -1440,6 +1451,8 @@ int jbd2_journal_destroy(journal_t *journal)
 		iput(journal->j_inode);
 	if (journal->j_revoke)
 		jbd2_journal_destroy_revoke(journal);
+	if (journal->j_chksum_driver)
+		crypto_free_shash(journal->j_chksum_driver);
 	kfree(journal->j_wbuf);
 	kfree(journal);
 
@@ -1556,6 +1569,18 @@ int jbd2_journal_set_features (journal_t *journal, unsigned long compat,
 		sb->s_checksum_type = JBD2_CRC32C_CHKSUM;
 		sb->s_feature_compat &=
 			~cpu_to_be32(JBD2_FEATURE_COMPAT_CHECKSUM);
+
+		/* Load the checksum driver */
+		if (journal->j_chksum_driver == NULL) {
+			journal->j_chksum_driver = crypto_alloc_shash("crc32c",
+								      0, 0);
+			if (IS_ERR(journal->j_chksum_driver)) {
+				printk(KERN_ERR "JBD: Cannot load crc32c "
+				       "driver.\n");
+				journal->j_chksum_driver = NULL;
+				return 0;
+			}
+		}
 	}
 
 	/* If enabling v1 checksums, downgrade superblock */
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index ecd9b45..5b2abf9 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -31,6 +31,7 @@
 #include <linux/mutex.h>
 #include <linux/timer.h>
 #include <linux/slab.h>
+#include <crypto/hash.h>
 #endif
 
 #define journal_oom_retry 1
@@ -965,6 +966,9 @@ struct journal_s
 	 * superblock pointer here
 	 */
 	void *j_private;
+
+	/* Reference to checksum algorithm driver via cryptoapi */
+	struct crypto_shash *j_chksum_driver;
 };
 
 /*
@@ -1283,6 +1287,25 @@ static inline int jbd_space_needed(journal_t *journal)
 
 extern int jbd_blocks_per_page(struct inode *inode);
 
+static inline u32 jbd2_chksum(journal_t *journal, u32 crc,
+			      const void *address, unsigned int length)
+{
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(journal->j_chksum_driver)];
+	} desc;
+	int err;
+
+	desc.shash.tfm = journal->j_chksum_driver;
+	desc.shash.flags = 0;
+	*(u32 *)desc.ctx = crc;
+
+	err = crypto_shash_update(&desc.shash, address, length);
+	BUG_ON(err);
+
+	return *(u32 *)desc.ctx;
+}
+
 #ifdef __KERNEL__
 
 #define buffer_trace_init(bh)	do {} while (0)

