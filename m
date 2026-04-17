Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C1F340280
	for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2026 21:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776462246; cv=none; b=TFPpJciEhfnnEN0lfDDz/XVYLJtcuSUrvMi5d3my6LaJ2NlEt6DwcMI5X1XfDjcln7uKevE2uST7bNaWwWWwXaePd31On2ElChWBDMGq1ufYdcUkx2zSqI6qjlr2R9gZCVDfx1qLvoSbea7LPXxDy7cGJeR5tgob96Kjac+UsNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776462246; c=relaxed/simple;
	bh=E7cDrEx4PO+bo403o+COTD6KgEopslIYG11ZOfrdmi4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lk4NgsIQhp5xEMz7eSRtYiz+385b0wQ8Yhu1z6aiwAP8u95lnKiITzKIiSYFVuhFT2qbLqBTkjhxrGil1AUjjPfZjMTN/r2aAbHOyjLFgHonEdToU+J6CAIqLzQP4qB7kaDCvcfUtdYA/NrHAuqyGVElM8t02Jjggw8BtV9e6Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n5ieEJV4; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n5ieEJV4"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-488ba6366a7so14670895e9.0
        for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2026 14:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776462229; x=1777067029; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Qvg3LHDDsq9UTYsWp8M3FqTgGrGDwaht5ocTR2AH8kg=;
        b=n5ieEJV4ibK6Onv7e0d4DyudM+6MLHFJ8bKbfsGM1MLmm9kpAQhHiE2LZYra1or+bQ
         raQZIWSDFxdXJWamn48FPrZoJNKzlHushouaii4v23ySpY0MdNfppEQnjHxCcSjXOToe
         1/haad0mMPVfq+AX7UG8Py35thBBKUAX4K1VkF9aPYMA7IKwvIIfw5KcmFyB4R0M8gAm
         tncYit2B3+eOj/plUb8hSZoKtev4GmkyqamNX7qYQw4KzSfZJhkKogI7VKxTPtgeHuB7
         T79XlO57L/DebI8PY5jmXgdaLVIkHX7QsZLyQcLZV4upuSrq8tmBd+8coGiayYFJ3zUU
         wTtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776462229; x=1777067029;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qvg3LHDDsq9UTYsWp8M3FqTgGrGDwaht5ocTR2AH8kg=;
        b=MS7sA3PqtOzQ4Jh7tRJTM7JTU+SrCM48kQ94RTkDK7PylDYEIu8r2mtQ3F6b0Le67s
         fAfqjygnbPa67iHGaKKmC37R1i5azVcYYQbVhjRFR4AtAAzeBEBILFOzPrtn6I5Jj47w
         XCN+HBCI3F3PqYLRrvoOgr3d+knXF1h8wuggdGjwJWKSBp2tPEpR/RN2KO7EBWCkQhNQ
         Tm6gnXWkKTayi2mwyzWjrZhydQ8wgPFE3cszqkQg/ak6V1Lf7xRrwPfzTd8n5WQ0ufvp
         TkySoQHmSDpR4KS0YhNYVKhk3rPDs2XTKVwlerCWA2VhJpyi7Jcp2HhYkbb7R1Msi0rs
         6HgQ==
X-Gm-Message-State: AOJu0Yw42D2KEFoTC2UtiTanEEKu9IqLwOk7LEdHttgqa0mzLEd4iSZm
	TfJtCafBc+a8Iscok0cwsfjiSvgNYqKv+vF23B8nh12YlvMBJL/3GOGel8mbNs3i
X-Gm-Gg: AeBDiesdvwf/l+ndglI97e6T1NKwdxry4w/6CpKCuuRmeDlKG4MnAkfGGZ63O2K08+p
	hvC2pYW0cOH35vywdt2jPXysTrXYnMrblggHos9hqBIrCA5Q8nybOQO6C96u26ix6Ilv43qt5rw
	2amR5kEJzaP7jYOWls5PZ+xPFdq+BbcY/NP+lDmtL/g0tL8YmjwaRWr0Zi6S1A5Ete2BV07WwEy
	TYGjkYSCY3UtLkVw+lEERGc1wnNRQTP2x6Jfn9ZMr8HxcTTNe06Y0XCzit/ofADA4eiYG1L8Gh1
	12Ms3Pu69u6hy6Swl/HwPLJeaVGDpRA9lA2s3SzmxH6N4dVbhdlGecWl6MU+grm7fgOlYOuA6LO
	wuIwfOXDnn4zv37cpTWyWFIYRaUISpnRsMj47KtTrcdWa4RogRjvf4N/xyni+pvFrZcOTP0Pp0d
	OCj+AXaiI3K6ZWzB0PYfqEM1gXMaW8K8teR4u3Z71XgA==
X-Received: by 2002:a05:600c:4e4f:b0:488:a2ac:a34c with SMTP id 5b1f17b1804b1-488fb7433ddmr68622045e9.12.1776462228249;
        Fri, 17 Apr 2026 14:43:48 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb74c7dcsm25812425e9.4.2026.04.17.14.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 14:43:46 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@ddn.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Andreas Dilger <andreas.dilger@intel.com>,
	Pravin Shelar <pravin@clusterfs.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH] e2fsck: add support for dirdata feature
Date: Fri, 17 Apr 2026 17:43:31 -0400
Message-ID: <20260417214331.20719-1-ablagodarenko@ddn.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andreas Dilger <andreas.dilger@intel.com>

Add support for the INCOMPAT_DIRDATA feature, which allows
storing extra data in the directory entry beyond the name.
This allows the Lustre File IDentifier to be accessed in
an efficient manner, and would be useful for expanding a
filesystem to allow more than 2^32 inodes in the future.

While adding the new file entry in directory block, link_proc()
calculates minimum record length of the existing directory entry
without considering the dirent data size and which leads to
corruption. Changed the code to use EXT2_DIR_REC_LEN() which will
return correct record length including dirent data size.

  LU-19105 e2fsck: support duplicate dentry rename with dirdata

  mutate_name() is used to generate a new name in case of duplicate dir
  entries. The rename is done in-place without modifying the record
  length. The record length is 4 bytes aligned. So mutate_name() uses
  the padding bytes to expand the name length.

  If dirdata is present in the record, the rename operation may
  overwrite the dirdata saved after dir entry name.

  If the name length needs to be expanded, this change moves the dirdata
  before renaming.

  Add the regression test f_dirdata_dup_de to verify duplicate entries
  fix with dirdata.

  Fixes: c06619d91 ("e2fsck: add support for dirdata feature")
  Signed-off-by: Etienne AUJAMES <eaujames@ddn.com>
  Change-Id: I2fcd93a0460bab1371d0621279a80d1994b26d2a
  Reviewed-on: https://review.whamcloud.com/c/tools/e2fsprogs/+/59821
  Tested-by: jenkins <devops@whamcloud.com>
  Tested-by: Maloo <maloo@whamcloud.com>
  Reviewed-by: Andreas Dilger <adilger@whamcloud.com>
  Reviewed-by: Li Dongyang <dongyangli@ddn.com>

Change-Id: I1b81948b5bf114822ab140cb989c3a7e81fdc6f5
Lustre-bug-id: https://jira.hpdd.intel.com/browse/LU-4677
Signed-off-by: Pravin Shelar <pravin@clusterfs.com>
Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 debugfs/debugfs.8.in              |   7 +-
 debugfs/htree.c                   |   2 +-
 debugfs/ls.c                      |  59 +++-
 debugfs/ncheck.c                  |   3 +
 e2fsck/message.c                  |  37 ++-
 e2fsck/pass1.c                    |   4 +-
 e2fsck/pass2.c                    | 146 +++++++--
 e2fsck/pass3.c                    |   7 +
 e2fsck/problem.c                  |   5 +
 e2fsck/problem.h                  |   3 +
 e2fsck/rehash.c                   | 235 +++++++++-----
 lib/ext2fs/dirblock.c             |  33 ++
 lib/ext2fs/ext2_fs.h              |  43 ++-
 lib/ext2fs/ext2fs.h               |  22 +-
 lib/ext2fs/inline_data.c          |  14 +-
 lib/ext2fs/lfsck.h                |  60 ++++
 lib/ext2fs/link.c                 |  11 +-
 lib/ext2fs/newdir.c               |   4 +-
 misc/mke2fs.c                     |   1 +
 misc/tune2fs.c                    |   7 +
 tests/f_dir_optimize/expect.1     | 511 ++++++++++++++++++++++++++++++
 tests/f_dir_optimize/expect.2     | 511 ++++++++++++++++++++++++++++++
 tests/f_dir_optimize/image.gz     | Bin 0 -> 102520 bytes
 tests/f_dir_optimize/name         |   1 +
 tests/f_dir_optimize/script       |  36 +++
 tests/f_dirdata_dup_de/expect.1   |  37 +++
 tests/f_dirdata_dup_de/expect.2   |   7 +
 tests/f_dirdata_dup_de/image.gz   | Bin 0 -> 79307 bytes
 tests/f_dirdata_dup_de/name       |   1 +
 tests/f_dirdata_optimize/expect.1 |  10 +
 tests/f_dirdata_optimize/expect.2 |   7 +
 tests/f_dirdata_optimize/image.gz | Bin 0 -> 32121 bytes
 tests/f_dirdata_optimize/name     |   1 +
 tests/f_dirdata_optimize/script   |   3 +
 34 files changed, 1699 insertions(+), 129 deletions(-)
 create mode 100644 lib/ext2fs/lfsck.h
 create mode 100644 tests/f_dir_optimize/expect.1
 create mode 100644 tests/f_dir_optimize/expect.2
 create mode 100644 tests/f_dir_optimize/image.gz
 create mode 100644 tests/f_dir_optimize/name
 create mode 100644 tests/f_dir_optimize/script
 create mode 100644 tests/f_dirdata_dup_de/expect.1
 create mode 100644 tests/f_dirdata_dup_de/expect.2
 create mode 100644 tests/f_dirdata_dup_de/image.gz
 create mode 100644 tests/f_dirdata_dup_de/name
 create mode 100644 tests/f_dirdata_optimize/expect.1
 create mode 100644 tests/f_dirdata_optimize/expect.2
 create mode 100644 tests/f_dirdata_optimize/image.gz
 create mode 100644 tests/f_dirdata_optimize/name
 create mode 100644 tests/f_dirdata_optimize/script

diff --git a/debugfs/debugfs.8.in b/debugfs/debugfs.8.in
index 08f41fdfa..5a5dd32b0 100644
--- a/debugfs/debugfs.8.in
+++ b/debugfs/debugfs.8.in
@@ -575,7 +575,7 @@ Instead, it will stop only when the entire log is printed or after
 .I num_trans
 transactions.
 .TP
-.BI ls " [\-l] [\-c] [\-d] [\-p] [\-r] filespec"
+.BI ls " [\-l] [\-c] [\-d] [\-p] [\-r] [\-D] filespec"
 Print a listing of the files in the directory
 .IR filespec .
 The
@@ -595,6 +595,11 @@ non-printing characters at the end of filenames.
 The
 .I \-r
 flag will force the printing of the filename, even if it is encrypted.
+The
+.I \-D
+flag will print the extra data found inside each entry when the
+.I \-l
+flag is used.
 .TP
 .BI list_deleted_inodes " [limit]"
 List deleted inodes, optionally limited to those deleted within
diff --git a/debugfs/htree.c b/debugfs/htree.c
index 4ea8f30b3..65b0ff908 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -298,7 +298,7 @@ void do_htree_dump(int argc, ss_argv_t argv, int sci_idx EXT2FS_ATTR((unused)),
 		goto errout;
 	}
 
-	rootnode = (struct ext2_dx_root_info *) (buf + 24);
+	rootnode = get_ext2_dx_root_info(current_fs, buf);
 
 	fprintf(pager, "Root node dump:\n");
 	fprintf(pager, "\t Reserved zero: %u\n", rootnode->reserved_zero);
diff --git a/debugfs/ls.c b/debugfs/ls.c
index 613ad7380..abc571832 100644
--- a/debugfs/ls.c
+++ b/debugfs/ls.c
@@ -24,6 +24,7 @@ extern char *optarg;
 #endif
 
 #include "debugfs.h"
+#include "ext2fs/lfsck.h"
 
 /*
  * list directory
@@ -32,6 +33,7 @@ extern char *optarg;
 #define LONG_OPT	0x0001
 #define PARSE_OPT	0x0002
 #define RAW_OPT		0x0004
+#define DIRDATA_OPT	0x0008
 #define ENCRYPT_OPT	0x8000
 
 struct list_dir_struct {
@@ -44,6 +46,54 @@ struct list_dir_struct {
 static const char *monstr[] = { "Jan", "Feb", "Mar", "Apr", "May", "Jun",
 				"Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
 
+static void list_dirdata(struct list_dir_struct *ls,
+			 struct ext2_dir_entry *dirent)
+{
+	unsigned char	*data;
+	int		dlen;
+	__u8		dirdata_mask;
+	__u8		file_type = dirent->name_len >> 8;
+
+	data = (unsigned char *)dirent->name +
+		(dirent->name_len & EXT2_NAME_LEN) + 1;
+
+	for (dirdata_mask = EXT2_FT_MASK + 1;
+	     dirdata_mask != 0; dirdata_mask <<= 1) {
+		if ((dirdata_mask & file_type) == 0)
+			continue;
+
+		dlen = data[0];
+
+		if (dirdata_mask == EXT2_DIRENT_LUFID) {
+			struct lu_fid fid;
+			int offset = 0;
+			fprintf(ls->f, "fid:");
+			while (offset < (dlen - 1)) {
+				memcpy(&fid, data + offset + 1, sizeof(fid));
+				fid_be_to_cpu(&fid, &fid);
+				offset += sizeof(fid);
+				fprintf(ls->f, DFID, PFID(&fid));
+				if (offset < (dlen - 1))
+					fprintf(ls->f,", ");
+			}
+		} else if (dirdata_mask == EXT2_DIRENT_CFHASH) {
+			struct ext4_dirent_hash hash;
+			memcpy(&hash, data + 1, sizeof(hash));
+			hash_le_to_cpu(&hash, &hash);
+			fprintf(ls->f, "hash: %x, minor_hash: %x\n",
+				hash.dh_hash.hash, hash.dh_hash.minor_hash);
+		} else {
+			int i;
+
+			for (i = 1; i < dlen; i++)
+				fprintf(ls->f, "%02x", data[i]);
+		}
+
+		fprintf(ls->f, " ");
+		data += dlen;
+	}
+}
+
 static int print_filename(FILE *f, struct ext2_dir_entry *dirent, int options)
 {
 	unsigned char	ch;
@@ -147,6 +197,8 @@ static int list_dir_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
 			fprintf(ls->f, "%5llu",
 				(unsigned long long) EXT2_I_SIZE(&inode));
 		fprintf(ls->f, " %s ", datestr);
+		if ((ls->options & DIRDATA_OPT) != 0)
+			list_dirdata(ls, dirent);
 		print_filename(ls->f, dirent, options);
 		fputc('\n', ls->f);
 	} else {
@@ -195,7 +247,7 @@ void do_list_dir(int argc, ss_argv_t argv, int sci_idx EXT2FS_ATTR((unused)),
 		return;
 
 	reset_getopt();
-	while ((c = getopt (argc, argv, "cdlpr")) != EOF) {
+	while ((c = getopt(argc, argv, "cdDlpr")) != EOF) {
 		switch (c) {
 		case 'c':
 			flags |= DIRENT_FLAG_INCLUDE_CSUM;
@@ -203,6 +255,9 @@ void do_list_dir(int argc, ss_argv_t argv, int sci_idx EXT2FS_ATTR((unused)),
 		case 'l':
 			ls.options |= LONG_OPT;
 			break;
+		case 'D':
+			ls.options |= DIRDATA_OPT;
+			break;
 		case 'd':
 			flags |= DIRENT_FLAG_INCLUDE_REMOVED;
 			break;
@@ -219,7 +274,7 @@ void do_list_dir(int argc, ss_argv_t argv, int sci_idx EXT2FS_ATTR((unused)),
 
 	if (argc > optind+1) {
 	print_usage:
-		com_err(0, 0, "Usage: ls [-c] [-d] [-l] [-p] [-r] file");
+		com_err(0, 0, "Usage: ls [-c] [-d] [-D] [-l] [-p] [-r] file");
 		return;
 	}
 
diff --git a/debugfs/ncheck.c b/debugfs/ncheck.c
index 1410e7c6d..03d1e49cf 100644
--- a/debugfs/ncheck.c
+++ b/debugfs/ncheck.c
@@ -51,6 +51,9 @@ static int ncheck_proc(struct ext2_dir_entry *dirent,
 	iw->position++;
 	if (iw->position <= 2)
 		return 0;
+	if (current_fs->super->s_feature_incompat &
+	    EXT4_FEATURE_INCOMPAT_DIRDATA)
+		filetype &= EXT2_FT_MASK;
 	for (i=0; i < iw->num_inodes; i++) {
 		if (iw->iarray[i] == dirent->inode) {
 			if (!iw->parent && !iw->get_pathname_failed) {
diff --git a/e2fsck/message.c b/e2fsck/message.c
index 9c42b13fb..da71fd2f5 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -99,6 +99,7 @@
 
 #include "e2fsck.h"
 #include "problem.h"
+#include "ext2fs/lfsck.h"
 
 #ifdef __GNUC__
 #define _INLINE_ __inline__
@@ -346,6 +347,33 @@ static _INLINE_ void expand_inode_expression(FILE *f, ext2_filsys fs, char ch,
 	}
 }
 
+int get_dirent_fid(struct ext2_dir_entry *dirent,
+				    struct lu_fid *fid)
+{
+	unsigned char *data = (unsigned char *)dirent->name +
+			      (dirent->name_len & EXT2_NAME_LEN) + 1;
+	__u8 file_type = dirent->name_len >> 8;
+	__u8 dirdata_mask;
+
+	for (dirdata_mask = EXT2_FT_MASK + 1;
+	     dirdata_mask != 0; dirdata_mask <<= 1) {
+		int dlen;
+
+		if ((dirdata_mask & file_type) == 0)
+			continue;
+
+		dlen = data[0];
+		if (dirdata_mask == EXT2_DIRENT_LUFID) {
+			memcpy(fid, data + 1, sizeof(*fid));
+			fid_be_to_cpu(fid, fid);
+			return 0;
+		}
+		data += dlen;
+	}
+
+	return -1;
+}
+
 /*
  * This function expands '%dX' expressions
  */
@@ -361,9 +389,16 @@ static _INLINE_ void expand_dirent_expression(FILE *f, ext2_filsys fs, char ch,
 	dirent = ctx->dirent;
 
 	switch (ch) {
-	case 'i':
+	case 'i': {
+		struct lu_fid fid;
+
 		fprintf(f, "%u", dirent->inode);
+
+		if (!get_dirent_fid(dirent, &fid))
+			fprintf(f, " fid="DFID, PFID(&fid));
+
 		break;
+	}
 	case 'n':
 		len = ext2fs_dirent_name_len(dirent);
 		if ((ext2fs_get_rec_len(fs, dirent, &rec_len) == 0) &&
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index e7d5d0ae9..7e2b81c1d 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -764,7 +764,7 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 		 */
 		memcpy(&dotdot, inode->i_block, sizeof(dotdot));
 		memcpy(&de, ((char *)inode->i_block) + EXT4_INLINE_DATA_DOTDOT_SIZE,
-		       EXT2_DIR_REC_LEN(0));
+		       EXT2_DIR_NAME_LEN(0));
 		dotdot = ext2fs_le32_to_cpu(dotdot);
 		de.inode = ext2fs_le32_to_cpu(de.inode);
 		de.rec_len = ext2fs_le16_to_cpu(de.rec_len);
@@ -2795,7 +2795,7 @@ static int handle_htree(e2fsck_t ctx, struct problem_context *pctx,
 		return 1;
 
 	/* XXX should check that beginning matches a directory */
-	root = (struct ext2_dx_root_info *) (block_buf + 24);
+	root = get_ext2_dx_root_info(fs, block_buf);
 
 	if ((root->reserved_zero || root->info_length < 8) &&
 	    fix_problem(ctx, PR_1_HTREE_BADROOT, pctx))
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 036c0022d..b6973cd2d 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -395,13 +395,97 @@ static EXT2_QSORT_TYPE special_dir_block_cmp(const void *a, const void *b)
 	return (int) (db_a->blockcnt - db_b->blockcnt);
 }
 
+void ext2_fix_dirent_dirdata(struct ext2_dir_entry *de)
+{
+	__u16 file_type = de->name_len & (EXT2_FT_MASK << 8);
+	__u8 de_flags = (de->name_len >> 8) & ~EXT2_FT_MASK;
+	__u8 name_len = de->name_len & EXT2_NAME_LEN;
+	__u8 new_flag = 0;
+	int i;
+
+	for (i = 0; i < 4; i++) {
+		__u8 flags = new_flag | (1 << i) << 4;
+
+		/* new_flag is accumulating flags that are set in de_flags
+		 * and still fit inside rec_len. ext2_get_dirent_dirdata_size()
+		 * returns the size of all the dirdata entries in flags, and
+		 * chops off any that are beyond rec_len.
+		 */
+		if ((de_flags & flags) == flags) {
+			int dirdatalen = ext2_get_dirdata_field_size(de,
+								      flags);
+			int rlen = EXT2_DIR_NAME_LEN(name_len + dirdatalen);
+
+			if (rlen > de->rec_len)
+				break;
+
+			new_flag |= flags;
+		}
+	}
+
+	de->name_len = name_len | file_type | (new_flag << 8);
+}
+
+/*
+ * check for dirent data in ext4 dirent.
+ * return 0 if dirent data is ok.
+ * return 1 if dirent data does not exist.
+ * return 2 if dirent was modified due to error.
+ */
+int e2fsck_check_dirent_data(e2fsck_t ctx, struct ext2_dir_entry *de,
+			     unsigned int offset, struct problem_context *pctx)
+{
+	if (!(ctx->fs->super->s_feature_incompat &
+			EXT4_FEATURE_INCOMPAT_DIRDATA)) {
+		if ((de->name_len >> 8) & ~EXT2_FT_MASK) {
+			/* clear dirent extra data flags. */
+			if (fix_problem(ctx, PR_2_CLEAR_DIRDATA, pctx)) {
+				de->name_len &= (EXT2_FT_MASK << 8) |
+						EXT2_NAME_LEN;
+				return 2;
+			}
+		}
+		return 1;
+	}
+	if ((de->name_len >> 8) & ~EXT2_FT_MASK) {
+		if (de->rec_len >= EXT2_DIR_REC_LEN(de) ||
+		    de->rec_len + offset == EXT2_BLOCK_SIZE(ctx->fs->super)) {
+			int lufid_size, cshash_size;
+			lufid_size = ext2_get_dirdata_field_size(de,
+							 EXT2_DIRENT_LUFID);
+			cshash_size = ext2_get_dirdata_field_size(de,
+							 EXT2_DIRENT_CFHASH);
+			if ((lufid_size == 0 || lufid_size %
+			    EXT2_DIRENT_LUFID_SIZE == 1 /*size*/
+			    + 1 /*NULL*/) &&
+			    (cshash_size == 0 ||
+			     cshash_size ==
+			     sizeof(struct ext2_dir_entry_hash) + 1 /*size*/
+								+ 1 /*NULL*/))
+				return 0;
+		}
+		/* just clear dirent data flags for now, we should fix FID data
+		 * in lustre specific pass.
+		 */
+		if (fix_problem(ctx, PR_2_CLEAR_DIRDATA, pctx)) {
+			ext2_fix_dirent_dirdata(de);
+			if (ext2_get_dirdata_field_size(de,
+							 EXT2_DIRENT_LUFID) !=
+			    EXT2_DIRENT_LUFID_SIZE)
+				de->name_len &= ~(EXT2_DIRENT_LUFID << 8);
+
+			return 2;
+		}
+	}
+	return 1;
+}
 
 /*
  * Make sure the first entry in the directory is '.', and that the
  * directory entry is sane.
  */
 static int check_dot(e2fsck_t ctx,
-		     struct ext2_dir_entry *dirent,
+		     struct ext2_dir_entry *dirent, unsigned int offset,
 		     ext2_ino_t ino, struct problem_context *pctx)
 {
 	struct ext2_dir_entry *nextdir;
@@ -410,6 +494,7 @@ static int check_dot(e2fsck_t ctx,
 	int		created = 0;
 	problem_t	problem = 0;
 	int		ftype = EXT2_FT_DIR;
+	int		dir_data_error;
 
 	if (!dirent->inode)
 		problem = PR_2_MISSING_DOT;
@@ -419,12 +504,14 @@ static int check_dot(e2fsck_t ctx,
 	else if (dirent->name[1] != '\0')
 		problem = PR_2_DOT_NULL_TERM;
 
+	dir_data_error = e2fsck_check_dirent_data(ctx, dirent, offset, pctx);
+
 	(void) ext2fs_get_rec_len(ctx->fs, dirent, &rec_len);
 	if (problem) {
 		if (!ext2fs_has_feature_filetype(ctx->fs->super))
 			ftype = EXT2_FT_UNKNOWN;
 		if (fix_problem(ctx, problem, pctx)) {
-			if (rec_len < 12)
+			if (rec_len < 12 && dir_data_error)
 				rec_len = dirent->rec_len = 12;
 			dirent->inode = ino;
 			ext2fs_dirent_set_name_len(dirent, 1);
@@ -443,7 +530,7 @@ static int check_dot(e2fsck_t ctx,
 	}
 	if (rec_len > 12) {
 		new_len = rec_len - 12;
-		if (new_len > 12) {
+		if (new_len > 12 && dir_data_error) {
 			if (created ||
 			    fix_problem(ctx, PR_2_SPLIT_DOT, pctx)) {
 				nextdir = (struct ext2_dir_entry *)
@@ -480,12 +567,13 @@ static int check_dot(e2fsck_t ctx,
  * here; this gets done in pass 3.
  */
 static int check_dotdot(e2fsck_t ctx,
-			struct ext2_dir_entry *dirent,
+			struct ext2_dir_entry *dirent, unsigned int offset,
 			ext2_ino_t ino, struct problem_context *pctx)
 {
 	problem_t	problem = 0;
 	unsigned int	rec_len;
 	int		ftype = EXT2_FT_DIR;
+	int		dir_data_error;
 
 	if (!dirent->inode)
 		problem = PR_2_MISSING_DOT_DOT;
@@ -496,12 +584,14 @@ static int check_dotdot(e2fsck_t ctx,
 	else if (dirent->name[2] != '\0')
 		problem = PR_2_DOT_DOT_NULL_TERM;
 
+	dir_data_error = e2fsck_check_dirent_data(ctx, dirent, offset, pctx);
+
 	(void) ext2fs_get_rec_len(ctx->fs, dirent, &rec_len);
 	if (problem) {
 		if (!ext2fs_has_feature_filetype(ctx->fs->super))
 			ftype = EXT2_FT_UNKNOWN;
 		if (fix_problem(ctx, problem, pctx)) {
-			if (rec_len < 12)
+			if (rec_len < 12 && dir_data_error)
 				dirent->rec_len = 12;
 			/*
 			 * Note: we don't have the parent inode just
@@ -597,6 +687,12 @@ static _INLINE_ int check_filetype(e2fsck_t ctx,
 	int	filetype = ext2fs_dirent_file_type(dirent);
 	int	should_be = EXT2_FT_UNKNOWN;
 	struct ext2_inode	inode;
+	__u8    dirdata = 0;
+
+	if (ext2fs_has_feature_dirdata(ctx->fs->super)) {
+		dirdata = filetype & ~EXT2_FT_MASK;
+		filetype = filetype & EXT2_FT_MASK;
+	}
 
 	if (!ext2fs_has_feature_filetype(ctx->fs->super)) {
 		if (filetype == 0 ||
@@ -627,8 +723,7 @@ static _INLINE_ int check_filetype(e2fsck_t ctx,
 	if (fix_problem(ctx, filetype ? PR_2_BAD_FILETYPE : PR_2_SET_FILETYPE,
 			pctx) == 0)
 		return 0;
-
-	ext2fs_dirent_set_file_type(dirent, should_be);
+	ext2fs_dirent_set_file_type(dirent, should_be | dirdata);
 	return 1;
 }
 
@@ -650,7 +745,7 @@ static void parse_int_node(ext2_filsys fs,
 	int		csum_size = 0;
 
 	if (db->blockcnt == 0) {
-		root = (struct ext2_dx_root_info *) (block_buf + 24);
+		root = get_ext2_dx_root_info(fs, block_buf);
 
 #ifdef DX_DEBUG
 		printf("Root node dump:\n");
@@ -660,8 +755,8 @@ static void parse_int_node(ext2_filsys fs,
 		printf("\t Indirect levels: %u\n", root->indirect_levels);
 		printf("\t Flags: %x\n", root->unused_flags);
 #endif
-
-		ent = (struct ext2_dx_entry *) (block_buf + 24 + root->info_length);
+		ent = (struct ext2_dx_entry *)((char *)root +
+					       root->info_length);
 
 		if (failed_csum &&
 		    (e2fsck_dir_will_be_rehashed(cd->ctx, cd->pctx.ino) ||
@@ -669,7 +764,7 @@ static void parse_int_node(ext2_filsys fs,
 				&cd->pctx)))
 			goto clear_and_exit;
 	} else {
-		ent = (struct ext2_dx_entry *) (block_buf+8);
+		ent = (struct ext2_dx_entry *)(block_buf + 8);
 
 		if (failed_csum &&
 		    (e2fsck_dir_will_be_rehashed(cd->ctx, cd->pctx.ino) ||
@@ -677,8 +772,7 @@ static void parse_int_node(ext2_filsys fs,
 				&cd->pctx)))
 			goto clear_and_exit;
 	}
-
-	limit = (struct ext2_dx_countlimit *) ent;
+	limit = (struct ext2_dx_countlimit *)ent;
 
 #ifdef DX_DEBUG
 	printf("Number of entries (count): %d\n",
@@ -852,7 +946,6 @@ static void salvage_directory(ext2_filsys fs,
 	}
 }
 
-#define NEXT_DIRENT(d)	((void *)((char *)(d) + (d)->rec_len))
 static errcode_t insert_dirent_tail(ext2_filsys fs, void *dirbuf)
 {
 	struct ext2_dir_entry *d;
@@ -862,11 +955,11 @@ static errcode_t insert_dirent_tail(ext2_filsys fs, void *dirbuf)
 	d = dirbuf;
 	top = EXT2_DIRENT_TAIL(dirbuf, fs->blocksize);
 
-	while (d->rec_len && !(d->rec_len & 0x3) && NEXT_DIRENT(d) <= top)
-		d = NEXT_DIRENT(d);
+	while (d->rec_len && !(d->rec_len & 0x3) && EXT2_NEXT_DIRENT(d) <= top)
+		d = EXT2_NEXT_DIRENT(d);
 
 	if (d != top) {
-		unsigned int min_size = EXT2_DIR_REC_LEN(
+		unsigned int min_size = EXT2_DIR_NAME_LEN(
 				ext2fs_dirent_name_len(dirbuf));
 		if (min_size > (char *)top - (char *)d)
 			return EXT2_ET_DIR_NO_SPACE_FOR_CSUM;
@@ -881,7 +974,6 @@ static errcode_t insert_dirent_tail(ext2_filsys fs, void *dirbuf)
 
 	return 0;
 }
-#undef NEXT_DIRENT
 
 static errcode_t fix_inline_dir_size(e2fsck_t ctx, ext2_ino_t ino,
 				     size_t *inline_data_size,
@@ -900,7 +992,7 @@ static errcode_t fix_inline_dir_size(e2fsck_t ctx, ext2_ino_t ino,
 	 */
 	if (old_size > EXT4_MIN_INLINE_DATA_SIZE &&
 	    old_size < EXT4_MIN_INLINE_DATA_SIZE +
-		       EXT2_DIR_REC_LEN(1)) {
+		       EXT2_DIR_NAME_LEN(1)) {
 		old_size = EXT4_MIN_INLINE_DATA_SIZE;
 		new_size = old_size;
 	} else
@@ -1187,7 +1279,7 @@ inline_read_fail:
 	if (((inline_data_size & 3) ||
 	     (inline_data_size > EXT4_MIN_INLINE_DATA_SIZE &&
 	      inline_data_size < EXT4_MIN_INLINE_DATA_SIZE +
-				 EXT2_DIR_REC_LEN(1))) &&
+				 EXT2_DIR_NAME_LEN(1))) &&
 	    fix_problem(ctx, PR_2_BAD_INLINE_DIR_SIZE, &pctx)) {
 		errcode_t err = fix_inline_dir_size(ctx, ino,
 						    &inline_data_size, &pctx,
@@ -1237,7 +1329,7 @@ inline_read_fail:
 		(void) ext2fs_get_rec_len(fs, dirent, &rec_len);
 		limit = (struct ext2_dx_countlimit *) (buf+8);
 		if (db->blockcnt == 0) {
-			root = (struct ext2_dx_root_info *) (buf + 24);
+			root = get_ext2_dx_root_info(fs, buf);
 			dx_db->type = DX_DIRBLOCK_ROOT;
 			dx_db->flags |= DX_FLAG_FIRST | DX_FLAG_LAST;
 
@@ -1409,7 +1501,7 @@ skip_checksum:
 				memset(&dot, 0, sizeof(dot));
 				dirent = &dot;
 				dirent->inode = ino;
-				dirent->rec_len = EXT2_DIR_REC_LEN(1);
+				dirent->rec_len = EXT2_DIR_NAME_LEN(1);
 				dirent->name_len = 1 | filetype;
 				dirent->name[0] = '.';
 			} else if (dot_state == 1) {
@@ -1417,7 +1509,7 @@ skip_checksum:
 				dirent = &dotdot;
 				dirent->inode =
 					((struct ext2_dir_entry *)buf)->inode;
-				dirent->rec_len = EXT2_DIR_REC_LEN(2);
+				dirent->rec_len = EXT2_DIR_NAME_LEN(2);
 				dirent->name_len = 2 | filetype;
 				dirent->name[0] = '.';
 				dirent->name[1] = '.';
@@ -1429,10 +1521,10 @@ skip_checksum:
 		}
 
 		if (dot_state == 0) {
-			if (check_dot(ctx, dirent, ino, &cd->pctx))
+			if (check_dot(ctx, dirent, offset, ino, &cd->pctx))
 				dir_modified++;
 		} else if (dot_state == 1) {
-			ret = check_dotdot(ctx, dirent, ino, &cd->pctx);
+			ret = check_dotdot(ctx, dirent, offset, ino, &cd->pctx);
 			if (ret < 0)
 				goto abort_free_dict;
 			if (ret)
@@ -1448,6 +1540,10 @@ skip_checksum:
 		if (!dirent->inode)
 			goto next;
 
+		ret = e2fsck_check_dirent_data(ctx, dirent, offset, &cd->pctx);
+		if (ret == 2)
+			dir_modified++;
+
 		/*
 		 * Make sure the inode listed is a legal one.
 		 */
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 56798b1bc..343609832 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -706,6 +706,7 @@ static int fix_dotdot_proc(struct ext2_dir_entry *dirent,
 	struct fix_dotdot_struct *fp = (struct fix_dotdot_struct *) priv_data;
 	errcode_t	retval;
 	struct problem_context pctx;
+	__u16 dirdata = 0;
 
 	if (ext2fs_dirent_name_len(dirent) != 2)
 		return 0;
@@ -725,11 +726,17 @@ static int fix_dotdot_proc(struct ext2_dir_entry *dirent,
 		fix_problem(fp->ctx, PR_3_ADJUST_INODE, &pctx);
 	}
 	dirent->inode = fp->parent;
+
+	dirdata  = dirent->name_len & ((__u16)~EXT2_FT_MASK << 8);
+
 	if (ext2fs_has_feature_filetype(fp->ctx->fs->super))
 		ext2fs_dirent_set_file_type(dirent, EXT2_FT_DIR);
 	else
 		ext2fs_dirent_set_file_type(dirent, EXT2_FT_UNKNOWN);
 
+	if (ext2fs_has_feature_dirdata(fp->ctx->fs->super))
+		dirent->name_len |= dirdata;
+
 	fp->done++;
 	return DIRENT_ABORT | DIRENT_CHANGED;
 }
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index e433281fa..afa3d517a 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1875,6 +1875,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@E references EA @i %Di.\n"),
 	  PROMPT_CLEAR, 0, 0, 0, 0 },
 
+	/* Directory entry dirdata length set incorrectly */
+	{ PR_2_CLEAR_DIRDATA,
+	  N_("@E dirdata length set incorrectly.\n"),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
 	/* Pass 3 errors */
 
 	/* Pass 3: Checking directory connectivity */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index ef15b8c84..1ef519908 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -1070,6 +1070,9 @@ struct problem_context {
 /* EA inode referenced from directory */
 #define PR_2_EA_INODE_DIR_LINK 0x020055
 
+/* Entry dirdata length set incorrectly */
+#define PR_2_CLEAR_DIRDATA		0x020057
+
 /*
  * Pass 3 errors
  */
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 4847d172e..60b395cd3 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -53,6 +53,9 @@
 #include "problem.h"
 #include "support/sort_r.h"
 
+#define min(a, b) ((a) < (b) ? (a) : (b))
+#define max(a, b) ((a) > (b) ? (a) : (b))
+
 /* Schedule a dir to be rebuilt during pass 3A. */
 void e2fsck_rehash_dir_later(e2fsck_t ctx, ext2_ino_t ino)
 {
@@ -86,6 +89,8 @@ struct fill_dir_struct {
 	int compress;
 	ext2_ino_t parent;
 	ext2_ino_t dir;
+	struct ext2_dir_entry *dot_de;
+	struct ext2_dir_entry *dotdot_de;
 };
 
 struct hash_entry {
@@ -187,11 +192,14 @@ static int fill_dir_block(ext2_filsys fs,
 			return BLOCK_ABORT;
 		}
 		if (!fd->compress && (name_len == 1) &&
-		    (dirent->name[0] == '.'))
+		    (dirent->name[0] == '.')) {
+			fd->dot_de = dirent;
 			continue;
+		}
 		if (!fd->compress && (name_len == 2) &&
 		    (dirent->name[0] == '.') && (dirent->name[1] == '.')) {
 			fd->parent = dirent->inode;
+			fd->dotdot_de = dirent;
 			continue;
 		}
 		if (fd->num_array >= fd->max_array) {
@@ -209,7 +217,7 @@ static int fill_dir_block(ext2_filsys fs,
 		}
 		ent = fd->harray + fd->num_array++;
 		ent->dir = dirent;
-		fd->dir_size += ext2fs_dir_rec_len(name_len, extended);
+		fd->dir_size += ext2fs_dirdata_rec_len(dirent, extended);
 		ent->ino = dirent->inode;
 		if (extended) {
 			ent->hash = EXT2_DIRENT_HASH(dirent);
@@ -390,66 +398,128 @@ static errcode_t get_next_block(ext2_filsys fs, struct out_dir *outdir,
 	return 0;
 }
 
+static void increment_name(char *str, int len)
+{
+	int i;
+
+	for (i = len - 1; i >= 0; i--) {
+		switch(str[i]) {
+		case '~':
+			str[i] = '1';
+			if (i > 0 && len > 2)
+				str[i-1] = '~';
+			break;
+		case '9':
+			if (i > 1) {
+				str[i] = '0';
+				continue;
+			}
+			str[i] = 'a';
+			break;
+		case 'z':
+			str[i] = 'A';
+			break;
+		case 'Z':
+			str[i] = '0';
+			continue;
+		default:
+			if (!isalnum(str[i]))
+				str[i] = '~';
+			else
+				str[i]++;
+		}
+		break;
+	}
+}
+
 /*
  * This function is used to make a unique filename.  We do this by
  * appending ~0, and then incrementing the number.  However, we cannot
  * expand the length of the filename beyond the padding available in
  * the directory entry.
+ * e.g:
+ * - test (max: 6)	-> test~0
+ * - test~9 (max: 6)	-> tes~10
+ * - test (max: 4)	-> te~0
+ * - te (max: 3)	-> t~0
+ * - t (max: 2)		-> t~
+ * - t~ (max: 2)	-> t1
+ * - t9 (max: 2)	-> ta
+ * - tZ (max: 2)	-> u0
+ * - t (max: 1)		-> u
  */
-static void mutate_name(char *str, unsigned int *len)
+static void mutate_name(char *str, int *len, int max_len)
 {
 	int i;
-	unsigned int l = *len;
+	int l = *len;
 
 	/*
 	 * First check to see if it looks the name has been mutated
 	 * already
 	 */
+	max_len = max(max_len, l);
 	for (i = l-1; i > 0; i--) {
-		if (!isdigit(str[i]))
+		if (!isalnum(str[i]))
 			break;
 	}
-	if ((i == (int)l - 1) || (str[i] != '~')) {
-		if (((l-1) & 3) < 2)
-			l += 2;
-		else
-			l = (l+3) & ~3;
-		if (l > 255)
-			l = 255;
+
+	if ((i != l-1 && str[i] == '~') ||
+	    (max_len <= 2 && max_len == l)) {
+		increment_name(str, l);
+		return;
+	}
+
+	/* Add the first suffix: "~0" */
+	l += min(2, max_len - l);
+	if (l > 2) {
 		str[l-2] = '~';
 		str[l-1] = '0';
-		*len = l;
-		return;
+	} else {
+		str[l-1] = '~';
 	}
-	for (i = l-1; i >= 0; i--) {
-		if (isdigit(str[i])) {
-			if (str[i] == '9')
-				str[i] = '0';
-			else {
-				str[i]++;
-				return;
-			}
-			continue;
-		}
-		if (i == 1) {
-			if (str[0] == 'z')
-				str[0] = 'A';
-			else if (str[0] == 'Z') {
-				str[0] = '~';
-				str[1] = '0';
-			} else
-				str[0]++;
-		} else if (i > 0) {
-			str[i] = '1';
-			str[i-1] = '~';
-		} else {
-			if (str[0] == '~')
-				str[0] = 'a';
-			else
-				str[0]++;
+
+	*len = l;
+}
+
+
+static errcode_t rename_dentry(struct ext2_dir_entry *de, char *new_name,
+			       unsigned int new_len)
+{
+	int dirdata_size = ext2_get_dirdata_size(de);
+	int diff = new_len - ext2fs_dirent_name_len(de);
+	int new_dirdata_off = offsetof(typeof(*de), name) + new_len;
+	void *mv_src, *mv_dst;
+
+	if (diff <= 0 || !dirdata_size) {
+		memcpy(de->name, new_name, new_len);
+		ext2fs_dirent_set_name_len(de, new_len);
+	}
+
+	if (!dirdata_size || !diff)
+		return 0;
+
+	/* move dirdata if needed */
+	if (diff > 0 ) {
+		int rec_len = EXT2_DIR_REC_LEN(de);
+
+		/* this should nerver happen (see mutate_name()) */
+		if (new_dirdata_off + dirdata_size > rec_len) {
+			com_err("rename_dentry", ERANGE,
+				_("failed to rename %u"), de->inode);
+			return ERANGE;
 		}
-		break;
 	}
+
+	mv_dst = (void *)de + new_dirdata_off;
+	mv_src = mv_dst - diff;
+	memmove(mv_dst, mv_src, dirdata_size);
+
+	if (diff > 0) {
+		memcpy(de->name, new_name, new_len);
+		ext2fs_dirent_set_name_len(de, new_len);
+	}
+
+	return 0;
 }
 
 static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
@@ -462,7 +532,7 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
 	blk_t			i, j;
 	int			fixed = 0;
 	char			new_name[256];
-	unsigned int		new_len;
+	int			new_len, max_len;
 	int			hash_alg;
 	int hash_flags = fd->inode->i_flags & EXT4_CASEFOLD_FL;
 
@@ -507,7 +577,9 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
 			continue;
 		}
 		memcpy(new_name, ent->dir->name, new_len);
-		mutate_name(new_name, &new_len);
+		max_len = min(EXT2_NAME_LEN,
+			      new_len + ext2fs_dir_rec_padding(ent->dir));
+		mutate_name(new_name, &new_len, max_len);
 		for (j=0; j < fd->num_array; j++) {
 			if ((i==j) ||
 			    !same_name(cmp_ctx, new_name, new_len,
@@ -515,15 +587,14 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
 				       ext2fs_dirent_name_len(fd->harray[j].dir))) {
 				continue;
 			}
-			mutate_name(new_name, &new_len);
+			mutate_name(new_name, &new_len, max_len);
 
 			j = -1;
 		}
 		new_name[new_len] = 0;
 		pctx.str = new_name;
-		if (fix_problem(ctx, PR_2_NON_UNIQUE_FILE, &pctx)) {
-			memcpy(ent->dir->name, new_name, new_len);
-			ext2fs_dirent_set_name_len(ent->dir, new_len);
+		if (fix_problem(ctx, PR_2_NON_UNIQUE_FILE, &pctx) &&
+		    !rename_dentry(ent->dir, new_name, new_len)) {
 			ext2fs_dirhash2(hash_alg, new_name, new_len,
 					fs->encoding, hash_flags,
 					fs->super->s_hash_seed,
@@ -587,8 +658,7 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 		ent = fd->harray + i;
 		if (ent->dir->inode == 0)
 			continue;
-		rec_len = ext2fs_dir_rec_len(ext2fs_dirent_name_len(ent->dir),
-					     hash_in_entry);
+		rec_len = ext2fs_dirdata_rec_len(ent->dir, hash_in_entry);
 		if (rec_len > left) {
 			if (left) {
 				left += prev_rec_len;
@@ -623,8 +693,7 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 		if (retval)
 			return retval;
 		prev_rec_len = rec_len;
-		memcpy(dirent->name, ent->dir->name,
-		       ext2fs_dirent_name_len(dirent));
+		memcpy(dirent->name, ent->dir->name, rec_len);
 		if (hash_in_entry) {
 			EXT2_DIRENT_HASHES(dirent)->hash = ext2fs_cpu_to_le32(ent->hash);
 			EXT2_DIRENT_HASHES(dirent)->minor_hash =
@@ -655,47 +724,52 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 
 static struct ext2_dx_root_info *set_root_node(ext2_filsys fs, char *buf,
 				    ext2_ino_t ino, ext2_ino_t parent,
+				    struct ext2_dir_entry *dot_de,
+				    struct ext2_dir_entry *dotdot_de,
 				    struct ext2_inode *inode)
 {
-	struct ext2_dir_entry 		*dir;
-	struct ext2_dx_root_info  	*root;
+	struct ext2_dir_entry		*dirent;
+	struct ext2_dx_root_info	*root;
 	struct ext2_dx_countlimit	*limits;
-	int				filetype = 0;
 	int				csum_size = 0;
-
-	if (ext2fs_has_feature_filetype(fs->super))
-		filetype = EXT2_FT_DIR;
+	int				offset;
+	int				rec_len;
 
 	memset(buf, 0, fs->blocksize);
-	dir = (struct ext2_dir_entry *) buf;
-	dir->inode = ino;
-	dir->name[0] = '.';
-	ext2fs_dirent_set_name_len(dir, 1);
-	ext2fs_dirent_set_file_type(dir, filetype);
-	dir->rec_len = 12;
-	dir = (struct ext2_dir_entry *) (buf + 12);
-	dir->inode = parent;
-	dir->name[0] = '.';
-	dir->name[1] = '.';
-	ext2fs_dirent_set_name_len(dir, 2);
-	ext2fs_dirent_set_file_type(dir, filetype);
-	dir->rec_len = fs->blocksize - 12;
-
-	root = (struct ext2_dx_root_info *) (buf+24);
+	dirent = (struct ext2_dir_entry *) buf;
+	dirent->inode = ino;
+
+	dirent->name_len = dot_de->name_len;
+	offset = rec_len = dirent->rec_len = dot_de->rec_len;
+	memcpy(dirent->name, dot_de->name, rec_len);
+
+	dirent = EXT2_NEXT_DIRENT(dirent);
+	/* set to jump over the index block */
+
+	dirent->inode = parent;
+
+	dirent->name_len = dotdot_de->name_len;
+	dirent->rec_len = fs->blocksize - rec_len;
+	rec_len = EXT2_DIR_REC_LEN(dotdot_de);
+	memcpy(dirent->name, dotdot_de->name, rec_len);
+	offset += rec_len;
+
+	root = (struct ext2_dx_root_info *)(buf + offset);
 	root->reserved_zero = 0;
 	if (ext4_hash_in_dirent(inode))
 		root->hash_version = EXT2_HASH_SIPHASH;
 	else
 		root->hash_version = fs->super->s_def_hash_version;
-	root->info_length = 8;
+	root->info_length = sizeof(*root);
 	root->indirect_levels = 0;
 	root->unused_flags = 0;
+	offset += root->info_length;
 
 	if (ext2fs_has_feature_metadata_csum(fs->super))
 		csum_size = sizeof(struct ext2_dx_tail);
 
-	limits = (struct ext2_dx_countlimit *) (buf+32);
-	limits->limit = (fs->blocksize - (32 + csum_size)) /
+	limits = (struct ext2_dx_countlimit *) (buf + offset);
+	limits->limit = (fs->blocksize - (offset + csum_size)) /
 			sizeof(struct ext2_dx_entry);
 	limits->count = 0;
 
@@ -773,6 +847,8 @@ static errcode_t calculate_tree(ext2_filsys fs,
 				struct out_dir *outdir,
 				ext2_ino_t ino,
 				ext2_ino_t parent,
+				struct ext2_dir_entry *dot_de,
+				struct ext2_dir_entry *dotdot_de,
 				struct ext2_inode *inode)
 {
 	struct ext2_dx_root_info	*root_info;
@@ -782,7 +858,9 @@ static errcode_t calculate_tree(ext2_filsys fs,
 	int				i, c1, c2, c3, nblks;
 	int				limit_offset, int_offset, root_offset;
 
-	root_info = set_root_node(fs, outdir->buf, ino, parent, inode);
+	root_info = set_root_node(fs, outdir->buf, ino, parent, dot_de,
+				  dotdot_de, inode);
+
 	root_offset = limit_offset = ((char *) root_info - outdir->buf) +
 		root_info->info_length;
 	root_limit = (struct ext2_dx_countlimit *) (outdir->buf + limit_offset);
@@ -1087,11 +1165,10 @@ resort:
 	if (retval)
 		goto errout;
 
-	free(dir_buf); dir_buf = 0;
-
 	if (!fd.compress) {
 		/* Calculate the interior nodes */
-		retval = calculate_tree(fs, &outdir, ino, fd.parent, fd.inode);
+		retval = calculate_tree(fs, &outdir, ino, fd.parent,
+					fd.dot_de, fd.dotdot_de, fd.inode);
 		if (retval)
 			goto errout;
 	}
diff --git a/lib/ext2fs/dirblock.c b/lib/ext2fs/dirblock.c
index 54b277728..d1d5a9e7f 100644
--- a/lib/ext2fs/dirblock.c
+++ b/lib/ext2fs/dirblock.c
@@ -50,6 +50,39 @@ errcode_t ext2fs_read_dir_block3(ext2_filsys fs, blk64_t block,
 	return ext2fs_read_dir_block4(fs, block, buf, flags, 0);
 }
 
+/*
+ * Compute the dirdata length. This includes only optional extensions.
+ * Each extension has a bit set in the high 4 bits of
+ * de->file_type, and the extension length is the first byte in each entry.
+ */
+int ext2_get_dirdata_field_size(struct ext2_dir_entry *de,
+				 __u8 dirdata_flags)
+{
+	char *lenp = de->name + (de->name_len & EXT2_NAME_LEN) + 1 /* NUL */;
+	__u8 extra_data_flags = (de->name_len & ~(EXT2_FT_MASK << 8)) >> 12;
+	int dlen = 0;
+
+	dirdata_flags >>= 4;
+	while ((extra_data_flags & dirdata_flags) != 0) {
+		if (extra_data_flags & 1) {
+			if (dirdata_flags & 1)
+				dlen += *lenp;
+
+			lenp += *lenp;
+		}
+		extra_data_flags >>= 1;
+		dirdata_flags >>= 1;
+	}
+
+	/* add NUL terminator byte to dirdata length */
+	return dlen + (dlen != 0);
+}
+
+int ext2_get_dirdata_size(struct ext2_dir_entry *de)
+{
+	return ext2_get_dirdata_field_size(de, ~EXT2_FT_MASK);
+}
+
 errcode_t ext2fs_read_dir_block2(ext2_filsys fs, blk_t block,
 				 void *buf, int flags EXT2FS_ATTR((unused)))
 {
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index fcd420556..a25a7c29e 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -977,7 +977,8 @@ EXT4_FEATURE_INCOMPAT_FUNCS(casefold,		4, CASEFOLD)
 #define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
 				       EXT4_FEATURE_INCOMPAT_MMP| \
 				       EXT4_FEATURE_INCOMPAT_LARGEDIR| \
-				       EXT4_FEATURE_INCOMPAT_EA_INODE)
+				       EXT4_FEATURE_INCOMPAT_EA_INODE| \
+				       EXT4_FEATURE_INCOMPAT_DIRDATA)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
@@ -1091,6 +1092,7 @@ struct ext2_dir_entry_tail {
 #define EXT2_FT_SYMLINK		7
 
 #define EXT2_FT_MAX		8
+#define EXT2_FT_MASK		0x0f
 
 /*
  * Annoyingly, e2fsprogs always swab16s ext2_dir_entry.name_len, so we
@@ -1100,6 +1102,9 @@ struct ext2_dir_entry_tail {
  */
 #define EXT2_DIR_NAME_LEN_CSUM	0xDE00
 
+int ext2_get_dirdata_field_size(struct ext2_dir_entry *de, __u8 dirdata_flags);
+int ext2_get_dirdata_size(struct ext2_dir_entry *de);
+
 /*
  * EXT2_DIR_PAD defines the directory entries boundaries
  *
@@ -1109,7 +1114,13 @@ struct ext2_dir_entry_tail {
 #define EXT2_DIR_ENTRY_HASH_LEN		8
 #define EXT2_DIR_PAD			4
 #define EXT2_DIR_ROUND			(EXT2_DIR_PAD - 1)
-#define EXT2_DIR_REC_LEN(name_len) ext2fs_dir_rec_len(name_len, 0)
+#define EXT2_DIR_NAME_LEN(name_len)	(((name_len) + \
+					  EXT2_DIR_ENTRY_HEADER_LEN + \
+					  EXT2_DIR_ROUND) & \
+					 ~EXT2_DIR_ROUND)
+#define EXT2_DIR_REC_LEN(de)	(EXT2_DIR_NAME_LEN(((de)->name_len &         \
+						     EXT2_NAME_LEN) +         \
+						    ext2_get_dirdata_size(de)))
 
 static inline unsigned int ext2fs_dir_rec_len(__u8 name_len,
 						int extended)
@@ -1122,6 +1133,32 @@ static inline unsigned int ext2fs_dir_rec_len(__u8 name_len,
 	return rec_len;
 }
 
+static inline unsigned int ext2fs_dirdata_rec_len(struct ext2_dir_entry *de,
+						int extended)
+{
+	int rec_len = EXT2_DIR_REC_LEN(de);
+
+	if (extended)
+		rec_len += EXT2_DIR_ENTRY_HASH_LEN;
+	return rec_len;
+}
+
+static inline unsigned int ext2fs_dir_rec_padding(struct ext2_dir_entry *de)
+{
+	unsigned int len = (de->name_len & EXT2_NAME_LEN) +
+		ext2_get_dirdata_size(de);
+
+	len &= EXT2_DIR_ROUND;
+	if (len)
+		len = EXT2_DIR_PAD - len;
+	return len;
+}
+
+/* lu_fid size and NUL char */
+#define EXT2_DIRENT_LUFID_SIZE		16
+#define EXT2_DIRENT_LUFID		0x10
+#define EXT2_DIRENT_CFHASH		0x40
+
 #define EXT4_ORPHAN_BLOCK_MAGIC 0x0b10ca04
 
 /* Structure at the tail of orphan block */
@@ -1202,4 +1239,6 @@ struct mmp_struct {
 
 #define EXT4_ENC_STRICT_MODE_FL			(1 << 0) /* Reject invalid sequences */
 
+#define EXT2_NEXT_DIRENT(d)	((void *)((char *)(d) + (d)->rec_len))
+
 #endif	/* _LINUX_EXT2_FS_H */
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index bb2170b78..9bb6fe96f 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -726,6 +726,7 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
 					 EXT4_FEATURE_INCOMPAT_EA_INODE|\
+					 EXT4_FEATURE_INCOMPAT_DIRDATA|\
 					 EXT4_LIB_INCOMPAT_MMP|\
 					 EXT4_FEATURE_INCOMPAT_64BIT|\
 					 EXT4_FEATURE_INCOMPAT_INLINE_DATA|\
@@ -2246,6 +2247,25 @@ _INLINE_ int ext2fs_htree_intnode_maxrecs(ext2_filsys fs, int blocks)
 						sizeof(struct ext2_dx_entry));
 }
 
+_INLINE_ struct ext2_dx_root_info *get_ext2_dx_root_info(ext2_filsys fs,
+							 char *buf)
+{
+	struct ext2_dir_entry *de = (struct ext2_dir_entry *)buf;
+
+	if (!(fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_DIRDATA))
+		return (struct ext2_dx_root_info *)(buf +
+						    EXT2_DIR_NAME_LEN(1) +
+						    EXT2_DIR_NAME_LEN(2));
+
+	/* get dotdot first */
+	de = (struct ext2_dir_entry *)((char *)de + de->rec_len);
+
+	/* dx root info is after dotdot entry */
+	de = (struct ext2_dir_entry *)((char *)de + EXT2_DIR_REC_LEN(de));
+
+	return (struct ext2_dx_root_info *)de;
+}
+
 /*
  * log base 2, rounded down
  */
@@ -2325,7 +2345,7 @@ _INLINE_ __u64 ext2fs_div64_ceil(__u64 a, __u64 b)
 
 _INLINE_ int ext2fs_dirent_name_len(const struct ext2_dir_entry *entry)
 {
-	return entry->name_len & 0xff;
+	return entry->name_len & EXT2_NAME_LEN;
 }
 
 _INLINE_ void ext2fs_dirent_set_name_len(struct ext2_dir_entry *entry, int len)
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index bd52e3770..c8d2fa0ce 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -149,7 +149,7 @@ int ext2fs_inline_data_dir_iterate(ext2_filsys fs, ext2_ino_t ino,
 	/* we first check '.' and '..' dir */
 	dirent.inode = ino;
 	dirent.name_len = 1;
-	ext2fs_set_rec_len(fs, EXT2_DIR_REC_LEN(2), &dirent);
+	ext2fs_set_rec_len(fs, EXT2_DIR_NAME_LEN(2), &dirent);
 	dirent.name[0] = '.';
 	dirent.name[1] = '\0';
 	ctx->buf = (char *)&dirent;
@@ -160,7 +160,7 @@ int ext2fs_inline_data_dir_iterate(ext2_filsys fs, ext2_ino_t ino,
 
 	dirent.inode = ext2fs_le32_to_cpu(inode.i_block[0]);
 	dirent.name_len = 2;
-	ext2fs_set_rec_len(fs, EXT2_DIR_REC_LEN(3), &dirent);
+	ext2fs_set_rec_len(fs, EXT2_DIR_NAME_LEN(3), &dirent);
 	dirent.name[0] = '.';
 	dirent.name[1] = '.';
 	dirent.name[2] = '\0';
@@ -296,14 +296,14 @@ static errcode_t ext2fs_inline_data_convert_dir(ext2_filsys fs, ext2_ino_t ino,
 	ext2fs_dirent_set_name_len(dir, 1);
 	ext2fs_dirent_set_file_type(dir, filetype);
 	dir->name[0] = '.';
-	rec_len = (fs->blocksize - csum_size) - EXT2_DIR_REC_LEN(1);
-	dir->rec_len = EXT2_DIR_REC_LEN(1);
+	rec_len = (fs->blocksize - csum_size) - EXT2_DIR_NAME_LEN(1);
+	dir->rec_len = EXT2_DIR_NAME_LEN(1);
 
 	/*
 	 * Set up entry for '..'
 	 */
 	dir = (struct ext2_dir_entry *) (bbuf + dir->rec_len);
-	dir->rec_len = EXT2_DIR_REC_LEN(2);
+	dir->rec_len = EXT2_DIR_NAME_LEN(2);
 	dir->inode = ext2fs_le32_to_cpu(((__u32 *)ibuf)[0]);
 	ext2fs_dirent_set_name_len(dir, 2);
 	ext2fs_dirent_set_file_type(dir, filetype);
@@ -313,11 +313,11 @@ static errcode_t ext2fs_inline_data_convert_dir(ext2_filsys fs, ext2_ino_t ino,
 	/*
 	 * Adjust the last rec_len
 	 */
-	offset = EXT2_DIR_REC_LEN(1) + EXT2_DIR_REC_LEN(2);
+	offset = EXT2_DIR_NAME_LEN(1) + EXT2_DIR_NAME_LEN(2);
 	dir = (struct ext2_dir_entry *) (bbuf + offset);
 	memcpy(bbuf + offset, ibuf + EXT4_INLINE_DATA_DOTDOT_SIZE,
 	       size - EXT4_INLINE_DATA_DOTDOT_SIZE);
-	size += EXT2_DIR_REC_LEN(1) + EXT2_DIR_REC_LEN(2) -
+	size += EXT2_DIR_NAME_LEN(1) + EXT2_DIR_NAME_LEN(2) -
 		EXT4_INLINE_DATA_DOTDOT_SIZE;
 
 	do {
diff --git a/lib/ext2fs/lfsck.h b/lib/ext2fs/lfsck.h
new file mode 100644
index 000000000..78f5bb132
--- /dev/null
+++ b/lib/ext2fs/lfsck.h
@@ -0,0 +1,60 @@
+#ifndef LFSCK_H
+#define LFSCK_H
+
+/* This is unfortunately needed for older lustre_user.h to be usable */
+#define LASSERT(cond)		do { } while (0)
+
+#ifdef HAVE_LUSTRE_LUSTREAPI_H
+#include <lustre/lustreapi.h>
+#elif HAVE_LUSTRE_LIBLUSTREAPI_H
+#include <lustre/liblustreapi.h>
+#endif
+
+#ifndef DFID
+#define DFID "[%#llx:0x%x:0x%x]"
+#define PFID(fid) (unsigned long long)fid_seq(fid), fid_oid(fid), fid_ver(fid)
+struct lu_fid {
+	__u64   f_seq;
+	__u32   f_oid;
+	__u32   f_ver;
+};
+#endif /* !DFID */
+
+/* If Lustre headers are not available provide a minimum set of definitions
+ * here for compatibility */
+#ifndef HAVE_LUSTRE_LUSTRE_IDL_H
+#define fid_seq(fid) ((fid)->f_seq)
+#define fid_oid(fid) ((fid)->f_oid)
+#define fid_ver(fid) ((fid)->f_ver)
+
+static inline void fid_be_to_cpu(struct lu_fid *dst, struct lu_fid *src)
+{
+	dst->f_seq = ext2fs_be64_to_cpu(src->f_seq);
+	dst->f_oid = ext2fs_be32_to_cpu(src->f_oid);
+	dst->f_ver = ext2fs_be32_to_cpu(src->f_ver);
+}
+#endif
+
+struct ext4_dir_entry_hash {
+        __le32 hash;
+        __le32 minor_hash;
+};
+
+struct ext4_dirent_data_header {
+	/* length of this header + the whole data blob */
+	__u8    ddh_length;
+};
+
+struct ext4_dirent_hash {
+	struct ext4_dirent_data_header  dh_header;
+	struct ext4_dir_entry_hash      dh_hash;
+};
+
+
+static inline void hash_le_to_cpu(struct ext4_dirent_hash *dst,
+				  struct ext4_dirent_hash *src) {
+
+	dst->dh_hash.hash = ext2fs_le32_to_cpu(dst->dh_hash.hash);
+	dst->dh_hash.hash = ext2fs_le32_to_cpu(dst->dh_hash.minor_hash);
+}
+#endif /* LFSCK_H */
diff --git a/lib/ext2fs/link.c b/lib/ext2fs/link.c
index 1697da39f..615a24fe4 100644
--- a/lib/ext2fs/link.c
+++ b/lib/ext2fs/link.c
@@ -197,7 +197,7 @@ static int link_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
 	if (ls->done)
 		return DIRENT_ABORT;
 
-	rec_len = EXT2_DIR_REC_LEN(ls->namelen);
+	rec_len = EXT2_DIR_NAME_LEN(ls->namelen);
 
 	ls->err = ext2fs_get_rec_len(ls->fs, dirent, &curr_rec_len);
 	if (ls->err)
@@ -226,7 +226,7 @@ static int link_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
 	 * truncate it and return.
 	 */
 	if (dirent->inode) {
-		min_rec_len = EXT2_DIR_REC_LEN(ext2fs_dirent_name_len(dirent));
+		min_rec_len = EXT2_DIR_REC_LEN(dirent);
 		if (curr_rec_len < (min_rec_len + rec_len))
 			return ret;
 		rec_len = curr_rec_len - min_rec_len;
@@ -254,8 +254,7 @@ static int link_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
 	ext2fs_dirent_set_name_len(dirent, ls->namelen);
 	strncpy(dirent->name, ls->name, ls->namelen);
 	if (ext2fs_has_feature_filetype(ls->sb))
-		ext2fs_dirent_set_file_type(dirent,
-					    ls->flags & EXT2FS_LINK_FT_MASK);
+		ext2fs_dirent_set_file_type(dirent, ls->flags & EXT2_FT_MASK);
 
 	ls->done++;
 	return DIRENT_ABORT|DIRENT_CHANGED;
@@ -331,8 +330,8 @@ static errcode_t dx_move_dirents(ext2_filsys fs, struct dx_hash_map *map,
 		csum_size = sizeof(struct ext2_dir_entry_tail);
 
 	for (i = 0; i < count; i++) {
-		de = (struct ext2_dir_entry *) ((char *)from + map[i].off);
-		rec_len = EXT2_DIR_REC_LEN(ext2fs_dirent_name_len(de));
+		de = from + map[i].off;
+		rec_len = EXT2_DIR_REC_LEN(de);
 		memcpy(to, de, rec_len);
 		retval = ext2fs_set_rec_len(fs, rec_len, to);
 		if (retval)
diff --git a/lib/ext2fs/newdir.c b/lib/ext2fs/newdir.c
index 7f4728500..f168d6686 100644
--- a/lib/ext2fs/newdir.c
+++ b/lib/ext2fs/newdir.c
@@ -64,8 +64,8 @@ errcode_t ext2fs_new_dir_block(ext2_filsys fs, ext2_ino_t dir_ino,
 		ext2fs_dirent_set_name_len(dir, 1);
 		ext2fs_dirent_set_file_type(dir, filetype);
 		dir->name[0] = '.';
-		rec_len = (fs->blocksize - csum_size) - EXT2_DIR_REC_LEN(1);
-		dir->rec_len = EXT2_DIR_REC_LEN(1);
+		rec_len = (fs->blocksize - csum_size) - EXT2_DIR_NAME_LEN(1);
+		dir->rec_len = EXT2_DIR_NAME_LEN(1);
 
 		/*
 		 * Set up entry for '..'
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 7f81a5137..f01b31599 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1232,6 +1232,7 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_INCOMPAT_FLEX_BG|
 		EXT4_FEATURE_INCOMPAT_EA_INODE|
 		EXT4_FEATURE_INCOMPAT_MMP |
+		EXT4_FEATURE_INCOMPAT_DIRDATA|
 		EXT4_FEATURE_INCOMPAT_64BIT|
 		EXT4_FEATURE_INCOMPAT_INLINE_DATA|
 		EXT4_FEATURE_INCOMPAT_ENCRYPT |
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 3db57632c..3b7a0272f 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -192,6 +192,7 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
 		EXT4_FEATURE_INCOMPAT_EA_INODE|
 		EXT4_FEATURE_INCOMPAT_MMP |
+		EXT4_FEATURE_INCOMPAT_DIRDATA |
 		EXT4_FEATURE_INCOMPAT_64BIT |
 		EXT4_FEATURE_INCOMPAT_ENCRYPT |
 		EXT4_FEATURE_INCOMPAT_CSUM_SEED |
@@ -222,6 +223,7 @@ static __u32 clear_ok_features[3] = {
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
 		EXT4_FEATURE_INCOMPAT_MMP |
+		EXT4_FEATURE_INCOMPAT_DIRDATA |
 		EXT4_FEATURE_INCOMPAT_64BIT |
 		EXT4_FEATURE_INCOMPAT_CSUM_SEED |
 		EXT4_FEATURE_INCOMPAT_CASEFOLD,
@@ -1604,6 +1606,11 @@ mmp_error:
 	}
 
 	if (FEATURE_ON(E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_CASEFOLD)) {
+		if (ext2fs_has_feature_dirdata(sb)) {
+			fputs(_("Can not enable casefold feature on "
+				"filesystem has dirdata.\n"), stderr);
+			return 1;
+		}
 		if (mount_flags & EXT2_MF_MOUNTED) {
 			fputs(_("The casefold feature may only be enabled when "
 				"the filesystem is unmounted.\n"), stderr);
diff --git a/tests/f_dir_optimize/expect.1 b/tests/f_dir_optimize/expect.1
new file mode 100644
index 000000000..4457fa783
--- /dev/null
+++ b/tests/f_dir_optimize/expect.1
@@ -0,0 +1,511 @@
+
+     94   40755 (18)      0      0    4096 25-Aug-2012 06:09 fid:[0x5e:0xf6d09ca7:0x0] ..
+    105   40755 (18)      0      0   36864 25-Aug-2012 06:09 fid:[0x200000400:0x1:0x0] .
+    106  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x2:0x0] file0
+    107  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x3:0x0] file1
+    108  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x4:0x0] file2
+    109  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x5:0x0] file3
+    110  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x6:0x0] file4
+    111  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x7:0x0] file5
+    112  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x8:0x0] file6
+    113  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x9:0x0] file7
+    114  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xa:0x0] file8
+    115  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xb:0x0] file9
+    116  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xc:0x0] file10
+    117  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xd:0x0] file11
+    118  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xe:0x0] file12
+    119  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xf:0x0] file13
+    120  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x10:0x0] file14
+    121  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x11:0x0] file15
+    122  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x12:0x0] file16
+    123  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x13:0x0] file17
+    124  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x14:0x0] file18
+    125  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x15:0x0] file19
+    126  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x16:0x0] file20
+    127  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x17:0x0] file21
+    128  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x18:0x0] file22
+    129  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x19:0x0] file23
+    130  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1a:0x0] file24
+    131  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1b:0x0] file25
+    132  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1c:0x0] file26
+    133  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1d:0x0] file27
+    134  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1e:0x0] file28
+    135  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1f:0x0] file29
+    136  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x20:0x0] file30
+    137  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x21:0x0] file31
+    138  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x22:0x0] file32
+    139  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x23:0x0] file33
+    140  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x24:0x0] file34
+    141  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x25:0x0] file35
+    142  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x26:0x0] file36
+    143  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x27:0x0] file37
+    144  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x28:0x0] file38
+    145  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x29:0x0] file39
+    146  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x2a:0x0] file40
+    147  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x2b:0x0] file41
+    148  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x2c:0x0] file42
+    149  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x2d:0x0] file43
+    150  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x2e:0x0] file44
+    151  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x2f:0x0] file45
+    152  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x30:0x0] file46
+    153  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x31:0x0] file47
+    154  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x32:0x0] file48
+    155  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x33:0x0] file49
+    156  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x34:0x0] file50
+    157  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x35:0x0] file51
+    158  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x36:0x0] file52
+    159  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x37:0x0] file53
+    160  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x38:0x0] file54
+    161  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x39:0x0] file55
+    162  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x3a:0x0] file56
+    163  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x3b:0x0] file57
+    164  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x3c:0x0] file58
+    165  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x3d:0x0] file59
+    166  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x3e:0x0] file60
+    167  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x3f:0x0] file61
+    168  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x40:0x0] file62
+    169  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x41:0x0] file63
+    170  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x42:0x0] file64
+    171  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x43:0x0] file65
+    172  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x44:0x0] file66
+    173  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x45:0x0] file67
+    174  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x46:0x0] file68
+    175  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x47:0x0] file69
+    176  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x48:0x0] file70
+    177  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x49:0x0] file71
+    178  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x4a:0x0] file72
+    179  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x4b:0x0] file73
+    180  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x4c:0x0] file74
+    181  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x4d:0x0] file75
+    182  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x4e:0x0] file76
+    183  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x4f:0x0] file77
+    184  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x50:0x0] file78
+    185  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x51:0x0] file79
+    186  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x52:0x0] file80
+    187  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x53:0x0] file81
+    188  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x54:0x0] file82
+    189  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x55:0x0] file83
+    190  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x56:0x0] file84
+    191  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x57:0x0] file85
+    192  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x58:0x0] file86
+    193  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x59:0x0] file87
+    194  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x5a:0x0] file88
+    195  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x5b:0x0] file89
+    196  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x5c:0x0] file90
+    197  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x5d:0x0] file91
+    198  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x5e:0x0] file92
+    199  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x5f:0x0] file93
+    200  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x60:0x0] file94
+    201  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x61:0x0] file95
+    202  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x62:0x0] file96
+    203  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x63:0x0] file97
+    204  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x64:0x0] file98
+    205  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x65:0x0] file99
+    206  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x66:0x0] file100
+    207  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x67:0x0] file101
+    208  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x68:0x0] file102
+    209  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x69:0x0] file103
+    210  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x6a:0x0] file104
+    211  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x6b:0x0] file105
+    212  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x6c:0x0] file106
+    213  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x6d:0x0] file107
+    214  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x6e:0x0] file108
+    215  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x6f:0x0] file109
+    216  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x70:0x0] file110
+    217  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x71:0x0] file111
+    218  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x72:0x0] file112
+    219  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x73:0x0] file113
+    220  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x74:0x0] file114
+    221  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x75:0x0] file115
+    222  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x76:0x0] file116
+    223  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x77:0x0] file117
+    224  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x78:0x0] file118
+    225  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x79:0x0] file119
+    226  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x7a:0x0] file120
+    227  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x7b:0x0] file121
+    228  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x7c:0x0] file122
+    229  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x7d:0x0] file123
+    230  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x7e:0x0] file124
+    231  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x7f:0x0] file125
+    232  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x80:0x0] file126
+    233  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x81:0x0] file127
+    234  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x82:0x0] file128
+    235  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x83:0x0] file129
+    236  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x84:0x0] file130
+    237  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x85:0x0] file131
+    238  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x86:0x0] file132
+    239  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x87:0x0] file133
+    240  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x88:0x0] file134
+    241  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x89:0x0] file135
+    242  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x8a:0x0] file136
+    243  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x8b:0x0] file137
+    244  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x8c:0x0] file138
+    245  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x8d:0x0] file139
+    246  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x8e:0x0] file140
+    247  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x8f:0x0] file141
+    248  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x90:0x0] file142
+    249  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x91:0x0] file143
+    250  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x92:0x0] file144
+    251  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x93:0x0] file145
+    252  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x94:0x0] file146
+    253  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x95:0x0] file147
+    254  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x96:0x0] file148
+    255  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x97:0x0] file149
+    256  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x98:0x0] file150
+    257  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x99:0x0] file151
+    258  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x9a:0x0] file152
+    259  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x9b:0x0] file153
+    260  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x9c:0x0] file154
+    261  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x9d:0x0] file155
+    262  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x9e:0x0] file156
+    263  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x9f:0x0] file157
+    264  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xa0:0x0] file158
+    265  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xa1:0x0] file159
+    266  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xa2:0x0] file160
+    267  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xa3:0x0] file161
+    268  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xa4:0x0] file162
+    269  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xa5:0x0] file163
+    270  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xa6:0x0] file164
+    271  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xa7:0x0] file165
+    272  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xa8:0x0] file166
+    273  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xa9:0x0] file167
+    274  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xaa:0x0] file168
+    275  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xab:0x0] file169
+    276  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xac:0x0] file170
+    277  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xad:0x0] file171
+    278  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xae:0x0] file172
+    279  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xaf:0x0] file173
+    280  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xb0:0x0] file174
+    281  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xb1:0x0] file175
+    282  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xb2:0x0] file176
+    283  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xb3:0x0] file177
+    284  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xb4:0x0] file178
+    285  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xb5:0x0] file179
+    286  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xb6:0x0] file180
+    287  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xb7:0x0] file181
+    288  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xb8:0x0] file182
+    289  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xb9:0x0] file183
+    290  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xba:0x0] file184
+    291  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xbb:0x0] file185
+    292  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xbc:0x0] file186
+    293  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xbd:0x0] file187
+    294  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xbe:0x0] file188
+    295  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xbf:0x0] file189
+    296  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xc0:0x0] file190
+    297  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xc1:0x0] file191
+    298  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xc2:0x0] file192
+    299  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xc3:0x0] file193
+    300  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xc4:0x0] file194
+    301  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xc5:0x0] file195
+    302  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xc6:0x0] file196
+    303  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xc7:0x0] file197
+    304  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xc8:0x0] file198
+    305  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xc9:0x0] file199
+    306  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xca:0x0] file200
+    307  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xcb:0x0] file201
+    308  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xcc:0x0] file202
+    309  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xcd:0x0] file203
+    310  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xce:0x0] file204
+    311  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xcf:0x0] file205
+    312  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xd0:0x0] file206
+    313  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xd1:0x0] file207
+    314  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xd2:0x0] file208
+    315  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xd3:0x0] file209
+    316  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xd4:0x0] file210
+    317  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xd5:0x0] file211
+    318  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xd6:0x0] file212
+    319  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xd7:0x0] file213
+    320  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xd8:0x0] file214
+    321  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xd9:0x0] file215
+    322  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xda:0x0] file216
+    323  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xdb:0x0] file217
+    324  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xdc:0x0] file218
+    325  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xdd:0x0] file219
+    326  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xde:0x0] file220
+    327  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xdf:0x0] file221
+    328  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xe0:0x0] file222
+    329  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xe1:0x0] file223
+    330  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xe2:0x0] file224
+    331  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xe3:0x0] file225
+    332  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xe4:0x0] file226
+    333  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xe5:0x0] file227
+    334  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xe6:0x0] file228
+    335  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xe7:0x0] file229
+    336  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xe8:0x0] file230
+    337  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xe9:0x0] file231
+    338  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xea:0x0] file232
+    339  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xeb:0x0] file233
+    340  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xec:0x0] file234
+    341  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xed:0x0] file235
+    342  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xee:0x0] file236
+    343  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xef:0x0] file237
+    344  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xf0:0x0] file238
+    345  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xf1:0x0] file239
+    346  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xf2:0x0] file240
+    347  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xf3:0x0] file241
+    348  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xf4:0x0] file242
+    349  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xf5:0x0] file243
+    350  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xf6:0x0] file244
+    351  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xf7:0x0] file245
+    352  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xf8:0x0] file246
+    353  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xf9:0x0] file247
+    354  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xfa:0x0] file248
+    355  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xfb:0x0] file249
+    356  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xfc:0x0] file250
+    357  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xfd:0x0] file251
+    358  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xfe:0x0] file252
+    359  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xff:0x0] file253
+    360  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x100:0x0] file254
+    361  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x101:0x0] file255
+    362  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x102:0x0] file256
+    363  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x103:0x0] file257
+    364  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x104:0x0] file258
+    365  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x105:0x0] file259
+    366  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x106:0x0] file260
+    367  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x107:0x0] file261
+    368  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x108:0x0] file262
+    369  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x109:0x0] file263
+    370  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x10a:0x0] file264
+    371  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x10b:0x0] file265
+    372  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x10c:0x0] file266
+    373  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x10d:0x0] file267
+    374  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x10e:0x0] file268
+    375  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x10f:0x0] file269
+    376  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x110:0x0] file270
+    377  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x111:0x0] file271
+    378  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x112:0x0] file272
+    379  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x113:0x0] file273
+    380  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x114:0x0] file274
+    381  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x115:0x0] file275
+    382  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x116:0x0] file276
+    383  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x117:0x0] file277
+    384  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x118:0x0] file278
+    385  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x119:0x0] file279
+    386  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x11a:0x0] file280
+    387  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x11b:0x0] file281
+    388  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x11c:0x0] file282
+    389  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x11d:0x0] file283
+    390  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x11e:0x0] file284
+    391  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x11f:0x0] file285
+    392  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x120:0x0] file286
+    393  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x121:0x0] file287
+    394  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x122:0x0] file288
+    395  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x123:0x0] file289
+    396  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x124:0x0] file290
+    397  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x125:0x0] file291
+    398  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x126:0x0] file292
+    399  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x127:0x0] file293
+    400  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x128:0x0] file294
+    401  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x129:0x0] file295
+    402  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x12a:0x0] file296
+    403  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x12b:0x0] file297
+    404  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x12c:0x0] file298
+    405  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x12d:0x0] file299
+    406  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x12e:0x0] file300
+    407  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x12f:0x0] file301
+    408  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x130:0x0] file302
+    409  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x131:0x0] file303
+    410  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x132:0x0] file304
+    411  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x133:0x0] file305
+    412  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x134:0x0] file306
+    413  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x135:0x0] file307
+    414  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x136:0x0] file308
+    415  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x137:0x0] file309
+    416  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x138:0x0] file310
+    417  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x139:0x0] file311
+    418  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x13a:0x0] file312
+    419  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x13b:0x0] file313
+    420  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x13c:0x0] file314
+    421  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x13d:0x0] file315
+    422  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x13e:0x0] file316
+    423  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x13f:0x0] file317
+    424  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x140:0x0] file318
+    425  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x141:0x0] file319
+    426  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x142:0x0] file320
+    427  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x143:0x0] file321
+    428  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x144:0x0] file322
+    429  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x145:0x0] file323
+    430  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x146:0x0] file324
+    431  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x147:0x0] file325
+    432  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x148:0x0] file326
+    433  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x149:0x0] file327
+    434  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x14a:0x0] file328
+    435  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x14b:0x0] file329
+    436  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x14c:0x0] file330
+    437  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x14d:0x0] file331
+    438  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x14e:0x0] file332
+    439  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x14f:0x0] file333
+    440  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x150:0x0] file334
+    441  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x151:0x0] file335
+    442  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x152:0x0] file336
+    443  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x153:0x0] file337
+    444  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x154:0x0] file338
+    445  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x155:0x0] file339
+    446  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x156:0x0] file340
+    447  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x157:0x0] file341
+    448  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x158:0x0] file342
+    449  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x159:0x0] file343
+    450  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x15a:0x0] file344
+    451  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x15b:0x0] file345
+    452  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x15c:0x0] file346
+    453  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x15d:0x0] file347
+    454  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x15e:0x0] file348
+    455  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x15f:0x0] file349
+    456  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x160:0x0] file350
+    457  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x161:0x0] file351
+    458  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x162:0x0] file352
+    459  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x163:0x0] file353
+    460  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x164:0x0] file354
+    461  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x165:0x0] file355
+    462  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x166:0x0] file356
+    463  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x167:0x0] file357
+    464  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x168:0x0] file358
+    465  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x169:0x0] file359
+    466  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x16a:0x0] file360
+    467  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x16b:0x0] file361
+    468  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x16c:0x0] file362
+    469  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x16d:0x0] file363
+    470  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x16e:0x0] file364
+    471  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x16f:0x0] file365
+    472  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x170:0x0] file366
+    473  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x171:0x0] file367
+    474  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x172:0x0] file368
+    475  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x173:0x0] file369
+    476  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x174:0x0] file370
+    477  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x175:0x0] file371
+    478  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x176:0x0] file372
+    479  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x177:0x0] file373
+    480  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x178:0x0] file374
+    481  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x179:0x0] file375
+    482  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x17a:0x0] file376
+    483  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x17b:0x0] file377
+    484  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x17c:0x0] file378
+    485  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x17d:0x0] file379
+    486  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x17e:0x0] file380
+    487  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x17f:0x0] file381
+    488  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x180:0x0] file382
+    489  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x181:0x0] file383
+    490  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x182:0x0] file384
+    491  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x183:0x0] file385
+    492  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x184:0x0] file386
+    493  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x185:0x0] file387
+    494  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x186:0x0] file388
+    495  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x187:0x0] file389
+    496  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x188:0x0] file390
+    497  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x189:0x0] file391
+    498  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x18a:0x0] file392
+    499  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x18b:0x0] file393
+    500  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x18c:0x0] file394
+    501  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x18d:0x0] file395
+    502  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x18e:0x0] file396
+    503  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x18f:0x0] file397
+    504  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x190:0x0] file398
+    505  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x191:0x0] file399
+    506  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x192:0x0] file400
+    507  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x193:0x0] file401
+    508  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x194:0x0] file402
+    509  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x195:0x0] file403
+    510  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x196:0x0] file404
+    511  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x197:0x0] file405
+    512  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x198:0x0] file406
+    513  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x199:0x0] file407
+    514  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x19a:0x0] file408
+    515  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x19b:0x0] file409
+    516  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x19c:0x0] file410
+    517  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x19d:0x0] file411
+    518  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x19e:0x0] file412
+    519  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x19f:0x0] file413
+    520  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1a0:0x0] file414
+    521  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1a1:0x0] file415
+    522  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1a2:0x0] file416
+    523  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1a3:0x0] file417
+    524  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1a4:0x0] file418
+    525  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1a5:0x0] file419
+    526  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1a6:0x0] file420
+    527  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1a7:0x0] file421
+    528  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1a8:0x0] file422
+    529  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1a9:0x0] file423
+    530  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1aa:0x0] file424
+    531  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1ab:0x0] file425
+    532  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1ac:0x0] file426
+    533  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1ad:0x0] file427
+    534  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1ae:0x0] file428
+    535  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1af:0x0] file429
+    536  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1b0:0x0] file430
+    537  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1b1:0x0] file431
+    538  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1b2:0x0] file432
+    539  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1b3:0x0] file433
+    540  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1b4:0x0] file434
+    541  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1b5:0x0] file435
+    542  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1b6:0x0] file436
+    543  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1b7:0x0] file437
+    544  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1b8:0x0] file438
+    545  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1b9:0x0] file439
+    546  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1ba:0x0] file440
+    547  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1bb:0x0] file441
+    548  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1bc:0x0] file442
+    549  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1bd:0x0] file443
+    550  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1be:0x0] file444
+    551  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1bf:0x0] file445
+    552  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1c0:0x0] file446
+    553  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1c1:0x0] file447
+    554  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1c2:0x0] file448
+    555  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1c3:0x0] file449
+    556  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1c4:0x0] file450
+    557  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1c5:0x0] file451
+    558  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1c6:0x0] file452
+    559  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1c7:0x0] file453
+    560  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1c8:0x0] file454
+    561  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1c9:0x0] file455
+    562  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1ca:0x0] file456
+    563  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1cb:0x0] file457
+    564  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1cc:0x0] file458
+    565  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1cd:0x0] file459
+    566  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1ce:0x0] file460
+    567  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1cf:0x0] file461
+    568  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1d0:0x0] file462
+    569  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1d1:0x0] file463
+    570  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1d2:0x0] file464
+    571  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1d3:0x0] file465
+    572  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1d4:0x0] file466
+    573  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1d5:0x0] file467
+    574  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1d6:0x0] file468
+    575  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1d7:0x0] file469
+    576  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1d8:0x0] file470
+    577  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1d9:0x0] file471
+    578  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1da:0x0] file472
+    579  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1db:0x0] file473
+    580  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1dc:0x0] file474
+    581  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1dd:0x0] file475
+    582  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1de:0x0] file476
+    583  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1df:0x0] file477
+    584  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1e0:0x0] file478
+    585  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1e1:0x0] file479
+    586  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1e2:0x0] file480
+    587  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1e3:0x0] file481
+    588  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1e4:0x0] file482
+    589  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1e5:0x0] file483
+    590  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1e6:0x0] file484
+    591  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1e7:0x0] file485
+    592  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1e8:0x0] file486
+    593  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1e9:0x0] file487
+    594  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1ea:0x0] file488
+    595  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1eb:0x0] file489
+    596  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1ec:0x0] file490
+    597  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1ed:0x0] file491
+    598  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1ee:0x0] file492
+    599  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1ef:0x0] file493
+    600  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1f0:0x0] file494
+    601  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1f1:0x0] file495
+    602  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1f2:0x0] file496
+    603  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1f3:0x0] file497
+    604  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1f4:0x0] file498
+    605  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1f5:0x0] file499
+    606  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1f6:0x0] file500
+    607  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1f7:0x0] file501
+    608  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1f8:0x0] file502
+    609  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1f9:0x0] file503
+    610  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1fa:0x0] file504
+    611  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1fb:0x0] file505
+    612  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1fc:0x0] file506
+    613  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1fd:0x0] file507
diff --git a/tests/f_dir_optimize/expect.2 b/tests/f_dir_optimize/expect.2
new file mode 100644
index 000000000..3649a36e5
--- /dev/null
+++ b/tests/f_dir_optimize/expect.2
@@ -0,0 +1,511 @@
+
+     94   40755 (18)      0      0    4096 25-Aug-2012 06:09 fid:[0x5e:0xf6d09ca7:0x0] ..
+    105   40755 (18)      0      0   28672 25-Aug-2012 06:09 fid:[0x200000400:0x1:0x0] .
+    106  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x2:0x0] file0
+    107  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x3:0x0] file1
+    108  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x4:0x0] file2
+    109  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x5:0x0] file3
+    110  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x6:0x0] file4
+    111  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x7:0x0] file5
+    112  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x8:0x0] file6
+    113  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x9:0x0] file7
+    114  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xa:0x0] file8
+    115  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xb:0x0] file9
+    116  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xc:0x0] file10
+    117  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xd:0x0] file11
+    118  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xe:0x0] file12
+    119  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xf:0x0] file13
+    120  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x10:0x0] file14
+    121  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x11:0x0] file15
+    122  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x12:0x0] file16
+    123  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x13:0x0] file17
+    124  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x14:0x0] file18
+    125  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x15:0x0] file19
+    126  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x16:0x0] file20
+    127  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x17:0x0] file21
+    128  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x18:0x0] file22
+    129  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x19:0x0] file23
+    130  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1a:0x0] file24
+    131  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1b:0x0] file25
+    132  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1c:0x0] file26
+    133  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1d:0x0] file27
+    134  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1e:0x0] file28
+    135  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1f:0x0] file29
+    136  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x20:0x0] file30
+    137  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x21:0x0] file31
+    138  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x22:0x0] file32
+    139  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x23:0x0] file33
+    140  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x24:0x0] file34
+    141  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x25:0x0] file35
+    142  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x26:0x0] file36
+    143  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x27:0x0] file37
+    144  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x28:0x0] file38
+    145  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x29:0x0] file39
+    146  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x2a:0x0] file40
+    147  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x2b:0x0] file41
+    148  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x2c:0x0] file42
+    149  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x2d:0x0] file43
+    150  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x2e:0x0] file44
+    151  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x2f:0x0] file45
+    152  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x30:0x0] file46
+    153  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x31:0x0] file47
+    154  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x32:0x0] file48
+    155  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x33:0x0] file49
+    156  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x34:0x0] file50
+    157  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x35:0x0] file51
+    158  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x36:0x0] file52
+    159  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x37:0x0] file53
+    160  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x38:0x0] file54
+    161  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x39:0x0] file55
+    162  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x3a:0x0] file56
+    163  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x3b:0x0] file57
+    164  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x3c:0x0] file58
+    165  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x3d:0x0] file59
+    166  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x3e:0x0] file60
+    167  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x3f:0x0] file61
+    168  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x40:0x0] file62
+    169  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x41:0x0] file63
+    170  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x42:0x0] file64
+    171  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x43:0x0] file65
+    172  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x44:0x0] file66
+    173  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x45:0x0] file67
+    174  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x46:0x0] file68
+    175  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x47:0x0] file69
+    176  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x48:0x0] file70
+    177  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x49:0x0] file71
+    178  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x4a:0x0] file72
+    179  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x4b:0x0] file73
+    180  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x4c:0x0] file74
+    181  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x4d:0x0] file75
+    182  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x4e:0x0] file76
+    183  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x4f:0x0] file77
+    184  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x50:0x0] file78
+    185  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x51:0x0] file79
+    186  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x52:0x0] file80
+    187  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x53:0x0] file81
+    188  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x54:0x0] file82
+    189  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x55:0x0] file83
+    190  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x56:0x0] file84
+    191  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x57:0x0] file85
+    192  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x58:0x0] file86
+    193  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x59:0x0] file87
+    194  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x5a:0x0] file88
+    195  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x5b:0x0] file89
+    196  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x5c:0x0] file90
+    197  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x5d:0x0] file91
+    198  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x5e:0x0] file92
+    199  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x5f:0x0] file93
+    200  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x60:0x0] file94
+    201  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x61:0x0] file95
+    202  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x62:0x0] file96
+    203  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x63:0x0] file97
+    204  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x64:0x0] file98
+    205  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x65:0x0] file99
+    206  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x66:0x0] file100
+    207  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x67:0x0] file101
+    208  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x68:0x0] file102
+    209  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x69:0x0] file103
+    210  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x6a:0x0] file104
+    211  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x6b:0x0] file105
+    212  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x6c:0x0] file106
+    213  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x6d:0x0] file107
+    214  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x6e:0x0] file108
+    215  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x6f:0x0] file109
+    216  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x70:0x0] file110
+    217  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x71:0x0] file111
+    218  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x72:0x0] file112
+    219  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x73:0x0] file113
+    220  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x74:0x0] file114
+    221  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x75:0x0] file115
+    222  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x76:0x0] file116
+    223  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x77:0x0] file117
+    224  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x78:0x0] file118
+    225  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x79:0x0] file119
+    226  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x7a:0x0] file120
+    227  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x7b:0x0] file121
+    228  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x7c:0x0] file122
+    229  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x7d:0x0] file123
+    230  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x7e:0x0] file124
+    231  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x7f:0x0] file125
+    232  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x80:0x0] file126
+    233  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x81:0x0] file127
+    234  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x82:0x0] file128
+    235  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x83:0x0] file129
+    236  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x84:0x0] file130
+    237  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x85:0x0] file131
+    238  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x86:0x0] file132
+    239  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x87:0x0] file133
+    240  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x88:0x0] file134
+    241  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x89:0x0] file135
+    242  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x8a:0x0] file136
+    243  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x8b:0x0] file137
+    244  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x8c:0x0] file138
+    245  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x8d:0x0] file139
+    246  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x8e:0x0] file140
+    247  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x8f:0x0] file141
+    248  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x90:0x0] file142
+    249  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x91:0x0] file143
+    250  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x92:0x0] file144
+    251  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x93:0x0] file145
+    252  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x94:0x0] file146
+    253  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x95:0x0] file147
+    254  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x96:0x0] file148
+    255  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x97:0x0] file149
+    256  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x98:0x0] file150
+    257  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x99:0x0] file151
+    258  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x9a:0x0] file152
+    259  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x9b:0x0] file153
+    260  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x9c:0x0] file154
+    261  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x9d:0x0] file155
+    262  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x9e:0x0] file156
+    263  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x9f:0x0] file157
+    264  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xa0:0x0] file158
+    265  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xa1:0x0] file159
+    266  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xa2:0x0] file160
+    267  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xa3:0x0] file161
+    268  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xa4:0x0] file162
+    269  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xa5:0x0] file163
+    270  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xa6:0x0] file164
+    271  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xa7:0x0] file165
+    272  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xa8:0x0] file166
+    273  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xa9:0x0] file167
+    274  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xaa:0x0] file168
+    275  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xab:0x0] file169
+    276  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xac:0x0] file170
+    277  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xad:0x0] file171
+    278  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xae:0x0] file172
+    279  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xaf:0x0] file173
+    280  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xb0:0x0] file174
+    281  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xb1:0x0] file175
+    282  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xb2:0x0] file176
+    283  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xb3:0x0] file177
+    284  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xb4:0x0] file178
+    285  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xb5:0x0] file179
+    286  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xb6:0x0] file180
+    287  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xb7:0x0] file181
+    288  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xb8:0x0] file182
+    289  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xb9:0x0] file183
+    290  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xba:0x0] file184
+    291  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xbb:0x0] file185
+    292  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xbc:0x0] file186
+    293  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xbd:0x0] file187
+    294  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xbe:0x0] file188
+    295  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xbf:0x0] file189
+    296  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xc0:0x0] file190
+    297  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xc1:0x0] file191
+    298  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xc2:0x0] file192
+    299  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xc3:0x0] file193
+    300  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xc4:0x0] file194
+    301  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xc5:0x0] file195
+    302  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xc6:0x0] file196
+    303  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xc7:0x0] file197
+    304  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xc8:0x0] file198
+    305  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xc9:0x0] file199
+    306  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xca:0x0] file200
+    307  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xcb:0x0] file201
+    308  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xcc:0x0] file202
+    309  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xcd:0x0] file203
+    310  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xce:0x0] file204
+    311  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xcf:0x0] file205
+    312  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xd0:0x0] file206
+    313  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xd1:0x0] file207
+    314  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xd2:0x0] file208
+    315  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xd3:0x0] file209
+    316  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xd4:0x0] file210
+    317  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xd5:0x0] file211
+    318  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xd6:0x0] file212
+    319  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xd7:0x0] file213
+    320  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xd8:0x0] file214
+    321  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xd9:0x0] file215
+    322  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xda:0x0] file216
+    323  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xdb:0x0] file217
+    324  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xdc:0x0] file218
+    325  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xdd:0x0] file219
+    326  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xde:0x0] file220
+    327  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xdf:0x0] file221
+    328  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xe0:0x0] file222
+    329  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xe1:0x0] file223
+    330  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xe2:0x0] file224
+    331  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xe3:0x0] file225
+    332  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xe4:0x0] file226
+    333  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xe5:0x0] file227
+    334  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xe6:0x0] file228
+    335  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xe7:0x0] file229
+    336  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xe8:0x0] file230
+    337  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xe9:0x0] file231
+    338  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xea:0x0] file232
+    339  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xeb:0x0] file233
+    340  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xec:0x0] file234
+    341  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xed:0x0] file235
+    342  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xee:0x0] file236
+    343  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xef:0x0] file237
+    344  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xf0:0x0] file238
+    345  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xf1:0x0] file239
+    346  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xf2:0x0] file240
+    347  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xf3:0x0] file241
+    348  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xf4:0x0] file242
+    349  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xf5:0x0] file243
+    350  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xf6:0x0] file244
+    351  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xf7:0x0] file245
+    352  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xf8:0x0] file246
+    353  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xf9:0x0] file247
+    354  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xfa:0x0] file248
+    355  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xfb:0x0] file249
+    356  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xfc:0x0] file250
+    357  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xfd:0x0] file251
+    358  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xfe:0x0] file252
+    359  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0xff:0x0] file253
+    360  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x100:0x0] file254
+    361  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x101:0x0] file255
+    362  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x102:0x0] file256
+    363  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x103:0x0] file257
+    364  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x104:0x0] file258
+    365  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x105:0x0] file259
+    366  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x106:0x0] file260
+    367  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x107:0x0] file261
+    368  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x108:0x0] file262
+    369  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x109:0x0] file263
+    370  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x10a:0x0] file264
+    371  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x10b:0x0] file265
+    372  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x10c:0x0] file266
+    373  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x10d:0x0] file267
+    374  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x10e:0x0] file268
+    375  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x10f:0x0] file269
+    376  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x110:0x0] file270
+    377  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x111:0x0] file271
+    378  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x112:0x0] file272
+    379  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x113:0x0] file273
+    380  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x114:0x0] file274
+    381  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x115:0x0] file275
+    382  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x116:0x0] file276
+    383  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x117:0x0] file277
+    384  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x118:0x0] file278
+    385  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x119:0x0] file279
+    386  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x11a:0x0] file280
+    387  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x11b:0x0] file281
+    388  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x11c:0x0] file282
+    389  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x11d:0x0] file283
+    390  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x11e:0x0] file284
+    391  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x11f:0x0] file285
+    392  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x120:0x0] file286
+    393  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x121:0x0] file287
+    394  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x122:0x0] file288
+    395  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x123:0x0] file289
+    396  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x124:0x0] file290
+    397  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x125:0x0] file291
+    398  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x126:0x0] file292
+    399  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x127:0x0] file293
+    400  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x128:0x0] file294
+    401  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x129:0x0] file295
+    402  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x12a:0x0] file296
+    403  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x12b:0x0] file297
+    404  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x12c:0x0] file298
+    405  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x12d:0x0] file299
+    406  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x12e:0x0] file300
+    407  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x12f:0x0] file301
+    408  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x130:0x0] file302
+    409  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x131:0x0] file303
+    410  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x132:0x0] file304
+    411  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x133:0x0] file305
+    412  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x134:0x0] file306
+    413  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x135:0x0] file307
+    414  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x136:0x0] file308
+    415  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x137:0x0] file309
+    416  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x138:0x0] file310
+    417  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x139:0x0] file311
+    418  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x13a:0x0] file312
+    419  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x13b:0x0] file313
+    420  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x13c:0x0] file314
+    421  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x13d:0x0] file315
+    422  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x13e:0x0] file316
+    423  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x13f:0x0] file317
+    424  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x140:0x0] file318
+    425  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x141:0x0] file319
+    426  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x142:0x0] file320
+    427  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x143:0x0] file321
+    428  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x144:0x0] file322
+    429  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x145:0x0] file323
+    430  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x146:0x0] file324
+    431  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x147:0x0] file325
+    432  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x148:0x0] file326
+    433  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x149:0x0] file327
+    434  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x14a:0x0] file328
+    435  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x14b:0x0] file329
+    436  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x14c:0x0] file330
+    437  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x14d:0x0] file331
+    438  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x14e:0x0] file332
+    439  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x14f:0x0] file333
+    440  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x150:0x0] file334
+    441  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x151:0x0] file335
+    442  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x152:0x0] file336
+    443  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x153:0x0] file337
+    444  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x154:0x0] file338
+    445  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x155:0x0] file339
+    446  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x156:0x0] file340
+    447  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x157:0x0] file341
+    448  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x158:0x0] file342
+    449  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x159:0x0] file343
+    450  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x15a:0x0] file344
+    451  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x15b:0x0] file345
+    452  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x15c:0x0] file346
+    453  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x15d:0x0] file347
+    454  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x15e:0x0] file348
+    455  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x15f:0x0] file349
+    456  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x160:0x0] file350
+    457  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x161:0x0] file351
+    458  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x162:0x0] file352
+    459  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x163:0x0] file353
+    460  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x164:0x0] file354
+    461  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x165:0x0] file355
+    462  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x166:0x0] file356
+    463  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x167:0x0] file357
+    464  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x168:0x0] file358
+    465  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x169:0x0] file359
+    466  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x16a:0x0] file360
+    467  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x16b:0x0] file361
+    468  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x16c:0x0] file362
+    469  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x16d:0x0] file363
+    470  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x16e:0x0] file364
+    471  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x16f:0x0] file365
+    472  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x170:0x0] file366
+    473  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x171:0x0] file367
+    474  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x172:0x0] file368
+    475  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x173:0x0] file369
+    476  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x174:0x0] file370
+    477  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x175:0x0] file371
+    478  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x176:0x0] file372
+    479  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x177:0x0] file373
+    480  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x178:0x0] file374
+    481  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x179:0x0] file375
+    482  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x17a:0x0] file376
+    483  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x17b:0x0] file377
+    484  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x17c:0x0] file378
+    485  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x17d:0x0] file379
+    486  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x17e:0x0] file380
+    487  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x17f:0x0] file381
+    488  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x180:0x0] file382
+    489  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x181:0x0] file383
+    490  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x182:0x0] file384
+    491  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x183:0x0] file385
+    492  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x184:0x0] file386
+    493  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x185:0x0] file387
+    494  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x186:0x0] file388
+    495  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x187:0x0] file389
+    496  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x188:0x0] file390
+    497  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x189:0x0] file391
+    498  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x18a:0x0] file392
+    499  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x18b:0x0] file393
+    500  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x18c:0x0] file394
+    501  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x18d:0x0] file395
+    502  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x18e:0x0] file396
+    503  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x18f:0x0] file397
+    504  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x190:0x0] file398
+    505  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x191:0x0] file399
+    506  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x192:0x0] file400
+    507  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x193:0x0] file401
+    508  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x194:0x0] file402
+    509  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x195:0x0] file403
+    510  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x196:0x0] file404
+    511  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x197:0x0] file405
+    512  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x198:0x0] file406
+    513  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x199:0x0] file407
+    514  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x19a:0x0] file408
+    515  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x19b:0x0] file409
+    516  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x19c:0x0] file410
+    517  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x19d:0x0] file411
+    518  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x19e:0x0] file412
+    519  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x19f:0x0] file413
+    520  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1a0:0x0] file414
+    521  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1a1:0x0] file415
+    522  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1a2:0x0] file416
+    523  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1a3:0x0] file417
+    524  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1a4:0x0] file418
+    525  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1a5:0x0] file419
+    526  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1a6:0x0] file420
+    527  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1a7:0x0] file421
+    528  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1a8:0x0] file422
+    529  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1a9:0x0] file423
+    530  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1aa:0x0] file424
+    531  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1ab:0x0] file425
+    532  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1ac:0x0] file426
+    533  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1ad:0x0] file427
+    534  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1ae:0x0] file428
+    535  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1af:0x0] file429
+    536  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1b0:0x0] file430
+    537  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1b1:0x0] file431
+    538  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1b2:0x0] file432
+    539  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1b3:0x0] file433
+    540  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1b4:0x0] file434
+    541  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1b5:0x0] file435
+    542  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1b6:0x0] file436
+    543  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1b7:0x0] file437
+    544  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1b8:0x0] file438
+    545  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1b9:0x0] file439
+    546  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1ba:0x0] file440
+    547  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1bb:0x0] file441
+    548  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1bc:0x0] file442
+    549  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1bd:0x0] file443
+    550  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1be:0x0] file444
+    551  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1bf:0x0] file445
+    552  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1c0:0x0] file446
+    553  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1c1:0x0] file447
+    554  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1c2:0x0] file448
+    555  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1c3:0x0] file449
+    556  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1c4:0x0] file450
+    557  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1c5:0x0] file451
+    558  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1c6:0x0] file452
+    559  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1c7:0x0] file453
+    560  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1c8:0x0] file454
+    561  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1c9:0x0] file455
+    562  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1ca:0x0] file456
+    563  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1cb:0x0] file457
+    564  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1cc:0x0] file458
+    565  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1cd:0x0] file459
+    566  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1ce:0x0] file460
+    567  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1cf:0x0] file461
+    568  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1d0:0x0] file462
+    569  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1d1:0x0] file463
+    570  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1d2:0x0] file464
+    571  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1d3:0x0] file465
+    572  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1d4:0x0] file466
+    573  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1d5:0x0] file467
+    574  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1d6:0x0] file468
+    575  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1d7:0x0] file469
+    576  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1d8:0x0] file470
+    577  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1d9:0x0] file471
+    578  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1da:0x0] file472
+    579  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1db:0x0] file473
+    580  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1dc:0x0] file474
+    581  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1dd:0x0] file475
+    582  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1de:0x0] file476
+    583  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1df:0x0] file477
+    584  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1e0:0x0] file478
+    585  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1e1:0x0] file479
+    586  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1e2:0x0] file480
+    587  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1e3:0x0] file481
+    588  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1e4:0x0] file482
+    589  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1e5:0x0] file483
+    590  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1e6:0x0] file484
+    591  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1e7:0x0] file485
+    592  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1e8:0x0] file486
+    593  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1e9:0x0] file487
+    594  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1ea:0x0] file488
+    595  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1eb:0x0] file489
+    596  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1ec:0x0] file490
+    597  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1ed:0x0] file491
+    598  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1ee:0x0] file492
+    599  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1ef:0x0] file493
+    600  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1f0:0x0] file494
+    601  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1f1:0x0] file495
+    602  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1f2:0x0] file496
+    603  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1f3:0x0] file497
+    604  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1f4:0x0] file498
+    605  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1f5:0x0] file499
+    606  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1f6:0x0] file500
+    607  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1f7:0x0] file501
+    608  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1f8:0x0] file502
+    609  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1f9:0x0] file503
+    610  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1fa:0x0] file504
+    611  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1fb:0x0] file505
+    612  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1fc:0x0] file506
+    613  100644 (17)      0      0       0 25-Aug-2012 06:09 fid:[0x200000400:0x1fd:0x0] file507
diff --git a/tests/f_dir_optimize/image.gz b/tests/f_dir_optimize/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..d457d3b67019f0047fd626bc90ee55f2724a73c6
GIT binary patch
literal 102520
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

literal 0
HcmV?d00001

diff --git a/tests/f_dir_optimize/name b/tests/f_dir_optimize/name
new file mode 100644
index 000000000..8a059bff2
--- /dev/null
+++ b/tests/f_dir_optimize/name
@@ -0,0 +1 @@
+optimize directories
diff --git a/tests/f_dir_optimize/script b/tests/f_dir_optimize/script
new file mode 100644
index 000000000..f535e7b7f
--- /dev/null
+++ b/tests/f_dir_optimize/script
@@ -0,0 +1,36 @@
+FSCK_OPT="-fvyD"
+
+IMAGE=$test_dir/image.gz
+gunzip < $IMAGE > $TMPFILE
+
+$DEBUGFS -R 'ls -lD /ROOT/testdir' $TMPFILE 2>&1 | tail -n +2 |	\
+	sort > $test_name.1.log
+
+cmp -s $test_dir/expect.1 $test_name.1.log
+status1=$?
+
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE > /dev/null 2>&1
+
+$DEBUGFS -R 'ls -lD /ROOT/testdir' $TMPFILE 2>&1 | tail -n +2 |	\
+	sort > $test_name.2.log
+cmp -s $test_dir/expect.2 $test_name.2.log
+status2=$?
+
+if [ "$status1" -eq 0 -a "$status2" -eq 0 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	[ $status1 -ne 0 ] &&
+		diff $DIFF_OPTS $test_dir/expect.1 $test_name.1.log	\
+			>> $test_name.failed
+	[ $status2 -ne 0 ] &&
+		diff $DIFF_OPTS $test_dir/expect.2 $test_name.2.log	\
+			>> $test_name.failed
+fi
+
+if [ "$SKIP_CLEANUP" != "true" ] ; then
+	unset IMAGE FSCK_OPT
+	unset SKIP_CLEANUP
+	unset DESCRIPTION SKIP_UNLINK
+fi
diff --git a/tests/f_dirdata_dup_de/expect.1 b/tests/f_dirdata_dup_de/expect.1
new file mode 100644
index 000000000..c064e82cc
--- /dev/null
+++ b/tests/f_dirdata_dup_de/expect.1
@@ -0,0 +1,37 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Duplicate entry 'f' found.
+	Marking /ROOT/dir1 (439) to be rebuilt.
+
+Entry 'foobar1' in /ROOT/dir1 (439) dirdata length set incorrectly.
+Clear? yes
+
+Entry 'foobar1' in /ROOT/dir1 (439) dirdata length set incorrectly.
+Clear? yes
+
+Pass 3: Checking directory connectivity
+Pass 3A: Optimizing directories
+Entry 'f125' in /ROOT/dir1 (439) has a non-unique filename.
+Rename to f125~0? yes
+
+Entry 'foobar1' in /ROOT/dir1 (439) has a non-unique filename.
+Rename to foobar~0? yes
+
+Entry 'f' in /ROOT/dir1 (439) has a non-unique filename.
+Rename to f~? yes
+
+Entry 'f1442' in /ROOT/dir1 (439) has a non-unique filename.
+Rename to f144~0? yes
+
+Entry 'f125' in /ROOT/dir1 (439) has a non-unique filename.
+Rename to f125~1? yes
+
+Entry 'f1442' in /ROOT/dir1 (439) has a non-unique filename.
+Rename to f144~1? yes
+
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 543/5000 files (0.9% non-contiguous), 706/5000 blocks
+Exit status is 1
diff --git a/tests/f_dirdata_dup_de/expect.2 b/tests/f_dirdata_dup_de/expect.2
new file mode 100644
index 000000000..4ed7f5245
--- /dev/null
+++ b/tests/f_dirdata_dup_de/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 543/5000 files (0.7% non-contiguous), 706/5000 blocks
+Exit status is 0
diff --git a/tests/f_dirdata_dup_de/image.gz b/tests/f_dirdata_dup_de/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..d3e240652bd1c64c8bf5b0da5dbe7c593e41b4bb
GIT binary patch
literal 79307
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

literal 0
HcmV?d00001

diff --git a/tests/f_dirdata_dup_de/name b/tests/f_dirdata_dup_de/name
new file mode 100644
index 000000000..5d4d2c3f3
--- /dev/null
+++ b/tests/f_dirdata_dup_de/name
@@ -0,0 +1 @@
+ duplicate directory entries with dirdata
diff --git a/tests/f_dirdata_optimize/expect.1 b/tests/f_dirdata_optimize/expect.1
new file mode 100644
index 000000000..52368d33d
--- /dev/null
+++ b/tests/f_dirdata_optimize/expect.1
@@ -0,0 +1,10 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 3A: Optimizing directories
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 102/4096 files (2.9% non-contiguous), 686/2048 blocks
+Exit status is 0
diff --git a/tests/f_dirdata_optimize/expect.2 b/tests/f_dirdata_optimize/expect.2
new file mode 100644
index 000000000..3cf9314e2
--- /dev/null
+++ b/tests/f_dirdata_optimize/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 102/4096 files (2.9% non-contiguous), 686/2048 blocks
+Exit status is 0
diff --git a/tests/f_dirdata_optimize/image.gz b/tests/f_dirdata_optimize/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..fcb7f4f866cea3160b77da4998ec69c0817afebd
GIT binary patch
literal 32121
zcmeFZ2~<-_w=Zr>D=I45h)hD-2~<Q>KxWcP3jzX82r@-QL}ZAOc}U_2DwBeM$`EY@
zlqoWXIjBIGgCIl<5FtQ-03n1BGM)1dpx@W`zPr}{-TS}qt@qaYvRIIFs!pA%UAuPe
z{oB6+7PV&0%B~9A6%w94mpt58O!lvJ-r^3cWqTx>p4)P+D(^(b{siHdQ>Qx){wkxb
z74`Vj!A%MEMh3-aD_O0D`{VW(O%@-HJ5W;CVq+~;(rQ^$We~&TO}77fchCO6=DvYE
zOic{Auu`i?tEE!vQ|_7gU1ASTWZapMldHq_>U5C<3i@AW%9pvG5_J|wh8?ixocd)S
zI@!9ntV}EUd62tSW=xFXgYJY;OYX&qk{ylM&ofU)w61D=t#TWvXuT7EnN-&2D<PwG
z%;Mdq64gs+Ii0**@7e1mCukq$t6$T(4s8zdud~#XqbFZwogJMFbVYU)vWr@-wavvu
zdlhC&cK&wu$hH&L46)=#sww9aclSD6M9{rLjf3USnQ9;IIf~6&`{E-x`0a~Vt5$Z*
zzSN&9jW(EpQ;$+kH_IekFRYE<WwH2kjx<hLsQS}hIT0g<cacf_i7(wJiNm)9jt7>?
zmupSrA0A+Vc7a!P-jZb(@*b_K$R5>&f3!<pE{1-;0i)(vAUd&4CD)m>a$#SkvEJ7J
zk=L#3S2XwR3-oVO-=~m3H&E$8=)C7yTTLbR!TUp;y_H5hY^`lt#}eZ8wLNcy-gLZP
z!TIWdt}Zr_h!<RaV;GmP;nW77RmbUCQD(92WYj==h_cgZ%nb+s8*i_BDMY>tOhT1i
zM=F@V-I#=WWANc{>=`x3hR+kbTJ+3TIW`nbTxrp34>7t&oIRARR-6#9t*6&uqjX{H
zPMd<*owg;huPYo#pR+EI4rMu!3S9E&Wm@~`GabG?D2Mj}+f*(qo8NOJJ-O6_I#(93
zP5F{C=}$*e!Ra29bFurj&5CZyk@b$GK~xXw&mg8=VPwFzfJ~?wQkgVY9P1W#frP5o
zpf`5>%GAq^3)nV5F^D};9J@0im;M&hgYw5R^+xwI^^Wu!#424>Fu$Mfqa2yxKpK?D
zqdz#u)H~c}5UY4a*&OGlOj=(W>(&KzZhecMf&YVmZAZQsY=lG2$&ZR$>6cp68&5M7
z$kjuAR$5V{82eA^(M8IuCc^1L^T3|3xvf?=)wXJ>Tndj<c>46kv(#@0m+w_@TjBTO
z;%KQhmhOf6*j7|8oy${V@KPI0N^90CtljG=?(za;j{VR81I$fvnipRPR%7yc;19)F
zoOxvrK83gP#6R!&e@Xaz1%Htm3*7w=JsL0bb&o4kuzU^^Fp$7mtam_Vc0PjdSCyDO
zyEFfv^(+K(?o}X#HHhvQ-(>HV@0=xBtZ?=&0mo*=HhlS1R#kB5d_!>&s+@Sp=jzEA
zA=mfPNr`ArE4OdW&q|ME`b572%5Iqj2v7X2XS*yq*%V9hhsf&0iETvfwqe1ee!jx<
ztAe+`YX-kQs@zUA%|P)*8E&VaGw*8JZHlXG;>uQXBtKq_srG`$m2~Al!@R|hPvPS2
z%DUeWz)6o;*LUK+T|qAl6Ty2Gr9>_t>4!1HKi8xZ*S_ev3=hV?n8FhXTLr!O)`j9Y
zA00FxRQ|vrhRx2PBLy!8054<kt9K`d()EpOeN&CWLD-dunbYqFRJy&v-nM~(%Zp_O
zDdqlO=jNr?<3oj#=gVBB(!pP@JuLObXg<JS6(UTov$iIr6VofIcbv)Fr=HVd&*=o6
z-2X8lo!A}d8#N|t5U^TeTWJ@$=wsNYGz`oq2N#s_k4o{oy4|^APNYF29bN<c^Y%F(
z>k#S59PjyyBL=5wu5f5cm)T&7fB(mPT67X~?~=jYV!3agsbCi8C<B}+Oa&PaHWuog
zlqG|&Nrm8YW##_NF%FnF=~B<cri^eAJ`>jnu{j2>U#5ZtjGr$y;K3Bk0b^XPseLYA
z+NBFNJsPFjL4^0fR%XG!T4Ud)0Ke;sxBF^%>0x^TZVKknd6AfizbOU~NcxKIM%Pp4
zCdXdbpF6BdDrpnjNrcggzhIigU1?On8V(P;e)F;!?rG~Qi@RM3U1z$OegXe5Te~c>
zcOdMzLaewbZAEv-`9>$KxlPhet8z@c%*$|}=l5Sfs+5fj*b=Rjl82q{GSexLeY(Z4
zVI;8SKqFb1-smUZ|2F3Obyr_!YC!&nb;;5vTi5KSkYiLA#C~wMq6T-_trW`L9sd*=
z>4GeIRYy*ZoSDIBHzh>vA3b^F=7c7KPj|gj>5`mT*po;amP<JkCUTaeZn*yFHuE_n
za%O3RY2)+4WkJ^#k+7zrK{>UluCn}$@w3ppHM0n9BX@rE1*s#fXM_Vqq6M7MnSFoe
zSvb&+TdS+5R5@yN2E9kK#)6H{Yi(^98*kpdGi+@9seWY|MXA_Z<SkbAUff%xOG0JA
z2=*V2mzyIb*7`757d~I<$}ZfM(iR{}INU>T1RL@Q?q6<$c3j;!f!297<?FY9EZy-v
zM}o4w6#YB+wCvCk$I4JuX<87pXgKib6B`Gv|4pBHYu|+m3GZ$gW03>Gm*oT@XKXhW
zM5GJ=fN~BE$oo2-_c?Pbl^CQ$h40R}kz+wd*!JV1ehRC*dtF}Q&6*x$RNytdGrq;P
z_MzU|+j<IVla>Kyn`}P38@tnW!=Pely}#+fW1Aiwyti}ZlLyDNFK>#{^Ea0khnd#B
zRttTl`&)-3`pJV`bEeqT`&ZW2_MZ6g$D17+?%vqAdZ)62{GC^Na-VLfM9{;dYgd(R
zdS15Xg8W18;os##<nKp4iThmk>#99<@>?$LKTxl?<<sroqDk)0ZasW<uc>UC{dY^}
z`+J`~%0X?&uMa3w(Y>gcNjK}emx7Y=t@kNY4*G7>cfS%PJzbA}c3XHzM*92F){mya
z@<r@5D)rl1>y27TZVtCd>|eJIS?vFKHdrx=y*|C(FIYwM`|<rBtb!Hr7x%i>AKp(|
zms{r*tc?6_U3K5iAx0-yiS^wjw>~Tw2K#OrelK7_9{2rhcm$cfs>e;Drq0a!qy2(n
z#@A?#uaA&38l{7V-Xz|_FYwEffkSGOAIS@=DhnjT3Z#W>b<8K$f&_L*b6YKK&s|_<
zmD1$QEw!reF{@{enra_&TlfodE~J5L5u?{`uPFXgz1U2t__$%Qxn$}s8PsnpQHKrw
zk}=r1ChPk-{|}ye$}XtY72D;vuQ@LNar5mHe{NSi^x*imir13ue;S4UB^SE$7j%c*
z!xP8gbEFF=8djvnY+3*3zRrVd7#9zAKDoVJ{*m9I^^8k;?W8r%x1^ptjCy?kNu$}u
zn@=K7m&x<xW2{cyIu?C&bHmV?XwyU6_IwC-j#&HbfyJ}v7SyWzI=g3g-jyj*zB@Wc
zGEowlmkfOCtjiP#-_Q3&P*IZ8buMK}yzj1kkqTunE%pkPy8TA?A`dCWeLvm$!MXKQ
zxKYHa;BB@Sx2M<bFuI>rAW!~&!6=f!Ug=u*Th+Z}_PV4YyZxVT=GIzPMNrtQ2kM+0
z?sq%fC9pRR)H_y1^4Pza)R{X(#<AC$)O##!LtHdI^4-e2PBr{K{`8}^uXpkmR?{vk
z)qDyJkAuzZ47{j@`FKDSjd-sV_Fhi-9!4C}6~)45)PRq_h++<pNtk)R|0Iz<b4ORP
zR&vAVH8F!xs@K-R7hWs8cnx`ZzvXo(`gCla>QGU>vC^i_VohDs*aMrf=-*TCoc+8i
zYtY}nUSTZa;=SLuTv}uP>yFL$uhsp&6*U&Cq9?;1d+0hA^XuGE#I7A{#T_t@?Fte%
zj+{BT>D`G>zo*{)aKe0b#Kk@B^#@ZU2lZe(Z~SuLPt^m*wwmow(r-MjVm5er*iHMu
z(O=dbT76tT%IeU@`Wr8QrK1#7FYZviboc;Cw(K|iOY1U+t~=lLLMi8yHav?MFWam;
zc(w126H3XKq+BKwH0axRHw*>4`W@3+ClS1<Xl9d2gSXKg^Fxw;hom`d`K{kkMz`+=
z{}wf~CB5OY(OnPrwsewI@Mf!--&`Bi9Uj>itZyk;sm@k(B`F2VATP<DciS+~U>Hm}
zi%s7|##Y5i&ulmOXb>K4JG0m16Juc|v)~uR<()?c)x%@XcsFeIuGd}IN}W+IrH6@b
z!3rb{*)oBH9-=$_U+-3bjTA4)5(k4sx8ZELjo*<^kA|>Ck;*DF_vETRuQ0jx!0g(3
zg!a+13m;%@9osZE-AcN4zvtTB(rc0PW4B~(?65iZyN#K-|1pnW2e+g?I-s{9>$Q6O
zAG*Kp{PoouQ@tIV9`5;b=jwt7ra^PH&mWlE&K*PUdMPc~vDsoQ63~-slD}2-<j(CA
z#}!u(Zd-3=aQNV_rl<oEgGTE~eEHi_H?|)}Z7w|cTW{mh1G5L$$?b%_My*|U>cOEs
zA03<@q4q>b?3RyfIrxjrp|uGp{ruX*vUO(<%G%QvouimHjD2ghPm*HF*6Px?_C2EB
zFr2PUE0YSMtMo+)4@&UdR8?y4KD!?|bMPvCv(Y2{XHg-~;z;jT#L?I8uS;;amo=lk
zm9AhE#h5X2t&MWHlRR_S^~0H}NA3=>vJMX^GX?{-DZx@X?-jjfjtqRLbco{3n3&W?
zF05hB95VTkwXhyXm&zrr4u2T)^&Wmk$Fe}d>AfuNyOZ~)ps%qkwgjeb<7A!f*ZVlO
zRG^#m{AJiY-Ch(yV@m>c2)$dx)2m0?IIzIrS{c_FGl_+l+ZDTqg8bTb=eOwYGKURh
zx6;6IoYZ=){2|YiMNtjIBXQ09_coE=&HIjcul%Q{^K)NWyyL%qoqrlJ``mNvIJ^^q
zvu??p51Ijc3C$^AW5&JdN7|{!zfB3eosY`4OJo*dY7m5v+su!C4%Xco=Oww7VPM%%
zfl7IlsMw-Ag&R45fK#{k*ut*Aiwo-@85ZNO8n>3bn`J&Xjo77D;frj?7N9`c<WKa2
zaYZ4b`au=aW<;Kgh#Yt$JuO!h4hU$jveQKsBidTYMdzNA&}Bq~9x0S~YJ`-qEl@wZ
zijtiZCH~m;tU?9G>#+qZM}^hGmgK|)nZ~<Az=jyhM6YVqJ&a4H*_py>6Ji?1d1Z9V
zK73^P$)1*$px^y4p_STiwP~v(pW_dY_D^i$7=HmSw|kTxCbR9uoMx-%xJ!<}HZ8)`
zAj7F9{gs_7F}!>>8lTc)m+j2hlG}#4Y7#d$1;hw1n7Vyy40#yF%z~v%;LJ;0jqHpH
z^u9hpJaamCrZQl^T|QUwO*H31A*Q*!RcNSvMZ7Y*ET$ZT>EV+iBa>)xH3$S9=tEZl
z{2GBKx+*-zQ--m7IuD1*jhkgYyg0ob>+OpI-Z&cBWHgt!3WPRi8M{Y>cM&=ud_Zup
z1?iH%@V=w*>)U5zv-~l>K!M}OW9MS9?`Whh^0Nxp@-hNOph&ukZR)|@nrhH+N!&*X
z9iRHz8e-ALOCF8909dxjA~8%|#@XwAHAmtY1-*#tVDJ&$OpVm!#b?X?wGjmNtzQ|8
z;aJqLq3YG7=(hHKdu}l27yG02l&_e3RTzcY$j!UV&v8g!c>M8D?BkW@zK6g7SK~jy
zO1)irdT;8UAWm&N^H_f$<<da2j<jFM+-!+<QcFLndQ_O`B>lXoBDhc5B#wi9`v>LC
zEE^PvSx=NfM9<6E<a7VAvc73vRng8xWM2;w5hJrdv$cCy@u!v5=Ezgbu?28#b2T00
zviAvsBe#y;Jm(l^NfK8cz~9(btxsG9m5I6Gk#;o*I<rKt9eg>Gomw8AksV0lhrLx)
zW+3oX@I)+!LdY8gTpV(^>PEBNoHi5?*-K1gUdoRdnY9!W(s2XWeJ}=V6mY2|O>Jti
z)A!?Bc7MRaPIXNoK8Y&_O2H>0^zDJ5Sb$b=r4noU`pk%<W;OX7AY6%G#|(0ztWs~&
z(W2P0sFzTn8_W0Q@Y{`HA7~2q79Q6{|8eWrkI@CY=(i$16YlMQ{Kw%W4ejs~N0L4i
zJ~sPZOYr{cn_KYRq=t(!N_P@A8Gf~lF1T#kgQ;ZIYgW~L<Fs3ySXqhDuhiGPVECkM
zG|lL4EM0zfej(4^iBM_TW&GlKe!fD?w>B23+}X}PfR+se@%$;(b~;4AfuW2vDLMak
zr}r1#!JfH??JBH4<mD+i23iK@_kh<{8~oM(Y!P-n&!FuaT01p-TkQ=NE?4ZS{|z=>
zmN=Lm=WV?4egbLAR%uZ01?OWeO1t0+Wu5Uj=S>4jn-kHWK3muus=PshKFvg@;hNc5
zZfpZsn;y7uA(h2CXM6iJrHQE@+cW*OI*W*}P5V?ESWi^COX5ohIXfH~n5%kpIM~oe
z;Cf^%Ah|@2N^YQ0gjJ(L5gbisUTYANh%qr3kzHSYaNoHj1MqvFm9YUw1!cVpf>0dZ
z3=Uk^rq9u7Z_bLse7}&S>ZdAnuaF*%8k+3D1fJW5wc{K5Hq!G8N$?i~_(sk%I;+hS
zt)gke?4(V`&Q9GWfh6+x&(R<<2iv`3`Ex5YV0|=r;4lEDb}Y~%hXnN~c<%zZ$xIjX
zRtMepfiB>fAYx1~W6_RMzpPj>W0hM&D_}cRvGr}<ECd`ILTzB{#VTYt&BD~qp!yTH
z$I85`8L*sRD5$pT44go#kQjPThRF2YtG=yTvEt<+<qI|YU55?<TZ|1^=n9<Ep|Ej~
zGhb=b?+7)%!fmfu46B@@Z{q64ydNv47nwmfYu_FAs`u-^px@8@xS(IU@9BZ3GJd$U
zq}kM>oYnVIv;8DmPg<H&2HgtkJn`@qx6U$aKMZ5d&u?UliMzpD-!D0Tb~NrkTz6PY
z(pm`c1Us;|y67kRz@nRP#n`;wjH6aVI)Bhhis=DQ$cmrl(E!es)FsCH#WRf6NA&aT
zXrQX~{(%N5Y4qIS;Ap*w8b(!#8+lIqx)9t7b`S_4irw>;be1i|+Vd-j-9oHWGey$I
z+GZ9P|CF<?YNKoJ6L7+Z0J!aU!EzE{jo5H^7TBvZ0Q$TR1`(BkU0$EsqWG|o+4{tS
zs)K_Jcr<e}b13h0T&EDeUJSt0TfBy`*Cr66J?aHwhqw#$=slz0*rQh*)?0_^JHukQ
z#$Gv9ce6CyD)sBb;FB;{@#*uIg$4OxrhBd!4S<yHMzFmkP1AjMDU5l@D|K_di0J1t
z#lwcprsG~b<s{rJYv+O7S){`uFkiof2qK<d!Jy7$$}Omr6`BFe(#i0>i!Y|o)*U~G
z0a+)lLTtD^(8`Q0#@fY*q=Whe1r8szq-&f*#k&I_QJ9B=B$?rjTmat+N}E3cH|Wf2
zj-+kn$KlxvK+tQEQcv(OvBC_{!efAu+`4%;<Et@Rf1Lr8O&K)Tg1(F<2H1KBE79|%
z5xj4%S{0wz2@u~L==qJ?oC3OA%p><a1F6Hb_p_teka)ED2N5zJ`w1#iN|?ki7L6<x
zftkC67gli)>R?2oF4$`^@3(Fg+{o9>t>P2)n}Fs!eBxPPgE|sGS`>nbclh{(r8ev=
z=I!NL!K+IZ$<~Fe{m;PAr3*yD6`I{a(094Sst|`b2s&LK#<J!{@K+Wkds*W&zKXAT
zq7dN#l`M6FxTgt&g8H}IcKj}3#wrfcW$Cpo@soIsXW;6k<}_^!v0fiUy3NE(BW>8@
z@#2709Bi^k>HL5QZ(E4Ca1ab?St_!N7jJ-?FkNawSG5;^;29VObz;PdM~qMWiph;C
z`LlX<l&IPS_^jg4b}bD)C4Q3TdJyC-x9$@!He5G~&01=m_WTMl{~{37wAea0x=YA~
zUW{8Rs!W(f?tS({60{druudODG|i<3sR@(1TUxPEOZA{$5Obg=D2?D}B1rhVEQp3p
zK<phpGI2??Veyl?vaQ&Z<rk-1!FqfUg)L8`eY{w>ZuEy_QW7R<kZhNWh`XDB={tPd
z@-*gI%u}Iy%fmN@E~G}m+lqW1(4F)5_tFxsV38k0tYxvs?h;CGX(ie($&9zVm$$X`
z$LNDpds+LQfd`i6fMruiJ9`l9hn7JI2fP?B9=OA2Jz4BI77>reeh|U;EDauQF)x%F
zB@)a4S~=^5+l7ZyqzVVCFOVh?At6EagiB)r|A-eyt{eR!F=@44?3;_gkD|}JgmI80
zh)a@yr(eOoya*8YEwz5vVjc(Suz0x_CA);STU)_jmO6;t*93gH!^fUj8VJs&5c~Eb
z0Ly;@%3woi1&hnbC3p7(r0kIilW=Gxag9rpT4XUFx1|+)z1$*qmyj&m3c4*{g~y9u
zui}7ZOC5n(6@oE$_^`)IvqiU<M?f7py7X%BYP=W;JtnjK*wike8nl|cbY@v&2I2b`
zZG)WG!%#?rg5oEMkoMaysTycyF;8@Yu4LPZT#}5ce@Pv-%{rOYU%;%n?8O$$NW;bK
zFAMkDl#S>g-xNp4d#yP;w1FB%xPKGq`qaV4xuAG7^=Ih0?{8;`6;Ht`{}8^kW(#KE
zyMoromy^O!ld^Io3wR6%O<y;HU9&Jb?g+7jsQZ+I)&9~B=0G=J9csiLt*8=3CXWy=
z&O}>%dMP6K_7=Hw(8khp_uX>ho9185BJ-NTrqjdVdmdQU2m(a+HbJ)+h4xhBwICwD
zZ3bJQhO~5MiGofyQsHmZxPXx9S{|_->P_7Kunqnj(^048=M>BGD#J|q9PkhGDHce?
zje_2{DIYw{6NzN7Y8DIde8-uzsvsudQw|4-had64oo<hzvTtT0QQUN>4}>GvVg2W)
znM@j0rjrIf)NkUXC(deUxRtu%a-jVq3-8rp=?(93>(SdOI3JG<$4Mt*M}*+J(^ViG
z!4$A;odfnH?X;~aI}914#oc2800&ZEad41HrNoPHHq8{Ns*Ng8TWY!oCfXL;;u4N+
zJ_PP8y3PP4Ev9KFnsudy!Qhys4UYV?f_c2iUNyjDw#p;JC`-TrpPvo~u&>O3Ad|pe
z@sj!ndwrqPGH75#Gd5S0xn$l!C!JY%UjTDSVBBXq8-F+(|N8SU3H(a}|B}GJB=9c@
z{7VA=Pe~y4#ud9+V&e8zN49g&`DQ;yQ}g<pGVwRBo>5gD$vxza9ep`|dtO1B<OWP_
zZ?#G1<vwK;M--_irDzufD`^_deU6Mwk>el;?hLC75BV^`{5<@?fFd_|;^HhZA9BOi
zc0qMhhvB>TGGv35s~mQM-Be#O$)N%mRf9hU7n+3tQmI}Dek)0FRq}Oh1@EtggO?T~
z-Nk11RD+*7SYSb6l^GD33Dn0ex@wT;(f;5vpv;MEC%(R1E)~xMi{Cgud#VtC*_!+I
z31~hY!Zly=VWv0y^3tR!h`4YZ8Fogj%})S}N@v^hJl9Hgo?$DqqYrBI0SQT+y7!uC
z%wF9Hi*bo6op-9~IFZ<PLW^ivDekpq0&@@5q`{d)yqG&WfJTeM!bS(GLQU;=-1GX#
z$pPk@XFAw)7{HnF4!?yB<w~dz`3DcBSY1XB$4$GcFeMP;<j$J}Q4?TFk|D!I;wzzL
zZ8@Ti!l>zPCNM3RbJa*(#IoUkz$qiT;&W$){ayQF%O>?L^mY3q^pKWk+N~^|1m~=+
zn^##pPkJh4d)>#q`%CLE@m0<7dh}kHqVN4*R(#)LP#E4T^Gaj~rdILBF~0Sa?jX|%
zocNL_3#sG5B*^zHNZA({mIiOVjKcJpA5>rOzd_Y~X!ke~e}bviDX<<FS$Lv79myvd
zWScBaE2i!n?ucjqlOE(r<{Vq?YFtV_scsTA`i7g*C1@_jSUG~0j)=q_`z+>@ex$Es
zP$pN$vp=zi(;13!)I7nw?^(SkPcDlaU+ns#r=?Tyt=Kia2Wd^&>BN%tM7ua5a6Rf>
zp>~e6$3424+=*h>gdU_7Go@27<yn0skM^X8b&?q{9(sjLZS$-)$*b%VBo)`_<Uw_)
zU7@CqP_KeAxX|6$VvMaL(vr!`<fcK@%b_l?te9<{VxV{+z9%S)+fzJ{)MM;fZJful
zV1{*tnmb~D&x5KA_!}2e+S-c;5_>AULTw$f2lIHD0SHH47PqE&0M|o&(F1*z@D#r)
z25vZFce%t(1_(bF0}hT@qde(1+z-XTpN^oTBld6}Jh4YQlbh8gcvXzi%Y!HM;H;VE
zo!k>NT^X!#9z3}RXUjD25)>2zF~u08JmTXX;`1J2Vh=H`XS}BIAu*u`agwQ-!DVGK
zpHw4o(Dy8^eW&1*Bk1Y~VjQtL)z}lvNwG>LkGx^UijLt}d-=+pm<4y#wiPRGQSN_T
zyVX#PKhYfKRMUArq-xUs8$ivnCF9RPGk<Y^42ciN=b!+RAtkWp=^~my%0-!N;lPD2
zzA>=AIQfrX-lQVF8`V-EFakos@Nd(=;}+9$YVM)8MfN?7#90yR2TU|<4Dxor)&qIj
ziu_0qm2iFajCndyL5|MmEkPdaM$in3EZL3NfEba7t60>sxCldA6+QmU5E(|a6RR(m
zTO|-dEh&to!&#;P7I!juw|WK>yDOj|=`Cek1$$$kGhjf&KpmIg?@GFU^O~o%?LApn
zA1|M&Nh2MhB2;jzOWhSTP|pf;k%yBy*~B6nMbIy>dx559b6SWJ+5Q{E@Q-aE`pU>A
z8t9Z=1InU~dvWJZnQv*`radL3E$kbCMKlrJE|xDiK9GA5Cui|UE+8fK>0S$c&Asd)
z3%0}UcNXQp?=7(9e@vZf0p}heKQ{wl)2luZrj@?6-Dj%5pMve4?-vI8sCx{kv|q0-
z2oqC#2K>YJ3ddjN1&F_OEBQJQ_%2?)m1rNHfNI4jjZ`3mNiURi`&>gcPD(L~=cWgU
zA-sOr*MdBMV&`Fv${+~g?(3Dkdd`|Gl??roPCjp~xu@E9b*5ZIOLnH*ecf}`nj4et
ztu-G;R-HSkxdEB`!u7lX>~ff%p%X4&*UpxlVrOiO4dl+<(eLh(qB$E^k2Oz>*CXGh
zyUwb2cUj@H(_I4ty5~gs<=tHzgPbe|;;eD?%bd{A!K#Vz<D8r<InB4}u7&SIL&yJ`
z7<Z4#$&~Zgc$c0|C=Lw;3Ma-_QO?_HI=e#c=5=>P*`Kr3EYFAPa=W`)&O@D@bcEi|
zikKMZ>q7M$T#T!4Saaw8BG}n#*1QW1ZKCF6CFkd*yUxdEj~{no<w6ZZj{|K`XM5~z
zH7E1aUHz@Nb3;y0y}t9t)pPSuCzPO}2l+sCdHGPoEU3;6^YNn5=%lG?>c_B7o-2YZ
zsmq({haIsyiJW3>U_l(C(w~?>U6lI3b4){D;Z^ZO2@|<4C{YD@jOo+guQXJ@1E2mh
ze8Br>7$1O9UAbb#A4U4V1%>BsyDqZz@`PQudhAU5NlT+utry(B)`*E&_9J|7^vz=2
zEW#$3p#Y+sieT*1BHD|`2r5b)hC*O&Kx9p|I4+7{W^Bp8PGqA2a+3vcHvXn7gdaqe
z%+dmx@P<yVE}VZ`M6w^?VX1o{NVi81q&!hWI4iVB$zXs_oqS?^1r&z68MT9i|LO+#
z>T%PhF#yyn-8o-A)mM$Q2TL`?PRBx0NyP`t-8t=Hg3<Y@aaMn&hu1dVA>)&t<NXv0
zk>D}iGoWl-DIg@1?wpinxD&FhlJPnYC}CTUuK(_4y4gMz4{}nqQ(yz8ChAyt%t@c#
zP*#!)Z*Fe7#)H#y#Xa7jTs-u~S^3+((J3agmnt`aa3ou3c)m^(8}gp|rVIq0Z+R#S
zWe09ip19F~(E`05qH(Ir1YMZZ;mADTR_3v3(F{lnJr;DNp>J*Z{vuma2MJqjzdxwA
zZqvZ28Tt2wZaskh15IWlEPg;`EeVs0U}(ZJCi(0N_BaG`9#}%+ba(fXA#l)f2>>J8
z6yhLAEod21YlA>y2$oA*Lc_3D@nSrLhNdmGfwwFqR$K&hAq%MhE_DV8MsLQ?Dg>>r
z!wGvwXsloe>an%!Gud8^K6_J`rS1#YsumkJO-Y~cOP@Mgp<XW5k|lU#Z6Ruviw7T3
z$reZ~@}|&KmSAg%#3F7AJ(vU6pg{(weg0?rSQa7Twh8YV$1A1B<Yu$|x<z@M6@ZY;
zUh>NU7<8!(7lY8B4$&Ma0jVvgYx!wg5dNPn3|sWqVmDpI2j?3?=@E@rkgYD4F&#^F
z$c^E8=~f@<t9ot`GWcZe-yzxmL+JSrnUfc=(5S9qen?;(l!TOLGz(l5#0wno-&@H0
z0wtT2x3{|faEp(H)!$TCjkwWYciE@PYbuixk)o@$muG_jESG%M<va%0VqP6Wub0ya
zi(2yv!qAu1t6`V08-n3&V?_Ayaln2Fa)fq0`vDPUS1&Q|B9O9-nxBmqF9P7MOB#x|
zF2q8q5Z2Qr^wuz8k^<qi5VF0WzN`g5B=cXG@Bf0Pq#HaF;dkEaRZnNOTZY(JUBf#}
zk3QU<i-S~zm)Ae{?FQ$n>PU0)G<Nqt!Q;hjK@yZLNLm^J1oac35iA4YMB^rm=?4*E
zNj_M&cyT4PXoF%zFtHFT{JT`4qy-B?t<Nusgs9epISW0toZP6km=D_8N;C&HwEWPH
zhX21S;Xff6V%A1gkh$j4{3Aw1(V6tF-@d6QReD`s!%BffGWCyD1Cj8j)c=-J_&<~j
zNn(Rbwjug|>q7Z=>(5sCBtY5xaZ;8Xu!t=0hO9Ng@A8^T)vaD`lyBDf4Z6syXF|b=
z?!T{qAhli=l$BauHrRtr7%0!fTT%<6W>XCjN{B2kfSO%GF_Zvv+6l7yg4+I`9YI(Z
z5}|tNW#j!j6l|^Hu#%T_ZZUCk<{-FO^g}namTc#LyUF->lK5e!i~|nx5$0=(?2RaC
ziL<Fm9T0GDt`;#<@UZ^dSK?BZIOX}%e?Oi$wO$yc^7!SH3zWBlQZqkNOIVF2AOW%@
ze=KK=EDN#kAptEXOS2LtVbJy#=`{@2AqIl}p2Qi1azs$ZXy<aW$2(rU6Uq_26)FAS
zq9r`0jOjujWL?9(e_B^t(Fl4uH?wRg;kYZ{H7I4byp@yUC$X<D0+P##x!`!Q93-Ms
zOF|(&zXCcz!@IY%dt)IJ^zaTJbc_)hR&0bV<y-0<|8j*Af@!;in$Vt~uq>1_@nRNq
zb@o07DQ4eW>yoi?qI`U|+Ay%+-dn>J1`KAw(-m>=%kO$XV1r&Uygl_d<kx{p4f&;A
z7ccq0*YvaqK=Q^eD>10#Xfq8GBB8at0#iPPI~`Vq&Cd9%)N1L*L!*F$_r@)Z!xpI(
zd&!<_J?!`M!epWd?C(EUpTSQdjFjiW(+>_#bk;<K{1|7r^$RLoG)Fp1PtZZmL@QW4
ztPB}y-OG-sNtgDWrdGm-$zaExS+H0{I*#TqdfFo**oG1gII(9Idu{zJ;_(4ZaL}Ev
zDQ`sYJh%tUbDH<=4M&hA(1TyIH`xM*{{-^v_;CG4BG^0tljGAsLhc1(=#(HO9=ibt
zD%kO{AzS#^Of$e95jyFxw6&6B_(6%Ytdq&fU}GWW55{)|x%)@)x2YACx=-OCeX7I+
z#A2a`0?+Y<BC<Njz_OBRfVMEgG%ZQU0o9>I-;+a)GzQjZCk8MNsxI}M@)&{}gz>ms
z*3{Z@A^eb9$UxDV8u!VHV7NVmPuU_UNk0Q+e~$+W#i=xf%!u344~r~0LtnuDo=}Vj
zw{>rpr`@9adS`l_sTj~?O?qjxDG7K`WMD)KJkP96-vv#`%hUBVb~h0$!tqDY60%}2
zBc*WjVnMCuleHrV5$SAJSis`ML7!WKL}?l>j5D#p<zbtWZoZ50WTA$sDD0+y^}P3$
zg!1-n@*@U1o%O453w5BLJn6U*JAKwaEL5oBS?$qqTXygjorG9mNLjTgpU6V$pGpTy
z=Vl*yylJr|Pvd-tpMdW4SHVQ7PO5YU59};~?du2f{0;7btU?EPs6~iij0U7+^LaHa
zpmUDbIgU6f3iK3wo<kK01KtEsv98$0V958qMZrz#@)%q98(`Y;;P79OSP=r8hT*Da
z{$l!~xym2_7mdk*Vq+KxSZNY!=I(=2*H{<eNIt{81<uV1Ld;Hr3!R3@1zS+?j%C}Z
zlBE-t3I{d4F#hdm8WGS0>9(pMZ!a9|rZEMBZ{`^QS4kHndFu9|#;_m~$Dg(?Lh`X-
z*F4C)!KA`((&C6!40zR`D8D83#A4L2qT$T8j+=pNs0kBU8rwztt7oqtNzKxJ#`xoH
zh1rb4CC4(cnnngXqR7TsGw>p8=*`?O124|Wkfkq$oWb$?d#A|05DsK(6tWPB51+#8
z+Q%8L8+<V%$|hDHjy=hr!9{w|B}830usw0%A^#!P*SRK%0Ru3Hjr&IJTt6+y_2*E;
z{hH_7f(0J5wAs6G!<x*D3?t0mH`L9^#%g;Rnbb{;`lz(j<fo-`?;fcgi*XCc+&%I!
z!O`i0j*eFPg@6YEj|{Eg+I{OJR@CmD%ey<mYV?a|5f_*EJHfQ*OWlx9IOeC}G*1sl
zx&MGrA!!_Rn54eg=ICf>T24gXyyi1?Qnhp!2xOH$)EL23bXCSeb!x}9U8tFScnTQD
z`VI*F;e^XJ!Xn$6@t*+VJ`9xq55p}8u@e~}aQ`gf{Nh6nmROL~b*{e4<tMQCSXp%@
z^QJNCjJ)0mmifo?g_2^7K^`%^XUfx9Cy#8)(o#<|N$rt)!!0gOf6^nD$vy6gMmdsN
zCPq|<P?Ib0x+L|~(_yF=ttjZqRqiq)Z1Ns)$6l5%|EAN3K1l4Fr-Sr4(LRWGwxS`P
z30Bt_Ck|t;^mOoTA&1n<0<cvZVXktOjDrYL2}*L@tBW)qfzu)n?cyHu^SePOg^#&E
z+!G!DbNh9-@AXjKJq_r4t*7GjuZ6xuH+*70!wOFcLC2hV&_=Nyp#2E&bNWDCKe0sh
zA<&dI0FdgPUaO!$<k-4Pfy;UHP>?me3xoh9d@b{Py&@k!@NdHWc>w1^7t@YFG=UO*
zA=dTT3<uW0eXvBX8W+PNFkoEb2$W&h=4xX8hSY(YRuFdf{{?hIaehW;=ZmzjKV~>{
z7YKn=p1tK^w0ywFNkG`u<&!~GC3p{n*wXrHjK$SqJntB_xfGR52!&cCC};(Fv0~F*
z#8lH~juqmn$$9_r*@D%w1lkhX9fG!lx2J1_5hf?Ce52F^DGHgT-qk@Z`C*}<LA0U}
zufoF?X?-fTKv2N7oM!|)-UEpU#(Em7mAr`woM-i&t;jP@P3+$~ZIem%H7ro+CuA`f
z=VXQT?&(@X!+TQ}+^(cen4a@B`jyYj^&Th9-$vJY-18iq#}z*fU9(TfEK<3<1kgXl
z&lDKFBa5ad=RI`ugk5UsMxsylHS?4dNfubCYDAns;@3+n!+}A#G`T@?A<G{Aeuqt@
zT21+`9&=!9dZfT)rW?CgBd7&83Ex7#I4k-@v(1d8RyCXCBK+~Lyda{34t*Sl4r-PL
zCKp~LCCvil$G+yy^Qot59-ruo(9@ijG}e5|LpNmYo2Eny_tEcL958xUl4y5UD*=p{
zIR4OWugQ<4>R&;I2U~tQ<Uj6@-v^C0I&$*&ICmvN{dC@AWl&c5ary*yr|k)5US*IE
z4MiSB3j@7##FYl1?Ttm@K%bXyV`oFE;vy!?`YWmQ;9E&Ecr7XzGW$5l)0%1eD%{9>
z93$oAME_jow>pgwR?O(87Wz1mrfUEJ>zToeeA;aprty2U#wTx@!mBD5_5#gw+~+RA
zjn_{tWsOa-dJTs~OWTc0g|SzVt)MJ%3U}zFP^NRf$S;qu@iS1GF3xZl!oGINFsH`R
zMS-yq-c@Gekfcnv^h+1FoygogoBFuNBgyw2Qg}JN1cASAuQ_MjLFpyBd61{k^`-1<
zdyo{3SK+bZGW4tBcF=&6dPSJI0fqAxe#@pJ4iUY+qlW0|i6*YqWXeN|>0J|qTZl3Q
z!v(vH?XibQtCIrh<jB*pARHs2yH#Z_i)BUaMdj^P+qb|#+HcvUvt*Ufs^CyGzTA+&
z<xLMDNE5rQg66n$Eb3VjdY`g2h4tzbZ2^or7E<*oL#K2n^~H9E^tRPE{t_eai%7o|
zXEITwHB;t6fLMxV@Wga{;)(=C>j7v|G<3)-&qLLT{QA{b)UO(^1bTPO!d;?A_3kXN
zM0lZqqN$?x#Aq*<b|^smDS-(bys_=*0Nr(nb9k&QS%&%~?<{vpLi1&A^|O}m^bPHb
zulgUCqCX#;+Q<uS`li37&`Z>fL8Lt|O;o1dI4$28I2<ThTIAI@BH5#EsG{bCfBh=l
z`oj)<(Ik2ci}C<p<ku<a>(t=-Ai{kuS;V8P*OPh)W_mTdeC>^5GyRQQ4(X|QoDq~I
zbdhp+{C(9pr3L<r)Sk1Jgf9d%yWFInre=^}{<R=03rUJxXJl(`8d5pLXb;J7TJ0+B
zqXWbuj6MqN@svj)E>g({91DYArhWBw`UcI6#|YagW+A*ZBY>Y`g{I0S%i}05JrMZa
z4W{cUHdAH&QXMOHgUk`p<{oTEXkMd<08*7qp5|<LESZ_HzzM-PB2HCg)J#ROGS2d=
zHA0RV1bH)iyNR#C+ik*m@BU7z6Ga>sF&k*SxsY{{@2bf*_NQ-R!s`UNWmg&bfLEw6
zOb`zyZzZY%m8=)-?OyX-NP#OegE+><;@;|JpDRom3hSeP^#po=L(HEDZMJL}3LzfM
zYoQ%wQfuTp-@!Lxyu?8#A(}UFx8{NV!|%}^s#FN-nZ4OtQY|_Aj=m#Q$C>amDEs#r
zlZqQ-BEx-2UbZ#iHrCC23w@)4nj`s8l=+As)T(Fzj?1>VER$?0&(X#Io@BcXA!~`P
zvuP*l^yAM2THNl_%DFxaOAnbD$$k1Q4!r6dO`?HHP&Cu96I6nTrqG{mompH6m!s+N
zlj94y!SV*+{G*Wr)&M}>zo2~4I!1&DzVh)Wys(A)E@vaGY2N#aP<IG;8`3fw)b3PO
z>^FF)Jw$42?j-F+VAWNjjEc1-Kj>Hurr|5z<WDfP0()h8x+bq%c&88zD-qy}xDSLm
zSJyk@1_csD+~->h(T_?f9%UTy2A+{SQ-<`5^WkgNnb9{?YNI~>0e7ztSz$W>GinuF
zseCb-5zqsCmLa3X!g3oi{}*!tj@em!0G;*LPk0%K!C-33Tnb?9!cL9XthlQE=sw*y
zarP`u_ZUMm+>|}~%Ziu!0Z(&2Fu)X9Gc-V?`?ytQ|6K6DLks@hT%4dm+~D_pSTC*t
zf~dJ^u;Dr}>ATT(w%)C<PqnBO+rOB^nHkw0uMe@e$pvpPoSIbNrMkh+*a5~NQph12
zCP(iDebrF;HAQiiJgRa?KKTPlD)mAE`gm;A!?>W|*GG4e{hUvRx30bPhJLD<AZ?(M
zDH6QZ+o<ZLt0Jux><peDeW(jGH`#dgE!7JK#^;$s$6Y1!$R|j|RJjNv!2LV=Ij1Z+
zxBvBarHOMOv+Q$R*!T&i?vjNZ@^F0(<NZcZSHa&rKA!X$#=Ci3P<9*u(qM{US+cGy
zQe{Q3vYz6jG!Trw(ae*GZsLP1c)<W46IoAFHWh8m>4V*vosuOI3+FdR3fg%vYPH)8
zJ(DAq$^hSR756(4AyX9skk@n*qZAK;pHms|0bK?&%;VJ*RbMcrels21>`Kd+YAns1
zm_LeVeRT~NuQwrM)9|dzWa>etjzcNN{8JM}vM~kQPT_gBV6`c75AbPcvC2`Orzj7o
zvIwoac+G>~#C~k{#(TFpg1F0IUoGFE)4B~f)W_8J(w&x53Rk|hQpm8mjxA%Jk1oa@
zC=K0{8a@Dc?sPVHn*quvonNV;)4!C(HdIXr?YwP6dcCV-BW`o1DMAByA_J!qMd4p-
z=fL1m9C6yj-VUk9Rq1Z5qoiqLF?!YXw$-KTK)-x=Iyjgwm7t6abv>?7rTl49+Js%v
z@-1r0gF(adLfUwItRS88Ih6$me7xtF_`0b_La!o@m;}aMC9+nH)2}ipcpm>cR1`gG
zBxWN!7v`8-iLNL5^1rfPq-DYHg^Md>DF}tX5ClPmdM_QeK@Fz~XL0mQ#1-{8Qq-qE
z;QSlV;R}lJS}X_#i*r{0P}MIvuZ_}2uI)Jjz+>CI=h&vGO5e2-bkJ13f8kZn97-~d
zNfw6d2o_#_-X^_?G^#B?)uAdc$M&*UY>%Gi-nc3#yGx=m&^3x;y`j_2v&s<e{fBvy
zW>oUqIQa1h;Pc^o(~R@2<#XS5BTNFk7G2@!j5!{5vLYs{cYJ;Ccp-G>Rwf&Y6JR2g
z2(?J;$PWC~NaxXqS{$NsyaYP%;FTesE~E*s?O%!(Al~SrJ8Qd}4|}fT4?v_1p<_JQ
zWx)@H5>{?Hv*2*U@#-ZE6Ik^8<t^$Lz`Y?X84`%7!M;F2yESx%<gXzf7!txdD-eT7
zfFsWG&0Fk7!8w!&Yt+W)f7-v5K|=qU<|+OWA>@TDMhKFg;+SIKsv{wb`=!_<b-?4i
z0s5$;trb(jQ~Wb}kjvoKdn!lf;tZ3>iwPL*yL8!hgMRf-Wrh$5wU&8oGCVE~u;1lw
z+LGXtD9MHQmW~&6adNgS_SLE#1O;2kAXu#reG5(G38b-)hk=+k;YEJ{ag;`4HDQXq
zM774ML-lKK#O7K8gv0kPG_j_a=q|C3MpSo=w7#jsfo>tG9j!;ZB&M`fVo4%u<TtR(
zu>=h2+%pf>%ygK;RD4}W0GtQLjZXhJQ3B%cQ3CCMHA>K#2OEHNhyT?`0qbAi!4EpO
zKj`QzfP=Uq35Q>|lkdnvv)5>h2bRv6P^!0YIb43u(XmKIXuUBnFD-2(>K7X*6FvFQ
z+#vtg+g%@rliCbf<0(`^7BPsGp2xn2>H73E=?4MEcdGw$Q4Th2%~>k~F1bJbfQw1b
z%c1!cd*qnqE<ApM1hKJMNonXNANH?UtxsQ)@_4?z0k*cR>98Y6>+`Db5~y?wFn^<u
zEN7m}ot%<lY34EBBo%*d2hzeU2_=z5h18Gz-OSJEunLu?eGym_WXBYzL01Nvo)z+1
zD9M4|?cTQ8xYBzwi-exudZUlGi;JZvcbe=xDMbL^WPC9_)r-J!<xg6|zUNu!utl4a
z)VR-SY5l-tW&l=Dmk^0vXr=(6obO^R<sQRcJe9ZzpTI?o!QO=x;M|1d`MU9$I^E<t
zK_jfc+NehoIs=(8;>%AEM-C~ROvf$=o91q$*!M<q|05nx=a~Uep>yg%OS(+6+@^<%
z!M*q;`{P@m@w2i#uLg7?d*yDq^e^9<v)?^$!kTjbsw>#?4<=7P17@`Qn=6C5sOWdE
zNQUgEmT3ec?@un^zsd!g3zR~RIU@V3y@au0M_5#Xo6{7nn~%K%B><N`#{-^{>1gdM
zq^W^^6_P~pJ#1PpKu(CPvhs3-tsCLYCQcLHm*}X(7<zPsRGNnYRT|XNfXQhl9*lkW
zdR(BaS1=$!r5tXZPutu~;y2K-Ss8>41F`)<NNUY%0?~u@n4^pAD+>%5pU>?#9;cr#
z#WozAvOPg1x0ehU{3)b{&L<~LVK3U+<`S}aZQt}23)zZX#)TKLArZGxzdtu?^gHH=
zyRhgAR_+=Osov^Z-NE|<;Q_{`8CUXTsSU58Foke$R)3y8f4|cJWVZUnPo*5GLl;hY
z<@jRjMftZ$597kl3xc^O2sKyf4TA8Pk$^QTR(ub5_1f8;4i+)t&I)Gw0MY-(QiKVK
z<%VUzy_wNRO|~up3nz}O)Kik&hWFD!_KMm=qLKp-ICtnHKio+aJMo?}>I;66QycmG
z=A>qSJThFI@yaOud*@tfHfqGhFNo)(T&C*qwC_~8vjK9t-A7zq$&+4BfETFP?s9K<
z$yM;JLYJC!b^5dwnRIg`&tEKK>~+Eg-!8OTokw}PIaZ=<j|+a%z}wUpT*FMr_ic=r
z@R))bv->EzDpkf`P~m^rzjfj-+{*hAP^kB4SuMKmhrmwMs=E!99sxU}gW{;NBrf87
zh5H;y(mBawTB&o%*;mf$s3lXBIt8;!0fNZekW12yndYhx)G-@_p86_$t<h31#WylS
z!>blT1Pw>yoEH4h17ju>dT1T_v-;{h+d(pSdyhvMz06GD9LJP_+takKRX2$Is&Aq@
zN!cRjxG9)*bM8^*6J7vjB2K8-&kR5BNIuYihBjYMISM&8ve3I!$b0(_3&>pkae9qD
zx@zfw<219aWb4Y8nOPf?n3LZIifqFNqyt7KF6TQfZ$>ojp!})j18F}_!lijFv-{?U
zNdpi=3HS7q4AYCgcxvkzmh$5O#Bqz!MV?YxuerL{FwwWAJ$WguD$YAq$F_S_?8h1w
zIayI|H94R8o!9!`LR#7h%Beh``I(#yVD7QM8wcW)8on=pEu>(VAL@4Ny7G2s7lApN
z6luM-o7A--T5hjZoLt|x%GcrB+^XZl0#xJPyV;VL!Y6F>*UzU+q-(1$eK%UM{b^j5
zm(nF+yHzvaG#7lyz3@c&Te>mE8##j#hu}!f^hrf_$hJ2A%FGCZSe!`=L+XK>^J<*t
z#bS~ziDbBGbu8q)iu{+nSI()YNSJ@0Kc9OVRpsB~YvdaWwX#!LQ<<vFH<CB)cNOZ5
zdm9ghZZO%1eM5gkmNHdQGoGnw4H<}nyw|~D`Y@*^R!LkXr|fCG5G*#L%E391*DMEl
z&8W6sHpm8F>zfE3LH-PkfLnB=IIhv7;ValkkJmWf4qtmws&cr=t<M<W<(_?laT)Vf
z0uzE;C7W||1|_@?Conc}%G2ngt-Yaj+=`nWg6Lkx{2E3{<2U0MPYLU<!&#8~O!i_Y
z6$6ROT0Px6#wdZDP&g95Z&A&raym&Gvz6{<*F+pgXP2swJ(<f!fLH(KU^5#$&<=6t
zmOfdo=4%)cvt<dh&rO(0wq08r+`@wj3ba3e_7`tVbzp_l`9p#AjNM8&?O?+|TD6Zb
zb^u7PHf@K=laop+)zE!LbiV4FDUzV|ln!Qk(a<%UOU%LFXK6cnhK15{(;$Z*e;S*f
zg-PX%ErKE$?B)PpS}}A0H<b<@!1W#J%8kWT_0`Rx$d)kt03+u!NgtQkGs5{ofueKy
z7&91LfuKGbYy$-bM3r_67_V=RJpp-vXwh(aeTw9YU@?S<K>yweMzo5#E&>(Ys?vW9
zuC~cwb;I4Q3LuQ-q@NxdC=n|iOAWA+mj_`V#~R3`nQ?}}Mo<WpbJHkbrwQV<KIZ#J
zs9#KaVE=EcV_^?KSQ~S&6$1O&0?4YynABjjNz!#*o3sTBf-;vwq{)Tbo6LBjdWPse
z?<!0++5UAL9-bA<fn2c%J6n>CH#Z}Usj~xF!g5)^tKc*h<o`sD7pbQ?2j;N>5xIuz
zq269oq!~B>A7G@Et5AYC<GOk6*~Rn}f0_SlgrAf8pUymG#fyl#9%G^`D3?{T3(QKG
z<*vlvB|*nxn_{9uiy%sH0JP@+Yy}&0zwyDN@j~7B*|wE@xa&@EexQ`}qXP8ql5@}@
zX>u4&4*;9}K<1sFFn0EW7_P%YTM|LtYN77WQ_Js$7C=tdx8*eYmCGcoXb^k+%#mWF
z-oU_6E@7;x6j{Ua&y#~1J{Y*K0mR{WCjI2RGC`+Pg^KY{xBL+sl)E>``=ySLf*tj6
zL_F#7c*D)TY0QrIH_(v5SxorZjxWUxI?DJP{Bc)>hW=&bdtV$#tRAtlBZ1g=Q&C8L
z7ortpUv3p}Ag^8qAYb^wOvyg*>&(A}|22(J-LD*Cjrc>&i-$)c4qCe9?0?s(F~j%@
zt;KX%`dKj_Y~5o55>M>}4Plj&z>)`Dr8B{1K}P=7EKHra7rWxxiK2L7<v$L2^ATbC
zV6W$1vVP@+5LC!|D_#)eUo&S49EOT1Fz8Hp!0*$bVd2dOEKuWh&87ueh+=3ubvjl5
z+BY7NZPyH6pMWLR-ei~Du-Sua^*M7!Rn2{wBE3g^Z_Qa#{;r!{@i#BE&yQe3>j`7S
z9i87ohG<J}ZgkdtKc}!D9v4x9=GC}Ro1YURiyV=Yu3%}2Zog|YCiI$@3o(!zq15Ap
zp}e5_BB<5C{22gMKCLuRFxs$zknAee^-*5~+VYVDXr5%Cw|YOm_+-npavEoAP~d$9
zyDrYh-O#U38FpP#&Eg2P|B17?mm9L-ADm5<zl>AU@@y$7*;$OX?DTYaWoYP!)QR!?
z$VCdIJ4AsbK-@}x;>37{Jw%?YthgSEq4Z6RhonKgO*};B?68Blm97xCk`M7P<)FG3
z9E_{|PjlxA>!A)*B%QM*J2^sJ&<hY3)C;0@9>Ax&&h<cCQ1$GrWM_MbS}B02mFf_`
zGcXT&e~>A6PNW3Y%Z1)wmKhrQnVOv?M>}U+Jv;^RMi*J1VdmX)f8__AhZ?pwHU>u_
zGAI*zAQ0khR%C>RvZ2|s^36$i4Gn`jvB9n@s`3a_H_RStI0&j!_ImDupIOWNfX|@u
zco-hfxSJxJpO#M9mr0oCMes6lFek!fZy~=XT~ZJ~ZV3IG5T~A8M0KFpdN99}Zhfs9
zI*s{BSV&IMK#Nm&zWp#b(h{ei(C%A~>W;8uRv;^?^QA2y6Z4yG1|7VL`vMvU(!u;3
z9RTUGcs$_;8Tk;%ayIk_lx15=Y}a49ex}{FdC-8g5&@lqmgTTsX!!$)bWqdsFi~%B
zmsGR_;=)ca!088hnu)x>BQ}eUy^7NYDoe6KM*Qh$5RvF73JM<mkZgsAj<iF^7Ubg~
zOY)_W_%z6I7+&+A1N8FfMA$!F4DKT|H&F~0bpl}eCgB*>X;jmx?AmzYDl0jX4J{)o
zxq(Wg9C_!?{>zJ?=~(POSm+*Q!xStA10`wGOzG6$0-PIXe&!z1j}jxz4eT|c(wUa=
z|IyyHhBbAiYdTJ~Q>J1^kt#K5wJln(SP@Vl#7e!4h_Q&Ga*2u*F<hi5;gS$-1u6(B
z6+z^Zq9V#IatQ%LvRehB1c+P{2oOz70)!-n5JGNypB-w?Gv~}R=Q;D|{5h;2xvcE$
zY~H=rx4!j#@B8s|CLD8R<~d~jyWK8{ou`1Z*y2Yt%Wl5I-(W<SPH!lE_l4=y>MV`e
z`}@oNf6kk_T5wnEQbve`{cWpX-a3M?K5t&IS(6^hKf~5ZZR@ECt01+Gn-!a}QJ$U$
zwyOoNv!aW}zk8HgU^#D?ENGd}qz5<t=o>;zr5ufR&6J}_tRXFu(mZwOzXT-I28yuA
zaz}V1=wAjTHm;YF&Ky;kppTxJ?f<U-_Ob~{%_XJ83dC<B78^zTeug^lDi18^R{}^N
z+9i_<Im4w0de~nu&<k|6*z9BzW7Z(_k)V(6@u+xc!cbvCI~~^HH_L~}Z^|ruc<E!*
zjZ~0(&>O$N81ROuRazbCUyLpXAyo01#B}$=S`GczKT0w9$gptP&fA}8vaWAs{;K-*
zhU?55^$e^z2aj$P%~!r6DI}&USa*Na3<76X0Z^dC1TKV%`{d3KEC#(ptop|S4F4AK
zz6#R)BaJh$4|rBqe(^<HDr_d7wavW}_WPu8Ozpn;Uj+Bj&V&ZaOrQGNIV(1eMfh_>
zyLmC##<QHq;hfbs^368U&!V#$1gj}MewKT?baKr$RATk`+*g{tYdMyv)V6!G22!1z
zbYdZ=d|NYvR^CjW8d{*T`cA5##E0CpzZZITovw+D+{9Z+d2jgTpCps$15@$rQx`3(
z-Je8yq$r7%?g9Bo^pw=tRWefY!wx<2pGhoN_esk+Iwk)iR_z)Y1HJA?VzMzqt-rZ^
zd*w3I9oC=|QOMCzI-c~D0+qqS@JKy5%P=DxK|0s3_+M+wZDmkZ4*>JNF*)m@3?{_h
z4eFrHxFKpN1HAVN`$R_Ca|Fa9c7v1$xzJz%!gGO0!if(9LtqI+zeIwrpLTt|Be7%m
zspq&CO-ki^5-zl49gPcVjgcUCb>ce0zofAwLg=kaVTubix{V7>)biYF%m+++BUCIF
z$W-%H(<ZV{2ozaOsNDlrQCPK`Eu-49nVLv+G0e*eMi|bMKQ#xvHr)-*%?k=*@e>km
zo)^*8b^?$c7RCfDo0ktrA=azAf|`iK-?yMNcAIZ964gJKw)o0o1>SgHZoNWN5LH4?
zG}d2FzYZU61q9cN(dix_t~xkSJWu{_856ib30(Z+o4R0Q+lqT{Cc?3YayYqh8Vrd~
z?}69o@9aJ;#1`jGzMZoq_@C@-;D^v~AzTn<N{n`1)2^n#36q7%*#0+5+T@S9ATpv6
zvJklmN!p%iioKsp+N5fPtFdIWb-@3SN4ZY~$-dXQP~qFq(rWl-SucoD-V{Bc{k76E
z_@viEA?MPiFCPD{sro*LLNsRm5!K8CLGl=6m$pT%%LqLuYIp|qtYZ%@n9f7`T|dRg
zhBC_>>ypGBw5p7drtlw0n1c|?CFi3b%QswEawph<z1{*K+;$Q_&w+rAmby6%<%{wV
z{D&Uljte2(2bn_1PR7K{7@^+RHz)@@|I?=wLjAbSMOOic%XrZXX@2*$e?Q&g<01l!
z2rMG7h`=HOiwG<tu!z7S0*eUzpCRxQ`;~uWq~gHTP#+K!<azz-re^>gc|4Jz9H&>2
z1dwoito`Z5vA3<z3@}p+{}U4S)s>#Z(kGFBZynbLM*URw`Bx_o<^9s}v%UW{CL<v*
zBqebC`1OxInfcqkB>_aMfWLfG9{c_~54>)Feds~u&P$i}{`vj2Cw3kRaJBj5#=B3u
zTH>h@bIA!P{I@($l-_)of!B47YT{&FV=X#TPl+|nIvdzq->C4BQG-LbH*UceG2PHD
zRk?FJ`Co2hG#_HP5zl^?@U7vT!v7uJnMu#AS<~>x)1kM((FW%n_bcaBeFUj<Fynl9
zS#A@(ZrVooSHD!{<3Ub;Lwo@j<Mw&~G50=ItP>_9w~4*l?jCjX6>R5JOY}zP3)KnX
z-o66crd5$IMSaO$&}1tj`}1@iKEKaFIgPXIo2sHWn#`By0I};OKX;^cSrTG21(awA
z@JBCtvfkHdsKNIKYisa+aK|Ou)<>_W9v_RAcFvBTR?OzAdxu-(Vb(O9i>BY&1=vbV
zK5gPZ6LX8t`j%c>`KN<qa%f>?cJ~24Y)$t-C<@q)PCAt^H~Z2t5SI~w>$lFP93O?w
zn}{!8^Z75^N4lmTzZ}*SRN&f=%EvCiKRExCzs7?Lku_#0?2P6Ru%N)a^wyS<;1Ul{
z+gOQR>2`CECeEzx`0fi*X9oeb1F!Atl4!EBTn^K_=k_#q9<l7{EN%ZDpTzpQ$_yzH
z^l5H(OrOqpoMFT>0jBt~CwfB-p(u(G_T<USY<u_2xFu=jIy3r0c%_>sp1DiAmWv3v
zS-ZI>kbf@(MHSk+%g4?MpKnzNR@@T0f57(ix=@s`s%CP2Uf&SG^%9J-HbS^0P@&~N
ze4Lu2-A>=7@8v)ycPvBiaV2VgPyFa^@7dFbgG%XD5oPxyP^-k=mAb5H72kOm&g)sG
zcH$;3qN>-~O)8gy4~AItDLOMN+5E);zxE(pfN)EoO?Lvb@0eS}rZKH?eylVOn10sZ
zsn|HxxQ#h@IdeuNuP+Z!=G%6@mo%JGunFG+`sZnmhP6}$jDM%9@++HP-anL5ofsYX
z1%0qbox_bCl>38;-%yjohEG&t>E`N0WV>Q%9VNP(hmY7aIAW*sn*$x0<mFO%s;q=I
zHgvB-Auk)QwOh++a*~`*xRk9BjGPsgE*Gp)*dIRuPHqs_5KglM8dIf`I&Jp))rd=B
zjpvpJ;IN}SoGIzHg0;uit!vPyAw=EW;Nlyp&Bzs)kN_#ofM*H)tBQ{)_l1TInqj5b
z>q|;*E@8~{%D;xFUW2~}oN;fhd>DQhwGHOOu~X{vltzxyc8bKwZk~zG`ff@;$DHPR
z_G6QU6oy92Jiebc*RJb3ks2dE@7cItz=MAhySzQ(q0-<>urZ&>Fi?jS!<mLQ!&m{Y
zYARL5!X6n3FC65nbP~BV;`up6ma~5f;K6Spx&v5N<@}E5m{awJ^p@naCBEa7^2QPR
zrl#0Nee29T<a5fl148%3(<}iUxLu05mj3#}1knVgKOaoI^=!ECocKyi46t7eVgEAN
z0kPGe$F)9T?ndobY|J*s-lJ#Vaqdj<46s)rIjF!McT#Ic97rFis=kj!&ARoFd?wBn
zLyuUX`I?3-NEimFvjZ$gGo4xx2RhEGs@Ltt<=-tZ;GLZ3C^OrkOf!RSZaTp1%rp!>
zsnINXL^Ly|h4MLr&IR~ru7pNm_X(S6{91lQr^eciMpJ1k#=+#?`rE|1SWL0UR<}6O
zD}LRbu$6nssr7D!s)_XgZx=3@<gO~Z8Ihs$!+AxG4~PmRhRAP}1&?bqR{1H=Dv4_H
zwn-wbaiXI$lUr?L*1@!uw4`mGJ~)J5Fyhz=>X7=Co966i`Oz3n%WmdWnX8g@4vpog
zE2?_A#x*h|xqZw`xurZcaPbbB-8*t8UPDVmxGk?qXotDEaUiGL+OeZZ85Pv2XqLnu
ze;~A#w9jOzbw_kKJR8yqsOD=rGGxDu2p)+FEOtKvze5`fNf%>FW4~mvrogqc`atuw
zelm1@Xr553((kGZp;*_%89p9OP5s&{p|Kk{hbGInt16!Yh?sTGLPhGd2<m>MWE(XX
z=g=vQg`o%tiQb@f1xZh$DHhvlX|uS-i;y%FzN690h^9kPJnJ%75Pb#guz63W&u44#
z3}7kTkJh{;;up_>=g(US>;&3fXS<jEh&E2z6wMGgVijWyt1zEhq2oyjAqbh!&$#?b
zj52HF@Zi>}UKYQ0-ea|9$*u`1de#L2?L6iY69peSG@iB0>g34)WAR#<Xsj@4J(Gml
zSIk=>i<{>7KcYDF%`qL<Nv}GYSvS^0$Hsq1+HpiDE-7^AGo})@VBG=hx)VmxXyaE<
z=rw-rc6K-^zdl)$6_!d(lkNziXkZR#{KU71v#|LLuFp3y#XRHr2PTBnPUsIS)s#{@
zbTLn!>rYIm-U2mv0f~kBQu@FhFKY8fIwJGI!9io3(d+qF)9gEXL)gMR3>*IiOV3hd
z@&Xav{s!Qn=4`1dEGhMfjtBRrIAPJH77Jk#4r}95)(14LHKUpw5fPN9{zp~K>oh4f
zbssuO1e&;%+aqzF`S#=jOn#?I-;Ap3g1Z>vx$8+x@6bwa<vO}Ro-6B39nFyp*>fEB
zOYj0R!#jq07!7{S0&|_p;XgWp`xU@K2yDr8O!y`<%%bSj5Iwk5%LtLnF}hH%*-uzD
z^o+8Xb<YVTFGP9<yW^HH%)FEDdf`=@ivt<u0(P~{^K&B(mTuos65S9z(WXW+FPP@j
z!YU4~<CYqg`!*=P&P_OtDuS~!R(S*+2Ap81OVb#SLx!~ifR!{DmE?m9weTKKx`qg4
zQ3&{zzXNFDo=q}Xs@fZf9J?i=Nif}{ibu9ykZPM|vy%+I*|Wm4zQVi;(!E?z9z9v4
zndQ3m38Q?4KUV;w`=DJx$#I-X?Ag0OZ$4`?25R49h&>v!4L&KM?Z*X$zM)nXq$U9K
zYYRkqkZGB7iN3~_YN2aBtZcIsH~5ICT#(gHu3V6>&tCogTW>xSS)}bhd8;i&ANEn^
z(eTq<j0p)p^}V_F#jh<w^8b63IEo;A+Om3B^yEYDfI>coC&wjZ3{N+f+DeMKAFcQq
z?yxegNNR!IcpnD)F)CXqqFqWn2Yj011Zt@po-o+?-pyepm6mMX>_kIZKV0@`y6)w4
zU5^Zs*>kWtQEL!IA;I@UibBbimW*>qrcCY2g|hlhQrhLFc~buDZ@v-Z!3CL?6^bd~
zdx?SEAk`H7W}ywbR;ZB4%3(XUeGdhdA{`E=cn-YODfB91)`KN?K5iX~C?T|14z11>
z6&thml7)POKqxS#sZ2&RC_s+Vb!-v{kmfK#^AJRYT!6W8I)s}S02;b>cr*HgWN3iQ
z1S9N_CNZQpQ;Y-dXo8uUz1zE;{+Cp>Gpy)m(X<+sxeZGcrw9N*ybLf6s!795@)Ee@
zUrX$?exQX8D$zodhLS2ugUr%$QgX_CM5<OJ)OVT~HYx=A#h&lsD}1=rtp;y#@GsHa
z7q$d6$6A}xRGGeceCSw@1heUT<MsGJ=k8!{pn1E?ML|?-)Nx7jA1gO~?Rzhk9hHd8
z7RV0Yu7d2}MJk0_a4x54RlHGn&S^t?0y{n9iM@NwD)G{H^~AR+(1ir-Z&QPeEv~K}
z^g~swQ?;c$6|G1cLyJ9II2Zj+cS5_l-T~uC4^xT;$_s}_W@$NOx{`7%&yyk(go5ee
zox+<1NM6y5f+NBBVY#J2DHpvNfse}xg4@N(8#{0TBvb<+majP>-udniuajfCc-=c3
z2S?}?{MrF**2M-QD$v=f_0g82MJ-!VbbgS%Jjon-)~To=FKalln9r)ohU-c_^y_8i
zmP;t!TgN*cq>N83OIzpEm#`!5%VIhD!g~sHS&=vpbA(g9$9S3{k~h2hP6FttZVl7Z
za_pld!UxaI7xAk0C02x2t>AzF>+G$zr5KgbPAe;NuK5*j-;ppq!EfumL#g)baYtsw
zFHy!iVb3|)oY^#1f<>>oC5y9>MEY_aZMrufSS{TBoY0#49Beh!`2^lO*AUMWuxfv~
z&n~d%u>6Vnp29Dt8XRJA?%Lx@0;$CuFd)nBm^t|%)bnWb@`vu!KsD{%bpl`)G4t^3
zRYFJ}7HCmb5kaA?vQ2yW*_6F>3f_%0!~QtzKM>5z%!Zv&fnH?KpUP)R-iaS^buYbu
zN+a$$)yAusihSl@NpnUB9<f+E-v2x(8??9qPwpJwUqvh$8R2o_P*OW`1=7*tY7lP&
z;^gYRUOC<;DluHPcDeSrAra5k9-|}%6RQKLN6@u&o&&ea+>GE*-SgSL+KDC#o*0a+
zNCgvFsp~C3^KF)zJ+ScgAdp@D26Qd5OGDiH#?>HT=0d%!(t4$pUJ$yY)Nl&|ItMKd
zgQa<V5Zz5tgoDudd4~@6a=r<=D(HeJ$HaPQCC(ip#Wt@L@8rdTq+;Wi3GvQlks$QL
zsn_hwhRpY^tnS}4y$|BKt+QVlg$4V`Q0SzE+-7Mf&F|e9`u*kN<01l!2rMG7h`_&v
QzzQ?E_2H9z*yphN4<R+&>;M1&

literal 0
HcmV?d00001

diff --git a/tests/f_dirdata_optimize/name b/tests/f_dirdata_optimize/name
new file mode 100644
index 000000000..1649a3702
--- /dev/null
+++ b/tests/f_dirdata_optimize/name
@@ -0,0 +1 @@
+optimize directories with dirdata
diff --git a/tests/f_dirdata_optimize/script b/tests/f_dirdata_optimize/script
new file mode 100644
index 000000000..52cf88ed2
--- /dev/null
+++ b/tests/f_dirdata_optimize/script
@@ -0,0 +1,3 @@
+FSCK_OPT="-Dyf"
+SECOND_FSCK_OPT="-yf"
+. $cmd_dir/run_e2fsck
-- 
2.43.5

