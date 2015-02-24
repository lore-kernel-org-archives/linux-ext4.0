From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: add regression tests for ^extents punch hole
Date: Wed, 25 Feb 2015 09:07:19 +1100
Message-ID: <20150224220719.GD4251@dastard>
References: <4c557308eb4e62752dc8b513495cb6d46ca5775d.1424730653.git.osandov@osandov.com>
 <20150223224620.GL12722@dastard>
 <alpine.LFD.2.00.1502241106110.28736@localhost.localdomain>
 <20150224113108.GA4251@dastard>
 <alpine.LFD.2.00.1502241249300.28736@localhost.localdomain>
 <20150224124938.GB4251@dastard>
 <alpine.LFD.2.00.1502241538430.5931@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Omar Sandoval <osandov@osandov.com>, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1502241538430.5931@localhost.localdomain>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Feb 24, 2015 at 03:58:06PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Tue, 24 Feb 2015, Dave Chinner wrote:
> > I think the test should still be generic and block size independent=
,
> > but if you want to force ext4 to turn off the extents flag, then
> > use something like this:
> >=20
> > [ "$FSTYP" =3D "ext4" ] && MKFS_OPTIONS=3D"-O ^extents $MKFS_OPTION=
S"
>=20
> Ok, so let's look at this from a different angle. "-O ^extents"
> applies for ext2 and ext3 file system. It would be sufficient for
> this test to be generic if most people would be using ext4 driver
> for ext2/3 file system which I am still not convinced about.
>=20
> In ideal world we would not need this special case options and we
> would just say this problem is for ext2/3 only so it'll be tested
> with ext2 and ext3 file system and no special case for ext4 is
> needed. However even when using ext4 driver, how many people are
> regularly running tests on ext2/3 ?
>=20
> On that basis I think that having this in the generic case
>=20
> [ "$FSTYP" =3D "ext4" ] && MKFS_OPTIONS=3D"-O ^extents $MKFS_OPTIONS"
>=20
> is fair enough. But then again, what if we really want to run this
> with extents as well ?
>=20
> Omar, can you make the test generic and can this be reproduced on 4k
> block size ? If not, can you make a generic reproducer which does
> not depend on the block size ?
>=20
> Also if we want to include the special case for ext4, we need to
> have a function which allows us to alter the mkfs options without
> completely overriding the user specified options. I think that there
> is something like that for xfs, Omar can you do that for ext4 as
> well ?

It's built into the _scratch_mkfs_xfs wrapper, where if the test
supplies extra options and that conflicts with the CLI supplied
options it drops the CLI specific options and just uses the test
options.

I've mentioned this specificly in the past, too. i.e. that all
_scratch_mkfs_$FSTYP wrappers should be handling CLI vs test
specific options like this.... :/

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
