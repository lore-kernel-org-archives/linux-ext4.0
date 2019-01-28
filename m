Return-Path: <SRS0=NyoO=QE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5267C282CF
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 21:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90B8321738
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 21:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbfA1VdC (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 28 Jan 2019 16:33:02 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58274 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfA1VdC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jan 2019 16:33:02 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 54E0527FB86
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        sfrench@samba.org, darrick.wong@oracle.com,
        samba-technical@lists.samba.org, jlayton@kernel.org,
        bfields@fieldses.org, paulus@samba.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RFC v5 10/11] ext4: Implement EXT4_CASEFOLD_FL flag
Date:   Mon, 28 Jan 2019 16:32:22 -0500
Message-Id: <20190128213223.31512-11-krisman@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190128213223.31512-1-krisman@collabora.com>
References: <20190128213223.31512-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

Casefold is implemented as a special case of the fname_encoding feature,
thus requiring it to be enabled.  This design mechanism works
semantically fine, because we consider that without an specified
encoding the casefold  operation cannot be defined.

Despite the common core implementation, the Casefold setting can be
applied to directories individually, making entire subtrees of the
filesystem case-insensitive or not.  The flag is set as an inode
attribute applied to directories and inherited by its children which
states that the directory requires case-insensitive searches.  This flag
can only be enabled on empty directories for filesystems that support
the encoding feature, thus preventing collision of file names that only
differ by case.

Changes since v2:
  - Rename sbi->encoding -> sbi->s_encoding.

Changes since v1:
  - Moved the CASEFOLD_FL to prevent collision with reserved verity flag.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/ext4/dir.c      |  5 ++++-
 fs/ext4/ext4.h     |  9 +++++----
 fs/ext4/hash.c     |  5 ++++-
 fs/ext4/inode.c    |  4 +++-
 fs/ext4/ioctl.c    | 18 ++++++++++++++++++
 fs/ext4/namei.c    |  6 +++++-
 include/linux/fs.h |  2 ++
 7 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index c8d2669e17dc..8a9343811d48 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -684,7 +684,10 @@ static int ext4_d_hash(const struct dentry *dentry, struct qstr *str)
 	if (!norm)
 		return -ENOMEM;
 
-	len = utf8_normalize(um, str, norm, PATH_MAX);
+	if (!IS_CASEFOLDED(dentry->d_inode))
+		len = utf8_normalize(um, str, norm, PATH_MAX);
+	else
+		len = utf8_casefold(um, str, norm, PATH_MAX);
 
 	if (len < 0) {
 		if (ext4_has_strict_mode(sbi))
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 009fab63c8e1..44b71e15e40b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -400,10 +400,11 @@ struct flex_groups {
 #define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF */
 #define EXT4_INLINE_DATA_FL		0x10000000 /* Inode has inline data. */
 #define EXT4_PROJINHERIT_FL		0x20000000 /* Create with parents projid */
+#define EXT4_CASEFOLD_FL		0x40000000 /* Casefolded file */
 #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
 
-#define EXT4_FL_USER_VISIBLE		0x304BDFFF /* User visible flags */
-#define EXT4_FL_USER_MODIFIABLE		0x204BC0FF /* User modifiable flags */
+#define EXT4_FL_USER_VISIBLE		0x704BDFFF /* User visible flags */
+#define EXT4_FL_USER_MODIFIABLE		0x604BC0FF /* User modifiable flags */
 
 /* Flags we can manipulate with through EXT4_IOC_FSSETXATTR */
 #define EXT4_FL_XFLAG_VISIBLE		(EXT4_SYNC_FL | \
@@ -418,10 +419,10 @@ struct flex_groups {
 			   EXT4_SYNC_FL | EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
 			   EXT4_NOCOMPR_FL | EXT4_JOURNAL_DATA_FL |\
 			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL |\
-			   EXT4_PROJINHERIT_FL)
+			   EXT4_PROJINHERIT_FL | EXT4_CASEFOLD_FL)
 
 /* Flags that are appropriate for regular files (all but dir-specific ones). */
-#define EXT4_REG_FLMASK (~(EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL))
+#define EXT4_REG_FLMASK (~(EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL | EXT4_CASEFOLD_FL))
 
 /* Flags that are appropriate for non-directories/regular files. */
 #define EXT4_OTHER_FLMASK (EXT4_NODUMP_FL | EXT4_NOATIME_FL)
diff --git a/fs/ext4/hash.c b/fs/ext4/hash.c
index 12a7b0eda132..e106c4727961 100644
--- a/fs/ext4/hash.c
+++ b/fs/ext4/hash.c
@@ -283,7 +283,10 @@ int ext4fs_dirhash(const struct inode *dir, const char *name, int len,
 		if (!buff)
 			return -1;
 
-		dlen = utf8_normalize(um, &qstr, buff, PATH_MAX);
+		if (!IS_CASEFOLDED(dir))
+			dlen = utf8_normalize(um, &qstr, buff, PATH_MAX);
+		else
+			dlen = utf8_casefold(um, &qstr, buff, PATH_MAX);
 
 		if (dlen < 0) {
 			kfree(buff);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 22a9d8159720..9908d7d98b6e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4745,9 +4745,11 @@ void ext4_set_inode_flags(struct inode *inode)
 		new_fl |= S_DAX;
 	if (flags & EXT4_ENCRYPT_FL)
 		new_fl |= S_ENCRYPTED;
+	if (flags & EXT4_CASEFOLD_FL)
+		new_fl |= S_CASEFOLD;
 	inode_set_flags(inode, new_fl,
 			S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|S_DAX|
-			S_ENCRYPTED);
+			S_ENCRYPTED|S_CASEFOLD);
 }
 
 static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 0edee31913d1..ef4ffe681836 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -231,6 +231,7 @@ static int ext4_ioctl_setflags(struct inode *inode,
 	struct ext4_iloc iloc;
 	unsigned int oldflags, mask, i;
 	unsigned int jflag;
+	struct super_block *sb = inode->i_sb;
 
 	/* Is it quota file? Do not allow user to mess with it */
 	if (ext4_is_quota_file(inode))
@@ -275,6 +276,23 @@ static int ext4_ioctl_setflags(struct inode *inode,
 			goto flags_out;
 	}
 
+	if ((flags ^ oldflags) & EXT4_CASEFOLD_FL) {
+		if (!ext4_has_feature_fname_encoding(sb)) {
+			err = -EOPNOTSUPP;
+			goto flags_out;
+		}
+
+		if (!S_ISDIR(inode->i_mode)) {
+			err = -ENOTDIR;
+			goto flags_out;
+		}
+
+		if (!ext4_empty_dir(inode)) {
+			err = -ENOTEMPTY;
+			goto flags_out;
+		}
+	}
+
 	handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 99d936a1c58e..66fbdebcb554 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1261,7 +1261,11 @@ int ext4_encoding_cmp(const struct inode *parent, const struct qstr *name,
 	const struct unicode_map *um = sbi->s_encoding;
 	int ret;
 
-	ret = utf8_strncmp(um, name, entry);
+	if (!IS_CASEFOLDED(parent))
+		ret = utf8_strncmp(um, name, entry);
+	else
+		ret = utf8_strncasecmp(um, name, entry);
+
 	if (ret < 0) {
 		/* Handle invalid character sequence as either an error
 		 * or as an opaque byte sequence.
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c95c0807471f..69abaca207c0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1947,6 +1947,7 @@ struct super_operations {
 #define S_DAX		0	/* Make all the DAX code disappear */
 #endif
 #define S_ENCRYPTED	16384	/* Encrypted file (using fs/crypto/) */
+#define S_CASEFOLD	32768	/* Casefolded file */
 
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-system
@@ -1987,6 +1988,7 @@ static inline bool sb_rdonly(const struct super_block *sb) { return sb->s_flags
 #define IS_NOSEC(inode)		((inode)->i_flags & S_NOSEC)
 #define IS_DAX(inode)		((inode)->i_flags & S_DAX)
 #define IS_ENCRYPTED(inode)	((inode)->i_flags & S_ENCRYPTED)
+#define IS_CASEFOLDED(inode)	((inode)->i_flags & S_CASEFOLD)
 
 #define IS_WHITEOUT(inode)	(S_ISCHR(inode->i_mode) && \
 				 (inode)->i_rdev == WHITEOUT_DEV)
-- 
2.20.1

