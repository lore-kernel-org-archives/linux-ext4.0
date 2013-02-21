From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: fix overhead calculation in bigalloc filesystem
 (Re: ... )
Date: Thu, 21 Feb 2013 21:49:43 +0800
Message-ID: <20130221134943.GA3818@gmail.com>
References: <1361433665-16880-1-git-send-email-lczerner@redhat.com>
 <20130221121545.GA30821@gmail.com>
 <alpine.LFD.2.00.1302211335390.19354@localhost>
 <alpine.LFD.2.00.1302211346240.19354@localhost>
 <alpine.LFD.2.00.1302211351090.19354@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f42.google.com ([209.85.210.42]:55035 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab3BUNez (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Feb 2013 08:34:55 -0500
Received: by mail-da0-f42.google.com with SMTP id z17so4153709dal.29
        for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2013 05:34:55 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1302211351090.19354@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 21, 2013 at 01:52:58PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Thu, 21 Feb 2013, Luk=C3=A1=C5=A1 Czerner wrote:
>=20
> > Date: Thu, 21 Feb 2013 13:50:03 +0100 (CET)
> > From: Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>
> > To: Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>
> > Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
> >     Theodore Ts'o <tytso@mit.edu>
> > Subject: Re: [PATCH] ext4: fix overhead calculation in bigalloc fil=
esystem
> >     (Re: ... )
> >=20
> > On Thu, 21 Feb 2013, Luk=C3=A1=C5=A1 Czerner wrote:
> >=20
> > ..snip...
> >=20
> > >=20
> > > Hi Zheng,
> > >=20
> > > thanks for the review. I know about the other issues and I'm tryi=
ng
> > > to resolve those as well. Right now I have a patch which includes
> > > the changes ext4_calculate_overhead() you've described below and =
more,
> > > but even with this I still see some problems remaining.
> > >=20
> > > Hopefully will send another patch soon.
> > >=20
> > > Thanks!
> > > -Lukas
> > >=20
> > > >=20
> > > > Subject: [PATCH] ext4: fix overhead calculation in bigalloc fil=
esystem
> > > >=20
> > > > From: Zheng Liu <wenqing.lz@taobao.com>
> > > >=20
> > > > ext4_calculate_overhead() should compute the overhead and stash=
 it in
> > > > sbi->s_overhead.  But we miss use EXT4_B2C() to calculate the n=
umber of
> > > > clusters before first_data_block and the number of journal bloc=
ks.  This
> > > > commit use EXT4_NUM_B2C() instead of EXT4_B2C() to calculate th=
e
> > > > overhead.
> > > >=20
> > > > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > > > Cc: "Theodore Ts'o" <tytso@mit.edu>
> > > > ---
> > > >  fs/ext4/super.c | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > >=20
> > > > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > > > index 3d4fb81..6165558 100644
> > > > --- a/fs/ext4/super.c
> > > > +++ b/fs/ext4/super.c
> > > > @@ -3219,7 +3219,7 @@ int ext4_calculate_overhead(struct super_=
block *sb)
> > > >  	/*
> > > >  	 * All of the blocks before first_data_block are overhead
> > > >  	 */
> > > > -	overhead =3D EXT4_B2C(sbi, le32_to_cpu(es->s_first_data_block=
));
> > > > +	overhead =3D EXT4_NUM_B2C(sbi, le32_to_cpu(es->s_first_data_b=
lock));
> >=20
> > ...except this. I do not think this is right because we do not skip
> > the first cluster right ? We're still using it, but we can never us=
e
> > the block before es->s_first_data_block. Please correct me if I am
> > wrong.

Yes, I think you are right.

>=20
> moreover we do not allow bigalloc file system with block size < 4k.

No, we allow user to use bigalloc with block size < 4k, such as:

  mkfs.ext4 -b 1024 -C 4096 -O bigalloc ${dev}

This command formats a bigalloc filesystem with blocksize =3D 1k and
clustersize =3D 4k, at least in e2fsprogs 1.42.7 it works well.

>=20
> >=20
> >=20
> > > > =20
> > > >  	/*
> > > >  	 * Add the overhead found in each block group
> > > > @@ -3235,7 +3235,7 @@ int ext4_calculate_overhead(struct super_=
block *sb)
> > > >  	}
> > > >  	/* Add the journal blocks as well */
> > > >  	if (sbi->s_journal)
> > > > -		overhead +=3D EXT4_B2C(sbi, sbi->s_journal->j_maxlen);
> > > > +		overhead +=3D EXT4_NUM_B2C(sbi, sbi->s_journal->j_maxlen);
> >=20
> > This I already have in my patch I'm testing right now. And as I sai=
d
> > there are other places where we misuse EXT4_B2C().
> >=20
> > -Lukas
> >=20
> > > > =20
> > > >  	sbi->s_overhead =3D overhead;
> > > >  	smp_wmb();
> > > >=20
> > >=20
> >=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
