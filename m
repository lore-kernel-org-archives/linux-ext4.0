From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] ext4/242: Add ext4 specific test for fallocate zero
 range
Date: Wed, 26 Feb 2014 08:50:11 +1100
Message-ID: <20140225215011.GF13647@dastard>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
 <1393355728-12056-6-git-send-email-lczerner@redhat.com>
 <20140225205349.GD13647@dastard>
 <alpine.LFD.2.00.1402252156290.12444@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1402252156290.12444@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Feb 25, 2014 at 10:01:06PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Wed, 26 Feb 2014, Dave Chinner wrote:
>=20
> > Date: Wed, 26 Feb 2014 07:53:49 +1100
> > From: Dave Chinner <david@fromorbit.com>
> > To: Lukas Czerner <lczerner@redhat.com>
> > Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@=
oss.sgi.com
> > Subject: Re: [PATCH 6/6] ext4/242: Add ext4 specific test for fallo=
cate zero
> >     range
> >=20
> > On Tue, Feb 25, 2014 at 08:15:28PM +0100, Lukas Czerner wrote:
> > > This is copy of xfs/242. However it's better to make it file syst=
em
> > > specific because the range can be zeroes either directly by writi=
ng
> > > zeroes, or converting to unwritten extent, so the actual result m=
ight
> > > differ from file system to file system.
> >=20
> > You could say the same thing about preallocation using unwritten
> > extents. Yet, funnily enough, we have generic tests for them becaus=
e
> > all filesystems currently use unwritten extents for preallocation
> > and behave identically....
> >=20
> > This test is no different - all filesystems currently use unwritten
> > extents, and so this test should be generic because all existing
> > filesystems *should* behave the same.
> >=20
> > When we get a filesystem that zeros rather uses unwritten extents,
> > we can add a new *generic* test that tests for zeroed data extents
> > rather than unwritten extents. All that we will need is a method of
> > checking what behaviour the filesystem has and adding that to a
> > _requires directive to ensure the correct generic fallocate tests
> > are run...
>=20
> Currently xfs/242 fails on xfs for me

Really? Where's the bug report? I haven't seen a failure on xfs/242
on any of my test machines for at least a year, even on 1k block
size filesystems...

$ sudo ./check xfs/242
=46STYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test2 3.14.0-rc3-dgc+
MKFS_OPTIONS  -- -f -bsize=3D4096 /dev/vdb
MOUNT_OPTIONS -- /dev/vdb /mnt/scratch

xfs/242 1s ... 0s
Ran: xfs/242
Passed all 1 tests
$


> and it does behave differently than ext4.

In what way? Does FALLOC_FL_ZERO_RANGE on XFS behave identically to
XFS_IOC_ZERO_RANGE, or is that different too? Or you haven't tested
it because you wrote this test as an ext4 specific test and so
haven't run this specific test exercising the FALLOC_FL_ZERO_RANGE
path in XFS?

IOWs, how do you know that what you are seeing is not a bug in the
ext4 (or XFS for that matter) implementation?

> Also I had to change to 242.out a bit because ext4 was
> a little different. It seems to me that it was expected that when
> the extent is small enough it would be overwritten by zeroes rather
> than converted to unwritten, but I have not looked into
> implementation.

The test assumes that sub-block head and tail ranges will be zeroed,
and everything else will be converted to unwritten extents. i.e. a
single block aligned range will get converted to unwritten, but a
single unaligned block range will result in the two overlapping
blocks being zeroed (because they still contain valid data).

This is the same sub-block zeroing behaviour as is done for
hole punching - the only difference between a hole punch and a zero
range on filesystems that use unwritten extents should be that the
range being operated on has unwritten extents rather a hole.....

> Btw this kind of optimization is actually something I've been
> thinking of as well for ext4. Rather than going though the hassle of
> changing extents around it might be worth in some situation to zero
> out. But that's an optimization I have not implemented yet.

Exactly my point - until such optimisations are implemented, all the
filesystems should be behaving the same way using unwritten extents,
just like for hole punching. Hence the tests should be checking that
the behaviour is the same across filesystems, just like we do for
hole punching.

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
