From: Oleg Drokin <green@linuxhacker.ru>
Subject: Re: [PATCH] Possible data loss on ext[34], reiserfs with external journal
Date: Tue, 15 Dec 2009 15:01:32 -0500
Message-ID: <02CF0C94-BEC0-428A-878D-D61ADA302944@linuxhacker.ru>
References: <20091211081608.GA597088@fiona.linuxhacker.ru> <20091215053207.GA26541@thunk.org> <2EEF5D3D-AFA5-4D74-92A7-B42A0FB9A4F5@linuxhacker.ru> <20091215164503.GI4867@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from linuxhacker.ru ([217.76.32.60]:38508 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755372AbZLOUBm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Dec 2009 15:01:42 -0500
In-Reply-To: <20091215164503.GI4867@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello!

On Dec 15, 2009, at 11:45 AM, tytso@mit.edu wrote:
>>> +	/* 
>>> +	 * If the journal is not located on the file system device,
>>> +	 * then we must flush the file system device before we issue
>>> +	 * the commit record
>>> +	 */
>>> +	if (commit_transaction->t_flushed_data_blocks &&
>>> +	    (journal->j_fs_dev != journal->j_dev) &&
>>> +	    (journal->j_flags & JBD2_BARRIER))
>>> +		blkdev_issue_flush(journal->j_fs_dev, NULL);
>>> +
>> I am afraid this is not enough. This code is called after journal
>> was flushed for async commit case, so it leaves a race window where
>> journal transaction is already on disk and complete, but the data is
>> still in cache somewhere.
> No, that's actually fine.  In the ASYNC_COMMIT case, the commit won't
> be valid until the checksum is correct, and we won't have written any
> descriptor blocks yet at this point.  So there is no race because

What do you mean by descriptor blocks? Actual logged blocks?

> during that window, the commit is written but we won't write any
> descriptor blocks until after the barrier returns.

>From my reading of the code, in jbd2_journal_commit_transaction:
After first "JBD: commit phase 2" message we submit actual data buffers.
Then after second "JBD: commit phase 2" message (in the
"while (commit_transaction->t_buffers) {" loop) we actually iterate
through all metadata changes and submit them to disk (after
start_journal_io: label)
Then journal_submit_commit_record writes commit record.
At this point on we have entire transacton + commit
block in the write queue (or partially already on disk) +
all the data blocks in the write queue.
Next blkdev_issue_flush on journal device is done, cementing the transaction
on the permanent storage, but the actual data is still potentially not
there abd it is not until the call to journal_finish_inode_data_buffers()
where that data is flushed too.

If you refer to the code after "JBD: commit phase 3" that waits on actual
transaction blocks buffers to make sure they made it to the disk,
my reading of blkdev_issue_flush is that it adds the flush at the end of the
queue, i.e. after all of the journalled blocks that are sitting in there,
so they all would be already copleted by the time blkdev_issue_flush returns.

Bye,
    Oleg