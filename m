From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: [PATCH 4/4 v3] tune2fs: update journal users while updating fs UUID (with external journal)
Date: Mon, 28 Jul 2014 11:43:25 +0400
Message-ID: <1406533405-6899-5-git-send-email-a3at.mail@gmail.com>
References: <1406533405-6899-1-git-send-email-a3at.mail@gmail.com>
Cc: tytso@mit.edu, darrick.wong@oracle.com, adilger@dilger.ca,
	Azat Khuzhin <a3at.mail@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:53847 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaG1HoG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2014 03:44:06 -0400
Received: by mail-la0-f43.google.com with SMTP id hr17so5131921lab.16
        for <linux-ext4@vger.kernel.org>; Mon, 28 Jul 2014 00:44:04 -0700 (PDT)
In-Reply-To: <1406533405-6899-1-git-send-email-a3at.mail@gmail.com>
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
index ab57534..d3a34d5 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -39,6 +39,8 @@ extern "C" {
 #define SUPERBLOCK_OFFSET	1024
 #define SUPERBLOCK_SIZE		1024
 
+#define UUID_STR_SIZE 37
+
 /*
  * The last ext2fs revision level that this version of the library is
  * able to support.
diff --git a/lib/ext2fs/kernel-jbd.h b/lib/ext2fs/kernel-jbd.h
index 059bf8f..2baae73 100644
--- a/lib/ext2fs/kernel-jbd.h
+++ b/lib/ext2fs/kernel-jbd.h
@@ -164,6 +164,9 @@ typedef struct journal_revoke_header_s
 #define JFS_FLAG_LAST_TAG	8	/* last tag in this descriptor block */
 
 
+#define UUID_SIZE 16
+#define JFS_USERS_MAX 48
+#define JFS_USERS_SIZE (UUID_SIZE * JFS_USERS_MAX)
 /*
  * The journal superblock.  All fields are in big-endian byte order.
  */
@@ -208,7 +211,8 @@ typedef struct journal_superblock_s
 	__u32	s_padding[44];
 
 /* 0x0100 */
-	__u8	s_users[16*48];		/* ids of all fs'es sharing the log */
+	__u8	s_users[JFS_USERS_SIZE];		/* ids of all fs'es sharing the log */
+
 /* 0x0400 */
 } journal_superblock_t;
 
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 74e57ae..0c1feb1 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -207,6 +207,18 @@ static int get_journal_sb(ext2_filsys jfs, char buf[SUPERBLOCK_SIZE])
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
@@ -261,11 +273,8 @@ static int remove_journal_device(ext2_filsys fs)
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
@@ -1915,6 +1924,68 @@ static int tune2fs_setup_tdb(const char *name, io_manager *io_ptr)
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
+	char buf[SUPERBLOCK_SIZE];
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
+	    -SUPERBLOCK_SIZE, buf))) {
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
@@ -2203,6 +2274,7 @@ retry_open:
 		int set_csum = 0;
 		dgrp_t i;
 		char buf[SUPERBLOCK_SIZE];
+		char old_uuid[UUID_SIZE];
 
 		if (sb->s_feature_ro_compat &
 		    EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
@@ -2230,6 +2302,8 @@ retry_open:
 			if (i >= fs->group_desc_count)
 				set_csum = 1;
 		}
+
+		memcpy(old_uuid, sb->s_uuid, UUID_SIZE);
 		if ((strcasecmp(new_UUID, "null") == 0) ||
 		    (strcasecmp(new_UUID, "clear") == 0)) {
 			uuid_clear(sb->s_uuid);
@@ -2264,9 +2338,13 @@ retry_open:
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
 	}
 	if (I_flag) {
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
2.0.1

