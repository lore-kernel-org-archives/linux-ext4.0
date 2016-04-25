From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
Date: Mon, 25 Apr 2016 16:34:29 -0700
Message-ID: <20160425233429.GH18517@birch.djwong.org>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
 <1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
 <x49twj26edj.fsf@segfault.boston.devel.redhat.com>
 <20160420205923.GA24797@infradead.org>
 <1461434916.3695.7.camel@intel.com>
 <20160425083114.GA27556@infradead.org>
 <1461604476.3106.12.camel@intel.com>
 <20160425232552.GD18496@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: "Verma, Vishal L" <vishal.l.verma@intel.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "jack@suse.cz" <jack@suse.cz>, "axboe@fb.com" <axboe@fb.com>,
        "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160425232552.GD18496@dastard>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 26, 2016 at 09:25:52AM +1000, Dave Chinner wrote:
> On Mon, Apr 25, 2016 at 05:14:36PM +0000, Verma, Vishal L wrote:
> > On Mon, 2016-04-25 at 01:31 -0700, hch@infradead.org wrote:
> > > On Sat, Apr 23, 2016 at 06:08:37PM +0000, Verma, Vishal L wrote:
> > > >=20
> > > > direct_IO might fail with -EINVAL due to misalignment, or -ENOMEM
> > > > due
> > > > to some allocation failing, and I thought we should return the
> > > > original
> > > > -EIO in such cases so that the application doesn't lose the
> > > > information
> > > > that the bad block is actually causing the error.
> > > EINVAL is a concern here.=A0=A0Not due to the right error reported,=
 but
> > > because it means your current scheme is fundamentally broken - we
> > > need to support I/O at any alignment for DAX I/O, and not fail due =
to
> > > alignbment concernes for a highly specific degraded case.
> > >=20
> > > I think this whole series need to go back to the drawing board as I
> > > don't think it can actually rely on using direct I/O as the EIO
> > > fallback.
> > >=20
> > Agreed that DAX I/O can happen with any size/alignment, but how else =
do
> > we send an IO through the driver without alignment restrictions? Also=
,
> > the granularity at which we store badblocks is 512B sectors, so it
> > seems natural that to clear such a sector, you'd expect to send a wri=
te
> > to the whole sector.
> >=20
> > The expected usage flow is:
> >=20
> > - Application hits EIO doing dax_IO or load/store io
> >=20
> > - It checks badblocks and discovers it's files have lost data
>=20
> Lots of hand-waving here. How does the application map a bad
> "sector" to a file without scanning the entire filesystem to find
> the owner of the bad sector?

FWIW there was some discussion @ LSF about using (XFS) rmap to figure out
which parts of a file (on XFS) have gone bad.  Chris Mason said that he'd
like to collaborate on having a common getfsmap ioctl between btrfs and
XFS since they have a backref index that could be hooked up to it for the=
m.

Obviously the app still has to coordinate stopping file IO and calling
GETFSMAP since the fs won't do that on its own.  There's also the questio=
n
of how to handle LBA translation if there's other stuff like dm in the wa=
y.
I don't think device-mapper or md do reverse mapping, so things get murky
from here.

Guess I should get on pushing out a getfsmap patch for review. :)

--D

(/me doesn't have answers to any of your other questions.)

> > - It write()s those sectors (possibly converted to file offsets using
> > fiemap)
> > =A0 =A0 * This triggers the fallback path, but if the application is =
doing
> > this level of recovery, it will know the sector is bad, and write the
> > entire sector
>=20
> Where does the application find the data that was lost to be able to
> rewrite it?
>=20
> > - Or it replaces the entire file from backup also using write() (not
> > mmap+stores)
> > =A0 =A0 * This just frees the fs block, and the next time the block i=
s
> > reallocated by the fs, it will likely be zeroed first, and that will =
be
> > done through the driver and will clear errors
>=20
> There's an implicit assumption that applications will keep redundant
> copies of their data at the /application layer/ and be able to
> automatically repair it? And then there's the implicit assumption
> that it will unlink and free the entire file before writing a new
> copy, and that then assumes the the filesystem will zero blocks if
> they get reused to clear errors on that LBA sector mapping before
> they are accessible again to userspace..
>=20
> It seems to me that there are a number of assumptions being made
> across multiple layers here. Maybe I've missed something - can you
> point me to the design/architecture description so I can see how
> "app does data recovery itself" dance is supposed to work?
>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com
>=20
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
