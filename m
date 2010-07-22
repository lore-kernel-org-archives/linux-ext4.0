From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCHv2 1/1] jbd2: Fix I/O hang in jbd2_journal_release_jbd_inode
Date: Thu, 22 Jul 2010 16:30:54 -0500
Message-ID: <4C48B88E.2010703@linux.vnet.ibm.com>
References: <201007141456.o6EEuFe9004519@d01av03.pok.ibm.com> <20100714174458.GA2378@localhost.localdomain> <4C3E08E6.2050203@linux.vnet.ibm.com> <20100721190252.GG1215@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org,
	cmm@linux.vnet.ibm.com, pmac@au1.ibm.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:48820 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab0GVVbF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Jul 2010 17:31:05 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o6MLQQLX012874
	for <linux-ext4@vger.kernel.org>; Thu, 22 Jul 2010 15:26:26 -0600
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o6MLUwMR093754
	for <linux-ext4@vger.kernel.org>; Thu, 22 Jul 2010 15:31:01 -0600
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o6MLUslB016801
	for <linux-ext4@vger.kernel.org>; Thu, 22 Jul 2010 15:30:55 -0600
In-Reply-To: <20100721190252.GG1215@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/21/2010 02:02 PM, Jan Kara wrote:
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
>> in this path.
>   Thanks for debugging this! I was thinking hard about how it could happen that
> wake_up_bit doesn't wake up the waiter but I haven't found any explanation. All
> the waitqueue work seems to be properly wrapped inside the j_list_lock so
> even the waitqueue_active check in wake_up_bit should be fine.
>   I'd really like to understand what in my mind-model of spinlocks etc. is
> wrong. So could you maybe run a test with the attached debug patch and
> dump 'wait.seen' value in the hung task?
>   And one more question - if you remove 'waitqueue_active' check from
> kernel/wait.c:__wake_up_bit
>   is the problem still present? Thanks a lot in advance.

I'll see about getting one of our systems loaded up with this change and see
what happens. 

Thanks!

Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


