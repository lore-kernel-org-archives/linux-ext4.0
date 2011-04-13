From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC] on-line resize with flex_bg and exclude_bitmap
Date: Wed, 13 Apr 2011 17:26:02 +0300
Message-ID: <BANLkTi=VjfQeH9TLBMJ9DpMwfzxA070VbQ@mail.gmail.com>
References: <BANLkTimfddp_6LkfCMfAe_SA2wa3t3jrMQ@mail.gmail.com>
	<1A1F7181-8985-477C-AECB-783848D88AC3@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36140 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198Ab1DMO0E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Apr 2011 10:26:04 -0400
Received: by qyk7 with SMTP id 7so2708788qyk.19
        for <linux-ext4@vger.kernel.org>; Wed, 13 Apr 2011 07:26:02 -0700 (PDT)
In-Reply-To: <1A1F7181-8985-477C-AECB-783848D88AC3@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 13, 2011 at 4:45 PM, Andreas Dilger <adilger@dilger.ca> wro=
te:
> On 2011-04-12, at 7:27 AM, Amir Goldstein wrote:
>> I realized another issue regarding exclude bitmap compatibility.
>> the exiting EXT4_IOC_GROUP_ADD ioctl doesn't pass a field for the lo=
cation
>> of exclude_bitmap block, so we need to either allocate exclude_bitma=
p in kernel
>> or define a new ioctl, which passes the exclude_bitmap to kernel.
>>
>> If we are going to go with the latter solution, we may want to add
>> support for flex_bg layout for the new ioctl, so following is my pro=
posal
>> for EXT4_IOC_FLEX_GROUP_ADD:
>>
>> 1. As far as online resize and mkfs are concerned, we always allocat=
e all
>> group descriptors of a flex bg at the same time.
>>
>> 2. If there is not enough space for all flex_bg metadata in the last=
 group,
>> the last group will be dropped.
>>
>> 3. The new flex group input will assume all bitmaps of the same type=
 are
>> consecutive, so only the address of the first bitmap is needed as in=
put.
>>
>> struct ext4_new_flex_group_input {
>> =A0 =A0 =A0__u32 group; =A0 =A0 =A0 =A0 =A0 =A0/* Group number for t=
his data */
>
> This field will cause a misalignment/padding in the structure and wil=
l cause
> problems with 32-bit binaries on 64-bit kernels.
>
> Should we add a "__u32 flags" field to this structure? =A0I prefer fl=
ags/features
> instead of versions... =A0This will avoid the need to continually add=
ing new
> ioctls in the future.

Agreed.
I just copy pasted the current ext4_new_group_input with its existing f=
laws.

>
>> =A0 =A0 =A0__u64 block_bitmap; =A0 =A0 /* Absolute block number of f=
irst
>> block bitmap */
>> =A0 =A0 =A0__u64 exclude_bitmap; =A0 =A0 /* Absolute block number of=
 first
>> exclude bitmap */
>> =A0 =A0 =A0__u64 inode_bitmap; =A0 =A0 /* Absolute block number of f=
irst
>> inode bitmap */
>> =A0 =A0 =A0__u64 inode_table; =A0 =A0 =A0/* Absolute block number of=
 first
>> inode table start */
>> =A0 =A0 =A0__u32 blocks_count; =A0 =A0 /* Total number of blocks in =
this flex group */
>> =A0 =A0 =A0__u16 reserved_blocks; =A0/* Number of reserved blocks in=
 this
>> flex group */
>> =A0 =A0 =A0__u16 flex_size; =A0 =A0 =A0 =A0 =A0 =A0/* Number of grou=
ps in the flex group */
>> };
>
>
> Since the kernel only supports a single s_log_groups_per_flex value i=
n the superblock, we should use the superblock value and change "flex_s=
ize" to be just a count of the number of groups that should be added. =A0=
That means resize2fs should align its ioctls to multiples of the superb=
lock s_log_groups_per_flex.
>

Agreed, let's call it group_count.
In most cases, resize2fs would use the new ioctl to add *exactly* 1 fle=
x group,
with all its bitmaps and descriptors, just as the current ioctl always
adds 1 group,
even if not all group is made available at that time.

resize2fs will need to use group_count < groups_per_flex to align
existing fs to flex group.
in case existing fs has 1 group and online resize extends it to 16 grou=
ps,
the bitmaps for group 1-15 will all be placed in group 1.
does that make sense? or would it be better to extend the fs 1 group
at a time until
flex group boundary in that case?



>
>> 4. ext4_group_extend() should be the same except we need to allow ex=
tending
>> within the last flex bg, but not necessarily the last block group.
>>
>>
>> To look at this from a different angle, if you imagine that the flex
>> group is just a big group, whose bitmaps and group descriptor are fl=
ex_size
>> times bigger and where ext4_new_flex_group_input encodes the info of=
 the big
>> descriptor, then this design is identical to the current implementat=
ion of
>> online resize.
>>
>> What I will do, if you agree to this design, is use the new ioctl,
>> with flex_size =3D 1 to pass the exclude_bitmap in online resize and=
 enforce
>> flex_size =3D=3D 1 in kernel.
>
> If you are going to be modifying the kernel to add support for this i=
octl,
> why not properly add in support for flex_size > 1?

because I don't have time to do it (test it) now :-(
and I want to post the e2fsprogs exclude bitmap patch as soon as possib=
le.

> It should only involve
> the kernel looping over the groups as they are added. =A0This doesn't=
 require
> that resize2fs has added support for it yet, but forcing flex_size =3D=
=3D 1 in
> the kernel means that userspace will not know whether the kernel is d=
oing
> the right thing or not.
>

if I implement group_count > 1 in the kernel, I will need to implement
it in e2fsprogs,
so I can test it properly.
hopefully, there will be no official kernel which enforces group_count =
=3D=3D 1.

> In order to handle future resize in the case of a partially-added fle=
x group,
> it would be desirable for the unused blocks (bitmaps, inode table) ar=
e reserved
> so that they are not allocated by the block allocator.
>

Yes, that would be desirable, but then again, we will anyway need to
handle resize
of fs which was formatted/resized before my patches.
Anayway, I hope I will implement proper flex_bg resize for 2.6.40, I'm
just not sure I can commit to it.

>> Then later we can teach resize2fs and the kernel to extend flex grou=
ps properly
>> using the new ioctl.
>>
>> What do you think?
>> Can you think of another way I can support exclude_bitmap and online=
 resize,
>> without the need for a new ioctl?
>>
>> Amir.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
> Cheers, Andreas
>
>
>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
