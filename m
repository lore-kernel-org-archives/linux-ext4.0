From: akpm@linux-foundation.org
Subject: [patch 243/268] ext4: fix error handling in ext4_create_journal
Date: Sun, 15 Jul 2007 23:41:45 -0700
Message-ID: <200707160641.l6G6fjXQ015194@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, bbpetkov@yahoo.de,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60354 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752218AbXGPGsE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jul 2007 02:48:04 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

Fix error handling in ext4_create_journal according to kernel conventions.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN fs/ext4/super.c~ext4-fix-error-handling-in-ext4_create_journal fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-fix-error-handling-in-ext4_create_journal
+++ a/fs/ext4/super.c
@@ -2158,6 +2158,7 @@ static int ext4_create_journal(struct su
 			       unsigned int journal_inum)
 {
 	journal_t *journal;
+	int err;
 
 	if (sb->s_flags & MS_RDONLY) {
 		printk(KERN_ERR "EXT4-fs: readonly filesystem when trying to "
@@ -2165,13 +2166,15 @@ static int ext4_create_journal(struct su
 		return -EROFS;
 	}
 
-	if (!(journal = ext4_get_journal(sb, journal_inum)))
+	journal = ext4_get_journal(sb, journal_inum);
+	if (!journal)
 		return -EINVAL;
 
 	printk(KERN_INFO "EXT4-fs: creating new journal on inode %u\n",
 	       journal_inum);
 
-	if (jbd2_journal_create(journal)) {
+	err = jbd2_journal_create(journal);
+	if (err) {
 		printk(KERN_ERR "EXT4-fs: error creating journal.\n");
 		jbd2_journal_destroy(journal);
 		return -EIO;
_
