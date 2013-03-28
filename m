From: Dave Chinner <david@fromorbit.com>
Subject: Re: Announce re-factor all current xfstests patches request
Date: Thu, 28 Mar 2013 11:35:47 +1100
Message-ID: <20130328003547.GX6369@dastard>
References: <5152F2BB.4000709@sgi.com>
 <20130327134606.GJ5861@thunk.org>
 <20130327205407.GU6369@dastard>
 <20130327214804.GA28143@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rich Johnston <rjohnston@sgi.com>, xfs-oss <xfs@oss.sgi.com>,
	linux-ext4@vger.kernel.org,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130327214804.GA28143@thunk.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 27, 2013 at 05:48:04PM -0400, Theodore Ts'o wrote:
> On Thu, Mar 28, 2013 at 07:54:07AM +1100, Dave Chinner wrote:
> > 
> > Support for named tests have not yet been added. From the check
> > script:
> > 
> > SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
> 
> Ah, I thought support for named tests was there.  For right now,
> though, if we have test ext4/123 and btrfs/123, that's OK and they are
> considered separate tests, right?  Or do we still need to keep the
> numbers unique for now?

Test numbers within a subdir are unique. So yes, ext4/123 and
btrfs/123 are recognised as different tests.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
