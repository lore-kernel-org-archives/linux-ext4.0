From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 04/51] libext2fs: Precompute FS UUID checksum seed
Date: Sat, 07 Jan 2012 00:33:23 -0800
Message-ID: <20120107083323.25788.32820.stgit@elm3c44.beaverton.ibm.com>
References: <20120107083256.25788.41238.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e37.co.us.ibm.com ([32.97.110.158]:41271 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759027Ab2AGIeO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Jan 2012 03:34:14 -0500
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 7 Jan 2012 01:34:13 -0700
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q078XPQp172196
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 01:33:25 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q078XOSh032733
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 01:33:25 -0700
In-Reply-To: <20120107083256.25788.41238.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Precompute the FS UUID checksum seed that is used for all metadata checksumming
operations and store it in ext2_filsys.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/super.c      |    1 +
 lib/ext2fs/ext2fs.h |   14 ++++++++++++++
 lib/ext2fs/openfs.c |    2 ++
 misc/mke2fs.c       |    1 +
 4 files changed, 18 insertions(+), 0 deletions(-)


diff --git a/e2fsck/super.c b/e2fsck/super.c
index afec4b4..99c0b84 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -719,6 +719,7 @@ void check_super_block(e2fsck_t ctx)
 	if (!(ctx->options & E2F_OPT_READONLY) && uuid_is_null(sb->s_uuid)) {
 		if (fix_problem(ctx, PR_0_ADD_UUID, &pctx)) {
 			uuid_generate(sb->s_uuid);
+			ext2fs_init_csum_seed(fs);
 			fs->flags |= EXT2_FLAG_DIRTY;
 			fs->flags &= ~EXT2_FLAG_MASTER_SB_ONLY;
 		}
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 16c4567..c00032e 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -279,6 +279,9 @@ struct struct_ext2_filsys {
 	 * Time at which e2fsck last updated the MMP block.
 	 */
 	long mmp_last_written;
+
+	/* Precomputed FS UUID checksum for seeding other checksums */
+	__u32 csum_seed;
 };
 
 #if EXT2_FLAT_INCLUDES
@@ -1424,6 +1427,7 @@ extern errcode_t ext2fs_write_bb_FILE(ext2_badblocks_list bb_list,
 
 
 /* inline functions */
+extern void ext2fs_init_csum_seed(ext2_filsys fs);
 extern errcode_t ext2fs_get_mem(unsigned long size, void *ptr);
 extern errcode_t ext2fs_get_memalign(unsigned long size,
 				     unsigned long align, void *ptr);
@@ -1476,6 +1480,16 @@ extern int ext2fs_fstat(int fd, ext2fs_struct_stat *buf);
 
 #ifndef EXT2_CUSTOM_MEMORY_ROUTINES
 #include <string.h>
+_INLINE_ void ext2fs_init_csum_seed(ext2_filsys fs)
+{
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return;
+
+	fs->csum_seed = ext2fs_crc32c_le(~0, fs->super->s_uuid,
+					 sizeof(fs->super->s_uuid));
+}
+
 /*
  *  Allocate memory
  */
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 40a52c5..6cb629e 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -298,6 +298,8 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 		retval = EXT2_ET_CORRUPT_SUPERBLOCK;
 		goto cleanup;
 	}
+	/* Precompute the FS UUID to seed other checksums */
+	ext2fs_init_csum_seed(fs);
 
 	/*
 	 * Read group descriptors
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 0ef2531..f2d7c81 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2315,6 +2315,7 @@ int main (int argc, char *argv[])
 		}
 	} else
 		uuid_generate(fs->super->s_uuid);
+	ext2fs_init_csum_seed(fs);
 
 	/*
 	 * Initialize the directory index variables

