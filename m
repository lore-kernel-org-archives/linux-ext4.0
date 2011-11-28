From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 04/22] ext4: Only call out to crc32c if necessary
Date: Mon, 28 Nov 2011 15:26:43 -0800
Message-ID: <20111128232642.19194.80905.stgit@elm3c44.beaverton.ibm.com>
References: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Only obtain a reference to the cryptoapi and crc32c if we happen to mount a
filesystem with metadata checksumming enabled.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/Kconfig |    2 ++
 fs/ext4/ext4.h  |   23 +++++++++++++++++++++++
 fs/ext4/super.c |   15 +++++++++++++++
 3 files changed, 40 insertions(+), 0 deletions(-)


diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 9ed1bb1..c22f170 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -2,6 +2,8 @@ config EXT4_FS
 	tristate "The Extended 4 (ext4) filesystem"
 	select JBD2
 	select CRC16
+	select CRYPTO
+	select CRYPTO_CRC32C
 	help
 	  This is the next generation of the ext3 filesystem.
 
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e496e72..eab64c2 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -29,6 +29,7 @@
 #include <linux/wait.h>
 #include <linux/blockgroup_lock.h>
 #include <linux/percpu_counter.h>
+#include <crypto/hash.h>
 #ifdef __KERNEL__
 #include <linux/compat.h>
 #endif
@@ -1255,6 +1256,9 @@ struct ext4_sb_info {
 
 	/* Precomputed FS UUID checksum */
 	__u32 s_uuid_csum;
+
+	/* Reference to checksum algorithm driver via cryptoapi */
+	struct crypto_shash *s_chksum_driver;
 };
 
 static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
@@ -1596,6 +1600,25 @@ static inline __le16 ext4_rec_len_to_disk(unsigned len, unsigned blocksize)
 #define DX_HASH_HALF_MD4_UNSIGNED	4
 #define DX_HASH_TEA_UNSIGNED		5
 
+static inline u32 ext4_chksum(struct ext4_sb_info *sbi, u32 crc,
+			      const void *address, unsigned int length)
+{
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(sbi->s_chksum_driver)];
+	} desc;
+	int err;
+
+	desc.shash.tfm = sbi->s_chksum_driver;
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
 
 /* hash info structure used by the directory hash */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a56c14e..a555811 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -887,6 +887,8 @@ static void ext4_put_super(struct super_block *sb)
 	unlock_super(sb);
 	kobject_put(&sbi->s_kobj);
 	wait_for_completion(&sbi->s_kobj_unregister);
+	if (sbi->s_chksum_driver)
+		crypto_free_shash(sbi->s_chksum_driver);
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
 }
@@ -3200,6 +3202,17 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto cantfind_ext4;
 	}
 
+	/* Load the checksum driver */
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+		sbi->s_chksum_driver = crypto_alloc_shash("crc32c", 0, 0);
+		if (IS_ERR(sbi->s_chksum_driver)) {
+			ret = PTR_ERR(sbi->s_chksum_driver);
+			sbi->s_chksum_driver = NULL;
+			goto failed_mount;
+		}
+	}
+
 	/* Set defaults before we parse the mount options */
 	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
 	set_opt(sb, INIT_INODE_TABLE);
@@ -3880,6 +3893,8 @@ failed_mount2:
 		brelse(sbi->s_group_desc[i]);
 	ext4_kvfree(sbi->s_group_desc);
 failed_mount:
+	if (sbi->s_chksum_driver)
+		crypto_free_shash(sbi->s_chksum_driver);
 	if (sbi->s_proc) {
 		remove_proc_entry(sb->s_id, ext4_proc_root);
 	}
