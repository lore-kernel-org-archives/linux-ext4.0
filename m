From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCHv2 1/1] jbd2: Fix I/O hang in jbd2_journal_release_jbd_inode
Date: Tue, 31 Aug 2010 09:04:59 -0500
Message-ID: <4C7D0C0B.2010804@linux.vnet.ibm.com>
References: <201007141456.o6EEuFe9004519@d01av03.pok.ibm.com> <20100714174458.GA2378@localhost.localdomain> <4C3E08E6.2050203@linux.vnet.ibm.com> <20100827191025.GV4453@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org,
	cmm@linux.vnet.ibm.com, pmac@au1.ibm.com
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:39968 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757409Ab0HaOFG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Aug 2010 10:05:06 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e38.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o7VDvbu3015458
	for <linux-ext4@vger.kernel.org>; Tue, 31 Aug 2010 07:57:37 -0600
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o7VE54FH211124
	for <linux-ext4@vger.kernel.org>; Tue, 31 Aug 2010 08:05:04 -0600
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o7VE53RT021738
	for <linux-ext4@vger.kernel.org>; Tue, 31 Aug 2010 08:05:04 -0600
In-Reply-To: <20100827191025.GV4453@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/27/2010 02:10 PM, Ted Ts'o wrote:
> On Wed, Jul 14, 2010 at 01:58:46PM -0500, Brian King wrote:
>>
>> I've been debugging a hang in jbd2_journal_release_jbd_inode
>> which is being seen on Power 6 systems quite a lot. When we get
>> in the hung state, all I/O to the disk in question gets blocked
>> where we stay indefinitely. Looking at the task list, I can see
>> we are stuck in jbd2_journal_release_jbd_inode waiting on a
>> wake up. I added some debug code to detect this scenario and
>> dump additional data if we were stuck in jbd2_journal_release_jbd_inode
>> for longer than 30 minutes. When it hit, I was able to see that
>> i_flags was 0, suggesting we missed the wake up.
>>
>> This patch changes i_flags to be an unsigned long, uses bit operators
>> to access it, and adds barriers around the accesses. Prior to applying
>> this patch, we were regularly hitting this hang on numerous systems
>> in our test environment. After applying the patch, the hangs no longer
>> occur. Its still not clear to me why the j_list_lock doesn't protect us
>> in this path. It also appears a hang very similar to this was seen
>> in the past and then was no longer recreatable:
> 
> I've been look at this patch, and I can see how converting to bitops
> definitely makes sense.  I can also see how adding
> smp_mb__after_clear_bit() makes sense.  However, it's not clear the
> smp_mb() call here helps?

I pulled out the smp_mb and we ran clean for 75 hours before stopping the test.
We would generally hit this in less than 36 hours, so I think we can safely
remove this barrier. I'll send out an updated patch.

Thanks,

Brian


> 
>> diff -puN fs/jbd2/journal.c~jbd2_ji_commit_barrier_patch fs/jbd2/journal.c
>> --- linux-2.6/fs/jbd2/journal.c~jbd2_ji_commit_barrier_patch	2010-07-14 13:46:17.000000000 -0500
>> +++ linux-2.6-bjking1/fs/jbd2/journal.c	2010-07-14 13:46:17.000000000 -0500
>> @@ -2209,9 +2211,10 @@ void jbd2_journal_release_jbd_inode(jour
>>  restart:
>>  	spin_lock(&journal->j_list_lock);
>>  	/* Is commit writing out inode - we have to wait */
>> -	if (jinode->i_flags & JI_COMMIT_RUNNING) {
>> +	if (test_bit(__JI_COMMIT_RUNNING, &jinode->i_flags)) {
>>  		wait_queue_head_t *wq;
>>  		DEFINE_WAIT_BIT(wait, &jinode->i_flags, __JI_COMMIT_RUNNING);
>> +		smp_mb();
>>  		wq = bit_waitqueue(&jinode->i_flags, __JI_COMMIT_RUNNING);
>>  		prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
>>  		spin_unlock(&journal->j_list_lock);
> 
> 						- Ted


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


