From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: Question on block group allocation
Date: Thu, 23 Apr 2009 15:02:05 -0700
Message-ID: <6601abe90904231502y393155dbrf8913b728c704320@mail.gmail.com>
References: <6601abe90904230941x5cdd590ck2d51410326df2fc5@mail.gmail.com>
	 <20090423190817.GN3209@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:40532 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbZDWWCK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Apr 2009 18:02:10 -0400
Received: from spaceape11.eur.corp.google.com (spaceape11.eur.corp.google.com [172.28.16.145])
	by smtp-out.google.com with ESMTP id n3NM27B4008904
	for <linux-ext4@vger.kernel.org>; Thu, 23 Apr 2009 15:02:08 -0700
Received: from qw-out-2122.google.com (qwd5.prod.google.com [10.241.193.197])
	by spaceape11.eur.corp.google.com with ESMTP id n3NM25Hm018247
	for <linux-ext4@vger.kernel.org>; Thu, 23 Apr 2009 15:02:06 -0700
Received: by qw-out-2122.google.com with SMTP id 5so635644qwd.29
        for <linux-ext4@vger.kernel.org>; Thu, 23 Apr 2009 15:02:05 -0700 (PDT)
In-Reply-To: <20090423190817.GN3209@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas:

On Thu, Apr 23, 2009 at 12:08 PM, Andreas Dilger <adilger@sun.com> wrot=
e:
> On Apr 23, 2009 =A009:41 -0700, Curt Wohlgemuth wrote:
>> I'm seeing a performance problem on ext4 vs ext2, and in trying to
>> narrow it down, I've got a question about block allocation in ext4
>> that I'm having trouble figuring out.
>>
>> Using dd, I created (in this order) two 4GB files and a 10GB file in
>> the mount directory.
>>
>> The extent blocks are reasonably close together for the two 4GB file=
s,
>> but the extents for the 10GB file show a huge gap, which seems to hu=
rt
>> the random read performance pretty substantially. =A0Here's the outp=
ut
>> from debugfs:
>>
>> BLOCKS:
>> (IND):8396832, (0-106495):8282112-8388607,
>> (106496-399359):11241472-11534335, (399360-888831):20482048-20971519=
,
>> (888832-1116159):23889920-24117247, (1116160-1277951):71665664-
>> 71827455, (1277952-1767423):78678016-79167487,
>> (1767424-2125823):102402048-102760447,
>> (2125824-2148351):102768672-102791199,
>> (2148352-2621439):102793216-103266303
>> TOTAL: 2621441
>>
>> Note the gap between blocks 79167487 and 102402048.
>
> Well, there are other even larger gaps for other chunks of the file.

Really?  Not that it's important, but I'm not seeing them...

>> I was lucky enough to capture the mb_history from this 10GB create:
>>
>> 29109 14 =A0 =A0 =A0 735/30720/32758@1114112 735/30720/2048@1114112
>> 735/30720/2048@1114112 =A01 =A0 =A0 0 =A0 =A0 0 =A01568 =A0M =A0 =A0=
 0 =A0 =A0 0
>> 29109 14 =A0 =A0 =A0 736/0/32758@1116160 =A0 =A0 736/0/2048@1116160
>> 2187/2048/2048@1116160 =A01 =A0 =A0 1 =A0 =A0 0 =A01568 =A0 =A0 =A0 =
=A00 =A0 =A0 0
>> 29109 14 =A0 =A0 =A0 2187/4096/32758@1118208 2187/4096/2048@1118208
>> 2187/4096/2048@1118208 =A01 =A0 =A0 0 =A0 =A0 0 =A01568 =A0M =A0 =A0=
 2048 =A04096
>>
>> I've been staring at ext4_mb_regular_allocator() trying to understan=
d
>> why an allocation with a goal block of 736 ends up with a best found
>> extent group of 2187, and I'm stuck -- at least without a lot of
>> printk messages. =A0It seems to me that we just cycle through the bl=
ock
>> groups starting with the goal group until we find a group that fits.
>> Again, according to dumpe2fs, block groups 737, 738, 739, ... all ha=
ve
>> 32768 free blocks. =A0So why we end up with a best fit group of 2187=
 is
>> a mystery to me.
>
> This is likely the "uninit_bg" feature that is causing the allocation=
s
> to skip groups which are marked BLOCK_UNINIT. =A0In some sense the be=
nefit
> of skipping the block bitmap read during e2fsck is probably not at al=
l
> beneficial compared to the cost of the extra seeking during IO. =A0As=
 the
> filesystem gets more full, the BLOCK_UNIIT flags would be cleared any=
ways,
> so we might as well just keep the early allocations contiguous.

Ah, thanks!  That's what I was missing.  Yes, I sort of skipped over
the "is this a good group?" question.

> A simple change to verify this would be something like the following,
> but it hasn't actually been tested.

Tell you what:  I'll try this out and see if it helps out my test case.

Thanks,
Curt

>
> --- ./fs/ext4/mballoc.c.uninit =A0 =A02009-04-08 19:13:13.000000000 -=
0600
> +++ ./fs/ext4/mballoc.c 2009-04-23 13:02:22.000000000 -0600
> @@ -1742,10 +1723,6 @@ static int ext4_mb_good_group(struct ext
> =A0 =A0 =A0 =A0switch (cr) {
> =A0 =A0 =A0 =A0case 0:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(ac->ac_2order =3D=3D 0);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* If this group is uninitialized, skip=
 it initially */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 desc =3D ext4_get_group_desc(ac->ac_sb,=
 group, NULL);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (desc->bg_flags & cpu_to_le16(EXT4_B=
G_BLOCK_UNINIT))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bits =3D ac->ac_sb->s_blocksize_bits +=
 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (i =3D ac->ac_2order; i <=3D bits;=
 i++)
> @@ -2039,9 +2035,7 @@ repeat:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ac->ac_groups_scanned+=
+;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0desc =3D ext4_get_grou=
p_desc(sb, group, NULL);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cr =3D=3D 0 || (des=
c->bg_flags &
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_=
le16(EXT4_BG_BLOCK_UNINIT) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ac->ac_=
2order !=3D 0))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cr =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_m=
b_simple_scan_group(ac, &e4b);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else if (cr =3D=3D 1 &=
&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0ac->ac_g_ex.fe_len =3D=3D sbi->s_stripe)
>
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
