From: akpm@linux-foundation.org
Subject: - ext4-fix-error-handling-in-ext4_create_journal.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:59:01 -0700
Message-ID: <200707162059.l6GKx1XL002388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: bbpetkov@yahoo.de, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: fix error handling in ext4_create_journal
has been removed from the -mm tree.  Its filename was
     ext4-fix-error-handling-in-ext4_create_journal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext4: fix error handling in ext4_create_journal
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

Patches currently in -mm which might be from bbpetkov@yahoo.de are

origin.patch
