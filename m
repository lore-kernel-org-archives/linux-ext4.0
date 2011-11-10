From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] mke2fs: do not initialize block bitmaps of groups having
 super block
Date: Thu, 10 Nov 2011 09:55:46 +0800
Message-ID: <CAGBYx2buEM2Bhf-YcBvxnEwiJGqGAS+rSXbmum_fD2UnXa46KA@mail.gmail.com>
References: <1320836006-6946-1-git-send-email-xiaoqiangnk@gmail.com>
	<D8CD6456-1740-4FA6-83E5-EFB0045EE74E@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57925 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756940Ab1KJBzr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Nov 2011 20:55:47 -0500
Received: by qao25 with SMTP id 25so2104553qao.19
        for <linux-ext4@vger.kernel.org>; Wed, 09 Nov 2011 17:55:46 -0800 (PST)
In-Reply-To: <D8CD6456-1740-4FA6-83E5-EFB0045EE74E@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 10, 2011 at 12:23 AM, Andreas Dilger <adilger@dilger.ca> wr=
ote:
> On 2011-11-09, at 3:53 AM, Yongqiang Yang <xiaoqiangnk@gmail.com> wro=
te:
>
>> Now mke2fs initializes block bitmaps of groups having super block, o=
n
>> the other hand ext4_init_block_bitmap in kernel can handle this case
>> rightly. =A0So let mke2fs let block bitmaps of groups having super b=
lock
>> be uninitialized.
>
> Is that true of older kernels, or only newer ones? =A0What about file=
systems with META_BG set?
According to code of kernel 2.6.24 in which uninit_bg was introduced
in, kernel can handle the case and META_BG can also be handled
rightly.  But it was not tested.  I will do a test later.

Yongqiang.
>
> Cheers, Andreas
>
>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>> ---
>> lib/ext2fs/alloc_sb.c | =A0 =A02 --
>> 1 files changed, 0 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/ext2fs/alloc_sb.c b/lib/ext2fs/alloc_sb.c
>> index 0d1c000..7517fbc 100644
>> --- a/lib/ext2fs/alloc_sb.c
>> +++ b/lib/ext2fs/alloc_sb.c
>> @@ -65,8 +65,6 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
>> =A0 =A0 =A0 =A0ext2fs_mark_block_bitmap2(bmap, 0);
>>
>> =A0 =A0if (old_desc_blk) {
>> - =A0 =A0 =A0 =A0if (fs->super->s_reserved_gdt_blocks && fs->block_m=
ap =3D=3D bmap)
>> - =A0 =A0 =A0 =A0 =A0 =A0ext2fs_bg_flags_clear(fs, group, EXT2_BG_BL=
OCK_UNINIT);
>> =A0 =A0 =A0 =A0for (j=3D0; j < old_desc_blocks; j++)
>> =A0 =A0 =A0 =A0 =A0 =A0if (old_desc_blk + j < ext2fs_blocks_count(fs=
->super))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2fs_mark_block_bitmap2(bmap,
>> --
>> 1.7.5.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
