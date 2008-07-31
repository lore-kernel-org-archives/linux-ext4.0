From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH] jbd2: don't abort if flushing file data failed
Date: Thu, 31 Jul 2008 15:00:32 +0900
Message-ID: <48915500.3050500@hitachi.com>
References: <1217118414-18636-1-git-send-email-tytso@mit.edu>
    <1217118414-18636-2-git-send-email-tytso@mit.edu>
    <1217118414-18636-3-git-send-email-tytso@mit.edu>
    <1217118414-18636-4-git-send-email-tytso@mit.edu>
    <488EB060.7080303@hitachi.com> <20080729123513.GG9378@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail9.hitachi.co.jp ([133.145.228.44]:47591 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbYGaGAq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jul 2008 02:00:46 -0400
Received: from mlsv8.hitachi.co.jp (unknown [133.144.234.166])
	by mail9.hitachi.co.jp (Postfix) with ESMTP id 6B3E037C92
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 15:00:41 +0900 (JST)
In-Reply-To: <20080729123513.GG9378@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

> On Tue, Jul 29, 2008 at 02:53:36PM +0900, Hidehiro Kawai wrote:
> 
>>>[PATCH] ext4: don't read inode block if the buffer has a write error
>>>[PATCH] jbd2: don't abort if flushing file data failed
>>
>>Thank you for porting my ext3/jbd patches to ext4/jbd2.
>>I would appreciate if you port the remained two patch set (haven't
>>been posted yet), too.  Although I'll try to port them by myself. 
> 
> If they are the ones which I think you are referring to, I don't
> believe they apply to ext4 since we are now using the
> generic_writepages routines to flush data pages to disk during a
> journal commit.  I've checked those code paths, and I believe they do
> set AS_EIO correctly; I would appreciate it though if you could double
> check to make sure they are do everything that needs to be done to
> handle write errors correctly.

I tested this patch on 2.6.27-rc1, but it didn't work properly.
Then, I noticed two mistakes.

(1) journal_submit_data_buffers() just submits I/Os, doesn't wait
    their completion.  We have to check file data write errors
    after calling journal_finish_inode_data_buffers()
(2) AS_EIO is cleared by wait_on_page_writeback_range(), so we
    have to set it again

I attached the revised patch below.  journal_submit_data_buffers()
can return error, but it wouldn't be write I/O error AFAIK, so I
didn't touched.

Best regards,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center


Subcject: [PATCH] jbd2: don't abort if flushing file data failed

In ordered mode, the current jbd2 aborts the journal if a file data buffer
has an error.  But this behavior is unintended, and we found that it has
been adopted accidentally.

This patch undoes it and just calls printk() instead of aborting the
journal.  Unlike a similar patch for ext3/jbd, file data buffers are
written via generic_writepages().  But we also need to set AS_EIO
into their mappings because wait_on_page_writeback_range() clears
AS_EIO before a user process sees it.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/jbd2/commit.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

Index: linux-2.6.27-rc1/fs/jbd2/commit.c
===================================================================
--- linux-2.6.27-rc1.orig/fs/jbd2/commit.c
+++ linux-2.6.27-rc1/fs/jbd2/commit.c
@@ -262,8 +262,18 @@ static int journal_finish_inode_data_buf
 		jinode->i_flags |= JI_COMMIT_RUNNING;
 		spin_unlock(&journal->j_list_lock);
 		err = filemap_fdatawait(jinode->i_vfs_inode->i_mapping);
-		if (!ret)
-			ret = err;
+		if (err) {
+			/*
+			 * Because AS_EIO is cleared by
+			 * wait_on_page_writeback_range(), set it again so
+			 * that user process can get -EIO from fsync().
+			 */
+			set_bit(AS_EIO,
+				&jinode->i_vfs_inode->i_mapping->flags);
+
+			if (!ret)
+				ret = err;
+		}
 		spin_lock(&journal->j_list_lock);
 		jinode->i_flags &= ~JI_COMMIT_RUNNING;
 		wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
@@ -670,8 +680,14 @@ start_journal_io:
 	 * commit block, which happens below in such setting.
 	 */
 	err = journal_finish_inode_data_buffers(journal, commit_transaction);
-	if (err)
-		jbd2_journal_abort(journal, err);
+	if (err) {
+		char b[BDEVNAME_SIZE];
+
+		printk(KERN_WARNING
+			"JBD2: Detected IO errors while flushing file data "
+			"on %s\n", bdevname(journal->j_fs_dev, b));
+		err = 0;
+	}
 
 	/* Lo and behold: we have just managed to send a transaction to
            the log.  Before we can commit it, wait for the IO so far to


