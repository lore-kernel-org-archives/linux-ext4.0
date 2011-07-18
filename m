From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 08/12] ext4: let setup_new_group_blocks set multi-bits
 each time
Date: Mon, 18 Jul 2011 09:56:51 +0300
Message-ID: <CAOQ4uxgmOFF_z2PP6H0WbbSsfYiw-BupqvA7RYuupNMZ7U+Adg@mail.gmail.com>
References: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
	<1310957555-15617-9-git-send-email-xiaoqiangnk@gmail.com>
	<3539826A-0FB0-4995-8588-1E6D45359FA3@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35834 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab1GRG4w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jul 2011 02:56:52 -0400
Received: by wyg8 with SMTP id 8so1863228wyg.19
        for <linux-ext4@vger.kernel.org>; Sun, 17 Jul 2011 23:56:51 -0700 (PDT)
In-Reply-To: <3539826A-0FB0-4995-8588-1E6D45359FA3@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 18, 2011 at 9:26 AM, Andreas Dilger <adilger@dilger.ca> wro=
te:
> On 2011-07-17, at 8:52 PM, Yongqiang Yang wrote:
>> This patch adds a function - ext4_set_btis() which can set multi-bit=
s
>> each time, and lets setup_new_group_blocks() use ext4_set_bits().
>>
>>
>> +void ext4_set_bits(void *bm, int cur, int len)
>> +{
>> + =A0 =A0 mb_set_bits(bm, cur, len);
>> +}
>
> Why not just rename mb_set_bits() to ext4_set_bits()? =A0That could b=
e done
> in one patch to avoid complexity.

Wouldn't it be better if mb_set_bits() remains static for compiler
optimizations inside mballoc.c?
I would however, change the name of the extern function to
ext4_mb_set_bits() to be compliant
with the name space.

If I am not mistaken, we were planning to use such a helper function
for setting bits in exclude bitmap.

>
>> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
>> index 4089642..c91653c 100644
>> --- a/fs/ext4/resize.c
>> +++ b/fs/ext4/resize.c
>> @@ -227,11 +227,6 @@ static int setup_new_group_blocks(struct super_=
block *sb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_journal;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 if (ext4_bg_has_super(sb, input->group)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_debug("mark backup superblock %#04llx=
 (+0)\n", start);
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_set_bit(0, bh->b_data);
>> - =A0 =A0 }
>> -
>> =A0 =A0 =A0 /* Copy all of the GDT blocks into the backup in this gr=
oup */
>> =A0 =A0 =A0 for (i =3D 0, bit =3D 1, block =3D start + 1;
>> =A0 =A0 =A0 =A0 =A0 =A0i < gdblocks; i++, block++, bit++) {
>> @@ -260,7 +255,6 @@ static int setup_new_group_blocks(struct super_b=
lock *sb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 brelse(gdb);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_bh;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_set_bit(bit, bh->b_data);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 brelse(gdb);
>> =A0 =A0 =A0 }
>>
>> @@ -271,8 +265,11 @@ static int setup_new_group_blocks(struct super_=
block *sb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0GFP_NOFS)=
;
>> =A0 =A0 =A0 if (err)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_bh;
>> - =A0 =A0 for (i =3D 0, bit =3D gdblocks + 1; i < reserved_gdb; i++,=
 bit++)
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_set_bit(bit, bh->b_data);
>> +
>> + =A0 =A0 if (ext4_bg_has_super(sb, input->group)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_debug("mark backup group tables %#04l=
lx (+0)\n", start);
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_set_bits(bh->b_data, 0, gdblocks + re=
served_gdb + 1);
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 ext4_debug("mark block bitmap %#04llx (+%llu)\n", input-=
>block_bitmap,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0input->block_bitmap - start);
>> @@ -288,9 +285,8 @@ static int setup_new_group_blocks(struct super_b=
lock *sb,
>> =A0 =A0 =A0 err =3D sb_issue_zeroout(sb, block, sbi->s_itb_per_group=
, GFP_NOFS);
>> =A0 =A0 =A0 if (err)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_bh;
>> - =A0 =A0 for (i =3D 0, bit =3D input->inode_table - start;
>> - =A0 =A0 =A0 =A0 =A0i < sbi->s_itb_per_group; i++, bit++)
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext4_set_bit(bit, bh->b_data);
>> + =A0 =A0 ext4_set_bits(bh->b_data, input->inode_table - start,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sbi->s_itb_per_group);
>>
>> =A0 =A0 =A0 if ((err =3D extend_or_restart_transaction(handle, 2, bh=
)))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_bh;
>> --
>> 1.7.5.1
>>
>
>
> Cheers, Andreas
>
>
>
>
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
