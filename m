From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] ext4/242: Add ext4 specific test for fallocate zero
 range
Date: Fri, 28 Feb 2014 06:35:33 +1100
Message-ID: <20140227193533.GB30131@dastard>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
 <1393355728-12056-6-git-send-email-lczerner@redhat.com>
 <20140225205349.GD13647@dastard>
 <alpine.LFD.2.00.1402252156290.12444@localhost.localdomain>
 <20140225215011.GF13647@dastard>
 <alpine.LFD.2.00.1402261520070.2243@localhost.localdomain>
 <20140226220106.GC29907@dastard>
 <alpine.LFD.2.00.1402271257590.2247@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1402271257590.2247@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Feb 27, 2014 at 01:03:09PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Thu, 27 Feb 2014, Dave Chinner wrote:
> > > xfs/242 fails on ppc64 with latest linus tree
> >=20
> > OK, that's a different kettle of fish. It's using 64k pages, right?
>=20
> 64k pages, yes.
=2E...
> > Yeah, ok, the data in all the files is correct - the md5sums all
> > match. What's different? Just about all unwritten extents are now
> > written (i.e. data) or contain some portion of written extents.
> >=20
> > So, ZERO_RANGE has the following size threshold for converting
> > blocks to unwritten extents vs just zeroing them:
> >=20
> > 	granularity =3D max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_=
SIZE);
> >=20
> > So if this is a 64k page size machine, it's going to have different
> > extent layout compared to a 4k page size machine. The file data wil=
l
> > still be the same, the difference will be zeroed blocks instead of
> > unwritten blocks, and that's exactly what we see.
> >=20
> > IOWs, the result in terms of data the application sees is correct,
> > just the extent layout representing that zeroed data is different.
>=20
> Ok, so that's yet another difference between xfs and ext4 code which
> makes having generic test even more complicated.

It actually makes the need for a generic test more important. A
generic test should handle the differences between block/page size
behaviours - the issue is that xfs/242 was written and tested on 4k
page machines, not 64k page machines.

We've already got the "multiple" code in _generic_test_punch to
increase the size of the regions being worked on, so the simple fix
here is to increase the sizes so that 64k page and 4k page behaviour
is the same and results in the same extent layout. This is the
normal way tests evolve as people run them on different hardware and
configurations....

> So as I said before
> I'll make the generic test (using _filter_hole_fiemap) and then ext4
> specific test as well to really make sure that the extent
> manipulation is right.

Which ignores the fact that if you turn off zeroout on ext4 then a
generic test can also determine that the extent manipulation is
correct. I really don't see the need for an ext4 specific test
here...

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
