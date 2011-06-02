From: Dave Chinner <david@fromorbit.com>
Subject: Re: Query about DIO/AIO WRITE throttling and ext4 serialization
Date: Fri, 3 Jun 2011 09:46:46 +1000
Message-ID: <20110602234646.GU561@dastard>
References: <20110601215049.GC17449@redhat.com>
 <20110602012209.GQ561@dastard>
 <20110602141716.GD18712@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:61212 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751903Ab1FBXqu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Jun 2011 19:46:50 -0400
Content-Disposition: inline
In-Reply-To: <20110602141716.GD18712@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 02, 2011 at 10:17:16AM -0400, Vivek Goyal wrote:
> On Thu, Jun 02, 2011 at 11:22:09AM +1000, Dave Chinner wrote:
> > On Wed, Jun 01, 2011 at 05:50:49PM -0400, Vivek Goyal wrote:
> > > Hi,
> > > 
> > > If I throttle a DIO/AIO WRITE bio at block device in a cgroup, will it
> > > lead to any kind of serialization of ext4 file system. IOW, is there any
> > > filesystem operation which will wait for that DIO/AIO WRITE to finish
> > > before other filesystem can make progress (fsync, journalling etc?)
> > 
> > Truncate?
> > 
> > (XFS explicitly serialises truncate against in flight DIO,
> > regardless of whether ext4 does.)
> > 
> 
> Dave,
> 
> Does this serialization happens against that particular inode on which
> truncate has been called? If yes, then I think I will still be fine
> as in common use case I am not expecting much sharing of inodes across
> cgroups.

Same inode serialisation only.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
