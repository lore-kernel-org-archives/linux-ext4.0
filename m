From: Nikhilesh Reddy <reddyn@codeaurora.org>
Subject: Re: Emergency remount readonly and EFBIG errors when unlinking files
 on 3.18 android kernel
Date: Wed, 27 Apr 2016 10:56:35 -0700
Message-ID: <5720FD53.6010707@codeaurora.org>
References: <571FE6DB.8030604@codeaurora.org> <20160427030736.GB30021@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46295 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbcD0R4h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Apr 2016 13:56:37 -0400
In-Reply-To: <20160427030736.GB30021@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

Thanks for your reply
Yes the sentence below should have the *if* .. sorry about the typo
The issue doesnt happen if all the writer processes/threads are killed 
before the
emergency remount

>
> Note that an emergency remount is very much an emergency.  So we don't
> do a graceful shutdown of any pending writes.  (Normally we would
> return EBUSY if there anything that would prevent a clean remount.)
> In the emergency remount path, we bypass all of these checks.
>
>> And on disk we see that one of the files being written to has incorrect
>> ext4_inode->i_blocks_lo ( which is less than the the size of the file by
>> something like 2k)
>>
>> When unlinking this file the vfs inode->iblocks underflows and we end up
>> with EFBIG if EXT4_FEATURE_RO_COMPAT_HUGE_FILE is not enabled in the
>> superblock.
>>
>> Is this a known issue?
>
> No, this isn't a known issue.  I've never seen anything like this, but
> all of the tests we do assume a forced poweroff, which we simulate
> using dm-flakey.  We do *not* test the blunt-force-trauma which is
> inflected on the file system structures which results from doing an
> emergency remount.
>
> Off by 2k really doesn't make sense.  I could see if it was off by 4k,
> but 2k is really wierd.

Just to clarify when i say off by 2k .. i meant the i_blocks count not 
the actual size file ( which would be 2k * 512 if i am not wrong)

For example we see fsck report
Pass 1: Checking inodes, blocks, and sizes
Inode XXX, i_blocks is 854024, should be 856072.

>
>> I would appreciate if you could point me in the right direction and any help
>> you can give me.
>
> Well, what I'd do is create a new ioctl interface which simulates an
> emergency ro on just the one device, and try to create a reliable
> repro.  Eventually we'll want to add some tests for this in xfstests.
>

Thanks so much for your suggestion.
I will try to see if i can reliably reproduce the issue after 
implementing the ioctl as you suggested.
I have some issues getting the xfs tests to run on the device which i 
have been meaning to work on .. maybe this is the time to do so.


-- 
Thanks
Nikhilesh Reddy

Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
