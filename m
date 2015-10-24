From: "Eunji Lee" <alicia0729@gmail.com>
Subject: [PATCH] fix jbd2 asynchronous commit
Date: Sat, 24 Oct 2015 17:14:15 +0900
Message-ID: <14b201d10e33$fb91c390$f2b54ab0$@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:32917 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbbJXIOb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Oct 2015 04:14:31 -0400
Received: by pabrc13 with SMTP id rc13so138385897pab.0
        for <linux-ext4@vger.kernel.org>; Sat, 24 Oct 2015 01:14:29 -0700 (PDT)
Content-Language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch is to fix a (seemingly) bug of asynchronous commit process
(pinging w/ a patch). 

In asynchronous commit, JBD2 issues a "FLUSH" request only once after
issuing a commit record if a file system and a journal reside on the same
device. This can reduce redundant storage flushes relying on the checksum. 

However, it seems to incur an undesirable result in ordered mode.
Specifically, the system can crash after metadata blocks and a commit record
are successfully written to the journal (i.e., with no checksum error), but
before data blocks are reflected to the file system. Then, on the system
recovery, metadata updates in a journal area will be replayed as the
checksum has no error, even though the associated data blocks are not
reflected to the file system. This fails to provide the correct ordering -
associated data blocks are written before metadata updates are written. 

This patch flushes a storage device before issuing a commit record, even if
a journal and a file system use a same device, thereby guaranteeing the
correct ordering between metadata and data block updates. 

Without asynchronous commit, it does not matter because the commit record
with WRITE_FUA guarantees to flush storage cache before the commit record is
written to the journal. 


Signed-off-by: Eunji Lee <alicia0729@gmail.com>

---
 fs/jbd2/commit.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 362e5f6..118b377 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -792,7 +792,6 @@ start_journal_io:
     * the commit record
     */
    if (commit_transaction->t_need_data_flush &&
-       (journal->j_fs_dev != journal->j_dev) &&
        (journal->j_flags & JBD2_BARRIER))
        blkdev_issue_flush(journal->j_fs_dev, GFP_NOFS, NULL);

--
1.7.9.5

