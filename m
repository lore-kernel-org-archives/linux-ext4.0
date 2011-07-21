From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH V2] e2fsprogs: add ext2fs_group_blocks_count helper
Date: Thu, 21 Jul 2011 22:57:25 +0800
Message-ID: <CAGBYx2bafe-okcwc3XkfrPbrTHU4f-kQDL=vxFYyrDM0oGcVhg@mail.gmail.com>
References: <1311090411-13766-1-git-send-email-xiaoqiangnk@gmail.com>
	<4E25AE6A.6090909@redhat.com>
	<4E274CD0.1000801@redhat.com>
	<4E274F57.8020007@redhat.com>
	<4E282FCF.4050602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35324 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab1GUO50 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jul 2011 10:57:26 -0400
Received: by pzk37 with SMTP id 37so2027984pzk.1
        for <linux-ext4@vger.kernel.org>; Thu, 21 Jul 2011 07:57:25 -0700 (PDT)
In-Reply-To: <4E282FCF.4050602@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 21, 2011 at 9:55 PM, Eric Sandeen <sandeen@redhat.com> wrot=
e:
> On 7/20/11 4:57 PM, Eric Sandeen wrote:
>> Code to count the number of blocks in the last partial
>> group is cut and pasted around the e2fsprogs codebase, and
>> is wrong in at least one instancem as pointed out by
>> Yongqiang Yang (but not fixed in this patch).
>>
>> Making this a helper function should improve matters.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>
> Argh V3 coming today, I got a little too fast and loose sending this =
one
> at the end of the day yesterday didn't I:
Hi Eric,

It seemed you did not send out the v3 patch.   You just pointed out
what to be added in the V3 patch.

Yongqiang.
>
>> @@ -499,18 +499,8 @@ retry:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_bg_flags_zap(fs, i);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (csum_flag)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_bg_flags_set(fs, =
i, EXT2_BG_INODE_UNINIT | EXT2_BG_INODE_ZEROED);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (i =3D=3D fs->group_desc_count-1) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 numblocks =3D (ext2fs_bloc=
ks_count(fs->super) -
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
fs->super->s_first_data_block) %
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0fs->super->s_blocks_per_group;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!numblocks)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 numblocks =
=3D fs->super->s_blocks_per_group;
>> - =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 numblocks =3D fs->super->s=
_blocks_per_group;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (csum_flag)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext2fs_bg_=
flags_set(fs, i,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT2_BG_BLOCK_UNINIT);
>
> still need to do that flag set with the new helper.
>
> - Eric
>
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 numblocks =3D ext2fs_group_blocks_count(fs=
, i);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 has_super =3D ext2fs_bg_has_super(fs, i)=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (has_super) {
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
