From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] tune2fs: fix uninitialized variable in remove_journal_device
Date: Thu, 31 Jul 2014 11:53:14 -0400
Message-ID: <1406821994-19600-1-git-send-email-tytso@mit.edu>
References: <53DA5DDC.1020703@redhat.com>
Cc: Azat Khuzhin <a3at.mail@gmail.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38621 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaGaPxV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jul 2014 11:53:21 -0400
In-Reply-To: <53DA5DDC.1020703@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This bug was introduced by commit 7dfefaf413bbd ("tune2fs: update
journal super block when changing UUID for fs").

Fixes-Coverity-Bug: 1229243

Reported-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 misc/tune2fs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 0c1feb1..639809d 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -232,7 +232,6 @@ static int remove_journal_device(ext2_filsys fs)
 	errcode_t	retval;
 	int		commit_remove_journal = 0;
 	io_manager	io_ptr;
-	int start;
 
 	if (f_flag)
 		commit_remove_journal = 1; /* force removal even if error */
@@ -286,8 +285,9 @@ static int remove_journal_device(ext2_filsys fs)
 	jsb->s_nr_users = htonl(nr_users);
 
 	/* Write back the journal superblock */
-	if ((retval = io_channel_write_blk64(jfs->io, start,
-	    -SUPERBLOCK_SIZE, buf))) {
+	if ((retval = io_channel_write_blk64(jfs->io,
+				ext2fs_journal_sb_start(fs->blocksize),
+				-SUPERBLOCK_SIZE, buf))) {
 		com_err(program_name, retval,
 			"while writing journal superblock.");
 		goto no_valid_journal;
-- 
2.0.0

