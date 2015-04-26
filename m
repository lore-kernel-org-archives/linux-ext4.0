From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] jbd2: validate physical block in jbd2_journal_bmap()
Date: Mon, 27 Apr 2015 01:24:03 +0800
Message-ID: <1430069043-30372-1-git-send-email-guaneryu@gmail.com>
Cc: tytso@mit.edu, Eryu Guan <guaneryu@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:33240 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbbDZRZ1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 26 Apr 2015 13:25:27 -0400
Received: by pdbnk13 with SMTP id nk13so103163401pdb.0
        for <linux-ext4@vger.kernel.org>; Sun, 26 Apr 2015 10:25:27 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A corrupted journal may map multiple logical blocks to physical block of
journal superblock and lead journal superblock to be overwriten.

I've seen the following bug when testing on such a corrupted ext4 image.
The journal was corrupted and the extent was like

	Displaying leaf extents for inode 8
	0:[0]6:27 6:[0]15:26 21:[0]1003:306

Journal superblock is at offset 27 and 7th block is mapped to 27 too.

  BUG: unable to handle kernel NULL pointer dereference at           (null)
  IP: [<ffffffffa01fb8f6>] jbd2_journal_commit_transaction+0x936/0x1a60 [jbd2]
  PGD 0
  Oops: 0000 [#1] SMP
  ...
  CPU: 2 PID: 12019 Comm: jbd2/loop0-8 Not tainted 4.0.0-rc3+ #16
  Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
  task: ffff8802145e5f60 ti: ffff8800362f0000 task.ti: ffff8800362f0000
  RIP: 0010:[<ffffffffa01fb8f6>]  [<ffffffffa01fb8f6>] jbd2_journal_commit_transaction+0x936/0x1a60 [jbd2]
  ...
  Stack:
   ffff8800362f3cb8 ffff880212717b98 000010e6644a258e 0000001c145e5fc8
   ffff8800da9d719c 000000000000000c 000007d8ffffffff ffff880212710810
   ffff880212710800 ffff8800da9d7150 ffff880212717824 ffff8800362f3d68
  Call Trace:
   [<ffffffff810abeb7>] ? set_next_entity+0x67/0x80
   [<ffffffff8101358c>] ? __switch_to+0xdc/0x580
   [<ffffffffa020041a>] kjournald2+0xca/0x260 [jbd2]
   [<ffffffff810bb4d0>] ? prepare_to_wait_event+0xf0/0xf0
   [<ffffffffa0200350>] ? commit_timeout+0x10/0x10 [jbd2]
   [<ffffffff81097258>] kthread+0xd8/0xf0
   [<ffffffff81097180>] ? kthread_create_on_node+0x1b0/0x1b0
   [<ffffffff816c93d8>] ret_from_fork+0x58/0x90
   [<ffffffff81097180>] ? kthread_create_on_node+0x1b0/0x1b0
  ...
  RIP  [<ffffffffa01fb8f6>] jbd2_journal_commit_transaction+0x936/0x1a60 [jbd2]
   RSP <ffff8800362f3c88>
  CR2: 0000000000000000

So validate the physical block in jbd2_journal_bmap() first to make sure
it's not the journal superblock if superblock is not requested.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 fs/jbd2/journal.c    | 18 ++++++++++++++----
 include/linux/jbd2.h |  2 ++
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index b96bd80..46208a8 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -789,15 +789,24 @@ int jbd2_journal_bmap(journal_t *journal, unsigned long blocknr,
 
 	if (journal->j_inode) {
 		ret = bmap(journal->j_inode, blocknr);
-		if (ret)
-			*retp = ret;
-		else {
+		if (ret) {
+			if (blocknr != 0 && ret == journal->j_sb_block) {
+				printk(KERN_ALERT "%s: journal block %lu mapped"
+					" to journal superblock(%llu) on %s\n",
+					__func__, blocknr, journal->j_sb_block,
+					journal->j_devname);
+				err = -EIO;
+			} else {
+				*retp = ret;
+			}
+		} else {
 			printk(KERN_ALERT "%s: journal block not found "
 					"at offset %lu on %s\n",
 			       __func__, blocknr, journal->j_devname);
 			err = -EIO;
-			__journal_abort_soft(journal, err);
 		}
+		if (err)
+			__journal_abort_soft(journal, err);
 	} else {
 		*retp = blocknr; /* +journal->j_blk_offset */
 	}
@@ -1245,6 +1254,7 @@ journal_t * jbd2_journal_init_inode (struct inode *inode)
 		goto out_err;
 	}
 	journal->j_sb_buffer = bh;
+	journal->j_sb_block = (unsigned long long)bh->b_blocknr;
 	journal->j_superblock = (journal_superblock_t *)bh->b_data;
 
 	return journal;
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 20e7f78..9a1aee7 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -691,6 +691,7 @@ jbd2_time_diff(unsigned long start, unsigned long end)
  *     prior abort)?
  * @j_sb_buffer: First part of superblock buffer
  * @j_superblock: Second part of superblock buffer
+ * @j_sb_block: Physical block number of superblock
  * @j_format_version: Version of the superblock format
  * @j_state_lock: Protect the various scalars in the journal
  * @j_barrier_count:  Number of processes waiting to create a barrier lock
@@ -767,6 +768,7 @@ struct journal_s
 	/* The superblock buffer */
 	struct buffer_head	*j_sb_buffer;
 	journal_superblock_t	*j_superblock;
+	unsigned long long	j_sb_block;
 
 	/* Version of the superblock format */
 	int			j_format_version;
-- 
1.8.3.1

