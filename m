From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] ext4/242: Add ext4 specific test for fallocate zero
 range
Date: Thu, 27 Feb 2014 09:17:57 +1100
Message-ID: <20140226221757.GD29907@dastard>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
 <1393355728-12056-6-git-send-email-lczerner@redhat.com>
 <20140225205349.GD13647@dastard>
 <alpine.LFD.2.00.1402252156290.12444@localhost.localdomain>
 <20140225215011.GF13647@dastard>
 <alpine.LFD.2.00.1402261537040.2243@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1402261537040.2243@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 26, 2014 at 03:58:36PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Wed, 26 Feb 2014, Dave Chinner wrote:
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
> Ok so once again. Yesterday was rally too late and I've
> misinterpreted the diff. It's not that xfs behaves differently, but
> rather ext4 behaves differently because we in fact have a code that
> will zero out entire unwritten extent if it's small enough rather
> than split it into unwritten and written.

Yes, we've come across this before, and there are several solutions.
this one is used in tests/generic/285:

# Disable extent zeroing for ext4 as that change where holes ar created
if [ "$FSTYP" =3D "ext4" ]; then
	DEV=3D`basename $TEST_DEV`
	echo 0 >/sys/fs/ext4/$DEV/extent_max_zeroout_kb
fi

> > > and it does behave differently than ext4.
> >=20
> > In what way? Does FALLOC_FL_ZERO_RANGE on XFS behave identically to
> > XFS_IOC_ZERO_RANGE, or is that different too? Or you haven't tested
> > it because you wrote this test as an ext4 specific test and so
> > haven't run this specific test exercising the FALLOC_FL_ZERO_RANGE
> > path in XFS?
>=20
> It does behave differently, but not because of zero_range code, but
> rather when writing into uninitialized extent which is small enough.
> The extent will not be split but rather converted to initialized and
> respective parts will be zeroed out.
>=20
> Btw that's actually the reason why we use
>=20
> _filter_hole_fiemap
>=20
> filtes instead of
>=20
> _filter_fiemap
>=20
> I've used in ext4/242.

Sure, but even so I think we might do better just to use the above
zeroout tune and be explicit in what we expect to happen w.r.t. data
vs holes...

>=20
> That said I think that both tests fs specific and fs independent
> have it's value so I'll create generic/242 as well by using
> _filter_hole_fiemap.

Just use the first unused generic test number - trying to keep test
numbers the same across different subdirs is just going to cause
confusion....

> > hole punching - the only difference between a hole punch and a zero
> > range on filesystems that use unwritten extents should be that the
> > range being operated on has unwritten extents rather a hole.....
> >=20
> > > Btw this kind of optimization is actually something I've been
> > > thinking of as well for ext4. Rather than going though the hassle=
 of
> > > changing extents around it might be worth in some situation to ze=
ro
> > > out. But that's an optimization I have not implemented yet.
> >=20
> > Exactly my point - until such optimisations are implemented, all th=
e
> > filesystems should be behaving the same way using unwritten extents=
,
> > just like for hole punching. Hence the tests should be checking tha=
t
> > the behaviour is the same across filesystems, just like we do for
> > hole punching.
>=20
> Using _filter_hole_fiemap filter in such test we would not make a
> difference between unwritten and written extent. However in the case
> of zero_range this somewhat make the test much less effective so
> it'll be worth having fs specific test as well as generic test I
> said above.
>=20
> Or we could actually directly inspect the data as we do in xfs/290, o=
r
> generic/290 respectively.

The md5sum does the data inspection for us. The whole point of
hole punch and zero range and so one is that they are extent
manipulation operations. If we don't check that extents have been
manipulated correctly, then we aren't testing that the key behaviour
the filesystems are supposed to display for those operations....

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
