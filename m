From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Wed, 9 Jul 2008 21:15:26 +1000
Message-ID: <20080709111526.GU11558@disturbed>
References: <20080709005254.GQ11558@disturbed> <20080709010922.GE9957@mit.edu> <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <20080709065950.GR11558@disturbed> <E1KGTrq-0006qj-1u@pomaz-ex.szeredi.hu> <20080709073358.GT11558@disturbed> <E1KGUlR-0006zH-FT@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: arjan@infradead.org, hch@infradead.org, tytso@mit.edu,
	pavel@suse.cz, t-sato@yk.jp.nec.com, akpm@linux-foundation.org,
	viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	axboe@kernel.dk, mtk.manpages@googlemail.com
To: Miklos Szeredi <miklos@szeredi.hu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:58502 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753814AbYGILPh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jul 2008 07:15:37 -0400
Content-Disposition: inline
In-Reply-To: <E1KGUlR-0006zH-FT@pomaz-ex.szeredi.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 09, 2008 at 10:11:01AM +0200, Miklos Szeredi wrote:
> On Wed, 9 Jul 2008, Dave Chinner wrote:
> > On Wed, Jul 09, 2008 at 09:13:34AM +0200, Miklos Szeredi wrote:
> > > On Wed, 9 Jul 2008, Dave Chinner wrote:
> > > > The argument against Miklos' version is that there may be multi=
ple
> > > > commands to execute while the fs is frozen.
> > >=20
> > > Which is what a shell is for ;)
> >=20
> > Yeah, we=C4=BAl, with your method I ca't tell a user to:
> >=20
> > 	# xfs_freeze -f /mntpt
> > 	# xfs_db -r -c 'sb 0' -c 'p rootino' /dev/foo
> > 	128
> > 	# xfs_db -r -c 'ino 128' -c 'p core.format' /dev/foo
> > 	core.format =3D 2 (extents)
> > 	# xfs_db .....
> > 	.....
> > 	# xfs_freeze -u /mntpt
> >=20
> > i.e. using the freeze to force all metadata to disk and
> > prevent it from changing while doing interactive debugging
> > of some problem.
>=20
> 	# run_freeze /mntpt /bin/bash
> 	# ...
> 	# ^D
>=20
> It's the same, no?

=46or that case, yeah. But it's a horrible hack - if that's the
best we can come up with for this freeze/unfreeze then we've
already lost.

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
