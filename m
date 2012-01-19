From: Jan Kara <jack@suse.cz>
Subject: [PATCH] quota: Remove unnecessary definitions
Date: Thu, 19 Jan 2012 21:18:49 +0100
Message-ID: <1327004329-6909-1-git-send-email-jack@suse.cz>
Cc: Aditya Kali <adityakali@google.com>, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932690Ab2ASUS4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jan 2012 15:18:56 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Quite some definitions in quota library are not necessary. Remove them.
Also fold quota.h file into quotaio.h since it didn't contain that many
definitions.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 lib/quota/dqblk_v2.h     |   22 ++-----
 lib/quota/mkquota.c      |   18 +-----
 lib/quota/mkquota.h      |    3 +-
 lib/quota/quota.h        |  155 ----------------------------------------------
 lib/quota/quotaio.c      |   12 +---
 lib/quota/quotaio.h      |   50 ++++++++--------
 lib/quota/quotaio_tree.h |    3 +-
 lib/quota/quotaio_v2.c   |   51 ++--------------
 lib/quota/quotaio_v2.h   |   55 +---------------
 9 files changed, 44 insertions(+), 325 deletions(-)
 delete mode 100644 lib/quota/quota.h

 Ted, after applying this patch, you'll need to run 'make depend' to fixup
dependencies in makefiles. I didn't include that in the patch because on my
system the dependencies are different and so diff is 1500+ lines.

Also I've talked with Aditya and there's no real reason for libquota to be a
separate library. So I think it would be best to just make it part of
libext2fs. Do you agree?

								Honza
diff --git a/lib/quota/dqblk_v2.h b/lib/quota/dqblk_v2.h
index 18055c6..d12512a 100644
--- a/lib/quota/dqblk_v2.h
+++ b/lib/quota/dqblk_v2.h
@@ -7,28 +7,16 @@
 #ifndef __QUOTA_DQBLK_V2_H__
 #define __QUOTA_DQBLK_V2_H__
 
-#include <sys/types.h>
 #include "quotaio_tree.h"
 
-#define Q_V2_GETQUOTA	0x0D00	/* Get limits and usage */
-#define Q_V2_SETQUOTA	0x0E00	/* Set limits and usage */
-#define Q_V2_SETUSE	0x0F00	/* Set only usage */
-#define Q_V2_SETQLIM	0x0700	/* Set only limits */
-#define Q_V2_GETINFO	0x0900	/* Get information about quota */
-#define Q_V2_SETINFO	0x0A00	/* Set information about quota */
-#define Q_V2_SETGRACE	0x0B00	/* Set just grace times in quotafile
-				 * information */
-#define Q_V2_SETFLAGS	0x0C00	/* Set just flags in quotafile information */
-#define Q_V2_GETSTATS	0x1100	/* get collected stats (before proc was used) */
-
 /* Structure for format specific information */
 struct v2_mem_dqinfo {
 	struct qtree_mem_dqinfo dqi_qtree;
-	uint dqi_flags;		/* Flags set in quotafile */
-	uint dqi_used_entries;	/* Number of entries in file -
-				   updated by scan_dquots */
-	uint dqi_data_blocks;	/* Number of data blocks in file -
-				   updated by scan_dquots */
+	unsigned int dqi_flags;		/* Flags set in quotafile */
+	unsigned int dqi_used_entries;	/* Number of entries in file -
+					   updated by scan_dquots */
+	unsigned int dqi_data_blocks;	/* Number of data blocks in file -
+					   updated by scan_dquots */
 };
 
 struct v2_mem_dqblk {
diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index ac7288c..9acbb10 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -6,9 +6,6 @@
 #include "config.h"
 #include <sys/types.h>
 #include <sys/stat.h>
-#ifdef HAVE_SYS_QUOTA_H
-#include <sys/quota.h>
-#endif
 #include <unistd.h>
 #include <errno.h>
 #include <string.h>
@@ -18,7 +15,6 @@
 #include "ext2fs/ext2fs.h"
 #include "e2p/e2p.h"
 
-#include "quota.h"
 #include "quotaio.h"
 #include "quotaio_v2.h"
 #include "quotaio_tree.h"
@@ -49,18 +45,6 @@ static void print_inode(struct ext2_inode *inode)
 	return;
 }
 
-int quota_is_on(ext2_filsys fs, int type)
-{
-	char tmp[1024];
-	qid_t id = (type == USRQUOTA) ? getuid() : getgid();
-
-#ifdef HAVE_QUOTACTL
-	if (!quotactl(QCMD(Q_V2_GETQUOTA, type), fs->device_name, id, tmp))
-		return 1;
-#endif
-	return 0;
-}
-
 /*
  * Returns 0 if not able to find the quota file, otherwise returns its
  * inode number.
@@ -74,7 +58,7 @@ int quota_file_exists(ext2_filsys fs, int qtype, int fmt)
 	if (qtype >= MAXQUOTAS)
 		return -EINVAL;
 
-	quota_get_qf_name(qtype, fmt, qf_name);
+	quota_get_qf_name(qtype, QFMT_VFS_V1, qf_name);
 
 	ret = ext2fs_lookup(fs, EXT2_ROOT_INO, qf_name, strlen(qf_name), 0,
 			    &ino);
diff --git a/lib/quota/mkquota.h b/lib/quota/mkquota.h
index a5fa74b..68ef435 100644
--- a/lib/quota/mkquota.h
+++ b/lib/quota/mkquota.h
@@ -32,7 +32,7 @@
 
 #include "ext2fs/ext2_fs.h"
 #include "ext2fs/ext2fs.h"
-#include "quota.h"
+#include "quotaio.h"
 #include "../e2fsck/dict.h"
 
 typedef struct quota_ctx *quota_ctx_t;
@@ -56,7 +56,6 @@ errcode_t quota_compute_usage(quota_ctx_t qctx);
 void quota_release_context(quota_ctx_t *qctx);
 
 errcode_t quota_remove_inode(ext2_filsys fs, int qtype);
-int quota_is_on(ext2_filsys fs, int type);
 int quota_file_exists(ext2_filsys fs, int qtype, int fmt);
 void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype);
 
diff --git a/lib/quota/quota.h b/lib/quota/quota.h
deleted file mode 100644
index a943ec6..0000000
--- a/lib/quota/quota.h
+++ /dev/null
@@ -1,155 +0,0 @@
-/*
- * Copyright (c) 1982, 1986 Regents of the University of California.
- * All rights reserved.
- *
- * This code is derived from software contributed to Berkeley by
- * Robert Elz at The University of Melbourne.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- * 2. Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in the
- *    documentation and/or other materials provided with the distribution.
- * 3. Neither the name of the University nor the names of its contributors
- *    may be used to endorse or promote products derived from this software
- *    without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
- * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
- */
-
-#ifndef _LINUX_QUOTA_
-#define _LINUX_QUOTA_
-
-#include <errno.h>
-#include <sys/types.h>
-#include <ext2fs/ext2_types.h>
-
-#define __DQUOT_VERSION__	"dquot_6.5.2"
-
-typedef u_int32_t qid_t;	/* Type in which we store ids in memory */
-typedef int64_t qsize_t;	/* Type in which we store size limitations */
-
-#define MAXQUOTAS 2
-#define USRQUOTA  0		/* element used for user quotas */
-#define GRPQUOTA  1		/* element used for group quotas */
-
-/*
- * Definitions for the default names of the quotas files.
- */
-#define INITQFNAMES { \
-	"user",    /* USRQUOTA */ \
-	"group",   /* GRPQUOTA */ \
-	"undefined", \
-};
-
-/*
- * Definitions of magics and versions of current quota files
- */
-#define INITQMAGICS {\
-	0xd9c01f11,	/* USRQUOTA */\
-	0xd9c01927	/* GRPQUOTA */\
-}
-
-/* Size of blocks in which are counted size limits in generic utility parts */
-#define QUOTABLOCK_BITS 10
-#define QUOTABLOCK_SIZE (1 << QUOTABLOCK_BITS)
-
-/* Conversion routines from and to quota blocks */
-#define qb2kb(x) ((x) << (QUOTABLOCK_BITS-10))
-#define kb2qb(x) ((x) >> (QUOTABLOCK_BITS-10))
-#define toqb(x) (((x) + QUOTABLOCK_SIZE - 1) >> QUOTABLOCK_BITS)
-
-/*
- * Command definitions for the 'quotactl' system call.
- * The commands are broken into a main command defined below
- * and a subcommand that is used to convey the type of
- * quota that is being manipulated (see above).
- */
-#define SUBCMDMASK  0x00ff
-#define SUBCMDSHIFT 8
-#define QCMD(cmd, type)  (((cmd) << SUBCMDSHIFT) | ((type) & SUBCMDMASK))
-
-#define Q_SYNC     0x800001	/* sync disk copy of a filesystems quotas */
-#define Q_QUOTAON  0x800002	/* turn quotas on */
-#define Q_QUOTAOFF 0x800003	/* turn quotas off */
-#define Q_GETFMT   0x800004	/* get quota format used on given filesystem */
-#define Q_GETINFO  0x800005	/* get information about quota files */
-#define Q_SETINFO  0x800006	/* set information about quota files */
-#define Q_GETQUOTA 0x800007	/* get user quota structure */
-#define Q_SETQUOTA 0x800008	/* set user quota structure */
-
-/* Quota format type IDs */
-#define	QFMT_VFS_OLD 1
-#define	QFMT_VFS_V0 2
-#define QFMT_OCFS2 3
-#define	QFMT_VFS_V1 4
-
-/* Size of block in which space limits are passed through the quota
- * interface */
-#define QIF_DQBLKSIZE_BITS 10
-#define QIF_DQBLKSIZE (1 << QIF_DQBLKSIZE_BITS)
-
-/*
- * Structure used for setting quota information about file via quotactl
- * Following flags are used to specify which fields are valid
- */
-#define IIF_BGRACE	1
-#define IIF_IGRACE	2
-#define IIF_FLAGS	4
-#define IIF_ALL		(IIF_BGRACE | IIF_IGRACE | IIF_FLAGS)
-
-struct if_dqinfo {
-	__u64 dqi_bgrace;
-	__u64 dqi_igrace;
-	__u32 dqi_flags;
-	__u32 dqi_valid;
-};
-
-/*
- * Definitions for quota netlink interface
- */
-#define QUOTA_NL_NOWARN 0
-#define QUOTA_NL_IHARDWARN 1		/* Inode hardlimit reached */
-#define QUOTA_NL_ISOFTLONGWARN 2	/* Inode grace time expired */
-#define QUOTA_NL_ISOFTWARN 3		/* Inode softlimit reached */
-#define QUOTA_NL_BHARDWARN 4		/* Block hardlimit reached */
-#define QUOTA_NL_BSOFTLONGWARN 5	/* Block grace time expired */
-#define QUOTA_NL_BSOFTWARN 6		/* Block softlimit reached */
-#define QUOTA_NL_IHARDBELOW 7		/* Usage got below inode hardlimit */
-#define QUOTA_NL_ISOFTBELOW 8		/* Usage got below inode softlimit */
-#define QUOTA_NL_BHARDBELOW 9		/* Usage got below block hardlimit */
-#define QUOTA_NL_BSOFTBELOW 10		/* Usage got below block softlimit */
-
-enum {
-	QUOTA_NL_C_UNSPEC,
-	QUOTA_NL_C_WARNING,
-	__QUOTA_NL_C_MAX,
-};
-#define QUOTA_NL_C_MAX (__QUOTA_NL_C_MAX - 1)
-
-enum {
-	QUOTA_NL_A_UNSPEC,
-	QUOTA_NL_A_QTYPE,
-	QUOTA_NL_A_EXCESS_ID,
-	QUOTA_NL_A_WARNING,
-	QUOTA_NL_A_DEV_MAJOR,
-	QUOTA_NL_A_DEV_MINOR,
-	QUOTA_NL_A_CAUSED_ID,
-	__QUOTA_NL_A_MAX,
-};
-#define QUOTA_NL_A_MAX (__QUOTA_NL_A_MAX - 1)
-
-#endif /* _QUOTA_ */
diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
index 3f434ca..d46cf28 100644
--- a/lib/quota/quotaio.c
+++ b/lib/quota/quotaio.c
@@ -14,11 +14,12 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/file.h>
+#include <sys/quota.h>
 
 #include "common.h"
 #include "quotaio.h"
 
-static const char extensions[MAXQUOTAS + 2][20] = INITQFNAMES;
+static const char * const extensions[MAXQUOTAS] = {"user", "group"};
 static const char * const basenames[] = {
 	"",		/* undefined */
 	"quota",	/* QFMT_VFS_OLD */
@@ -27,14 +28,6 @@ static const char * const basenames[] = {
 	"aquota"	/* QFMT_VFS_V1 */
 };
 
-static const char * const fmtnames[] = {
-	"vfsold",
-	"vfsv0",
-	"vfsv1",
-	"rpc",
-	"xfs"
-};
-
 /* Header in all newer quotafiles */
 struct disk_dqheader {
 	u_int32_t dqh_magic;
@@ -65,7 +58,6 @@ const char *quota_get_qf_name(int type, int fmt, char *buf)
 const char *quota_get_qf_path(const char *mntpt, int qtype, int fmt,
 			      char *path_buf, size_t path_buf_size)
 {
-	struct stat	qf_stat;
 	char qf_name[QUOTA_NAME_LEN];
 
 	if (!mntpt || !path_buf || !path_buf_size)
diff --git a/lib/quota/quotaio.h b/lib/quota/quotaio.h
index 91a1ff2..5a7db7b 100644
--- a/lib/quota/quotaio.h
+++ b/lib/quota/quotaio.h
@@ -12,13 +12,33 @@
 #include <sys/stat.h>
 
 #include "ext2fs/ext2fs.h"
-#include "quota.h"
 #include "dqblk_v2.h"
 
+typedef int64_t qsize_t;	/* Type in which we store size limitations */
+
+#define MAXQUOTAS 2
+#define USRQUOTA 0
+#define GRPQUOTA 1
+
+/*
+ * Definitions of magics and versions of current quota files
+ */
+#define INITQMAGICS {\
+	0xd9c01f11,	/* USRQUOTA */\
+	0xd9c01927	/* GRPQUOTA */\
+}
+
+/* Size of blocks in which are counted size limits in generic utility parts */
+#define QUOTABLOCK_BITS 10
+#define QUOTABLOCK_SIZE (1 << QUOTABLOCK_BITS)
+#define toqb(x) (((x) + QUOTABLOCK_SIZE - 1) >> QUOTABLOCK_BITS)
+
+/* Quota format type IDs */
+#define	QFMT_VFS_OLD 1
+#define	QFMT_VFS_V0 2
+#define	QFMT_VFS_V1 4
+
 /*
- * Definitions for disk quotas imposed on the average user
- * (big brother finally hits Linux).
- *
  * The following constants define the default amount of time given a user
  * before the soft limits are treated as hard limits (usually resulting
  * in an allocation failure). The timer is started when the user crosses
@@ -27,11 +47,7 @@
 #define MAX_IQ_TIME  604800	/* (7*24*60*60) 1 week */
 #define MAX_DQ_TIME  604800	/* (7*24*60*60) 1 week */
 
-#define IOFL_QUOTAON	0x01	/* Is quota enabled in kernel? */
-#define IOFL_INFODIRTY	0x02	/* Did info change? */
-#define IOFL_RO		0x04	/* Just RO access? */
-#define IOFL_NFS_MIXED_PATHS	0x08	/* Should we trim leading slashes
-					   from NFSv4 mountpoints? */
+#define IOFL_INFODIRTY	0x01	/* Did info change? */
 
 struct quotafile_ops;
 
@@ -64,19 +80,6 @@ struct quota_handle {
 	struct util_dqinfo qh_info;	/* Generic quotafile info */
 };
 
-/* Statistics gathered from kernel */
-struct util_dqstats {
-	u_int32_t lookups;
-	u_int32_t drops;
-	u_int32_t reads;
-	u_int32_t writes;
-	u_int32_t cache_hits;
-	u_int32_t allocated_dquots;
-	u_int32_t free_dquots;
-	u_int32_t syncs;
-	u_int32_t version;
-};
-
 /* Utility quota block */
 struct util_dqblk {
 	qsize_t dqb_ihardlimit;
@@ -134,9 +137,6 @@ static inline void mark_quotafile_info_dirty(struct quota_handle *h)
 	h->qh_io_flags |= IOFL_INFODIRTY;
 }
 
-#define QIO_ENABLED(h)	((h)->qh_io_flags & IOFL_QUOTAON)
-#define QIO_RO(h)	((h)->qh_io_flags & IOFL_RO)
-
 /* Open existing quotafile of given type (and verify its format) on given
  * filesystem. */
 errcode_t quota_file_open(struct quota_handle *h, ext2_filsys fs,
diff --git a/lib/quota/quotaio_tree.h b/lib/quota/quotaio_tree.h
index 37c15ce..6ee54c9 100644
--- a/lib/quota/quotaio_tree.h
+++ b/lib/quota/quotaio_tree.h
@@ -6,7 +6,8 @@
 #define _LINUX_QUOTA_TREE_H
 
 #include <sys/types.h>
-#include "quota.h"
+
+typedef u_int32_t qid_t;        /* Type in which we store ids in memory */
 
 #define QT_TREEOFF	1	/* Offset of tree in file in blocks */
 #define QT_TREEDEPTH	4	/* Depth of quota tree */
diff --git a/lib/quota/quotaio_v2.c b/lib/quota/quotaio_v2.c
index e658706..f8d553b 100644
--- a/lib/quota/quotaio_v2.c
+++ b/lib/quota/quotaio_v2.c
@@ -18,8 +18,6 @@
 #include "quotaio.h"
 #include "quotaio_tree.h"
 
-typedef char *dqbuf_t;
-
 static int v2_check_file(struct quota_handle *h, int type, int fmt);
 static int v2_init_io(struct quota_handle *h);
 static int v2_new_io(struct quota_handle *h);
@@ -43,9 +41,6 @@ struct quotafile_ops quotafile_ops_2 = {
 	.report		= v2_report,
 };
 
-#define getdqbuf() smalloc(V2_DQBLKSIZE)
-#define freedqbuf(buf) free(buf)
-
 /*
  * Copy dquot from disk to memory
  */
@@ -140,34 +135,6 @@ static inline void v2_mem2diskdqinfo(struct v2_disk_dqinfo *d,
 		ext2fs_cpu_to_le32(m->u.v2_mdqi.dqi_qtree.dqi_free_entry);
 }
 
-/* Convert kernel quotablock format to utility one */
-static inline void v2_kern2utildqblk(struct util_dqblk *u,
-				     struct v2_kern_dqblk *k)
-{
-	u->dqb_ihardlimit = k->dqb_ihardlimit;
-	u->dqb_isoftlimit = k->dqb_isoftlimit;
-	u->dqb_bhardlimit = k->dqb_bhardlimit;
-	u->dqb_bsoftlimit = k->dqb_bsoftlimit;
-	u->dqb_curinodes = k->dqb_curinodes;
-	u->dqb_curspace = k->dqb_curspace;
-	u->dqb_itime = k->dqb_itime;
-	u->dqb_btime = k->dqb_btime;
-}
-
-/* Convert utility quotablock format to kernel one */
-static inline void v2_util2kerndqblk(struct v2_kern_dqblk *k,
-				     struct util_dqblk *u)
-{
-	k->dqb_ihardlimit = u->dqb_ihardlimit;
-	k->dqb_isoftlimit = u->dqb_isoftlimit;
-	k->dqb_bhardlimit = u->dqb_bhardlimit;
-	k->dqb_bsoftlimit = u->dqb_bsoftlimit;
-	k->dqb_curinodes = u->dqb_curinodes;
-	k->dqb_curspace = u->dqb_curspace;
-	k->dqb_itime = u->dqb_itime;
-	k->dqb_btime = u->dqb_btime;
-}
-
 static int v2_read_header(struct quota_handle *h, struct v2_disk_dqheader *dqh)
 {
 	if (h->e2fs_read(&h->qh_qf, 0, dqh, sizeof(struct v2_disk_dqheader)) !=
@@ -184,16 +151,11 @@ static int v2_check_file(struct quota_handle *h, int type, int fmt)
 {
 	struct v2_disk_dqheader dqh;
 	int file_magics[] = INITQMAGICS;
-	int known_versions[] = INIT_V2_VERSIONS;
-	int version;
 
-	if (!v2_read_header(h, &dqh))
+	if (fmt != QFMT_VFS_V1)
 		return 0;
-	if (fmt == QFMT_VFS_V0)
-		version = 0;
-	else if (fmt == QFMT_VFS_V1)
-		version = 1;
-	else
+
+	if (!v2_read_header(h, &dqh))
 		return 0;
 
 	if (ext2fs_le32_to_cpu(dqh.dqh_magic) != file_magics[type]) {
@@ -202,9 +164,7 @@ static int v2_check_file(struct quota_handle *h, int type, int fmt)
 				"endianity.", "");
 		return 0;
 	}
-	if (ext2fs_le32_to_cpu(dqh.dqh_version) > known_versions[type])
-		return 0;
-	if (version != ext2fs_le32_to_cpu(dqh.dqh_version))
+	if (V2_VERSION != ext2fs_le32_to_cpu(dqh.dqh_version))
 		return 0;
 	return 1;
 }
@@ -236,14 +196,13 @@ static int v2_new_io(struct quota_handle *h)
 	int file_magics[] = INITQMAGICS;
 	struct v2_disk_dqheader ddqheader;
 	struct v2_disk_dqinfo ddqinfo;
-	int version = 1;
 
 	if (h->qh_fmt != QFMT_VFS_V1)
 		return -1;
 
 	/* Write basic quota header */
 	ddqheader.dqh_magic = ext2fs_cpu_to_le32(file_magics[h->qh_type]);
-	ddqheader.dqh_version = ext2fs_cpu_to_le32(version);
+	ddqheader.dqh_version = ext2fs_cpu_to_le32(V2_VERSION);
 	if (h->e2fs_write(&h->qh_qf, 0, &ddqheader, sizeof(ddqheader)) !=
 			sizeof(ddqheader))
 		return -1;
diff --git a/lib/quota/quotaio_v2.h b/lib/quota/quotaio_v2.h
index 072e36f..0bb4363 100644
--- a/lib/quota/quotaio_v2.h
+++ b/lib/quota/quotaio_v2.h
@@ -8,11 +8,12 @@
 #define GUARD_QUOTAIO_V2_H
 
 #include <sys/types.h>
-#include "quota.h"
+#include "quotaio.h"
 
 /* Offset of info header in file */
 #define V2_DQINFOOFF		sizeof(struct v2_disk_dqheader)
-#define INIT_V2_VERSIONS	{ 1, 1}
+/* Supported version of quota-tree format */
+#define V2_VERSION 1
 
 struct v2_disk_dqheader {
 	u_int32_t dqh_magic;	/* Magic number identifying file */
@@ -35,21 +36,6 @@ struct v2_disk_dqinfo {
 					 * free entry */
 } __attribute__ ((packed));
 
-/* Structure of quota for one user on disk */
-struct v2r0_disk_dqblk {
-	u_int32_t dqb_id;	/* id this quota applies to */
-	u_int32_t dqb_ihardlimit;	/* absolute limit on allocated inodes */
-	u_int32_t dqb_isoftlimit;	/* preferred inode limit */
-	u_int32_t dqb_curinodes;	/* current # allocated inodes */
-	u_int32_t dqb_bhardlimit;	/* absolute limit on disk space
-					 * (in QUOTABLOCK_SIZE) */
-	u_int32_t dqb_bsoftlimit;	/* preferred limit on disk space
-					 * (in QUOTABLOCK_SIZE) */
-	u_int64_t dqb_curspace;	/* current space occupied (in bytes) */
-	u_int64_t dqb_btime;	/* time limit for excessive disk use */
-	u_int64_t dqb_itime;	/* time limit for excessive inode use */
-} __attribute__ ((packed));
-
 struct v2r1_disk_dqblk {
 	u_int32_t dqb_id;	/* id this quota applies to */
 	u_int32_t dqb_pad;
@@ -65,39 +51,4 @@ struct v2r1_disk_dqblk {
 	u_int64_t dqb_itime;	/* time limit for excessive inode use */
 } __attribute__ ((packed));
 
-/* Structure of quota for communication with kernel */
-struct v2_kern_dqblk {
-	unsigned int dqb_ihardlimit;
-	unsigned int dqb_isoftlimit;
-	unsigned int dqb_curinodes;
-	unsigned int dqb_bhardlimit;
-	unsigned int dqb_bsoftlimit;
-	qsize_t dqb_curspace;
-	time_t dqb_btime;
-	time_t dqb_itime;
-};
-
-/* Structure of quotafile info for communication with kernel (obsolete) */
-struct v2_kern_dqinfo {
-	unsigned int dqi_bgrace;
-	unsigned int dqi_igrace;
-	unsigned int dqi_flags;
-	unsigned int dqi_blocks;
-	unsigned int dqi_free_blk;
-	unsigned int dqi_free_entry;
-};
-
-/* Structure with gathered statistics from kernel */
-struct v2_dqstats {
-	u_int32_t lookups;
-	u_int32_t drops;
-	u_int32_t reads;
-	u_int32_t writes;
-	u_int32_t cache_hits;
-	u_int32_t allocated_dquots;
-	u_int32_t free_dquots;
-	u_int32_t syncs;
-	u_int32_t version;
-};
