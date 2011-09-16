From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 02/25] e2fsprogs: Remove impossible name_len tests.
Date: Fri, 16 Sep 2011 15:49:17 -0500
Message-ID: <1316206180-6375-3-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46724 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458Ab1IPUto (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:44 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The name_len field in ext2_dir_entry is actually comprised of
the name length in the lower 8 bytes, and the filetype in the
high 8 bytes.  So in places, we mask name_len with 0xFF to
get the actual length.

But once we have masked name_len with 0xFF, there is no point
in testing whether it is greater than EXT2_NAME_LEN, which
is 255 - or 0xFF.  So all of these tests are extraneous.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 debugfs/dump.c   |    3 +--
 debugfs/htree.c  |    3 +--
 debugfs/ls.c     |    3 +--
 e2fsck/message.c |    2 --
 e2fsck/pass2.c   |    6 ------
 5 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/debugfs/dump.c b/debugfs/dump.c
index 4cf0752..ec36eca 100644
--- a/debugfs/dump.c
+++ b/debugfs/dump.c
@@ -300,8 +300,7 @@ static int rdump_dirent(struct ext2_dir_entry *dirent,
 	const char *dumproot = private;
 	struct ext2_inode inode;
 
-	thislen = ((dirent->name_len & 0xFF) < EXT2_NAME_LEN
-		   ? (dirent->name_len & 0xFF) : EXT2_NAME_LEN);
+	thislen = dirent->name_len & 0xFF;
 	strncpy(name, dirent->name, thislen);
 	name[thislen] = 0;
 
diff --git a/debugfs/htree.c b/debugfs/htree.c
index b829e25..de36bd4 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -81,8 +81,7 @@ static void htree_dump_leaf_node(ext2_filsys fs, ext2_ino_t ino,
 				blk);
 			break;
 		}
-		thislen = ((dirent->name_len & 0xFF) < EXT2_NAME_LEN) ?
-			(dirent->name_len & 0xFF) : EXT2_NAME_LEN;
+		thislen = dirent->name_len & 0xFF;
 		strncpy(name, dirent->name, thislen);
 		name[thislen] = '\0';
 		errcode = ext2fs_dirhash(hash_alg, name,
diff --git a/debugfs/ls.c b/debugfs/ls.c
index 8e019d2..e01fd20 100644
--- a/debugfs/ls.c
+++ b/debugfs/ls.c
@@ -60,8 +60,7 @@ static int list_dir_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
 	int			thislen;
 	struct list_dir_struct *ls = (struct list_dir_struct *) private;
 
-	thislen = ((dirent->name_len & 0xFF) < EXT2_NAME_LEN) ?
-		(dirent->name_len & 0xFF) : EXT2_NAME_LEN;
+	thislen = dirent->name_len & 0xFF;
 	strncpy(name, dirent->name, thislen);
 	name[thislen] = '\0';
 	ino = dirent->inode;
diff --git a/e2fsck/message.c b/e2fsck/message.c
index 49b861d..565c3cd 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -372,8 +372,6 @@ static _INLINE_ void expand_dirent_expression(ext2_filsys fs, char ch,
 		break;
 	case 'n':
 		len = dirent->name_len & 0xFF;
-		if (len > EXT2_NAME_LEN)
-			len = EXT2_NAME_LEN;
 		if ((ext2fs_get_rec_len(fs, dirent, &rec_len) == 0) &&
 		    (len > rec_len))
 			len = rec_len;
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index e57afb9..9c44aa2 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -858,12 +858,6 @@ out_htree:
 			} else
 				goto abort_free_dict;
 		}
-		if ((dirent->name_len & 0xFF) > EXT2_NAME_LEN) {
-			if (fix_problem(ctx, PR_2_FILENAME_LONG, &cd->pctx)) {
-				dirent->name_len = EXT2_NAME_LEN;
-				dir_modified++;
-			}
-		}
 
 		if (dot_state == 0) {
 			if (check_dot(ctx, dirent, ino, &cd->pctx))
-- 
1.7.4.1

