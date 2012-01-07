From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] libext2fs: Only link an inode into a directory once
Date: Fri, 06 Jan 2012 20:47:43 -0800
Message-ID: <20120107044743.3366.16848.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48529 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759084Ab2AGEsL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Jan 2012 23:48:11 -0500
Received: from /spool/local
	by e6.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Fri, 6 Jan 2012 23:48:09 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q074liXS281390
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jan 2012 23:47:44 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q074lix2004004
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 02:47:44 -0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext2fs_link helper function link_proc does not check the value of ls->done,
which means that if the function finds multiple empty spaces that will fit the
new directory entry, it will create a directory entry in each of the spaces.
Instead of doing that, check the done value and don't do anything more if we've
already added the directory entry.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/link.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/lib/ext2fs/link.c b/lib/ext2fs/link.c
index 2d03b57..2f4f54a 100644
--- a/lib/ext2fs/link.c
+++ b/lib/ext2fs/link.c
@@ -42,6 +42,9 @@ static int link_proc(struct ext2_dir_entry *dirent,
 	unsigned int rec_len, min_rec_len, curr_rec_len;
 	int ret = 0;
 
+	if (ls->done)
+		return 0;
+
 	rec_len = EXT2_DIR_REC_LEN(ls->namelen);
 
 	ls->err = ext2fs_get_rec_len(ls->fs, dirent, &curr_rec_len);

