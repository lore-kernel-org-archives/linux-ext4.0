From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 39/47] libext2fs: Add checksum to MMP block
Date: Sat, 08 Oct 2011 00:37:25 -0700
Message-ID: <20111008073725.17888.64536.stgit@elm3c44.beaverton.ibm.com>
References: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50006 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab1JHHjx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 03:39:53 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p987DIY9024454
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:13:18 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987bSj5213814
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:37:28 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987bRWu026846
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 04:37:28 -0300
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Calculate and verify a checksum of the MMP block.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 debugfs/debugfs.c         |    1 +
 debugfs/set_fields.c      |    1 +
 lib/ext2fs/csum.c         |   35 +++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2_err.et.in |    3 +++
 lib/ext2fs/ext2_fs.h      |    3 ++-
 lib/ext2fs/ext2fs.h       |    3 +++
 lib/ext2fs/mmp.c          |   20 ++++++++++++++++++--
 lib/ext2fs/swapfs.c       |    1 +
 8 files changed, 64 insertions(+), 3 deletions(-)


diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index d71de7d..693db62 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -2216,6 +2216,7 @@ void do_dump_mmp(int argc, char *argv[])
 	fprintf(stdout, "time: %lld -- %s", mmp_s->mmp_time, ctime(&t));
 	fprintf(stdout, "node_name: %s\n", mmp_s->mmp_nodename);
 	fprintf(stdout, "device_name: %s\n", mmp_s->mmp_bdevname);
+	fprintf(stdout, "checksum: 0x%08x\n", mmp_s->mmp_checksum);
 }
 
 static int source_file(const char *cmd_file, int sci_idx)
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 0103497..0daea66 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -753,6 +753,7 @@ static struct field_set_info mmp_fields[] = {
 	{ "bdevname", &set_mmp.mmp_bdevname, NULL, sizeof(set_mmp.mmp_bdevname),
 		parse_string },
 	{ "check_interval", &set_mmp.mmp_check_interval, NULL, 2, parse_uint },
+	{ "checksum", &set_mmp.mmp_checksum, NULL, 4, parse_uint },
 };
 
 void do_set_mmp_value(int argc, char *argv[])
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 9694185..1429d9f 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -30,6 +30,41 @@
 #define STATIC static
 #endif
 
+static __u32 ext2fs_mmp_csum(ext2_filsys fs, struct mmp_struct *mmp)
+{
+	int offset = offsetof(struct mmp_struct, mmp_checksum);
+	__u32 crc;
+
+#ifdef WORDS_BIGENDIAN
+	struct mmp_struct swabmmp;
+	memcpy(&swabmmp, mmp, sizeof(struct mmp_struct));
+	ext2fs_swap_mmp(&swabmmp);
+	mmp = &swabmmp;
+#endif
+	crc = ext2fs_crc32c_le(~0, fs->super->s_uuid,
+			       sizeof(fs->super->s_uuid));
+	return ext2fs_crc32c_le(crc, (unsigned char *)mmp, offset);
+}
+
+int ext2fs_mmp_csum_verify(ext2_filsys fs, struct mmp_struct *mmp)
+{
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	    (mmp->mmp_checksum != ext2fs_mmp_csum(fs, mmp)))
+		return 0;
+	return 1;
+}
+
+errcode_t ext2fs_mmp_csum_set(ext2_filsys fs, struct mmp_struct *mmp)
+{
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 0;
+
+	mmp->mmp_checksum = ext2fs_mmp_csum(fs, mmp);
+	return 0;
+}
+
 int ext2fs_verify_csum_type(ext2_filsys fs, struct ext2_super_block *sb)
 {
 	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index 3b92eac..403bc61 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -461,4 +461,7 @@ ec	EXT2_ET_SB_CSUM_INVALID,
 ec	EXT2_ET_UNKNOWN_CSUM,
 	"Unknown checksum algorithm"
 
+ec	EXT2_ET_MMP_CSUM_INVALID,
+	"MMP: invalid checksum"
+
 	end
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 709fc2f..ef0a288 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -876,7 +876,8 @@ struct mmp_struct {
 	char	mmp_bdevname[32];	/* Bdev which last updated MMP block */
 	__u16	mmp_check_interval;	/* Changed mmp_check_interval */
 	__u16	mmp_pad1;
-	__u32	mmp_pad2[227];
+	__u32	mmp_pad2[226];
+	__u32	mmp_checksum;		/* crc32c(uuid+mmp_block) */
 };
 
 /*
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index d4d4ecf..ff7ee7b 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -931,6 +931,8 @@ extern __u32 ext2fs_crc32c_be(__u32 crc, unsigned char const *p, size_t len);
 extern __u32 ext2fs_crc32c_le(__u32 crc, unsigned char const *p, size_t len);
 
 /* csum.c */
+extern errcode_t ext2fs_mmp_csum_set(ext2_filsys fs, struct mmp_struct *mmp);
+extern int ext2fs_mmp_csum_verify(ext2_filsys, struct mmp_struct *mmp);
 extern int ext2fs_verify_csum_type(ext2_filsys fs, struct ext2_super_block *sb);
 extern errcode_t ext2fs_superblock_csum_set(ext2_filsys fs,
 					    struct ext2_super_block *sb);
@@ -1420,6 +1422,7 @@ errcode_t ext2fs_mmp_clear(ext2_filsys fs);
 errcode_t ext2fs_mmp_init(ext2_filsys fs);
 errcode_t ext2fs_mmp_start(ext2_filsys fs);
 errcode_t ext2fs_mmp_update(ext2_filsys fs);
+errcode_t ext2fs_mmp_update2(ext2_filsys fs, int immediately);
 errcode_t ext2fs_mmp_stop(ext2_filsys fs);
 unsigned ext2fs_mmp_new_seq(void);
 
diff --git a/lib/ext2fs/mmp.c b/lib/ext2fs/mmp.c
index 91f4fb2..ea2e913 100644
--- a/lib/ext2fs/mmp.c
+++ b/lib/ext2fs/mmp.c
@@ -103,6 +103,12 @@ errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf)
 		goto out;
 	}
 
+	if (!(fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
+	    !ext2fs_mmp_csum_verify(fs, mmp_cmp)) {
+		retval = EXT2_ET_MMP_CSUM_INVALID;
+		goto out;
+	}
+
 out:
 	return retval;
 }
@@ -121,6 +127,10 @@ errcode_t ext2fs_mmp_write(ext2_filsys fs, blk64_t mmp_blk, void *buf)
 	    fs->super->s_mmp_block > ext2fs_blocks_count(fs->super))
 		return EXT2_ET_MMP_BAD_BLOCK;
 
+	retval = ext2fs_mmp_csum_set(fs, mmp_s);
+	if (retval)
+		return retval;
+
 #ifdef WORDS_BIGENDIAN
 	ext2fs_swap_mmp(mmp_s);
 #endif
@@ -381,7 +391,7 @@ mmp_error:
 /*
  * Update the on-disk mmp buffer, after checking that it hasn't been changed.
  */
-errcode_t ext2fs_mmp_update(ext2_filsys fs)
+errcode_t ext2fs_mmp_update2(ext2_filsys fs, int immediately)
 {
 	struct mmp_struct *mmp, *mmp_cmp;
 	struct timeval tv;
@@ -392,7 +402,8 @@ errcode_t ext2fs_mmp_update(ext2_filsys fs)
 		return 0;
 
 	gettimeofday(&tv, 0);
-	if (tv.tv_sec - fs->mmp_last_written < EXT2_MIN_MMP_UPDATE_INTERVAL)
+	if (!immediately &&
+	    tv.tv_sec - fs->mmp_last_written < EXT2_MIN_MMP_UPDATE_INTERVAL)
 		return 0;
 
 	retval = ext2fs_mmp_read(fs, fs->super->s_mmp_block, NULL);
@@ -412,3 +423,8 @@ errcode_t ext2fs_mmp_update(ext2_filsys fs)
 mmp_error:
 	return retval;
 }
+
+errcode_t ext2fs_mmp_update(ext2_filsys fs)
+{
+	return ext2fs_mmp_update2(fs, 0);
+}
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index de178a4..1295e81 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -349,6 +349,7 @@ void ext2fs_swap_mmp(struct mmp_struct *mmp)
 	mmp->mmp_seq = ext2fs_swab32(mmp->mmp_seq);
 	mmp->mmp_time = ext2fs_swab64(mmp->mmp_time);
 	mmp->mmp_check_interval = ext2fs_swab16(mmp->mmp_check_interval);
+	mmp->mmp_checksum = ext2fs_swab32(mmp->mmp_checksum);
 }
 
 errcode_t ext2fs_dirent_swab_in(ext2_filsys fs, char *buf, int flags)

