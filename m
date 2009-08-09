From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [RFC][PATCH 1/7]ext4: Add EXT4_IOC_ADD_GLOBAL_ALLOC_RULE
	restricts block allocation
Date: Sun, 9 Aug 2009 14:18:39 -0400
Message-ID: <87f94c370908091118l4e0923feyf36eb2a067a3f948@mail.gmail.com>
References: <4A409168.3020404@rs.jp.nec.com>
	 <20090623231950.GN31668@webber.adilger.int>
	 <4A7BCCD8.1070500@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Akira Fujita <a-fujita@rs.jp.nec.com>,
	Andreas Dilger <adilger@sun.com>, Theodore Tso <tytso@mit.edu>,
	ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f196.google.com ([209.85.221.196]:63924 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbZHISSj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 9 Aug 2009 14:18:39 -0400
Received: by qyk34 with SMTP id 34so2309689qyk.33
        for <linux-ext4@vger.kernel.org>; Sun, 09 Aug 2009 11:18:39 -0700 (PDT)
In-Reply-To: <4A7BCCD8.1070500@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Akira-san,

I joined the project ohsm team a couple weeks ago and we hope to use
your patches / features to build on.  Below is our feedback as relates
to ohsm as well as my personal feedback.

2009/8/7 Akira Fujita <a-fujita@rs.jp.nec.com>:
> Hi Andreas,
>
> Andreas Dilger wrote:
>> On Jun 23, 2009 =A017:25 +0900, Akira Fujita wrote:
>>> alloc_flag of ext4_alloc_rule structure is set as "mandatory" or "a=
dvisory".
>>> Restricted blocks with "mandatory" are never used by block allocato=
r.
>>> But in "advisory" case, block allocator is allowed to use restricte=
d blocks
>>> when there are no free blocks on FS.
>>
>> Would it make more sense to implement the range protections via the
>> existing preallocation ranges (PA)? =A0An inode can have multiple
>> PAs attached to it to have it prefer allocations from that range.
>>
>> We could also attach PAs to the superblock to prevent other files fr=
om
>> allocating out of those ranges. =A0This would work better with the e=
xisting
>> allocation code instead of creating a second similar mechanism.
>
> Thank you for comments.
>
> I have considered about the block allocation control with preallocati=
on (PA).
> This is my new implementation idea.
>
> a. Block allocation restriction (balloc restriction)
> =A0 Redesigned balloc restriction ioctl (EXT4_IOC_BALOC_CONTROL) can =
set
> =A0 and clear protected ranges with flag.
> =A0 And balloc restriction used a new type PA (MB_RESTRICT_PA),
> =A0 not inode PA (MB_INODE_PA) and group PA (MB_GROUP_PA).
>
> =A0 Previous my patch set has implemented two restriction types: mand=
atory
> =A0 (never used by block allocator) and advisory (used if there is
> =A0 no other free blocks to allocate).
> =A0 But, to make more simple, I implement only mandatory mode.

The ohsm team has no current specific plan to use "Block allocation
restriction", but if we did it would be in the advisory role.  We
agree this functionality can be added later when there is an actual
user.

> =A0 With "SET_BALLOC_RESTRICTION" flag, this ioctl sets MB_RESTRIT_PA=
,
> =A0 and blocks in this PA covers are protected from other block alloc=
ator.
> =A0 If you want to use these ranges, call with "CLR_BALLOC_RESTRICTIO=
IN" flag.
>
> =A0 EXT4_IOC_BALLOC_CONTROL calls ext4_mb_new_blocks(). =A0It tries t=
o check
> =A0 whether specified range blocks are free or not with mballoc routi=
ne.
> =A0 If range blocks are free, ext4_mb_new_blocks() sets memory block =
bitmap
> =A0 used (same as ext4 PA), and then adds this information to restric=
tion PA.
> =A0 But it does *not* set disk block bitmap used, because these block=
s are part of PA.
>
> =A0 ext4_prealloc_space has a new list structure "pa_restrict_list" w=
hich holds
> =A0 restriction PA passed from user-space.
> =A0 ext4_group_info also has a new list structure "bb_restrict_reques=
t" which holds
> =A0 block group related restriction range.
> =A0 This list is used, when we calculate blocks count which are free
> =A0 but can not use because of restriction PA.

Can't say I know enough to comment on the implementation details.

>
> b. Preferred block allocation for inode (preferred balloc)
> =A0 EXT4_IOC_ADD_PREALLOC adds specified blocks to the inode PA.
> =A0 You can set arbitrary blocks ranges to inode PA,
> =A0 this is the different from fallocate.
>

This function is the core functionality that ohsm still needs from
ext4, and we look forward to seeing actual functioning patches, and in
turn those eventually getting pushed to Linus.

>
> =A0 Ext4 inode PA is removed when file is closed, therefore it is not
> =A0 necessary to implement to clear inode PA.

That is fine from ohsm perspective.  Possibly there are other use
cases that need a longer lifetime?

> Ioctl interfaces are as follows.
>
> a. EXT4_IOC_BALLOC_CONTROL (Set or clear balloc restriction)
>
> =A0 =A0 EXT4_IOC_BALLOC_CONTROL
> =A0 =A0 =A0 =A0_IOW('f', 16, struct ext4_balloc_control balloc_contro=
l)
>
> =A0 =A0 struct ext4_balloc_control {
> =A0 =A0 =A0 __u64 start; /* start physical block offset balloc rest *=
/
> =A0 =A0 =A0 __u64 len; =A0 /* block length */
> =A0 =A0 =A0 __u32 flags; /* set or clear */
> =A0 =A0 }
>
> =A0 =A0"flags" can be set following 2 types.
> =A0 =A0- SET_BALLOC_RESTRICTION
> =A0 =A0 =A0 =A0Set blocks in range to the balloc restriction list.
> =A0 =A0- CLR_BALLOC_RESTRICTION
> =A0 =A0 =A0 =A0Clear blocks from the balloc restriction list.

ohsm will be an in kernel user of the above, so we hope a kernel API
is also provided.  I assume that would be a simple export and
documenting it in Documentation/filesystems/ext4.

It seems you need to add 3 flags to the above:
mandatory - Have a future block allocate request return ENO_SPACE_PA
if the blocks cannot be found within the restricted range.
advisory - Attempt future block allocate requests from the restricted
range, but use entire unrestricted block range if that fails.
mandatory_with_fallback - Not Implemented - If block allocate from
restricted range fails, fallback to an alternate block range.  API and
implementation details not yet agreed on.

As to mandatory_with_fallback, we (the ohsm team) are looking for
feedback on the below proposal:

The ohsm team envisions submitting subsequent patches to enhance the
ext4 block allocator function such that it makes a callout to ohsm if
a block allocation fails from the current restricted block range.
Possibly by adding an init routine that would allow ohsm to register a
callout routine for the ENO_SPACE_PA condition. This can be thought of
as a inotify type situation for that one case.

After making the callout (to ohsm or other registered kernel user), we
would like to see the block allocation re-attempted.

This would allow ohsm to eventually have multiple tiers of preferred
storage. And if one tier is not able to provide the requested blocks,
an alternate block range could be set.  We envision the oshm callout
function in turn calling the EXT4_IOC_BALLOC_CONTROL kernel API to set
the alternate block range.  Thus the block allocator function would
need to be made aware of this possibility.

Again, the above is mostly our future plans / enhancements to the
initial primary patch and is provided just to let everyone keep ohsm's
needs in mind as the patch is writen / reviewed.  ie. ohsm is the only
known use case for this routine other than defrag at present so we
thought it useful explain how ohsm would utilize / enhance this
function.

> b. EXT4_IOC_ADD_PREALLOC (Add inode preferred range)
>
> =A0 =A0 EXT4_IOC_ADD_PREALLOC _IOW('f', 18, struct ext4_balloc_contro=
l)
>
> =A0 =A0 struct ext4_balloc_control {
> =A0 =A0 =A0 __u64 start; /* start physical block offset */
> =A0 =A0 =A0 __u64 len; =A0 /* block length */
> =A0 =A0 =A0 __u32 flags; =A0/* create and add mode for inode PA =A0*/
> =A0 =A0 }
>
> =A0 =A0"flags" must include one of the following create modes
> =A0 =A0(MANDATORY or ADVISORY). =A0In addition, one of the control mo=
des also must
> =A0 =A0be set (REPLACER_INODE_PREALLOC or ADD_INODE_PREALLOC).
> =A0 =A0 Create modes:
> =A0 =A0 - MANDATORY
> =A0 =A0 =A0 =A0 Find free extent which satisfies "start" and "len" co=
mpletely.
> =A0 =A0 - ADVISORY
> =A0 =A0 =A0 =A0 Try to find free extent from "start" and "len" blocks=
=2E
> =A0 =A0 Control modes:
> =A0 =A0 - REPLACE_INODE_PREALLOC
> =A0 =A0 =A0 =A0 Remove existed inode PA first, and then add specified=
 range to
> =A0 =A0 =A0 =A0 the inode PA list newly.
> =A0 =A0 - ADD_INODE_PREALLOC
> =A0 =A0 =A0 =A0 Add specified range to the inode PA list.
>
> =A0 =A0 e.g. =A0flag =3D MANDATORY | ADD_INODE_PREALLOC
> =A0 =A0 =A0 =A0 =A0 Find free extent which fulfills the requirements =
completely,
> =A0 =A0 =A0 =A0 =A0 and if succeed, add this extent to the inode PA.

I am unsure how the above relates to EXT4_IOC_BALLOC_CONTROL.  It
appears to be totally independent which I don't think is a good idea.
Nor do I understand the use case of the advisory flag and
add_inode_prealloc flag.

I would prefer if the above API were simplified to:

b. EXT4_IOC_RESET_PREALLOC (Ensure inode prealloc range is withing
preferred block alloc range)

    EXT4_IOC_ADD_PREALLOC _IOW('f', 18, struct ext4_balloc_control)

    struct ext4_balloc_control {
      __u32 flags;  /* Currently unused  */
    }

=46ind appropriate free prealloc block extent within range set of inode
via EXT4_IOC_BALLOC_CONTROL.

If unable to do so, a preallock block is set via the default logic and
a error is returned to show that the prealloc block is not within the
restricted block range.

This seems far simpler to code, understand, and use.

> Regards,
> Akira Fujita

Thanks
Greg
--
Greg Freemyer
Member of OHSM devel team
http://sourceforge.net/projects/ohsm/
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
