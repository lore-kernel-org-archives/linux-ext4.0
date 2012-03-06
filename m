From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 04/54] libext2fs: Precompute FS UUID checksum seed
Date: Tue, 06 Mar 2012 15:57:47 -0800
Message-ID: <20120306235747.11945.56817.stgit@elm3b70.beaverton.ibm.com>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
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
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53798 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932718Ab2CFX5z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Mar 2012 18:57:55 -0500
Received: from /spool/local
	by e3.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 6 Mar 2012 18:57:55 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 4699E38C805A
	for <linux-ext4@vger.kernel.org>; Tue,  6 Mar 2012 18:57:53 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q26NvqX2128826
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 18:57:52 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q26NvoAa009999
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 20:57:52 -0300
In-Reply-To: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
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
index 3397d77..94648c3 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -710,6 +710,7 @@ void check_super_block(e2fsck_t ctx)
 	if (!(ctx->options & E2F_OPT_READONLY) && uuid_is_null(sb->s_uuid)) {
 		if (fix_problem(ctx, PR_0_ADD_UUID, &pctx)) {
 			uuid_generate(sb->s_uuid);
+			ext2fs_init_csum_seed(fs);
 			fs->flags |= EXT2_FLAG_DIRTY;
 			fs->flags &= ~EXT2_FLAG_MASTER_SB_ONLY;
 		}
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index bde22b6..f7a73e5 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -281,6 +281,9 @@ struct struct_ext2_filsys {
 	 * Time at which e2fsck last updated the MMP block.
 	 */
 	long mmp_last_written;
+
+	/* Precomputed FS UUID checksum for seeding other checksums */
+	__u32 csum_seed;
 };
 
 #if EXT2_FLAT_INCLUDES
@@ -1438,6 +1441,7 @@ extern errcode_t ext2fs_write_bb_FILE(ext2_badblocks_list bb_list,
 
 
 /* inline functions */
+extern void ext2fs_init_csum_seed(ext2_filsys fs);
 extern errcode_t ext2fs_get_mem(unsigned long size, void *ptr);
 extern errcode_t ext2fs_get_memalign(unsigned long size,
 				     unsigned long align, void *ptr);
@@ -1490,6 +1494,16 @@ extern int ext2fs_fstat(int fd, ext2fs_struct_stat *buf);
 
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
index 32e068c..10beb06 100644
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
index c70c1b4..d80c0b2 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2318,6 +2318,7 @@ int main (int argc, char *argv[])
 		}
 	} else
 		uuid_generate(fs->super->s_uuid);
+	ext2fs_init_csum_seed(fs);
 
 	/*
 	 * Initialize the directory index variables

