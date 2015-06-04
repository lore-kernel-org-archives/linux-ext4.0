From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [RFC/PATCH 7/8] fs/jbd2/journal.c: Use strreplace
Date: Thu,  4 Jun 2015 11:37:14 +0200
Message-ID: <1433410636-26812-8-git-send-email-linux@rasmusvillemoes.dk>
References: <1433410636-26812-1-git-send-email-linux@rasmusvillemoes.dk>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433410636-26812-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In one case, we eliminate a local variable; in the other a strlen()
call and some .text.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 fs/jbd2/journal.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index b96bd8076b70..5c187ded12d6 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1137,7 +1137,6 @@ journal_t * jbd2_journal_init_dev(struct block_device *bdev,
 {
 	journal_t *journal = journal_init_common();
 	struct buffer_head *bh;
-	char *p;
 	int n;
 
 	if (!journal)
@@ -1150,9 +1149,7 @@ journal_t * jbd2_journal_init_dev(struct block_device *bdev,
 	journal->j_blk_offset = start;
 	journal->j_maxlen = len;
 	bdevname(journal->j_dev, journal->j_devname);
-	p = journal->j_devname;
-	while ((p = strchr(p, '/')))
-		*p = '!';
+	strreplace(journal->j_devname, '/', '!');
 	jbd2_stats_proc_init(journal);
 	n = journal->j_blocksize / sizeof(journal_block_tag_t);
 	journal->j_wbufsize = n;
@@ -1204,10 +1201,7 @@ journal_t * jbd2_journal_init_inode (struct inode *inode)
 	journal->j_dev = journal->j_fs_dev = inode->i_sb->s_bdev;
 	journal->j_inode = inode;
 	bdevname(journal->j_dev, journal->j_devname);
-	p = journal->j_devname;
-	while ((p = strchr(p, '/')))
-		*p = '!';
-	p = journal->j_devname + strlen(journal->j_devname);
+	p = strreplace(journal->j_devname, '/', '!');
 	sprintf(p, "-%lu", journal->j_inode->i_ino);
 	jbd_debug(1,
 		  "journal %p: inode %s/%ld, size %Ld, bits %d, blksize %ld\n",
-- 
2.1.3
