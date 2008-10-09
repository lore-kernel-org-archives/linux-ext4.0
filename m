From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: [PATCH] debugfs : Fix printing of pathnames with ncheck if files have hardlinks in same directory.
Date: Thu, 9 Oct 2008 23:04:45 +0530
Message-ID: <ea11fea30810091034k56788d54ka794fdde914f6616@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mkatiyar@gmail.com
To: ext4 <linux-ext4@vger.kernel.org>, "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.186]:48344 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbYJIRer (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2008 13:34:47 -0400
Received: by ti-out-0910.google.com with SMTP id b6so52776tic.23
        for <linux-ext4@vger.kernel.org>; Thu, 09 Oct 2008 10:34:45 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Commit 03206bd introduced regression in ncheck while printing all the
pathnames of an inode. For files which have hardlink in the same
directory we will print the same pathname instead of all possible like
below :-

debugfs:  ncheck 14
Inode	Pathname
14	/a/f1
14	/a/f1
14	/b/f3

where it should have printed

debugfs:  ncheck 14
Inode   Pathname
14      /a/f1
14      /a/f2
14      /b/f3

Below patch fixes it.

Signed-off-by : Manish Katiyar <mkatiyar@gmail.com>

---
 debugfs/ncheck.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/debugfs/ncheck.c b/debugfs/ncheck.c
index 22fa29f..c850739 100644
--- a/debugfs/ncheck.c
+++ b/debugfs/ncheck.c
@@ -36,14 +36,16 @@ static int ncheck_proc(struct ext2_dir_entry *dirent,
 	int	i;
 	char	*pathname;
 	errcode_t	retval;
+	static ext2_ino_t parent;

 	iw->position++;
+	if (iw->position == 2)
+		parent = dirent->inode;
 	if (iw->position <= 2)
 		return 0;
 	for (i=0; i < iw->num_inodes; i++) {
 		if (iw->iarray[i] == dirent->inode) {
-			retval = ext2fs_get_pathname(current_fs, iw->parent,
-						     iw->iarray[i],
+			retval = ext2fs_get_pathname(current_fs, parent, iw->parent,
 						     &pathname);
 			if (retval)
 				com_err("ncheck", retval,
@@ -51,7 +53,7 @@ static int ncheck_proc(struct ext2_dir_entry *dirent,
 					"inode %d (%d)", iw->parent,
 					iw->iarray[i]);
 			else
-				printf("%u\t%s\n", iw->iarray[i], pathname);
+				printf("%u\t%s/%s\n", iw->iarray[i], pathname, dirent->name);
 		}
 	}
 	if (!iw->inodes_left)
-- 
1.5.4.3


Thanks -
Manish
