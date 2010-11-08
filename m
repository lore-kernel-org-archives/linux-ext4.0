From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext3: don't update sb journal_devnum when RO dev
Date: Mon, 8 Nov 2010 13:15:04 +0100
Message-ID: <20101108121504.GA2971@quack.suse.cz>
References: <1285540709-16217-1-git-send-email-zenczykowski@gmail.com>
 <AANLkTi=eyT7qzUCDubVKiiWwaAG7008vw=vJ7YnwbR1=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>,
	Eric Sandeen <sandeen@redhat.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49843 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab0KHMPH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Nov 2010 07:15:07 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTi=eyT7qzUCDubVKiiWwaAG7008vw=vJ7YnwbR1=@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 07-11-10 17:09:24, Maciej =C5=BBenczykowski wrote:
> 2010/9/26 Maciej =C5=BBenczykowski <zenczykowski@gmail.com>:
> > An ext3 filesystem on a read-only device, with an external journal
> > which is at a different device number then recorded in the superblo=
ck
> > will fail to honor the read-only setting of the device and trigger
> > a superblock update (write).
> >
> > For example:
> > =C2=A0- ext3 on a software raid which is in read-only mode
> > =C2=A0- external journal on a read-write device which has changed d=
evice num
> > =C2=A0- attempt to mount with -o journal_dev=3D<new_number>
> > =C2=A0- hits BUG_ON(mddev->ro =3D 1) in md.c
> >
> > Cc: Theodore Ts'o <tytso@mit.edu>
> > Signed-off-by: Maciej =C5=BBenczykowski <zenczykowski@gmail.com>
> > ---
> > =C2=A0fs/ext3/super.c | =C2=A0 =C2=A02 +-
> > =C2=A01 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> > index 5dbf4db..19dfbe9 100644
> > --- a/fs/ext3/super.c
> > +++ b/fs/ext3/super.c
> > @@ -2299,7 +2299,7 @@ static int ext3_load_journal(struct super_blo=
ck *sb,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0EXT3_SB(sb)->s_journal =3D journal;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0ext3_clear_journal_err(sb, es);
> >
> > - =C2=A0 =C2=A0 =C2=A0 if (journal_devnum &&
> > + =C2=A0 =C2=A0 =C2=A0 if (!really_read_only && journal_devnum &&
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0journal_devnum !=3D le32_t=
o_cpu(es->s_journal_dev)) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0es->s_journa=
l_dev =3D cpu_to_le32(journal_devnum);
> >
> > --
> > 1.7.2.3
> >
> >
>=20
> While I can see the ext4 patch at:
>=20
>  http://git.kernel.org/?p=3Dlinux/kernel/git/tytso/ext4.git;a=3Dshort=
log
>=20
> I can't find the ext3 patch.  Did it get missed?
  Yes, it seems so. I'm taking care of ext3 so please CC me directly fo=
r
ext3 fixes. Thanks! I'll merge this fix.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
