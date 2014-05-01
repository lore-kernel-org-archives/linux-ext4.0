From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 03/37] libext2fs: create sockets when populating filesystem
Date: Thu, 01 May 2014 16:12:42 -0700
Message-ID: <20140501231242.31890.24539.stgit@birch.djwong.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28116 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaEAXMs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2014 19:12:48 -0400
In-Reply-To: <20140501231222.31890.82860.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since the code to copy-in a socket when creating a filesystem is
fairly simple, just do it here.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/create_inode.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/misc/create_inode.c b/misc/create_inode.c
index 4bb5e5b..e7faab1 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -114,6 +114,9 @@ errcode_t do_mknod_internal(ext2_filsys fs, ext2_ino_t cwd, const char *name,
 		mode = LINUX_S_IFIFO;
 		filetype = EXT2_FT_FIFO;
 		break;
+	case S_IFSOCK:
+		mode = LINUX_S_IFSOCK;
+		filetype = EXT2_FT_SOCK;
 	default:
 		abort();
 		/* NOTREACHED */
@@ -516,6 +519,7 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
 		case S_IFCHR:
 		case S_IFBLK:
 		case S_IFIFO:
+		case S_IFSOCK:
 			retval = do_mknod_internal(fs, parent_ino, name, &st);
 			if (retval) {
 				com_err(__func__, retval,
@@ -524,11 +528,6 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
 				goto out;
 			}
 			break;
-		case S_IFSOCK:
-			/* FIXME: there is no make socket function atm. */
-			com_err(__func__, 0,
-				_("ignoring socket file \"%s\""), name);
-			continue;
 		case S_IFLNK:
 			read_cnt = readlink(name, ln_target,
 					    sizeof(ln_target) - 1);

