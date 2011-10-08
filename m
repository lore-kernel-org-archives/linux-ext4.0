From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 08/28] ext4: Record the checksum algorithm in use in the
	superblock
Date: Sat, 08 Oct 2011 00:54:36 -0700
Message-ID: <20111008075436.20506.63897.stgit@elm3c44.beaverton.ibm.com>
References: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com>
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
In-Reply-To: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Record the type of checksum algorithm we're using for metadata in the
superblock, in case we ever want/need to change the algorithm.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/ext4.h  |    5 ++++-
 fs/ext4/super.c |   18 ++++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletions(-)


diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8ee8646..a74e125 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -957,6 +957,9 @@ extern void ext4_set_bits(void *bm, int cur, int len);
 #define EXT4_ERRORS_PANIC		3	/* Panic */
 #define EXT4_ERRORS_DEFAULT		EXT4_ERRORS_CONTINUE
 
+/* Metadata checksum algorithm codes */
+#define EXT4_CRC32C_CHKSUM		1
+
 /*
  * Structure of the super block
  */
@@ -1043,7 +1046,7 @@ struct ext4_super_block {
 	__le64  s_mmp_block;            /* Block for multi-mount protection */
 	__le32  s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
 	__u8	s_log_groups_per_flex;  /* FLEX_BG group size */
-	__u8	s_reserved_char_pad;
+	__u8	s_checksum_type;	/* metadata checksum algorithm used */
 	__le16  s_reserved_pad;
 	__le64	s_kbytes_written;	/* nr of lifetime kilobytes written */
 	__le32	s_snapshot_inum;	/* Inode number of active snapshot */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 44d0c8d..ac33e45 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -110,6 +110,16 @@ static struct file_system_type ext3_fs_type = {
 #define IS_EXT3_SB(sb) (0)
 #endif
 
+static int ext4_verify_csum_type(struct super_block *sb,
+				 struct ext4_super_block *es)
+{
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 1;
+
+	return es->s_checksum_type == EXT4_CRC32C_CHKSUM;
+}
+
 void *ext4_kvmalloc(size_t size, gfp_t flags)
 {
 	void *ret;
@@ -3153,6 +3163,14 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto cantfind_ext4;
 	sbi->s_kbytes_written = le64_to_cpu(es->s_kbytes_written);
 
+	/* Check for a known checksum algorithm */
+	if (!ext4_verify_csum_type(sb, es)) {
+		ext4_msg(sb, KERN_ERR, "VFS: Found ext4 filesystem with "
+			 "unknown checksum algorithm.");
+		silent = 1;
+		goto cantfind_ext4;
+	}
+
 	/* Set defaults before we parse the mount options */
 	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
 	set_opt(sb, INIT_INODE_TABLE);
