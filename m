From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/2 v3] EXT4: Secure Delete: Zero out file data
Date: Thu, 7 Jul 2011 13:52:10 -0600
Message-ID: <2DE49B61-CC67-4613-99EB-88601D6EC564@dilger.ca>
References: <1309468923-5677-1-git-send-email-achender@linux.vnet.ibm.com> <1309468923-5677-2-git-send-email-achender@linux.vnet.ibm.com> <CAOQ4uxicueV9QOvHEhyk0mNSs+B+dT1X=Z64i_L2_qn6X6_vHA@mail.gmail.com> <4E14CE15.90404@linux.vnet.ibm.com> <CAOQ4uxh4iUKjDgCBV54VxZ4PhDi18aqL3O6YHOoMYrHyXcECiA@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:11309 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab1GGTwM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Jul 2011 15:52:12 -0400
In-Reply-To: <CAOQ4uxh4iUKjDgCBV54VxZ4PhDi18aqL3O6YHOoMYrHyXcECiA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-07-07, at 1:05 AM, Amir Goldstein wrote:
> On Thu, Jul 7, 2011 at 12:05 AM, Allison Henderson
> <achender@linux.vnet.ibm.com> wrote:
>> On 07/02/2011 02:33 AM, Amir Goldstein wrote:
>>> On Fri, Jul 1, 2011 at 12:22 AM, Allison Henderson
>>> <achender@linux.vnet.ibm.com>  wrote:
>>>> @@ -4485,6 +4485,14 @@ void ext4_free_blocks(handle_t *handle, struct
>>>> inode *inode,
>>>>        ext4_debug("freeing block %llu\n", block);
>>>>        trace_ext4_free_blocks(inode, block, count, flags);
>>>> 
>>>> +       if (flags&  EXT4_FREE_BLOCKS_ZERO) {
>>>> +               err = sb_issue_zeroout(inode->i_sb, block, count,
>>>> GFP_NOFS);
>>> 
>>> But the delete of these blocks in not yet committed,
>>> so after reboot, you can end up with a non-deleted but zeroed file data.
>>> Is that acceptable? I should think not.
>>> 
>>> One way around this is a 2-phase unlink/truncate.
>>> Phase 1: add to orphan list and register a callback on commit
>>> Phase 2: issue zeroout and free the blocks
>>> 
>>> This won't work for punch hole, but then again, for punch hole
>>> it's probably OK to end up with zeroed data, but non-deleted blocks.
>>> Right?
>> 
>> Hi, I had a quick question about the orphan list.  I notice that
>> ext4_ext_truncate and also ext4_ext_punch_hole already have a call to
>> ext4_orphan_add that happens really early before any calls to free blocks.
>>  Does this address your earlier concerns, or is there another reason I
>> missed?  Thx!
> 
> It doesn't address the concerns of getting a non-deleted file with zeroed data
> after crash, because the existence of the inode on the orphan list after crash
> depends on the transaction that added it to the list being committed.
> And your patch zeroes the blocks before that transaction is committed.
> 
> However, the orphan list gives you a very good framework to implement
> deferred delete (by a kernel thread) as Andreas suggested.
> Unlink should be simple, because freeing unlinked inode blocks it is anyway
> deferred till the inode refcount drops to zero.

Right.  The patch that I referenced moved all of the blocks from unlink
and truncate-to-zero from the current inode to a new temporary inode on the
orphan list (simply copying the i_blocks field + i_block and i_size, IIRC,
and zeroing them on the original inode).

> Truncate is more tricky, because of the truncate shrink/extend requirement
> (that all data is zeroes after extending the inode's size via truncate
> system call), so a shrinking-deferred truncate would have to mark all the
> to-be-deleted extents uninitialized.

It would be possible to do this for partial truncate/punch as well, to
move whole blocks over to a new inode on the orphan list and zeroing only
the 1 or 2 partial blocks inline.

It should even be possible to leverage the "block migrate" facility used
by defrag, so that we don't duplicate this code.  That would mean just
allocating a temp "unlink" inode in the kernel and putting it on the orphan
list (like an open-unlinked file), migrate the selected range of blocks,
and then zeroing the blocks in the background before unlinking the inode.

I don't think that just marking the deleted extents as uninitialized is
enough, since it would still leave "private" data on disk that could be
read afterward.  This would also only work for extent-mapped filesystems.

There may need to be some work to enable the migrate code on block-mapped
files, if you want to allow secure-delete on those files, but that is good
IMHO since it also means that we could defrag block-mapped files.

Cheers, Andreas





