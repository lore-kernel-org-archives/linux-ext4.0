From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2 v3] EXT4: Secure Delete: Zero out file data
Date: Fri, 08 Jul 2011 13:43:55 -0700
Message-ID: <4E176C0B.9060308@linux.vnet.ibm.com>
References: <1309468923-5677-1-git-send-email-achender@linux.vnet.ibm.com> <1309468923-5677-2-git-send-email-achender@linux.vnet.ibm.com> <CAOQ4uxicueV9QOvHEhyk0mNSs+B+dT1X=Z64i_L2_qn6X6_vHA@mail.gmail.com> <4E14CE15.90404@linux.vnet.ibm.com> <CAOQ4uxh4iUKjDgCBV54VxZ4PhDi18aqL3O6YHOoMYrHyXcECiA@mail.gmail.com> <2DE49B61-CC67-4613-99EB-88601D6EC564@dilger.ca> <4E1614C1.1050209@linux.vnet.ibm.com> <CAOQ4uxiV+h3G7vPZtZp0afbhek8uAP0gER+H7yS9xdrr_XBmVw@mail.gmail.com> <4E16639A.3060504@linux.vnet.ibm.com> <CAOQ4uxjZNduK5BtmwBnGoz=Gvr2C3twV5aPK2xhT0YSC29RYOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	Mingming Cao <cmm@linux.vnet.ibm.com>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:56977 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab1GHUoA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Jul 2011 16:44:00 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p68KaNsL010330
	for <linux-ext4@vger.kernel.org>; Fri, 8 Jul 2011 14:36:23 -0600
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p68Khv75129460
	for <linux-ext4@vger.kernel.org>; Fri, 8 Jul 2011 14:43:57 -0600
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p68KhuOq005756
	for <linux-ext4@vger.kernel.org>; Fri, 8 Jul 2011 14:43:57 -0600
In-Reply-To: <CAOQ4uxjZNduK5BtmwBnGoz=Gvr2C3twV5aPK2xhT0YSC29RYOg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/07/2011 11:29 PM, Amir Goldstein wrote:
> On Fri, Jul 8, 2011 at 4:55 AM, Allison Henderson
> <achender@linux.vnet.ibm.com>  wrote:
>> On 07/07/2011 05:09 PM, Amir Goldstein wrote:
>>>
>>> On Thu, Jul 7, 2011 at 11:19 PM, Allison Henderson
>>> <achender@linux.vnet.ibm.com>    wrote:
>>>>
>>>> On 07/07/2011 12:52 PM, Andreas Dilger wrote:
>>>>>
>>>>> On 2011-07-07, at 1:05 AM, Amir Goldstein wrote:
>>>>>>
>>>>>> On Thu, Jul 7, 2011 at 12:05 AM, Allison Henderson
>>>>>> <achender@linux.vnet.ibm.com>      wrote:
>>>>>>>
>>>>>>> On 07/02/2011 02:33 AM, Amir Goldstein wrote:
>>>>>>>>
>>>>>>>> On Fri, Jul 1, 2011 at 12:22 AM, Allison Henderson
>>>>>>>> <achender@linux.vnet.ibm.com>       wrote:
>>>>>>>>>
>>>>>>>>> @@ -4485,6 +4485,14 @@ void ext4_free_blocks(handle_t *handle,
>>>>>>>>> struct
>>>>>>>>> inode *inode,
>>>>>>>>>         ext4_debug("freeing block %llu\n", block);
>>>>>>>>>         trace_ext4_free_blocks(inode, block, count, flags);
>>>>>>>>>
>>>>>>>>> +       if (flags&       EXT4_FREE_BLOCKS_ZERO) {
>>>>>>>>> +               err = sb_issue_zeroout(inode->i_sb, block, count,
>>>>>>>>> GFP_NOFS);
>>>>>>>>
>>>>>>>> But the delete of these blocks in not yet committed,
>>>>>>>> so after reboot, you can end up with a non-deleted but zeroed file
>>>>>>>> data.
>>>>>>>> Is that acceptable? I should think not.
>>>>>>>>
>>>>>>>> One way around this is a 2-phase unlink/truncate.
>>>>>>>> Phase 1: add to orphan list and register a callback on commit
>>>>>>>> Phase 2: issue zeroout and free the blocks
>>>>>>>>
>>>>>>>> This won't work for punch hole, but then again, for punch hole
>>>>>>>> it's probably OK to end up with zeroed data, but non-deleted blocks.
>>>>>>>> Right?
>>>>>>>
>>>>>>> Hi, I had a quick question about the orphan list.  I notice that
>>>>>>> ext4_ext_truncate and also ext4_ext_punch_hole already have a call to
>>>>>>> ext4_orphan_add that happens really early before any calls to free
>>>>>>> blocks.
>>>>>>>   Does this address your earlier concerns, or is there another reason I
>>>>>>> missed?  Thx!
>>>>>>
>>>>>> It doesn't address the concerns of getting a non-deleted file with
>>>>>> zeroed
>>>>>> data
>>>>>> after crash, because the existence of the inode on the orphan list
>>>>>> after
>>>>>> crash
>>>>>> depends on the transaction that added it to the list being committed.
>>>>>> And your patch zeroes the blocks before that transaction is committed.
>>>>>>
>>>>>> However, the orphan list gives you a very good framework to implement
>>>>>> deferred delete (by a kernel thread) as Andreas suggested.
>>>>>> Unlink should be simple, because freeing unlinked inode blocks it is
>>>>>> anyway
>>>>>> deferred till the inode refcount drops to zero.
>>>>>
>>>>> Right.  The patch that I referenced moved all of the blocks from unlink
>>>>> and truncate-to-zero from the current inode to a new temporary inode on
>>>>> the
>>>>> orphan list (simply copying the i_blocks field + i_block and i_size,
>>>>> IIRC,
>>>>> and zeroing them on the original inode).
>>>>>
>>>>>> Truncate is more tricky, because of the truncate shrink/extend
>>>>>> requirement
>>>>>> (that all data is zeroes after extending the inode's size via truncate
>>>>>> system call), so a shrinking-deferred truncate would have to mark all
>>>>>> the
>>>>>> to-be-deleted extents uninitialized.
>>>>>
>>>>> It would be possible to do this for partial truncate/punch as well, to
>>>>> move whole blocks over to a new inode on the orphan list and zeroing
>>>>> only
>>>>> the 1 or 2 partial blocks inline.
>>>>>
>>>>> It should even be possible to leverage the "block migrate" facility used
>>>>> by defrag, so that we don't duplicate this code.  That would mean just
>>>>> allocating a temp "unlink" inode in the kernel and putting it on the
>>>>> orphan
>>>>> list (like an open-unlinked file), migrate the selected range of blocks,
>>>>> and then zeroing the blocks in the background before unlinking the
>>>>> inode.
>>>>>
>>>>> I don't think that just marking the deleted extents as uninitialized is
>>>>> enough, since it would still leave "private" data on disk that could be
>>>>> read afterward.  This would also only work for extent-mapped
>>>>> filesystems.
>>>>>
>>>>> There may need to be some work to enable the migrate code on
>>>>> block-mapped
>>>>> files, if you want to allow secure-delete on those files, but that is
>>>>> good
>>>>> IMHO since it also means that we could defrag block-mapped files.
>>>>>
>>>>> Cheers, Andreas
>>>>>
>>>>
>>>> Ah, ok then.  Yes, part of the requirements was to make secure delete
>>>> work
>>>> for partial truncates, punch hole, and also indexed files.  So that will
>>>> save me some time if I can get the migrate routines work.  Thx for the
>>>> pointers all!
>>>>
>>>
>>> I realized that there is a basic flaw in the concept of
>>> deferred-secure-delete.
>>>   From a security point of view, after a crash during a secure-delete,
>>> if the file is not there, all its data should have been wiped.
>>> Orphan cleanup on the next mount may be done on a system that
>>> doesn't respect secure delete.
>>> So for real security, the unlink/truncate command cannot return before
>>> all data is wiped.
>>> The unlink/truncate metadata changes must not even be committed
>>> before all data is wiped (or at least part of the data with partial
>>> truncate).
>>>
>>> Amir.
>>
>>
>> I see, so then it sounds like using a background thread to do the zeroing
>> would not help us if we have to wait for it complete anyway. Going back to
>> the 2 phase approach, this means that we need to do the zero out and then
>> the free before we do the orphan list and commit? Just trying to make sure I
>> understand things correctly :)
>>
>
> Well, that really depends of the precise definition of "secure delete".
> If you agree with the "100% secure" interpretation, then your current patch
> is "almost" correct.
> I can see 2 things that are missing:
> 1. ext4_unlink() will have to invoke ext4_truncate(0) directly just
> like truncate system call does.
> This is to prevent an attacker from keeping the protected file open
> and preventing freeing
> of it's data when the file is removed from the name space.
> 2. ext4_truncate() currently changes i_disksize first (and adds inode
> to orphan list)
> and then frees the blocks. for 100% secure delete, you cannot change i_disksize
> before zeroing the blocks, so it has to be:
> - zeroout range
> - change i_disksize and add to orphan list
> - free blocks
>
> I don't see how it could be done any other way, but maybe someone else can...
>
> Amir.

Ok, I seem to have a lot voices that are interested in the synchronous 
implementation, and I think it is a reasonable design too.  So I am 
going to move forward with this, but I will keep an eye on this thread. 
  I suppose if we get more voices that are interested in the 
asynchronous approach we could always add it as an optimization later. 
Thx all for your feed back!!  :)

Allison Henderson
