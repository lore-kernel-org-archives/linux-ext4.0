From: Dave Chinner <david@fromorbit.com>
Subject: Re: Emergency remount readonly and EFBIG errors when unlinking files
 on 3.18 android kernel
Date: Wed, 27 Apr 2016 13:25:17 +1000
Message-ID: <20160427032517.GK18496@dastard>
References: <571FE6DB.8030604@codeaurora.org>
 <20160427030736.GB30021@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nikhilesh Reddy <reddyn@codeaurora.org>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:3327 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752685AbcD0DZW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Apr 2016 23:25:22 -0400
Content-Disposition: inline
In-Reply-To: <20160427030736.GB30021@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 26, 2016 at 11:07:36PM -0400, Theodore Ts'o wrote:
> On Tue, Apr 26, 2016 at 03:08:27PM -0700, Nikhilesh Reddy wrote:
> > I would appreciate if you could point me in the right direction and any help
> > you can give me.
> 
> Well, what I'd do is create a new ioctl interface which simulates an
> emergency ro on just the one device, and try to create a reliable
> repro.  Eventually we'll want to add some tests for this in xfstests.

That's pretty much XFS_IOC_GOINGDOWN, controlled by xfs_io -c shutdown.
I'd suggest that adding a new flag:

#define XFS_FSOP_GOING_FLAGS_EMERG_REMOUNT 0x4

Would be in line with it's existing usage in xfstests for forcing
different shutdown conditions on filesystems....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
