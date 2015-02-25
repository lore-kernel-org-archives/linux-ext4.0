From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: add regression tests for ^extents punch hole
Date: Wed, 25 Feb 2015 09:42:19 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1502250941060.2212@localhost.localdomain>
References: <20150225030356.GA6880@mew.dhcp4.washington.edu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-863826668-1424853743=:2212"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@sandeen.net>, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbbBYImb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Feb 2015 03:42:31 -0500
In-Reply-To: <20150225030356.GA6880@mew.dhcp4.washington.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-863826668-1424853743=:2212
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 24 Feb 2015, Omar Sandoval wrote:

> Date: Tue, 24 Feb 2015 19:03:56 -0800
> From: Omar Sandoval <osandov@osandov.com>
> To: Theodore Ts'o <tytso@mit.edu>, Lukáš Czerner <lczerner@redhat.com>,
>     Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>
> Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
> Subject: Re: [PATCH] ext4: add regression tests for ^extents punch hole
> 
> On Tue, Feb 24, 2015 at 07:24:37PM -0500, Theodore Ts'o wrote:
> > I suspect our current generic fsstress and fsx tests would catch this
> > already, and what I need to do is to make sure I add ext3/1k to my
> > test configurations (currently I test an ext3 configuration, and a 1k
> > block configuration, but I don't currently test ext3/1k together).
> > That would probably round out my full test iteration to a very
> > pleasing 24 hours or so, which is fine, although I wouldn't want it to
> > take much longer than that.
> > 
> Actually, this issue isn't specific to 1k blocks, so I wouldn't count on
> it :) That block size in my tests is an artifact of the initial
> reproducer Lukas had (generic/270 on ext3 with 1k blocks). It just so
> happens that the start/len arguments fsstress chooses for punch hole
> operations in that setup straddles the indirect tree levels in the wrong
> ways.

Right, it's not specific to 1k but it was easier to hit it this way.
Even though we've been able to detect this problem before I think
it's very much worth to have a special test case for this particular
problem anyway.

> 
> 
> On Tue, Feb 24, 2015 at 03:58:06PM +0100, Lukáš Czerner wrote:
> > Omar, can you make the test generic and can this be reproduced on 4k
> > block size ? If not, can you make a generic reproducer which does
> > not depend on the block size ?
> > 
> > Also if we want to include the special case for ext4, we need to
> > have a function which allows us to alter the mkfs options without
> > completely overriding the user specified options. I think that there
> > is something like that for xfs, Omar can you do that for ext4 as
> > well ?
> > 
> > Thanks!
> > -Lukas
> > 
> > 
> No problem, I'll have a go at it.

Great, thanks!

-Lukas

> 
> 
> On Wed, Feb 25, 2015 at 09:07:19AM +1100, Dave Chinner wrote:
> > It's built into the _scratch_mkfs_xfs wrapper, where if the test
> > supplies extra options and that conflicts with the CLI supplied
> > options it drops the CLI specific options and just uses the test
> > options.
> > 
> > I've mentioned this specificly in the past, too. i.e. that all
> > _scratch_mkfs_$FSTYP wrappers should be handling CLI vs test
> > specific options like this.... :/
> > 
> > Cheers,
> > 
> > Dave.
> > 
> I'll take that into account.
> 
> 
> Thanks, everyone!
> 
--8323328-863826668-1424853743=:2212--
