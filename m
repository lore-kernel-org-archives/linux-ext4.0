From: Zhang Huan <zhhuan@gmail.com>
Subject: potential memory leak on transaction commit
Date: Tue, 8 Mar 2011 19:40:24 +0800 (CST)
Message-ID: <alpine.LFD.2.02.1103081849430.6414@zhanghuan.nrchpc.ac.cn>
Reply-To: Zhang Huan <zhhuan@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57674 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab1CHLkc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Mar 2011 06:40:32 -0500
Received: by iyb26 with SMTP id 26so4755680iyb.19
        for <linux-ext4@vger.kernel.org>; Tue, 08 Mar 2011 03:40:32 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

There is potential memory leak of journal head in function
jbd2_journal_commit_transaction. The problem is that JBD2 will not
reclaim the journal head of commit record if error occurs or journal is
abotred.

I use the following script to reproduce this issue, on a RHEL6 system. I
found it very easy to reproduce with async commit enabled.

mount /dev/sdb /mnt -o journal_checksum,journal_async_commit
touch /mnt/xxx
echo offline > /sys/block/sdb/device/state
sync
umount /mnt
rmmod ext4
rmmod jbd2

Removal of the jbd2 module will make slab complaining that
"cache `jbd2_journal_head': can't free all objects".


Here is my fix for this issue. The commit record should be reclaimed no
matter error occurs or not.

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index f3ad159..37a973a 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -105,6 +105,8 @@ static int journal_submit_commit_record(journal_t *journal,
 	int ret;
 	struct timespec now = current_kernel_time();
 
+	*cbh = NULL;
+
 	if (is_journal_aborted(journal))
 		return 0;
 
@@ -808,7 +810,7 @@ wait_for_iobuf:
 		if (err)
 			__jbd2_journal_abort_hard(journal);
 	}
-	if (!err && !is_journal_aborted(journal))
+	if (cbh)
 		err = journal_wait_on_commit_record(journal, cbh);
 	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
 				      JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT) &&



PS: Just out of curiosity, why would journal_submit_commit_record return a
value of 1 instead of an error number if get descriptor buffer is failed.


Zhang Huan
