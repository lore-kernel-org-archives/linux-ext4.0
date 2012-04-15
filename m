From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC]jbd2: use GFP_NOFS for blkdev_issue_flush
Date: Mon, 16 Apr 2012 08:44:27 +1000
Message-ID: <20120415224427.GV6734@dastard>
References: <4F878F17.2030900@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu
To: Shaohua Li <shli@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:21161 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752074Ab2DOWoa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Apr 2012 18:44:30 -0400
Content-Disposition: inline
In-Reply-To: <4F878F17.2030900@kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 13, 2012 at 10:27:35AM +0800, Shaohua Li wrote:
> 
> flush request is issued in transaction commit code path, so looks using
> GFP_KERNEL to allocate memory for flush request bio falls into the classic
> deadlock issue.  I saw btrfs and dm get it right, but ext4, xfs and md are
> using GFP_KERNEL, which makes me confused. Hoping filesystem developers
> clarify.

Only one of the 5 calls XFS makes to blkdev_issue_flush() is
questionable. Probably should use GFP_NOFS by default, though, so we
don't trip over this problem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
