From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: add regression tests for ^extents punch hole
Date: Tue, 24 Feb 2015 15:58:06 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1502241538430.5931@localhost.localdomain>
References: <4c557308eb4e62752dc8b513495cb6d46ca5775d.1424730653.git.osandov@osandov.com> <20150223224620.GL12722@dastard> <alpine.LFD.2.00.1502241106110.28736@localhost.localdomain> <20150224113108.GA4251@dastard> <alpine.LFD.2.00.1502241249300.28736@localhost.localdomain>
 <20150224124938.GB4251@dastard>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-451048997-1424789892=:5931"
Cc: Omar Sandoval <osandov@osandov.com>, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20150224124938.GB4251@dastard>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-451048997-1424789892=:5931
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 24 Feb 2015, Dave Chinner wrote:

> Date: Tue, 24 Feb 2015 23:49:38 +1100
> From: Dave Chinner <david@fromorbit.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Omar Sandoval <osandov@osandov.com>, fstests@vger.kernel.org,
>     linux-ext4@vger.kernel.org
> Subject: Re: [PATCH] ext4: add regression tests for ^extents punch hole
> 
> On Tue, Feb 24, 2015 at 12:52:00PM +0100, Lukáš Czerner wrote:
> > On Tue, 24 Feb 2015, Dave Chinner wrote:
> > > > it's not that long ago when we discussed very similar case, where
> > > > directly in the test itself the author would specify mkfs options. I
> > > > had the same comment as you have here and you argued that the test
> > > > was made specifically to test that mkfs option. I agree.
> > > 
> > > The case I remember and was basing this off was commit 448efe1
> > > ("generic/017: Do not create file systems with different block
> > > sizes") where you made the argument that we shouldn't be setting
> > > mkfs parameters inside the test and instead those specific cases
> > > would be tested by using test-wide mkfs parameters....
> > > 
> > > I don't recall any other discussion, so maybe you should remind me
> > > of it....
> > 
> > Here it is
> > 
> > http://www.spinics.net/lists/fstests/msg00073.html
> > 
> > specifically your paragraph:
> > 
> > "No, I'm not advocating that at all. If the test has a specific
> > reason for overriding the user configuration, then it should.
> > Some configurations are rarely tested, and so having some tests that
> > exercise them even when other options are being tested is not a bad
> > thing. We catch problem with new changes much faster that way."
> 
> Ah, right, I said that was during the discussion about the commit I
> quoted above. You convinced me that we shouldn't cater for special
> cases like this and instead iterate mkfs/mount configurations.
> On that basis I committed your patch to remove the special cases
> from generic/017.
> 
> > I do not really want to hold your words against you but the thing is
> > that I changed my mind since then and I do agree with that, because
> > it really is useful for testing specific cases where we already had
> > problems before. And this test is one of those cases.
> 
> <sigh>

Yes :)

> 
> /me shakes his head, wonders how other maintainers stay sane

I always though it was drugs. But in your case it might be burning rubber
and gas vapors ;)

> 
> I think the test should still be generic and block size independent,
> but if you want to force ext4 to turn off the extents flag, then
> use something like this:
> 
> [ "$FSTYP" = "ext4" ] && MKFS_OPTIONS="-O ^extents $MKFS_OPTIONS"

Ok, so let's look at this from a different angle. "-O ^extents"
applies for ext2 and ext3 file system. It would be sufficient for
this test to be generic if most people would be using ext4 driver
for ext2/3 file system which I am still not convinced about.

In ideal world we would not need this special case options and we
would just say this problem is for ext2/3 only so it'll be tested
with ext2 and ext3 file system and no special case for ext4 is
needed. However even when using ext4 driver, how many people are
regularly running tests on ext2/3 ?

On that basis I think that having this in the generic case

[ "$FSTYP" = "ext4" ] && MKFS_OPTIONS="-O ^extents $MKFS_OPTIONS"

is fair enough. But then again, what if we really want to run this
with extents as well ?

Omar, can you make the test generic and can this be reproduced on 4k
block size ? If not, can you make a generic reproducer which does
not depend on the block size ?

Also if we want to include the special case for ext4, we need to
have a function which allows us to alter the mkfs options without
completely overriding the user specified options. I think that there
is something like that for xfs, Omar can you do that for ext4 as
well ?

Thanks!
-Lukas

> 
> Cheers,
> 
> Dave.
> 
--8323328-451048997-1424789892=:5931--
