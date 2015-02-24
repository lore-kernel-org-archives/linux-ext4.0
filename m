From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: add regression tests for ^extents punch hole
Date: Tue, 24 Feb 2015 12:52:00 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1502241249300.28736@localhost.localdomain>
References: <4c557308eb4e62752dc8b513495cb6d46ca5775d.1424730653.git.osandov@osandov.com> <20150223224620.GL12722@dastard> <alpine.LFD.2.00.1502241106110.28736@localhost.localdomain> <20150224113108.GA4251@dastard>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-28483026-1424778723=:28736"
Cc: Omar Sandoval <osandov@osandov.com>, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbbBXLwI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2015 06:52:08 -0500
In-Reply-To: <20150224113108.GA4251@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-28483026-1424778723=:28736
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 24 Feb 2015, Dave Chinner wrote:

> Date: Tue, 24 Feb 2015 22:31:08 +1100
> From: Dave Chinner <david@fromorbit.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Omar Sandoval <osandov@osandov.com>, fstests@vger.kernel.org,
>     linux-ext4@vger.kernel.org
> Subject: Re: [PATCH] ext4: add regression tests for ^extents punch hole
> 
> On Tue, Feb 24, 2015 at 11:11:04AM +0100, Lukáš Czerner wrote:
> > On Tue, 24 Feb 2015, Dave Chinner wrote:
> > 
> > > Date: Tue, 24 Feb 2015 09:46:20 +1100
> > > From: Dave Chinner <david@fromorbit.com>
> > > To: Omar Sandoval <osandov@osandov.com>
> > > Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
> > > Subject: Re: [PATCH] ext4: add regression tests for ^extents punch hole
> > > 
> > > On Mon, Feb 23, 2015 at 02:39:36PM -0800, Omar Sandoval wrote:
> > > > Linux commit 6f30b7e37a82 (ext4: fix indirect punch hole corruption)
> > > > fixes several bugs in the FALLOC_FL_PUNCH_HOLE implementation for an
> > > > ext4 filesystem with indirect blocks.
> > > > 
> > > > Signed-off-by: Omar Sandoval <osandov@osandov.com>
> > > > ---
> > > >  tests/ext4/005     | 115 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/ext4/005.out |  29 ++++++++++++++
> > > >  tests/ext4/group   |   1 +
> > > >  3 files changed, 145 insertions(+)
> > > >  create mode 100755 tests/ext4/005
> > > >  create mode 100644 tests/ext4/005.out
> > > 
> > > What's ext4 specific about this test apart from the mkfs parameter?
> > > Shouldn't it be generic and so test all the filesystems behave the
> > > same?  i.e. when someone then runs
> > > 
> > > # MKFS_OPTIONS="-b size=1k -O ^extents" ./check -g auto
> > > 
> > > That will exercise this specific regression fix, not to mention give
> > > much, much better test coverage of that configuration than just
> > > making a single test use that config...
> > > 
> > > Cheers,
> > > 
> > > Dave.
> > 
> > Hi Dave,
> > 
> > it's not that long ago when we discussed very similar case, where
> > directly in the test itself the author would specify mkfs options. I
> > had the same comment as you have here and you argued that the test
> > was made specifically to test that mkfs option. I agree.
> 
> The case I remember and was basing this off was commit 448efe1
> ("generic/017: Do not create file systems with different block
> sizes") where you made the argument that we shouldn't be setting
> mkfs parameters inside the test and instead those specific cases
> would be tested by using test-wide mkfs parameters....
> 
> I don't recall any other discussion, so maybe you should remind me
> of it....

Here it is

http://www.spinics.net/lists/fstests/msg00073.html

specifically your paragraph:

"No, I'm not advocating that at all. If the test has a specific
reason for overriding the user configuration, then it should.
Some configurations are rarely tested, and so having some tests that
exercise them even when other options are being tested is not a bad
thing. We catch problem with new changes much faster that way."

I do not really want to hold your words against you but the thing is
that I changed my mind since then and I do agree with that, because
it really is useful for testing specific cases where we already had
problems before. And this test is one of those cases.

-Lukas

> 
> Cheers,
> 
> Dave.
> 
--8323328-28483026-1424778723=:28736--
