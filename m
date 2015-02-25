From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH] ext4: add regression tests for ^extents punch hole
Date: Tue, 24 Feb 2015 19:03:56 -0800
Message-ID: <20150225030356.GA6880@mew.dhcp4.washington.edu>
References: <20150224220719.GD4251@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@sandeen.net>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150224220719.GD4251@dastard>
 <alpine.LFD.2.00.1502241538430.5931@localhost.localdomain>
 <20150225002437.GB3782@thunk.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Feb 24, 2015 at 07:24:37PM -0500, Theodore Ts'o wrote:
> I suspect our current generic fsstress and fsx tests would catch this
> already, and what I need to do is to make sure I add ext3/1k to my
> test configurations (currently I test an ext3 configuration, and a 1k
> block configuration, but I don't currently test ext3/1k together).
> That would probably round out my full test iteration to a very
> pleasing 24 hours or so, which is fine, although I wouldn't want it t=
o
> take much longer than that.
>=20
Actually, this issue isn't specific to 1k blocks, so I wouldn't count o=
n
it :) That block size in my tests is an artifact of the initial
reproducer Lukas had (generic/270 on ext3 with 1k blocks). It just so
happens that the start/len arguments fsstress chooses for punch hole
operations in that setup straddles the indirect tree levels in the wron=
g
ways.


On Tue, Feb 24, 2015 at 03:58:06PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> Omar, can you make the test generic and can this be reproduced on 4k
> block size ? If not, can you make a generic reproducer which does
> not depend on the block size ?
>=20
> Also if we want to include the special case for ext4, we need to
> have a function which allows us to alter the mkfs options without
> completely overriding the user specified options. I think that there
> is something like that for xfs, Omar can you do that for ext4 as
> well ?
>=20
> Thanks!
> -Lukas
>=20
>=20
No problem, I'll have a go at it.


On Wed, Feb 25, 2015 at 09:07:19AM +1100, Dave Chinner wrote:
> It's built into the _scratch_mkfs_xfs wrapper, where if the test
> supplies extra options and that conflicts with the CLI supplied
> options it drops the CLI specific options and just uses the test
> options.
>=20
> I've mentioned this specificly in the past, too. i.e. that all
> _scratch_mkfs_$FSTYP wrappers should be handling CLI vs test
> specific options like this.... :/
>=20
> Cheers,
>=20
> Dave.
>=20
I'll take that into account.


Thanks, everyone!
--=20
Omar
