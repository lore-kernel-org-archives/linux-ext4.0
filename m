From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext4: Fix BUG_ON in ext4_da_block_invalidatepages()
Date: Wed, 16 Mar 2011 22:11:33 +0100
Message-ID: <20110316211133.GE4456@quack.suse.cz>
References: <1300308774-14140-1-git-send-email-jack@suse.cz>
 <1300308774-14140-2-git-send-email-jack@suse.cz>
 <AANLkTin31soAwuZERFTikPtCHXtj6G52HXgj6ep2=eGR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu, linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37858 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213Ab1CPVLf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Mar 2011 17:11:35 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTin31soAwuZERFTikPtCHXtj6G52HXgj6ep2=eGR@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Curt,

On Wed 16-03-11 14:02:02, Curt Wohlgemuth wrote:
> This problem was fixed by the patch I sent on 18 Feb, titled
>=20
>    [PATCH 1/2] ext4: mark multi-page IO complete on mapping failure
>=20
> I guess this didn't make it into 2.6.38, but it's in the ext4 patch q=
ueue now.
  Ah, OK. And I see you also fixed the second issue although my patch I=
MHO
still makes sense as a cleanup...

								Honza

> On Wed, Mar 16, 2011 at 1:52 PM, Jan Kara <jack@suse.cz> wrote:
> > When an allocation of blocks fails in mpage_da_map_and_submit() e.g=
=2E because of
> > EIO we call ext4_da_block_invalidatepages() to invalidate pages we =
cannot write
> > but we fail to set mpd->io_done. Thus we continue searching for dir=
ty pages and
> > add them to the current extent in mpd structure. Eventually we try =
to allocate
> > blocks for the extent again and strange things start happening. In =
particular
> > if the allocation fails again, we try to invalidate pages again and=
 that
> > triggers BUG_ON in ext4_da_block_invalidatepages().
> >
> > Fix the issue by setting mpd->io_done after the pages are invalidat=
ed.
> >
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> > =A0fs/ext4/inode.c | =A0 =A01 +
> > =A01 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 9f7f9e4..337d9ca 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -2314,6 +2314,7 @@ static void mpage_da_map_and_submit(struct mp=
age_da_data *mpd)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* invalidate all the pages */
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_da_block_invalidatepages(mpd, n=
ext,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mpd-=
>b_size >> mpd->inode->i_blkbits);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mpd->io_done =3D 1;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
> > =A0 =A0 =A0 =A0}
> > =A0 =A0 =A0 =A0BUG_ON(blks =3D=3D 0);
> > --
> > 1.7.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
