From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/2 v3] EXT4: Secure Delete: Zero out file data
Date: Fri, 8 Jul 2011 03:09:08 +0300
Message-ID: <CAOQ4uxiV+h3G7vPZtZp0afbhek8uAP0gER+H7yS9xdrr_XBmVw@mail.gmail.com>
References: <1309468923-5677-1-git-send-email-achender@linux.vnet.ibm.com>
	<1309468923-5677-2-git-send-email-achender@linux.vnet.ibm.com>
	<CAOQ4uxicueV9QOvHEhyk0mNSs+B+dT1X=Z64i_L2_qn6X6_vHA@mail.gmail.com>
	<4E14CE15.90404@linux.vnet.ibm.com>
	<CAOQ4uxh4iUKjDgCBV54VxZ4PhDi18aqL3O6YHOoMYrHyXcECiA@mail.gmail.com>
	<2DE49B61-CC67-4613-99EB-88601D6EC564@dilger.ca>
	<4E1614C1.1050209@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50418 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab1GHAJJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Jul 2011 20:09:09 -0400
Received: by wwe5 with SMTP id 5so1442507wwe.1
        for <linux-ext4@vger.kernel.org>; Thu, 07 Jul 2011 17:09:08 -0700 (PDT)
In-Reply-To: <4E1614C1.1050209@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 7, 2011 at 11:19 PM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> On 07/07/2011 12:52 PM, Andreas Dilger wrote:
>>
>> On 2011-07-07, at 1:05 AM, Amir Goldstein wrote:
>>>
>>> On Thu, Jul 7, 2011 at 12:05 AM, Allison Henderson
>>> <achender@linux.vnet.ibm.com> =A0wrote:
>>>>
>>>> On 07/02/2011 02:33 AM, Amir Goldstein wrote:
>>>>>
>>>>> On Fri, Jul 1, 2011 at 12:22 AM, Allison Henderson
>>>>> <achender@linux.vnet.ibm.com> =A0 wrote:
>>>>>>
>>>>>> @@ -4485,6 +4485,14 @@ void ext4_free_blocks(handle_t *handle, s=
truct
>>>>>> inode *inode,
>>>>>> =A0 =A0 =A0 =A0ext4_debug("freeing block %llu\n", block);
>>>>>> =A0 =A0 =A0 =A0trace_ext4_free_blocks(inode, block, count, flags=
);
>>>>>>
>>>>>> + =A0 =A0 =A0 if (flags& =A0 EXT4_FREE_BLOCKS_ZERO) {
>>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D sb_issue_zeroout(inode->i_=
sb, block, count,
>>>>>> GFP_NOFS);
>>>>>
>>>>> But the delete of these blocks in not yet committed,
>>>>> so after reboot, you can end up with a non-deleted but zeroed fil=
e
>>>>> data.
>>>>> Is that acceptable? I should think not.
>>>>>
>>>>> One way around this is a 2-phase unlink/truncate.
>>>>> Phase 1: add to orphan list and register a callback on commit
>>>>> Phase 2: issue zeroout and free the blocks
>>>>>
>>>>> This won't work for punch hole, but then again, for punch hole
>>>>> it's probably OK to end up with zeroed data, but non-deleted bloc=
ks.
>>>>> Right?
>>>>
>>>> Hi, I had a quick question about the orphan list. =A0I notice that
>>>> ext4_ext_truncate and also ext4_ext_punch_hole already have a call=
 to
>>>> ext4_orphan_add that happens really early before any calls to free
>>>> blocks.
>>>> =A0Does this address your earlier concerns, or is there another re=
ason I
>>>> missed? =A0Thx!
>>>
>>> It doesn't address the concerns of getting a non-deleted file with =
zeroed
>>> data
>>> after crash, because the existence of the inode on the orphan list =
after
>>> crash
>>> depends on the transaction that added it to the list being committe=
d.
>>> And your patch zeroes the blocks before that transaction is committ=
ed.
>>>
>>> However, the orphan list gives you a very good framework to impleme=
nt
>>> deferred delete (by a kernel thread) as Andreas suggested.
>>> Unlink should be simple, because freeing unlinked inode blocks it i=
s
>>> anyway
>>> deferred till the inode refcount drops to zero.
>>
>> Right. =A0The patch that I referenced moved all of the blocks from u=
nlink
>> and truncate-to-zero from the current inode to a new temporary inode=
 on
>> the
>> orphan list (simply copying the i_blocks field + i_block and i_size,=
 IIRC,
>> and zeroing them on the original inode).
>>
>>> Truncate is more tricky, because of the truncate shrink/extend
>>> requirement
>>> (that all data is zeroes after extending the inode's size via trunc=
ate
>>> system call), so a shrinking-deferred truncate would have to mark a=
ll the
>>> to-be-deleted extents uninitialized.
>>
>> It would be possible to do this for partial truncate/punch as well, =
to
>> move whole blocks over to a new inode on the orphan list and zeroing=
 only
>> the 1 or 2 partial blocks inline.
>>
>> It should even be possible to leverage the "block migrate" facility =
used
>> by defrag, so that we don't duplicate this code. =A0That would mean =
just
>> allocating a temp "unlink" inode in the kernel and putting it on the
>> orphan
>> list (like an open-unlinked file), migrate the selected range of blo=
cks,
>> and then zeroing the blocks in the background before unlinking the i=
node.
>>
>> I don't think that just marking the deleted extents as uninitialized=
 is
>> enough, since it would still leave "private" data on disk that could=
 be
>> read afterward. =A0This would also only work for extent-mapped files=
ystems.
>>
>> There may need to be some work to enable the migrate code on block-m=
apped
>> files, if you want to allow secure-delete on those files, but that i=
s good
>> IMHO since it also means that we could defrag block-mapped files.
>>
>> Cheers, Andreas
>>
>
> Ah, ok then. =A0Yes, part of the requirements was to make secure dele=
te work
> for partial truncates, punch hole, and also indexed files. =A0So that=
 will
> save me some time if I can get the migrate routines work. =A0Thx for =
the
> pointers all!
>

I realized that there is a basic flaw in the concept of deferred-secure=
-delete.
=46rom a security point of view, after a crash during a secure-delete,
if the file is not there, all its data should have been wiped.
Orphan cleanup on the next mount may be done on a system that
doesn't respect secure delete.
So for real security, the unlink/truncate command cannot return before
all data is wiped.
The unlink/truncate metadata changes must not even be committed
before all data is wiped (or at least part of the data with partial tru=
ncate).

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
