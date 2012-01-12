From: Dave Chinner <david@fromorbit.com>
Subject: Re: punch-hole should go beyond i_size
Date: Thu, 12 Jan 2012 13:55:47 +1100
Message-ID: <20120112025547.GC2806@dastard>
References: <alpine.LSU.2.00.1201111639240.1833@eggly.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Hugh Dickins <hughd@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:29814 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752419Ab2ALCzt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jan 2012 21:55:49 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1201111639240.1833@eggly.anvils>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 11, 2012 at 05:02:12PM -0800, Hugh Dickins wrote:
> Hi Allison,
> 
> In thinking about fallocate() on tmpfs, I cross-check with ext4
> and find this bug in its implementation of FALLOC_FL_PUNCH_HOLE:
> 
> rm -f temp
> fallocate    -l 4096 temp
> du temp				# shows 4, right
> fallocate -p -l 4096 temp
> du temp				# shows 0, right
> rm -f temp
> fallocate -n -l 4096 temp
> du temp				# shows 4, right
> fallocate -p -l 4096 temp
> du temp				# shows 4, wrong
> rm temp
> 
> ext4_ext_punch_hole() contains /* No need to punch hole beyond i_size */
> early return, and trimming to i_size below, but forgets that the other
> variety of fallocate(), with FALLOC_FL_KEEP_SIZE set, may have allocated
> blocks beyond i_size.  They can be removed with ftruncate(), but it is
> unexpected for fallocate() not to undo its own work, and xfs does so.

I'm pretty sure that's a bug as XFS allows punching holes in extents
beyond EOF.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
