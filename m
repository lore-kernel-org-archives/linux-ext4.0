From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: [PATCH 5/5] tune2fs: update journal users while updating fs UUID (with external journal)
Date: Thu, 10 Jul 2014 18:35:08 +0400
Message-ID: <1405002908-16332-6-git-send-email-a3at.mail@gmail.com>
References: <1405002908-16332-1-git-send-email-a3at.mail@gmail.com>
Cc: darrick.wong@oracle.com, adilger@dilger.ca, tytso@mit.edu,
	Azat Khuzhin <a3at.mail@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:39422 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbaGJOfe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2014 10:35:34 -0400
Received: by mail-la0-f51.google.com with SMTP id mc6so6112825lab.24
        for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2014 07:35:33 -0700 (PDT)
In-Reply-To: <1405002908-16332-1-git-send-email-a3at.mail@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we have fs with external journal device, and updating it's UUID, we
should update UUID in users list for that external journal device.

Before:
$ tune2fs -U clear /tmp/dev
tune2fs 1.42.10 (18-May-2014)
$ dumpe2fs /tmp/dev | fgrep UUID
dumpe2fs 1.42.10 (18-May-2014)
Filesystem UUID:          <none>
Journal UUID:             da1f2ed0-60f6-aaaa-92fd-738701418523
$ dumpe2fs /tmp/journal | fgrep users -A10
dumpe2fs 1.42.10 (18-May-2014)
Journal number of users:  2
Journal users:            0707762d-638e-4bc6-944e-ae8ee7a3359e
                          0ad849df-1041-4f0a-b1c1-2f949d6a1e37

After:
$ sudo tune2fs -U clear /tmp/dev
tune2fs 1.43-WIP (18-May-2014)
$ dumpe2fs /tmp/dev | fgrep UUID
dumpe2fs 1.42.10 (18-May-2014)
Filesystem UUID:          <none>
Journal UUID:             da1f2ed0-60f6-aaaa-92fd-738701418523
$ dumpe2fs /tmp/journal | fgrep users -A10
dumpe2fs 1.42.10 (18-May-2014)
Journal number of users:  2
Journal users:            0707762d-638e-4bc6-944e-ae8ee7a3359e
                          00000000-0000-0000-0000-000000000000

Also add some consts to avoid *magic numbers*:
- UUID_STR_SIZE
- UUID_SIZE
- JFS_USERS_MAX
- JFS_USERS_SIZE

Proposed-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
---
 lib/ext2fs/ext2fs.h     |  2 ++
 lib/ext2fs/kernel-jbd.h |  6 +++-
 misc/tune2fs.c          | 90 +++++++++++++++++++++++++++++++++++++++++++++----
 misc/uuidd.c            |  3 +-
 4 files changed, 93 insertions(+), 8 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 1a96f24..f9e12c8 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -45,6 +45,8 @@ extern "C" {
 #define SUPERBLOCK_OFFSET EXT2_SUPERBLOCK_OFFSET
 #define SUPERBLOCK_SIZE EXT2_SUPERBLOCK_SIZE
 
+#define UUID_STR_SIZE 37
+
 /*
  * The last ext2fs revision level that this version of the library is
  * able to support.
diff --git a/lib/ext2fs/kernel-jbd.h b/lib/ext2fs/kernel-jbd.h
index 130c3a2..a9cdc30 100644
--- a/lib/ext2fs/kernel-jbd.h
+++ b/lib/ext2fs/kernel-jbd.h
@@ -186,6 +186,9 @@ struct journal_revoke_tail {
 #define JFS_FLAG_LAST_TAG	8	/* last tag in this descriptor block */
 
 
+#define UUID_SIZE 16
+#define JFS_USERS_MAX 48
+#define JFS_USERS_SIZE (UUID_SIZE * JFS_USERS_MAX)
 /*
  * The journal superblock.  All fields are in big-endian byte order.
  */
@@ -233,7 +236,8 @@ typedef struct journal_superblock_s
 	__u32	s_checksum;		/* crc32c(superblock) */
 
 /* 0x0100 */
-	__u8	s_users[16*48];		/* ids of all fs'es sharing the log */
+	__u8	s_users[JFS_USERS_SIZE];		/* ids of all fs'es sharing the log */
+
 /* 0x0400 */
 } journal_superblock_t;
 
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index d1fa6ba..9f5b96c 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -212,6 +212,18 @@ static int get_journal_sb(ext2_filsys jfs, char buf[EXT2_SUPERBLOCK_SIZE])
 	return 0;
 }
 
+static void *
+journal_user(char uuid[UUID_SIZE], char s_users[JFS_USERS_SIZE], int nr_users)
+{
+	int i;
+	for (i = 0; i < nr_users; i++) {
+		if (memcmp(uuid, &s_users[i * UUID_SIZE], UUID_SIZE) == 0)
+			return &s_users[i * UUID_SIZE];
+	}
+
+	return NULL;
+}
+
 /*
  * Remove an external journal from the filesystem
  */
@@ -266,11 +278,8 @@ static int remove_journal_device(ext2_filsys fs)
 	jsb = (journal_superblock_t *) buf;
 	/* Find the filesystem UUID */
 	nr_users = ntohl(jsb->s_nr_users);
-	for (i = 0; i < nr_users; i++) {
-		if (memcmp(fs->super->s_uuid, &jsb->s_users[i * 16], 16) == 0)
-			break;
-	}
-	if (i >= nr_users) {
+
+	if (!journal_user(fs->super->s_uuid, jsb->s_users, nr_users)) {
 		fputs(_("Filesystem's UUID not found on journal device.\n"),
 		      stderr);
 		commit_remove_journal = 1;
@@ -2426,6 +2435,68 @@ static int tune2fs_setup_tdb(const char *name, io_manager *io_ptr)
 	return retval;
 }
 
+int
+fs_update_journal_user(struct ext2_super_block *sb, char old_uuid[UUID_SIZE])
+{
+	int retval, nr_users, start;
+	journal_superblock_t *jsb;
+	ext2_filsys jfs;
+	char *j_uuid, *journal_path;
+	char uuid[UUID_STR_SIZE];
+	char buf[EXT2_SUPERBLOCK_SIZE];
+
+	if (!(sb->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL) ||
+		uuid_is_null(sb->s_journal_uuid))
+		return 0;
+
+	uuid_unparse(sb->s_journal_uuid, uuid);
+	journal_path = blkid_get_devname(NULL, "UUID", uuid);
+	if (!journal_path)
+		return 0;
+
+	retval = ext2fs_open2(journal_path, io_options,
+			      EXT2_FLAG_JOURNAL_DEV_OK | EXT2_FLAG_RW,
+			      0, 0, unix_io_manager, &jfs);
+	if (retval) {
+		com_err(program_name, retval,
+			_("while trying to open %s"),
+			journal_path);
+		return retval;
+	}
+
+	if ((retval = get_journal_sb(jfs, buf))) {
+		if (retval == EXT2_ET_UNSUPP_FEATURE)
+			fprintf(stderr, _("%s is not a journal device.\n"),
+				journal_path);
+		return retval;
+	}
+
+	jsb = (journal_superblock_t *) buf;
+	/* Find the filesystem UUID */
+	nr_users = ntohl(jsb->s_nr_users);
+
+	if (!(j_uuid = journal_user(old_uuid, jsb->s_users, nr_users))) {
+		fputs(_("Filesystem's UUID not found on journal device.\n"),
+		      stderr);
+		return EXT2_ET_LOAD_EXT_JOURNAL;
+	}
+
+	memcpy(j_uuid, sb->s_uuid, UUID_SIZE);
+
+	start = ext2fs_journal_sb_start(jfs->blocksize);
+	/* Write back the journal superblock */
+	if ((retval = io_channel_write_blk64(jfs->io, start,
+	    -EXT2_SUPERBLOCK_SIZE, buf))) {
+		com_err(program_name, retval,
+			"while writing journal superblock.");
+		return retval;
+	}
+
+	ext2fs_close(jfs);
+
+	return 0;
+}
+
 int main(int argc, char **argv)
 {
 	errcode_t retval;
@@ -2714,6 +2785,7 @@ retry_open:
 		int set_csum = 0;
 		dgrp_t i;
 		char buf[EXT2_SUPERBLOCK_SIZE];
+		char old_uuid[UUID_SIZE];
 
 		if (ext2fs_has_group_desc_csum(fs)) {
 			/*
@@ -2740,6 +2812,8 @@ retry_open:
 			if (i >= fs->group_desc_count)
 				set_csum = 1;
 		}
+
+		memcpy(old_uuid, sb->s_uuid, UUID_SIZE);
 		if ((strcasecmp(new_UUID, "null") == 0) ||
 		    (strcasecmp(new_UUID, "clear") == 0)) {
 			uuid_clear(sb->s_uuid);
@@ -2775,9 +2849,13 @@ retry_open:
 				goto closefs;
 		} else if (rc != EXT2_ET_UNSUPP_FEATURE)
 			goto closefs;
-		else
+		else {
 			rc = 0; /** Reset rc to avoid ext2fs_mmp_stop() */
 
+			if ((rc = fs_update_journal_user(sb, old_uuid)))
+				goto closefs;
+		}
+
 		ext2fs_mark_super_dirty(fs);
 		if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
diff --git a/misc/uuidd.c b/misc/uuidd.c
index 5a53138..02ca6be 100644
--- a/misc/uuidd.c
+++ b/misc/uuidd.c
@@ -36,6 +36,7 @@ extern int optind;
 #include "uuid/uuid.h"
 #include "uuid/uuidd.h"
 #include "nls-enable.h"
+#include "ext2fs/ext2fs.h"
 
 #ifdef __GNUC__
 #define CODE_ATTR(x) __attribute__(x)
@@ -236,7 +237,7 @@ static void server_loop(const char *socket_path, const char *pidfile_path,
 	uuid_t			uu;
 	mode_t			save_umask;
 	char			reply_buf[1024], *cp;
-	char			op, str[37];
+	char			op, str[UUID_STR_SIZE];
 	int			i, s, ns, len, num;
 	int			fd_pidfile, ret;
 
-- 
2.0.0

