From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: ext4: why init the unused block group at batched discard?
Date: Wed, 6 Jul 2011 10:21:23 +0300
Message-ID: <CAOQ4uxjiUGnbKxYvDKj2vbrvtiGBVVyGDx1=rgjjrBahKzL3Sw@mail.gmail.com>
References: <CAH9JG2Xp_u-46x8bf2Uq-9FREZyYhcP3E7H+MsSoFVrWpyLrtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Lukas Czerner <lczerner@redhat.com>,
	Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Kyungmin Park <kmpark@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAH9JG2Xp_u-46x8bf2Uq-9FREZyYhcP3E7H+MsSoFVrWpyLrtA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 6, 2011 at 9:09 AM, Kyungmin Park <kmpark@infradead.org> wr=
ote:
> Hi Lukas,
>
> During code review batched discard support at ext4. I wonder why do
> you init the uninitialized block group during batched discard.
> As you know uninitialized block group mean that there's no operation
> at these blocks.

Hi Kyungmin,

EXT4_MB_GRP_NEED_INIT() is not the same as EXT4_BG_BLOCK_UNINIT.
The former means that no allocation/free was attempted from the block g=
roup
since mount time and the latter means that no allocation happened since=
 mkfs.

> So no need to trim it at all.

So I think it is possible that blocks deleted in previous mount time wo=
uld
need to be trimmed in this mount time.

Am I right, Lukas?

Amir.

>
> How do you think?
>
> int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
> {
> =A0 =A0 =A0 =A0...
>
> =A0 =A0 =A0 =A0for (group =3D first_group; group <=3D last_group; gro=
up++) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0grp =3D ext4_get_group_info(sb, group)=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* We only do this if the grp has neve=
r been initialized */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (unlikely(EXT4_MB_GRP_NEED_INIT(grp=
))) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D ext4_mb_init_g=
roup(sb, group);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0...
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0...
> }
>
> Thank you,
> Kyungmin Park
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdev=
el" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
