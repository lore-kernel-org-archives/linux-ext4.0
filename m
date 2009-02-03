From: Dan Carpenter <error27@gmail.com>
Subject: Re: typo in jbd2_journal_begin_ordered_truncate()
Date: Tue, 3 Feb 2009 12:02:42 +0300 (EAT)
Message-ID: <alpine.DEB.2.00.0902031156320.2929@bikeee>
References: <alpine.DEB.2.00.0902012309120.26166@bikeee> <20090203003351.1efaa6db.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Dan Carpenter <error27@gmail.com>, sct@redhat.com,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:36176 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZBCJDU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Feb 2009 04:03:20 -0500
Received: by ewy14 with SMTP id 14so2292989ewy.13
        for <linux-ext4@vger.kernel.org>; Tue, 03 Feb 2009 01:03:18 -0800 (PST)
In-Reply-To: <20090203003351.1efaa6db.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 3 Feb 2009, Andrew Morton wrote:

> On Tue, 3 Feb 2009 11:23:03 +0300 (EAT) Dan Carpenter <error27@gmail.com> wrote:
>
>> This is jbd2_journal_begin_ordered_truncate() from fs/jbd2/transaction.c.
>>
>> I think the "&&" is supposed to be an "||" on line 2144.  Just knowing
>> that inode->i_transaction is NULL should be enough, otherwise we would
>> immediately dereference a null on line 2146.
>>
>>    2144          if (!inode->i_transaction && !inode->i_next_transaction)
>>    2145                  goto out;
>>    2146          journal = inode->i_transaction->t_journal;
>>
>
> Could be.  Hard to tell from the code, changelog and (non) comments.  Perhaps
> it's dead code.
>
> Send a patch, become famous ;)
>
> While you're there, rename local var `inode' to `jinode'.
>

Changed '&&' to '||' to avoid a potential NULL dereference.

Also renamed jbd2_inode *inode to jbd2_inode *jinode.

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/fs/jbd2/transaction.c	2009-02-03 11:49:52.000000000 +0300
+++ devel/fs/jbd2/transaction.c	2009-02-03 11:51:49.000000000 +0300
@@ -2134,21 +2134,21 @@
   * case it is in the committing transaction so that we stand to ordered
   * mode consistency guarantees.
   */
-int jbd2_journal_begin_ordered_truncate(struct jbd2_inode *inode,
+int jbd2_journal_begin_ordered_truncate(struct jbd2_inode *jinode,
  					loff_t new_size)
  {
  	journal_t *journal;
  	transaction_t *commit_trans;
  	int ret = 0;

-	if (!inode->i_transaction && !inode->i_next_transaction)
+	if (!jinode->i_transaction || !jinode->i_next_transaction)
  		goto out;
-	journal = inode->i_transaction->t_journal;
+	journal = jinode->i_transaction->t_journal;
  	spin_lock(&journal->j_state_lock);
  	commit_trans = journal->j_committing_transaction;
  	spin_unlock(&journal->j_state_lock);
-	if (inode->i_transaction == commit_trans) {
-		ret = filemap_fdatawrite_range(inode->i_vfs_inode->i_mapping,
+	if (jinode->i_transaction == commit_trans) {
+		ret = filemap_fdatawrite_range(jinode->i_vfs_inode->i_mapping,
  			new_size, LLONG_MAX);
  		if (ret)
  			jbd2_journal_abort(journal, ret);
