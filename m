From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: add regression tests for ^extents punch hole
Date: Tue, 24 Feb 2015 11:11:04 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1502241106110.28736@localhost.localdomain>
References: <4c557308eb4e62752dc8b513495cb6d46ca5775d.1424730653.git.osandov@osandov.com> <20150223224620.GL12722@dastard>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Omar Sandoval <osandov@osandov.com>, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20150223224620.GL12722@dastard>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 24 Feb 2015, Dave Chinner wrote:

> Date: Tue, 24 Feb 2015 09:46:20 +1100
> From: Dave Chinner <david@fromorbit.com>
> To: Omar Sandoval <osandov@osandov.com>
> Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
> Subject: Re: [PATCH] ext4: add regression tests for ^extents punch hole
> 
> On Mon, Feb 23, 2015 at 02:39:36PM -0800, Omar Sandoval wrote:
> > Linux commit 6f30b7e37a82 (ext4: fix indirect punch hole corruption)
> > fixes several bugs in the FALLOC_FL_PUNCH_HOLE implementation for an
> > ext4 filesystem with indirect blocks.
> > 
> > Signed-off-by: Omar Sandoval <osandov@osandov.com>
> > ---
> >  tests/ext4/005     | 115 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/ext4/005.out |  29 ++++++++++++++
> >  tests/ext4/group   |   1 +
> >  3 files changed, 145 insertions(+)
> >  create mode 100755 tests/ext4/005
> >  create mode 100644 tests/ext4/005.out
> 
> What's ext4 specific about this test apart from the mkfs parameter?
> Shouldn't it be generic and so test all the filesystems behave the
> same?  i.e. when someone then runs
> 
> # MKFS_OPTIONS="-b size=1k -O ^extents" ./check -g auto
> 
> That will exercise this specific regression fix, not to mention give
> much, much better test coverage of that configuration than just
> making a single test use that config...
> 
> Cheers,
> 
> Dave.

Hi Dave,

it's not that long ago when we discussed very similar case, where
directly in the test itself the author would specify mkfs options. I
had the same comment as you have here and you argued that the test
was made specifically to test that mkfs option. I agree.

In this case it's the same. This test was specifically designed for
this combination of options, because that's where the ext4 bug was.

If we want to make the test generic and use those options just in
ext4 case, I am fine with that, but the mkfs options needs to be a
part of the test nevertheless.

Thanks!
-Lukas

> 
