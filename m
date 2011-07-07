From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: ext4: why init the unused block group at batched discard?
Date: Thu, 7 Jul 2011 09:47:29 +0800
Message-ID: <CAGBYx2aLY0e_MR4+hSG5DYgH9Juoc=VB9RN5h77=wG22oaFtUw@mail.gmail.com>
References: <CAH9JG2Xp_u-46x8bf2Uq-9FREZyYhcP3E7H+MsSoFVrWpyLrtA@mail.gmail.com>
	<CAOQ4uxjiUGnbKxYvDKj2vbrvtiGBVVyGDx1=rgjjrBahKzL3Sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Kyungmin Park <kmpark@infradead.org>,
	Lukas Czerner <lczerner@redhat.com>,
	Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48511 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab1GGBra convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jul 2011 21:47:30 -0400
In-Reply-To: <CAOQ4uxjiUGnbKxYvDKj2vbrvtiGBVVyGDx1=rgjjrBahKzL3Sw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 6, 2011 at 3:21 PM, Amir Goldstein <amir73il@gmail.com> wro=
te:
> On Wed, Jul 6, 2011 at 9:09 AM, Kyungmin Park <kmpark@infradead.org> =
wrote:
>> Hi Lukas,
>>
>> During code review batched discard support at ext4. I wonder why do
>> you init the uninitialized block group during batched discard.
>> As you know uninitialized block group mean that there's no operation
>> at these blocks.
>
> Hi Kyungmin,
>
> EXT4_MB_GRP_NEED_INIT() is not the same as EXT4_BG_BLOCK_UNINIT.
> The former means that no allocation/free was attempted from the block=
 group
> since mount time and the latter means that no allocation happened sin=
ce mkfs.
>
>> So no need to trim it at all.
>
> So I think it is possible that blocks deleted in previous mount time =
would
> need to be trimmed in this mount time.
>
> Am I right, Lukas?
It seems that you both are right.

if EXT4_MB_GRP_NEED_INIT() retruns true, it means buddy allocator has
not been initialized, and ext4_mb_init_group() initializes the buddy
allocator for specified group.

Actually, ext4_mb_init_group() initializes UNINIT block bitmap to
generate buddy bitmaps.

Maybe in trim case, we should consider BLOCK_UNINIT as well.

Yongqiang.
>
> Amir.
>
>>
>> How do you think?
>>
>> int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
>> {
>> =A0 =A0 =A0 =A0...
>>
>> =A0 =A0 =A0 =A0for (group =3D first_group; group <=3D last_group; gr=
oup++) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0grp =3D ext4_get_group_info(sb, group=
);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* We only do this if the grp has nev=
er been initialized */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (unlikely(EXT4_MB_GRP_NEED_INIT(gr=
p))) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D ext4_mb_init_=
group(sb, group);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0...
>> =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0...
>> }
>>
>> Thank you,
>> Kyungmin Park
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsde=
vel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
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
