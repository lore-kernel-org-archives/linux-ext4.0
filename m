From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: fix overhead calculation in bigalloc filesystem
 (Re: ... )
Date: Fri, 22 Feb 2013 11:03:27 +0800
Message-ID: <20130222030327.GB3421@gmail.com>
References: <1361433665-16880-1-git-send-email-lczerner@redhat.com>
 <20130221121545.GA30821@gmail.com>
 <alpine.LFD.2.00.1302211335390.19354@localhost>
 <alpine.LFD.2.00.1302211346240.19354@localhost>
 <alpine.LFD.2.00.1302211351090.19354@localhost>
 <20130221134943.GA3818@gmail.com>
 <alpine.LFD.2.00.1302211553060.14141@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:59836 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab3BVCsi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Feb 2013 21:48:38 -0500
Received: by mail-pb0-f52.google.com with SMTP id ma3so127791pbc.11
        for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2013 18:48:38 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1302211553060.14141@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 21, 2013 at 03:56:51PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Thu, 21 Feb 2013, Zheng Liu wrote:
>=20
> ..snip..
>=20
> > > > > >  	/*
> > > > > >  	 * All of the blocks before first_data_block are overhead
> > > > > >  	 */
> > > > > > -	overhead =3D EXT4_B2C(sbi, le32_to_cpu(es->s_first_data_b=
lock));
> > > > > > +	overhead =3D EXT4_NUM_B2C(sbi, le32_to_cpu(es->s_first_da=
ta_block));
> > > >=20
> > > > ...except this. I do not think this is right because we do not =
skip
> > > > the first cluster right ? We're still using it, but we can neve=
r use
> > > > the block before es->s_first_data_block. Please correct me if I=
 am
> > > > wrong.
> >=20
> > Yes, I think you are right.
> >=20
> > >=20
> > > moreover we do not allow bigalloc file system with block size < 4=
k.
> >=20
> > No, we allow user to use bigalloc with block size < 4k, such as:
> >=20
> >   mkfs.ext4 -b 1024 -C 4096 -O bigalloc ${dev}
> >=20
> > This command formats a bigalloc filesystem with blocksize =3D 1k an=
d
> > clustersize =3D 4k, at least in e2fsprogs 1.42.7 it works well.
> >=20
>=20
> Ok, i was pretty sure that we do not allow that, it's good to know.
> Also, does it make any sense ? I do not think so, and I would really
> consider the fact that we allow that as a bug. We should not allow
> that otherwise it unnecessarily extending the test matrix.
>=20
> What people think about restricting bigalloc _only_ for 4k block
> size file systems ?

I agree with you that we should forbid user to use bigalloc feature wit=
h
block size =3D 1k or 2k because I guess no one really use it, at least =
in
Taobao we always use bigalloc feature with block size =3D 4k.

=46WIW, recently I am considering whether we could remove 'data=3Djourn=
al'
and 'data=3Dwriteback' mode.  'data=3Djournal' mode hurts performance
dramatically.  Further, 'data=3Dwriteback' seems also useless, especial=
ly
after we have 'no journal' feature.  TBH, these modes are lack of tests=
=2E
Maybe this is a crazy idea in my mind.

Regards,
                                                - Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
