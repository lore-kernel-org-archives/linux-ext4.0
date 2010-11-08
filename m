From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH 1/2] ext3: don't update sb journal_devnum when RO dev
Date: Sun, 7 Nov 2010 17:09:24 -0800
Message-ID: <AANLkTi=eyT7qzUCDubVKiiWwaAG7008vw=vJ7YnwbR1=@mail.gmail.com>
References: <1285540709-16217-1-git-send-email-zenczykowski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
To: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>,
	Eric Sandeen <sandee
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45977 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab0KHBJZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Nov 2010 20:09:25 -0500
Received: by wwb39 with SMTP id 39so3299551wwb.1
        for <linux-ext4@vger.kernel.org>; Sun, 07 Nov 2010 17:09:24 -0800 (PST)
In-Reply-To: <1285540709-16217-1-git-send-email-zenczykowski@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/9/26 Maciej =C5=BBenczykowski <zenczykowski@gmail.com>:
> An ext3 filesystem on a read-only device, with an external journal
> which is at a different device number then recorded in the superblock
> will fail to honor the read-only setting of the device and trigger
> a superblock update (write).
>
> For example:
> =C2=A0- ext3 on a software raid which is in read-only mode
> =C2=A0- external journal on a read-write device which has changed dev=
ice num
> =C2=A0- attempt to mount with -o journal_dev=3D<new_number>
> =C2=A0- hits BUG_ON(mddev->ro =3D 1) in md.c
>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Maciej =C5=BBenczykowski <zenczykowski@gmail.com>
> ---
> =C2=A0fs/ext3/super.c | =C2=A0 =C2=A02 +-
> =C2=A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 5dbf4db..19dfbe9 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -2299,7 +2299,7 @@ static int ext3_load_journal(struct super_block=
 *sb,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0EXT3_SB(sb)->s_journal =3D journal;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext3_clear_journal_err(sb, es);
>
> - =C2=A0 =C2=A0 =C2=A0 if (journal_devnum &&
> + =C2=A0 =C2=A0 =C2=A0 if (!really_read_only && journal_devnum &&
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0journal_devnum !=3D le32_to_=
cpu(es->s_journal_dev)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0es->s_journal_=
dev =3D cpu_to_le32(journal_devnum);
>
> --
> 1.7.2.3
>
>

While I can see the ext4 patch at:

 http://git.kernel.org/?p=3Dlinux/kernel/git/tytso/ext4.git;a=3Dshortlo=
g

I can't find the ext3 patch.  Did it get missed?

Maciej
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
