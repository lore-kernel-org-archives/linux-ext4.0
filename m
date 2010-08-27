From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCHv2 1/1] jbd2: Fix I/O hang in jbd2_journal_release_jbd_inode
Date: Fri, 27 Aug 2010 14:28:07 -0500
Message-ID: <4C7811C7.2050506@linux.vnet.ibm.com>
References: <201007141456.o6EEuFe9004519@d01av03.pok.ibm.com> <20100714174458.GA2378@localhost.localdomain> <4C3E08E6.2050203@linux.vnet.ibm.com> <20100827191025.GV4453@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org,
	cmm@linux.vnet.ibm.com, pmac@au1.ibm.com
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41224 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389Ab0H0T2F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Aug 2010 15:28:05 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id o7RJLplm031866
	for <linux-ext4@vger.kernel.org>; Fri, 27 Aug 2010 15:21:51 -0400
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o7RJS49h449042
	for <linux-ext4@vger.kernel.org>; Fri, 27 Aug 2010 15:28:04 -0400
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o7RJS3NE015497
	for <linux-ext4@vger.kernel.org>; Fri, 27 Aug 2010 13:28:04 -0600
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

It may not be necessary. I originally added it in order to balance
the test_bit with the clear_bit. I'll check with the folks hitting this
in test and see if I can get access to the failing machine. If so,
I'll pull this out and see if we actually need it or not.

Thanks,

Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


