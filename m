From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 40/50] libext2fs: Add checksum to MMP block
Date: Mon, 28 Nov 2011 16:32:30 -0800
Message-ID: <20111129003230.17953.62357.stgit@elm3c44.beaverton.ibm.com>
References: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33602 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab1K2Act (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Nov 2011 19:32:49 -0500
Received: from /spool/local
	by e5.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 28 Nov 2011 19:32:47 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pAT0WYJT154096
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 19:32:34 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pAT0WWnd003631
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 22:32:34 -0200
In-Reply-To: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Calculate and verify a checksum of the MMP block.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 debugfs/debugfs.c         |    1 +
 debugfs/set_fields.c      |    1 +
 lib/ext2fs/csum.c         |   39 +++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2_err.et.in |    3 +++
 lib/ext2fs/ext2_fs.h      |    3 ++-
 lib/ext2fs/ext2fs.h       |    3 +++
 lib/ext2fs/mmp.c          |   19 +++++++++++++++++--
 lib/ext2fs/swapfs.c       |    1 +
 8 files changed, 67 insertions(+), 3 deletions(-)


diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 1d2b2f3..d2e2ff2 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -2248,6 +2248,7 @@ void do_dump_mmp(int argc EXT2FS_ATTR((unused)), char *argv[])
 	fprintf(stdout, "node_name: %s\n", mmp_s->mmp_nodename);
 	fprintf(stdout, "device_name: %s\n", mmp_s->mmp_bdevname);
 	fprintf(stdout, "magic: 0x%x\n", mmp_s->mmp_magic);
+	fprintf(stdout, "checksum: 0x%08x\n", mmp_s->mmp_checksum);
 }
 
 static int source_file(const char *cmd_file, int sci_idx)
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 871bf20..986e404 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -256,6 +256,7 @@ static struct field_set_info mmp_fields[] = {
 	{ "bdevname", &set_mmp.mmp_bdevname, NULL, sizeof(set_mmp.mmp_bdevname),
 		parse_string },
 	{ "check_interval", &set_mmp.mmp_check_interval, NULL, 2, parse_uint },
+	{ "checksum", &set_mmp.mmp_checksum, NULL, 4, parse_uint },
 };
 
 static int check_suffix(const char *field)
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 6059039..af1e6e4 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -30,6 +30,45 @@
 #define STATIC static
 #endif
 
+static __u32 ext2fs_mmp_csum(ext2_filsys fs, struct mmp_struct *mmp)
+{
+	int offset = offsetof(struct mmp_struct, mmp_checksum);
+	__u32 crc;
+
+	crc = ext2fs_crc32c_le(~0, fs->super->s_uuid,
+			       sizeof(fs->super->s_uuid));
+	crc = ext2fs_crc32c_le(crc, (unsigned char *)mmp, offset);
+
+	return crc;
+}
+
+int ext2fs_mmp_csum_verify(ext2_filsys fs, struct mmp_struct *mmp)
+{
+	__u32 calculated;
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 1;
+
+	calculated = ext2fs_mmp_csum(fs, mmp);
+
+	return ext2fs_le32_to_cpu(mmp->mmp_checksum) == calculated;
+}
+
+errcode_t ext2fs_mmp_csum_set(ext2_filsys fs, struct mmp_struct *mmp)
+{
+	__u32 crc;
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 0;
+
+	crc = ext2fs_mmp_csum(fs, mmp);
+	mmp->mmp_checksum = ext2fs_cpu_to_le32(crc);
+
+	return 0;
+}
+
 int ext2fs_verify_csum_type(ext2_filsys fs, struct ext2_super_block *sb)
 {
 	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index 01f9f7b..a42ed9a 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -467,4 +467,7 @@ ec	EXT2_ET_SB_CSUM_INVALID,
 ec	EXT2_ET_UNKNOWN_CSUM,
 	"Unknown checksum algorithm"
 
+ec	EXT2_ET_MMP_CSUM_INVALID,
+	"MMP block checksum does not match MMP block"
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
index 844dc98..16c0b81 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -944,6 +944,8 @@ extern __u32 ext2fs_crc32c_be(__u32 crc, unsigned char const *p, size_t len);
 extern __u32 ext2fs_crc32c_le(__u32 crc, unsigned char const *p, size_t len);
 
 /* csum.c */
+extern errcode_t ext2fs_mmp_csum_set(ext2_filsys fs, struct mmp_struct *mmp);
+extern int ext2fs_mmp_csum_verify(ext2_filsys, struct mmp_struct *mmp);
 extern int ext2fs_verify_csum_type(ext2_filsys fs, struct ext2_super_block *sb);
 extern errcode_t ext2fs_superblock_csum_set(ext2_filsys fs,
 					    struct ext2_super_block *sb);
@@ -1432,6 +1434,7 @@ errcode_t ext2fs_mmp_clear(ext2_filsys fs);
 errcode_t ext2fs_mmp_init(ext2_filsys fs);
 errcode_t ext2fs_mmp_start(ext2_filsys fs);
 errcode_t ext2fs_mmp_update(ext2_filsys fs);
+errcode_t ext2fs_mmp_update2(ext2_filsys fs, int immediately);
 errcode_t ext2fs_mmp_stop(ext2_filsys fs);
 unsigned ext2fs_mmp_new_seq(void);
 
diff --git a/lib/ext2fs/mmp.c b/lib/ext2fs/mmp.c
index b27d9a4..20a98f5 100644
--- a/lib/ext2fs/mmp.c
+++ b/lib/ext2fs/mmp.c
@@ -91,6 +91,11 @@ errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf)
 	}
 
 	mmp_cmp = fs->mmp_cmp;
+
+	if (!(fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
+	    !ext2fs_mmp_csum_verify(fs, mmp_cmp))
+		retval = EXT2_ET_MMP_CSUM_INVALID;
+
 #ifdef WORDS_BIGENDIAN
 	ext2fs_swap_mmp(mmp_cmp);
 #endif
@@ -125,6 +130,10 @@ errcode_t ext2fs_mmp_write(ext2_filsys fs, blk64_t mmp_blk, void *buf)
 	ext2fs_swap_mmp(mmp_s);
 #endif
 
+	retval = ext2fs_mmp_csum_set(fs, mmp_s);
+	if (retval)
+		return retval;
+
 	/* I was tempted to make this use O_DIRECT and the mmp_fd, but
 	 * this caused no end of grief, while leaving it as-is works. */
 	retval = io_channel_write_blk64(fs->io, mmp_blk, -(int)sizeof(struct mmp_struct), buf);
@@ -381,7 +390,7 @@ mmp_error:
 /*
  * Update the on-disk mmp buffer, after checking that it hasn't been changed.
  */
-errcode_t ext2fs_mmp_update(ext2_filsys fs)
+errcode_t ext2fs_mmp_update2(ext2_filsys fs, int immediately)
 {
 	struct mmp_struct *mmp, *mmp_cmp;
 	struct timeval tv;
@@ -392,7 +401,8 @@ errcode_t ext2fs_mmp_update(ext2_filsys fs)
 		return 0;
 
 	gettimeofday(&tv, 0);
-	if (tv.tv_sec - fs->mmp_last_written < EXT2_MIN_MMP_UPDATE_INTERVAL)
+	if (!immediately &&
+	    tv.tv_sec - fs->mmp_last_written < EXT2_MIN_MMP_UPDATE_INTERVAL)
 		return 0;
 
 	retval = ext2fs_mmp_read(fs, fs->super->s_mmp_block, NULL);
@@ -412,3 +422,8 @@ errcode_t ext2fs_mmp_update(ext2_filsys fs)
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

