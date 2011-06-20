From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC] on-line resize with flex_bg and exclude_bitmap
Date: Mon, 20 Jun 2011 21:37:52 +0300
Message-ID: <BANLkTi=831+K++G5o8ivt0cMJbHtRisJmg@mail.gmail.com>
References: <BANLkTimfddp_6LkfCMfAe_SA2wa3t3jrMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42876 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab1FTShx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Jun 2011 14:37:53 -0400
Received: by wwe5 with SMTP id 5so2845532wwe.1
        for <linux-ext4@vger.kernel.org>; Mon, 20 Jun 2011 11:37:52 -0700 (PDT)
In-Reply-To: <BANLkTimfddp_6LkfCMfAe_SA2wa3t3jrMQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 12, 2011 at 2:27 PM, Amir Goldstein <amir73il@gmail.com> wr=
ote:
> Hi Ted,
>
> I realized another issue regarding exclude bitmap compatibility.
> the exiting EXT4_IOC_GROUP_ADD ioctl doesn't pass a field for the loc=
ation
> of exclude_bitmap block, so we need to either allocate exclude_bitmap=
 in kernel
> or define a new ioctl, which passes the exclude_bitmap to kernel.
>
> If we are going to go with the latter solution, we may want to add
> support for flex_bg
> layout for the new ioctl, so following is my proposal for
> EXT4_IOC_FLEX_GROUP_ADD:
>
> 1. As far as online resize and mkfs are concerned, we always allocate=
 all
> group descriptors of a flex bg at the same time.
>
> 2. If there is not enough space for all flex_bg metadata in the last =
group,
> the last group will be dropped.
>
> 3. The new flex group input will assume all bitmaps of the same type =
are
> consecutive, so only the address of the first bitmap is needed as inp=
ut.
>
> struct ext4_new_flex_group_input {
> =A0 =A0 =A0 =A0__u32 group; =A0 =A0 =A0 =A0 =A0 =A0/* Group number fo=
r this data */
> =A0 =A0 =A0 =A0__u64 block_bitmap; =A0 =A0 /* Absolute block number o=
f first
> block bitmap */
> =A0 =A0 =A0 =A0__u64 exclude_bitmap; =A0 =A0 /* Absolute block number=
 of first
> exclude bitmap */
> =A0 =A0 =A0 =A0__u64 inode_bitmap; =A0 =A0 /* Absolute block number o=
f first
> inode bitmap */
> =A0 =A0 =A0 =A0__u64 inode_table; =A0 =A0 =A0/* Absolute block number=
 of first
> inode table start */
> =A0 =A0 =A0 =A0__u32 blocks_count; =A0 =A0 /* Total number of blocks =
in this flex group */
> =A0 =A0 =A0 =A0__u16 reserved_blocks; =A0/* Number of reserved blocks=
 in this
> flex group */
> =A0 =A0 =A0 =A0__u16 flex_size; =A0 =A0 =A0 =A0 =A0 =A0/* Number of g=
roups in the flex group */
> };
>
> 4. ext4_group_extend() should be the same except we need to allow ext=
ending
> within the last flex bg, but not necessarily the last block group.
>
>
> To look at this from a different angle, if you imagine that the flex
> group is just
> a big group, whose bitmaps and group descriptor are flex_size times b=
igger and
> where ext4_new_flex_group_input encodes the info of the big descripto=
r,
> then this design is identical to the current implementation of online=
 resize.
>
> What I will do, if you agree to this design, is use the new ioctl,
> with flex_size =3D 1
> to pass the exclude_bitmap in online resize and enforce flex_size =3D=
=3D 1
> in kernel.
> Then later we can teach resize2fs and the kernel to extend flex group=
s properly
> using the new ioctl.
>
> What do you think?
> Can you think of another way I can support exclude_bitmap and online =
resize,
> without the need for a new ioctl?
>
> Amir.
>


Hi Yongqiang,

=46ollowing today's conf call, we agreed to drop the old habit of
letting user space decide
on bitmap allocations and leave the decision in the hands on the kernel=
=2E

The new resize ioctl should just provide the new 64bit blocks count to
the kernel.
The new resize ioctl (say EXT4_IOC_ONLINE_RESIZE) cabability should be =
published
to user space via ext4_feat_attrs, like lazy_itable_init and
batch_discard and resize2fs
should check that attribute before choosing the ioctl to use.

As a first step, I think the new ioctl should be implemented by
calling ext4_group_add()
and ext4_group_extend() for all groups in the range.

This is sufficient for supporting exclude bitmap, because the kernel
can decide on the location
for the exclude bitmaps.

The next obvious steps would be to:
1. honor the flex_bg layout (whenever possible)
2. resize to large sizes very quickly by skipping the bitmaps and itabl=
e init

But you don't have to complete all the steps if you are overbooked
with other tasks.

More future enhancement that will be accessible with the new ioctl are:
3. support resize for 64bit/meta_bg fs
4. support resize for big_alloc fs

Thanks,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
