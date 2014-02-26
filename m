From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] ext4/242: Add ext4 specific test for fallocate zero
 range
Date: Thu, 27 Feb 2014 09:01:06 +1100
Message-ID: <20140226220106.GC29907@dastard>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
 <1393355728-12056-6-git-send-email-lczerner@redhat.com>
 <20140225205349.GD13647@dastard>
 <alpine.LFD.2.00.1402252156290.12444@localhost.localdomain>
 <20140225215011.GF13647@dastard>
 <alpine.LFD.2.00.1402261520070.2243@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:18428 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753880AbaBZWBN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Feb 2014 17:01:13 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1402261520070.2243@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 26, 2014 at 03:24:18PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Wed, 26 Feb 2014, Dave Chinner wrote:
>=20
> > Date: Wed, 26 Feb 2014 08:50:11 +1100
> > From: Dave Chinner <david@fromorbit.com>
> > To: Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>
> > Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@=
oss.sgi.com
> > Subject: Re: [PATCH 6/6] ext4/242: Add ext4 specific test for fallo=
cate zero
> >     range
> >=20
> > On Tue, Feb 25, 2014 at 10:01:06PM +0100, Luk=C3=A1=C5=A1 Czerner w=
rote:
> > > On Wed, 26 Feb 2014, Dave Chinner wrote:
> > >=20
> > > > Date: Wed, 26 Feb 2014 07:53:49 +1100
> > > > From: Dave Chinner <david@fromorbit.com>
> > > > To: Lukas Czerner <lczerner@redhat.com>
> > > > Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, =
xfs@oss.sgi.com
> > > > Subject: Re: [PATCH 6/6] ext4/242: Add ext4 specific test for f=
allocate zero
> > > >     range
> > > >=20
> > > > On Tue, Feb 25, 2014 at 08:15:28PM +0100, Lukas Czerner wrote:
> > > > > This is copy of xfs/242. However it's better to make it file =
system
> > > > > specific because the range can be zeroes either directly by w=
riting
> > > > > zeroes, or converting to unwritten extent, so the actual resu=
lt might
> > > > > differ from file system to file system.
> > > >=20
> > > > You could say the same thing about preallocation using unwritte=
n
> > > > extents. Yet, funnily enough, we have generic tests for them be=
cause
> > > > all filesystems currently use unwritten extents for preallocati=
on
> > > > and behave identically....
> > > >=20
> > > > This test is no different - all filesystems currently use unwri=
tten
> > > > extents, and so this test should be generic because all existin=
g
> > > > filesystems *should* behave the same.
> > > >=20
> > > > When we get a filesystem that zeros rather uses unwritten exten=
ts,
> > > > we can add a new *generic* test that tests for zeroed data exte=
nts
> > > > rather than unwritten extents. All that we will need is a metho=
d of
> > > > checking what behaviour the filesystem has and adding that to a
> > > > _requires directive to ensure the correct generic fallocate tes=
ts
> > > > are run...
> > >=20
> > > Currently xfs/242 fails on xfs for me
> >=20
> > Really? Where's the bug report? I haven't seen a failure on xfs/242
> > on any of my test machines for at least a year, even on 1k block
> > size filesystems...
> >=20
> > $ sudo ./check xfs/242
> > FSTYP         -- xfs (debug)
> > PLATFORM      -- Linux/x86_64 test2 3.14.0-rc3-dgc+
> > MKFS_OPTIONS  -- -f -bsize=3D4096 /dev/vdb
> > MOUNT_OPTIONS -- /dev/vdb /mnt/scratch
> >=20
> > xfs/242 1s ... 0s
> > Ran: xfs/242
> > Passed all 1 tests
> > $
>=20
> Here it is.
>=20
> xfs/242 fails on ppc64 with latest linus tree

OK, that's a different kettle of fish. It's using 64k pages, right?

> # uname -a
> Linux ibm-p740-01-lp4.rhts.eng.bos.redhat.com 3.14.0-rc4+ #1 SMP Wed
> Feb 26 08:59:48 EST 2014 ppc64 ppc64 ppc64 GNU/Linux
>=20
> # ./check xfs/242
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/ppc64 ibm-p740-01-lp4 3.14.0-rc4+
> MKFS_OPTIONS  -- -f -bsize=3D4096 /dev/loop1
> MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:nfs_t:s0 /dev/loop1 /=
mnt/test2
>=20
> xfs/242  - output mismatch (see /root/xfstests/results//xfs/242.out.b=
ad)
>     --- tests/xfs/242.out       2014-02-26 05:51:16.602579462 -0500
>     +++ /root/xfstests/results//xfs/242.out.bad 2014-02-26 09:20:55.5=
85396040 -0500
>     @@ -1,76 +1,71 @@
>      QA output created by 242
>         1. into a hole
>      0: [0..7]: hole
>     -1: [8..23]: unwritten
>     +1: [8..23]: data
>      2: [24..39]: hole
>      daa100df6e6711906b61c9ab5aa16032

So the data is correct, but the range got zeroes written to it
rather than an unwritten extent.

>     (Run 'diff -u tests/xfs/242.out /root/xfstests/results//xfs/242.o=
ut.bad'  to see the entire diff)
> Ran: xfs/242
> Failures: xfs/242
> Failed 1 of 1 tests
>=20
>=20
> Here is 242.out.bad

The diff would have been better.

/me goes off to diff the output

Yeah, ok, the data in all the files is correct - the md5sums all
match. What's different? Just about all unwritten extents are now
written (i.e. data) or contain some portion of written extents.

So, ZERO_RANGE has the following size threshold for converting
blocks to unwritten extents vs just zeroing them:

	granularity =3D max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE=
);

So if this is a 64k page size machine, it's going to have different
extent layout compared to a 4k page size machine. The file data will
still be the same, the difference will be zeroed blocks instead of
unwritten blocks, and that's exactly what we see.

IOWs, the result in terms of data the application sees is correct,
just the extent layout representing that zeroed data is different.

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
