From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] debugfs : Fix printing of pathnames with ncheck if
	files have hardlinks in same directory.
Date: Fri, 10 Oct 2008 14:57:15 -0400
Message-ID: <20081010185715.GE8645@mit.edu>
References: <ea11fea30810091034k56788d54ka794fdde914f6616@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:48897 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758412AbYJJS5R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Oct 2008 14:57:17 -0400
Content-Disposition: inline
In-Reply-To: <ea11fea30810091034k56788d54ka794fdde914f6616@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 09, 2008 at 11:04:45PM +0530, Manish Katiyar wrote:
> Hi Ted,
> 
> Commit 03206bd introduced regression in ncheck while printing all the
> pathnames of an inode. For files which have hardlink in the same
> directory we will print the same pathname instead of all possible like
> below :-

This patch is a better way to fix things.  It fixes a memory leak,
avoids the static variable, and avoids calling ext2fs_get_pathname
multiple times for each directory.

								- Ted

commit b4c36addc0279193018a4bb59871c5365db1489b
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Oct 10 14:53:09 2008 -0400

    debugfs: Fix ncheck when printing pathnames for multiple hardlinks in a directory
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/debugfs/ncheck.c b/debugfs/ncheck.c
index 22fa29f..abb38a8 100644
--- a/debugfs/ncheck.c
+++ b/debugfs/ncheck.c
@@ -23,7 +23,7 @@ struct inode_walk_struct {
 	int			inodes_left;
 	int			num_inodes;
 	int			position;
-	ext2_ino_t		parent;
+	char			*parent;
 };
 
 static int ncheck_proc(struct ext2_dir_entry *dirent,
@@ -42,16 +42,8 @@ static int ncheck_proc(struct ext2_dir_entry *dirent,
 		return 0;
 	for (i=0; i < iw->num_inodes; i++) {
 		if (iw->iarray[i] == dirent->inode) {
-			retval = ext2fs_get_pathname(current_fs, iw->parent,
-						     iw->iarray[i], 
-						     &pathname);
-			if (retval)
-				com_err("ncheck", retval,
-					"while resolving pathname for "
-					"inode %d (%d)", iw->parent, 
-					iw->iarray[i]);
-			else
-				printf("%u\t%s\n", iw->iarray[i], pathname);
+			printf("%u\t%s/%*s\n", iw->iarray[i], iw->parent,
+			       (dirent->name_len & 0xFF), dirent->name);
 		}
 	}
 	if (!iw->inodes_left)
@@ -124,10 +116,17 @@ void do_ncheck(int argc, char **argv)
 			goto next;
 
 		iw.position = 0;
-		iw.parent = ino;
+
+		retval = ext2fs_get_pathname(current_fs, ino, 0, &iw.parent);
+		if (retval) {
+			com_err("ncheck", retval, 
+				"while calling ext2fs_get_pathname");
+			goto next;
+		}
 
 		retval = ext2fs_dir_iterate(current_fs, ino, 0, 0,
 					    ncheck_proc, &iw);
+		ext2fs_free_mem(&iw.parent);
 		if (retval) {
 			com_err("ncheck", retval,
 				"while calling ext2_dir_iterate");
