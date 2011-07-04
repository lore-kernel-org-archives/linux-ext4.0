From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/2 v3] EXT4: Secure Delete: Zero out file data
Date: Mon, 4 Jul 2011 20:44:01 +0300
Message-ID: <CAOQ4uxjwHeP3DqgbW2mJ8wBi=HBcDd-UTaZ=XTsSAcH+jdNvJQ@mail.gmail.com>
References: <1309468923-5677-1-git-send-email-achender@linux.vnet.ibm.com>
	<1309468923-5677-2-git-send-email-achender@linux.vnet.ibm.com>
	<CAOQ4uxicueV9QOvHEhyk0mNSs+B+dT1X=Z64i_L2_qn6X6_vHA@mail.gmail.com>
	<E9840366-F572-48CA-B71F-D9AF5E11EBCC@dilger.ca>
	<CAOQ4uxj26t=Z6mssXZ3dY7=yd8_upuy7-ZMpHrsCbQczp7O0Og@mail.gmail.com>
	<4E11F61C.6070100@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63134 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535Ab1GDRoE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Jul 2011 13:44:04 -0400
Received: by wyg8 with SMTP id 8so3536756wyg.19
        for <linux-ext4@vger.kernel.org>; Mon, 04 Jul 2011 10:44:02 -0700 (PDT)
In-Reply-To: <4E11F61C.6070100@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 4, 2011 at 8:19 PM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> On 07/03/2011 12:37 AM, Amir Goldstein wrote:
>>
>> On Sun, Jul 3, 2011 at 10:00 AM, Andreas Dilger<adilger@dilger.ca> =A0=
wrote:
>>>
>>> On 2011-07-02, at 3:33 AM, Amir Goldstein<amir73il@gmail.com> =A0wr=
ote:
>>>
>>>> On Fri, Jul 1, 2011 at 12:22 AM, Allison Henderson
>>>> <achender@linux.vnet.ibm.com> =A0wrote:
>>>>>
>>>>> The first patch adds a new flag, EXT4_FREE_BLOCKS_ZERO,
>>>>> to ext4_free_blocks. This flag causes causes blocks to be
>>>>> zerod before they are freed. =A0Files that have the EXT4_SECRM_FL
>>>>> attribute flag on will have their blocks zerod when
>>>>> they are released. =A0The EXT4_SECRM_FL attribute flag can
>>>>> be enabled useing chattr +s
>>>>>
>>>>> Signed-off-by: Allison Henderson<achender@linux.vnet.ibm.com>
>>>>> ---
>>>>> v1->v2
>>>>> Removed check for discard mount option and replaced with
>>>>> check for secure discard and discard_zeroes_data
>>>>>
>>>>> Added BLKDEV_DISCARD_SECURE to the sb_issue_discard call
>>>>>
>>>>> v2->v3
>>>>> Removed code for discard. =A0A seperate patch will
>>>>> be done to add that code in the block layer
>>>>>
>>>>> :100644 100644 1921392... 38a4d75... M =A0fs/ext4/ext4.h
>>>>> :100644 100644 f815cc8... cf178f3... M =A0fs/ext4/extents.c
>>>>> :100644 100644 62f86e7... 8fdae7d... M =A0fs/ext4/inode.c
>>>>> :100644 100644 6ed859d... 94872b2... M =A0fs/ext4/mballoc.c
>>>>> :100644 100644 c757adc... 1ff7532... M =A0fs/ext4/xattr.c
>>>>> =A0fs/ext4/ext4.h =A0 =A0| =A0 =A01 +
>>>>> =A0fs/ext4/extents.c | =A0 =A03 +++
>>>>> =A0fs/ext4/inode.c =A0 | =A0 =A03 +++
>>>>> =A0fs/ext4/mballoc.c | =A0 =A08 ++++++++
>>>>> =A0fs/ext4/xattr.c =A0 | =A0 12 ++++++++----
>>>>> =A05 files changed, 23 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>>>>> index 1921392..38a4d75 100644
>>>>> --- a/fs/ext4/ext4.h
>>>>> +++ b/fs/ext4/ext4.h
>>>>> @@ -526,6 +526,7 @@ struct ext4_new_group_data {
>>>>> =A0#define EXT4_FREE_BLOCKS_METADATA 0x0001
>>>>> =A0#define EXT4_FREE_BLOCKS_FORGET =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
0x0002
>>>>> =A0#define EXT4_FREE_BLOCKS_VALIDATED 0x0004
>>>>> +#define EXT4_FREE_BLOCKS_ZERO =A0 =A0 =A0 =A0 =A00x0008
>>>>>
>>>>> =A0/*
>>>>> =A0* ioctl commands
>>>>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>>>>> index f815cc8..cf178f3 100644
>>>>> --- a/fs/ext4/extents.c
>>>>> +++ b/fs/ext4/extents.c
>>>>> @@ -2231,6 +2231,9 @@ static int ext4_remove_blocks(handle_t *han=
dle,
>>>>> struct inode *inode,
>>>>>
>>>>> =A0 =A0 =A0 =A0if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mod=
e))
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flags |=3D EXT4_FREE_BLOCKS_METADA=
TA;
>>>>> +
>>>>> + =A0 =A0 =A0 if (EXT4_I(inode)->i_flags& =A0EXT4_SECRM_FL)
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D EXT4_FREE_BLOCKS_ZERO;
>>>>> =A0#ifdef EXTENTS_STATS
>>>>> =A0 =A0 =A0 =A0{
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct ext4_sb_info *sbi =3D EXT4_=
SB(inode->i_sb);
>>>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>>>>> index 62f86e7..8fdae7d 100644
>>>>> --- a/fs/ext4/inode.c
>>>>> +++ b/fs/ext4/inode.c
>>>>> @@ -4182,6 +4182,9 @@ static int ext4_clear_blocks(handle_t *hand=
le,
>>>>> struct inode *inode,
>>>>> =A0 =A0 =A0 =A0for (p =3D first; p< =A0last; p++)
>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*p =3D 0;
>>>>>
>>>>> + =A0 =A0 =A0 if (EXT4_I(inode)->i_flags& =A0EXT4_SECRM_FL)
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D EXT4_FREE_BLOCKS_ZERO;
>>>>> +
>>>>> =A0 =A0 =A0 =A0ext4_free_blocks(handle, inode, NULL, block_to_fre=
e, count,
>>>>> flags);
>>>>> =A0 =A0 =A0 =A0return 0;
>>>>> =A0out_err:
>>>>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>>>>> index 6ed859d..94872b2 100644
>>>>> --- a/fs/ext4/mballoc.c
>>>>> +++ b/fs/ext4/mballoc.c
>>>>> @@ -4485,6 +4485,14 @@ void ext4_free_blocks(handle_t *handle, st=
ruct
>>>>> inode *inode,
>>>>> =A0 =A0 =A0 =A0ext4_debug("freeing block %llu\n", block);
>>>>> =A0 =A0 =A0 =A0trace_ext4_free_blocks(inode, block, count, flags)=
;
>>>>>
>>>>> + =A0 =A0 =A0 if (flags& =A0EXT4_FREE_BLOCKS_ZERO) {
>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D sb_issue_zeroout(inode->i_s=
b, block, count,
>>>>> GFP_NOFS);
>>>>
>>>> But the delete of these blocks in not yet committed,
>>>> so after reboot, you can end up with a non-deleted but zeroed file=
 data.
>>>> Is that acceptable? I should think not.
>>>>
>>>> One way around this is a 2-phase unlink/truncate.
>>>> Phase 1: add to orphan list and register a callback on commit
>>>> Phase 2: issue zeroout and free the blocks
>>>
>>> I didn't look at this very closely, but I thought the place this wa=
s
>>> being done was in the mballoc commit callback, so that it only zero=
es the
>>> blocks after they are really freed?
>>
>> Nope, the zeroout is in the beginning of ext4_free_blocks().
>> I also thought it was a mistake until I realized the purpose of secu=
re
>> delete was security,
>> so deleting non-zeroed blocks is not an option.
>>
>>>
>>> The danger then would be that you want to complete the zeroing of t=
he
>>> blocks before they are reallocated.
>>>
>>
>> Actually, I think the secure delete requirement is stronger - that
>> zeroing is completed *before* blocks are freed.
>> Otherwise, after blocks are freed, the power may go down and the dis=
ks
>> may be mounted on a different
>> system where the deleted blocks can be reallocated.
>
> Thx all for the reviews! =A0It sounds like the zero out code is in th=
e right
> spot then. =A0We are thinking about adding an optimization too, where=
 we use
> use secure discard instead of the sb_issue_zeroout, but only if the d=
evice
> supports it. =A0I was thinking about putting that code some where in =
the
> commit call back because that is where the existing discard code is, =
but
> maybe that's not such a good place to put it then? =A0What does every=
one
> think? =A0Thx!
>
> Allison
>

I already stated my opinion about the need for 2-phase secure delete.
If you have to choose between security (zeroout pre commit) and the
atomicity of the unlink() command (zeroout post commit), then it's
a question of policy.
Is there any other FS (or OS) that implements secure delete?
Perhaps we could follow its semantics.

Cheers,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
