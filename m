From: Dave Chinner <david@fromorbit.com>
Subject: Re: Announce re-factor all current xfstests patches request
Date: Thu, 28 Mar 2013 07:54:07 +1100
Message-ID: <20130327205407.GU6369@dastard>
References: <5152F2BB.4000709@sgi.com>
 <20130327134606.GJ5861@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rich Johnston <rjohnston@sgi.com>, xfs-oss <xfs@oss.sgi.com>,
	linux-ext4@vger.kernel.org,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:11745 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752453Ab3C0VLD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Mar 2013 17:11:03 -0400
Content-Disposition: inline
In-Reply-To: <20130327134606.GJ5861@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 27, 2013 at 09:46:06AM -0400, Theodore Ts'o wrote:
> On Wed, Mar 27, 2013 at 08:23:07AM -0500, Rich Johnston wrote:
> > All xfstest developers,
> > 
> > Thanks again for all your time in submitting and reviewing patches
> > for xfstests.  The latest patchset posted here:
> > 
> > http://oss.sgi.com/archives/xfs/2013-03/msg00467.html
> > 
> > requires all current patches to be re-factored.
> 
> Given that we are now segregating patches into subdirectories, is it
> correct in the future tests should be named descriptively, instead of
> using 3 digit NNN numbers (which has been a major pain from a central
> assignment perspective)?

Support for named tests have not yet been added. From the check
script:

SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
