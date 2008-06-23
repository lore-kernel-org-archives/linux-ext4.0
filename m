From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH] jbd: don't abort if flushing file data failed
Date: Mon, 23 Jun 2008 20:06:44 +0900
Message-ID: <485F83C4.3060704@hitachi.com>
References: <4859FD82.1000306@hitachi.com> <20080619163044.GB7874@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, sct@redhat.com,
	adilger@clusterfs.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Josef Bacik <jbacik@redhat.com>, Mingming Cao <cmm@us.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37320 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbYFWLHA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jun 2008 07:07:00 -0400
In-Reply-To: <20080619163044.GB7874@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Aneesh Kumar K.V wrote:
> On Thu, Jun 19, 2008 at 03:32:34PM +0900, Hidehiro Kawai wrote:
> 
>>In ordered mode, the current jbd aborts the journal if a file data
>>buffer has an error.  But this behavior is unintended, and we found
>>that it has been adopted accidentally.
> 
> Do you have more information on this ?  Isn't ordered mode required to
> guarantee that file data hit the disk and if there are errors in sending
> data to the disk, should we not mark the file system readonly by aborting
> the journal ?

If we make the file system read-only on a file data write error,
the system can be unavailable easily.  So some people need this patch.
On the other hand, there are people (including me) who want to abort
the journal to prevent the situation getting worse.
To make all be happy, I'm going to send a patch to make the behavior
on file data write error tunable.
Please refer to the following thread for details:
http://kerneltrap.org/mailarchive/linux-kernel/2008/6/3/2022594


>>This patch undoes it and just calls printk() instead of aborting
>>the journal.  Additionally, set AS_EIO into the address_space
>>object of the failed buffer which is submitted by
>>journal_do_submit_data() so that fsync() can get -EIO.
>>
>>Missing error checkings are also added to inform errors on file
>>data buffers to the user.  The following buffers are targeted.
>>
>>  (a) the buffer which has already been written out by pdflush
>>  (b) the buffer which has been unlocked before scanned in the
>>      t_locked_list loop
>>
>>Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> 
> We may want a similar patch for jbd2 also. IF you are doing that can you
> make sure  you do that against the patch queue at
> http://repo.or.cz/w/ext4-patch-queue.git. There are some changes in the
> same area in the patch queue.

Sure.  I'm going to port this patch to ext4/jbd2 after I finish the
remaining ext3/jbd fixes.  But it may take time because I'm not
familiar with ext4/jbd2.

Thanks,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center
 
>>---
>> fs/jbd/commit.c |   32 +++++++++++++++++++++++++-------
>> 1 file changed, 25 insertions(+), 7 deletions(-)
>>
>>Index: linux-2.6.26-rc5-mm3/fs/jbd/commit.c
>>===================================================================
>>--- linux-2.6.26-rc5-mm3.orig/fs/jbd/commit.c
>>+++ linux-2.6.26-rc5-mm3/fs/jbd/commit.c
>>@@ -172,7 +172,7 @@ static void journal_do_submit_data(struc
>> /*
>>  *  Submit all the data buffers to disk
>>  */
>>-static void journal_submit_data_buffers(journal_t *journal,
>>+static int journal_submit_data_buffers(journal_t *journal,
>> 				transaction_t *commit_transaction)
>> {
>> 	struct journal_head *jh;
>>@@ -180,6 +180,7 @@ static void journal_submit_data_buffers(
>> 	int locked;
>> 	int bufs = 0;
>> 	struct buffer_head **wbuf = journal->j_wbuf;
>>+	int err = 0;
>>
>> 	/*
>> 	 * Whenever we unlock the journal and sleep, things can get added
>>@@ -253,6 +254,8 @@ write_out_data:
>> 			put_bh(bh);
>> 		} else {
>> 			BUFFER_TRACE(bh, "writeout complete: unfile");
>>+			if (unlikely(!buffer_uptodate(bh)))
>>+				err = -EIO;
>> 			__journal_unfile_buffer(jh);
>> 			jbd_unlock_bh_state(bh);
>> 			if (locked)
>>@@ -271,6 +274,8 @@ write_out_data:
>> 	}
>> 	spin_unlock(&journal->j_list_lock);
>> 	journal_do_submit_data(wbuf, bufs);
>>+
>>+	return err;
>> }
>>
>> /*
>>@@ -410,8 +415,7 @@ void journal_commit_transaction(journal_
>> 	 * Now start flushing things to disk, in the order they appear
>> 	 * on the transaction lists.  Data blocks go first.
>> 	 */
>>-	err = 0;
>>-	journal_submit_data_buffers(journal, commit_transaction);
>>+	err = journal_submit_data_buffers(journal, commit_transaction);
>>
>> 	/*
>> 	 * Wait for all previously submitted IO to complete.
>>@@ -426,10 +430,21 @@ void journal_commit_transaction(journal_
>> 		if (buffer_locked(bh)) {
>> 			spin_unlock(&journal->j_list_lock);
>> 			wait_on_buffer(bh);
>>-			if (unlikely(!buffer_uptodate(bh)))
>>-				err = -EIO;
>> 			spin_lock(&journal->j_list_lock);
>> 		}
>>+		if (unlikely(!buffer_uptodate(bh))) {
>>+			if (TestSetPageLocked(bh->b_page)) {
>>+				spin_unlock(&journal->j_list_lock);
>>+				lock_page(bh->b_page);
>>+				spin_lock(&journal->j_list_lock);
>>+			}
>>+			if (bh->b_page->mapping)
>>+				set_bit(AS_EIO, &bh->b_page->mapping->flags);
>>+
>>+			unlock_page(bh->b_page);
>>+			SetPageError(bh->b_page);
>>+			err = -EIO;
>>+		}
>> 		if (!inverted_lock(journal, bh)) {
>> 			put_bh(bh);
>> 			spin_lock(&journal->j_list_lock);
>>@@ -448,8 +463,11 @@ void journal_commit_transaction(journal_
>> 	}
>> 	spin_unlock(&journal->j_list_lock);
>>
>>-	if (err)
>>-		journal_abort(journal, err);
>>+	if (err) {
>>+		printk(KERN_WARNING
>>+		       "JBD: Detected IO errors during flushing file data\n");
>>+		err = 0;
>>+	}
>>
>> 	journal_write_revoke_records(journal, commit_transaction);


