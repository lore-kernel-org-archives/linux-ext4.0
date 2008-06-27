From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH 4/5] jbd: fix error handling for checkpoint io
Date: Fri, 27 Jun 2008 17:06:56 +0900
Message-ID: <48649FA0.70303@hitachi.com>
References: <4843CE15.6080506@hitachi.com> <4843CFBD.7040706@hitachi.com>
    <20080602124409.GL30613@duck.suse.cz> <4844CB39.6060409@hitachi.com>
    <20080603080219.GA17936@duck.suse.cz> <485F85AE.1010704@hitachi.com>
    <20080623122240.GJ26743@duck.suse.cz> <4860E01B.8010806@hitachi.com>
    <20080624133309.GG9959@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:52769 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbYF0IHM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Jun 2008 04:07:12 -0400
In-Reply-To: <20080624133309.GG9959@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,
Thank you for your reply.

Jan Kara wrote:

> On Tue 24-06-08 20:52:59, Hidehiro Kawai wrote:

>>>>3. is implemented as described below.
>>>> (1) if log_do_checkpoint() detects an I/O error during
>>>>     checkpointing, it calls journal_abort() to abort the journal
>>>> (2) if the journal has aborted, don't update s_start and s_sequence
>>>>     in the on-disk journal superblock
>>>>
>>>>So, if the journal aborts, journaled data will be replayed on the
>>>>next mount.
>>>>
>>>>Now, please remember that some dirty metadata buffers are written
>>>>back to the filesystem without journaling if the journal aborted.
>>>>We are happy if all dirty metadata buffers are written to the disk,
>>>>the integrity of the filesystem will be kept.  However, replaying
>>>>the journaled data can overwrite the latest on-disk metadata blocks
>>>>partly with old data.  It would break the filesystem.
>>>
>>>  Yes, it would. But how do you think it can happen that a metadata buffer
>>>will be written back to the filesystem when it is a part of running
>>>transaction? Note that checkpointing code specifically checks whether the
>>>buffer being written back is part of a running transaction and if so, it
>>>waits for commit before writing back the buffer. So I don't think this can
>>>happen but maybe I miss something...
>>
>>Checkpointing code checks it and may call log_wait_commit(), but this
>>problem is caused by transactions which have not started checkpointing.
>>
>>For example, the tail transaction has an old update for block_B and
>>the running transaction has a new update for block_B.  Then, the
>>committing transaction fails to write the commit record, it aborts the
>>journal, and new block_B will be written back to the file system without
>>journaling.  Because this patch doesn't separate between normal abort
>>and checkpointing related abort, the tail transaction is left in the
>>journal space.  So by replaying the tail transaction, new block_B is
>>overwritten with old one.
> 
>   Yes, and this is expected an correct. When we cannot properly finish a
> transaction, we have to discard everything in it. A bug would be (and I
> think it could currently happen) if we already checkpointed the previous
> transaction and then written over block_B new data from the uncommitted
> transaction. I think we have to avoid that - i.e., in case we abort the
> journal we should not mark buffers dirty when processing the forget loop.

Yes.

> But this is not too serious since fsck has to be run anyway and it will
> fix the problems.

Yes.  The filesystem should be marked with an error, so fsck will check
and recover the filesystem on boot.  But this means the filesystem loses
some latest updates even if it was cleanly unmounted (although some file
data has been lost.)  I'm a bit afraid that some people would think of
this as a regression due to this PATCH 4/5.  At least, to avoid
undesirable replay, we had better keep journaled data only when the
journal has been aborted for checkpointing related reason.
 
>>It can happen in the case of the checkpointing related abort.
>>For example, assuming the tail transaction has an update for block_A,
>>the next transaction has an old update for block_B, and the running
>>transaction has a new update for block_B.
>>Now, the running transaction needs more log space, and it calls
>>log_do_checkpoint().  But it aborts the journal because it detected
>>write error on block_A.  In this case, new block_B will be
>>overwritten when the old block_B in the second transaction to the tail
>>is replayed.
> 
>   Well, the scenario has to be a bit different (if we need more space than
> there is in the journal, we commit the running transaction, do checkpoint
> and start a new transaction) but something like what you describe could
> happen. But again I think that this is a correct behavior - i.e., discard
> all the data in the running transaction when the journal is aborted before
> the transaction is properly committed. 

I think it is correct behavior to discard _all_ metadata updates
in the running transaction on abort.  But, we don't hope some of
metadata updates are often discarded, do we?

Thanks,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

