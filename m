From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] generic: test locking when setting encryption policy
Date: Tue, 22 Nov 2016 08:32:51 +1100
Message-ID: <20161121213251.GL31101@dastard>
References: <1479412027-34416-1-git-send-email-ebiggers@google.com>
 <1479412027-34416-5-git-send-email-ebiggers@google.com>
 <20161120223536.GL28177@dastard>
 <20161121192519.GE30672@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        David Gstir <david@sigma-star.at>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:45966 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752505AbcKUVef (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 21 Nov 2016 16:34:35 -0500
Content-Disposition: inline
In-Reply-To: <20161121192519.GE30672@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 21, 2016 at 11:25:19AM -0800, Eric Biggers wrote:
> On Mon, Nov 21, 2016 at 09:35:36AM +1100, Dave Chinner wrote:
> > On Thu, Nov 17, 2016 at 11:47:07AM -0800, Eric Biggers wrote:
> > > This test tries to reproduce (with a moderate chance of success on ext4)
> > > a race condition where a file could be created in a directory
> > > concurrently to an encryption policy being set on that directory,
> > > causing the directory to become corrupted.
> > 
> > Why can't this be done with shell loops rather than requiring a
> > helper application?
> 
> That's what I tried originally, but the race was too difficult to hit with the
> overhead of execing a program for every mkdir and ioctl syscall.

This means that reproducing the race condition is going to be
machine dependent regardless of how the test is written.

In cases like this for XFS, we tend towards adding a debug sysfs
file to introduce a delay into the code that allows the race to be
triggered reliably. The delay is only included in CONFIG_XFS_DEBUG=y
builds, and the test is conditional on the sysfs file being present.

e.g. xfs/051 uses a log recovery delay to allow us to reliably
trigger IO errors in the middle of log recovery and hence exercise
the IO error failure paths in the middle of recovery. This made an
extremely unreliable reproducer into a test case that triggered
reliably on every machine the test is run on....

Can something like this be done in this case?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
