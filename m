From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: fix overhead calculation in bigalloc filesystem
 (Re: ... )
Date: Thu, 21 Feb 2013 21:12:53 +0800
Message-ID: <20130221131253.GA2268@gmail.com>
References: <1361433665-16880-1-git-send-email-lczerner@redhat.com>
 <20130221121545.GA30821@gmail.com>
 <alpine.LFD.2.00.1302211335390.19354@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:55507 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab3BUM6J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Feb 2013 07:58:09 -0500
Received: by mail-pa0-f52.google.com with SMTP id fb1so4676432pad.11
        for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2013 04:58:08 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1302211335390.19354@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 21, 2013 at 01:40:34PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
[snip]
>=20
> Hi Zheng,
>=20
> thanks for the review. I know about the other issues and I'm trying
> to resolve those as well. Right now I have a patch which includes
> the changes ext4_calculate_overhead() you've described below and more=
,
> but even with this I still see some problems remaining.
>=20
> Hopefully will send another patch soon.

Yeah, we will get a lot of xfstests failures about bigalloc feature whe=
n
bigalloc and delalloc are enabled simultaneouly.  So that would be grea=
t
if we could fix these problems.  Looking forward your patch. :-)

Regards,
                                                - Zheng

> >=20
> > Subject: [PATCH] ext4: fix overhead calculation in bigalloc filesys=
tem
> >=20
> > From: Zheng Liu <wenqing.lz@taobao.com>
> >=20
> > ext4_calculate_overhead() should compute the overhead and stash it =
in
> > sbi->s_overhead.  But we miss use EXT4_B2C() to calculate the numbe=
r of
> > clusters before first_data_block and the number of journal blocks. =
 This
> > commit use EXT4_NUM_B2C() instead of EXT4_B2C() to calculate the
> > overhead.
> >=20
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > Cc: "Theodore Ts'o" <tytso@mit.edu>
> > ---
> >  fs/ext4/super.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index 3d4fb81..6165558 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -3219,7 +3219,7 @@ int ext4_calculate_overhead(struct super_bloc=
k *sb)
> >  	/*
> >  	 * All of the blocks before first_data_block are overhead
> >  	 */
> > -	overhead =3D EXT4_B2C(sbi, le32_to_cpu(es->s_first_data_block));
> > +	overhead =3D EXT4_NUM_B2C(sbi, le32_to_cpu(es->s_first_data_block=
));
> > =20
> >  	/*
> >  	 * Add the overhead found in each block group
> > @@ -3235,7 +3235,7 @@ int ext4_calculate_overhead(struct super_bloc=
k *sb)
> >  	}
> >  	/* Add the journal blocks as well */
> >  	if (sbi->s_journal)
> > -		overhead +=3D EXT4_B2C(sbi, sbi->s_journal->j_maxlen);
> > +		overhead +=3D EXT4_NUM_B2C(sbi, sbi->s_journal->j_maxlen);
> > =20
> >  	sbi->s_overhead =3D overhead;
> >  	smp_wmb();
> >=20
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
