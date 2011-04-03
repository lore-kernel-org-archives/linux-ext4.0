From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: Is this a bug?
Date: Sun, 3 Apr 2011 22:51:39 +0800
Message-ID: <BANLkTimpp7YeAWh-Eq8vKVAXAv=qKQgWew@mail.gmail.com>
References: <BANLkTinPYj7_qpKcZgp3Oya1LXzcbfBczQ@mail.gmail.com>
	<BANLkTimc3LC19vzjuvL4QyXcjrGAQgnqJA@mail.gmail.com>
	<BANLkTimEAtVeHge52Sj9F6=mh6jo2KB5hQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Amir Goldstein <amir73il@gmail.com>, linux-ext4@vger.kernel.org
To: Ding Dinghua <dingdinghua85@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57399 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab1DCOvk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Apr 2011 10:51:40 -0400
Received: by pwi15 with SMTP id 15so1079543pwi.19
        for <linux-ext4@vger.kernel.org>; Sun, 03 Apr 2011 07:51:39 -0700 (PDT)
In-Reply-To: <BANLkTimEAtVeHge52Sj9F6=mh6jo2KB5hQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 3, 2011 at 5:24 PM, Ding Dinghua <dingdinghua85@gmail.com> =
wrote:
> 2011/4/3 Amir Goldstein <amir73il@gmail.com>:
>> On Sat, Apr 2, 2011 at 1:05 AM, Ding Dinghua <dingdinghua85@gmail.co=
m> wrote:
>>> When truncate files and free blocks, the following codes make me pu=
zzled:
>>>
>>> void ext4_free_blocks(handle_t *handle, struct inode *inode,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct buffer_head *bh, =
ext4_fsblk_t block,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long count, int=
 flags)
>>> {
>>> =A0 =A0 =A0 =A0if (flags & EXT4_FREE_BLOCKS_FORGET) {
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct buffer_head *tbh =3D bh;
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int i;
>>>
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(bh && (count > 1));
>>>
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (i =3D 0; i < count; i++) {
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!bh)
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tbh =
=3D sb_find_get_block(inode->i_sb,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0block + i);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (unlikely(!tbh))
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cont=
inue;
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_forget(handle, =
flags & EXT4_FREE_BLOCKS_METADATA,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0inode, tbh, block + i);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>>> =A0 =A0 =A0 =A0}
>>> }
>>>
>>> I notice that ext4_forget mainly do two things:
>>> =A0 =A0a) =A0call jbd2_journa_forget to forget the modification of =
some buffer head
>>> =A0 =A0b) =A0or deal with the revoke issue
>>> however, if we are freeing data blocks && ext4_forget get into bran=
ch a),
>>
>> Simple. we don't pass the FORGET flag when freeing data blocks,
>> only when freeing metadata blocks, which may have been journalled
>> already.
>> I am not sure about the journal=3Ddata case through.
> Thanks for reply. The reason for me to dip into this issue is journal=
=3Ddata mode.
I think data processing in journal=3Ddata mode is similar to metadata
processing in joutnal=3Dordered mode.
>>
>>> tbh is not the buffer_head which journal took care of in ext4_write=
_begin,
>>> so i'm puzzled with this.
>>>
>>> Could anyone explain it to me? Thanks.
>>>
>>> --
>>> Ding Dinghua
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>
>
>
> --
> Ding Dinghua
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
