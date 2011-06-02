From: Dave Chinner <david@fromorbit.com>
Subject: Re: Query about DIO/AIO WRITE throttling and ext4 serialization
Date: Thu, 2 Jun 2011 11:22:09 +1000
Message-ID: <20110602012209.GQ561@dastard>
References: <20110601215049.GC17449@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:35936 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758003Ab1FBBWN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Jun 2011 21:22:13 -0400
Content-Disposition: inline
In-Reply-To: <20110601215049.GC17449@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 01, 2011 at 05:50:49PM -0400, Vivek Goyal wrote:
> Hi,
> 
> If I throttle a DIO/AIO WRITE bio at block device in a cgroup, will it
> lead to any kind of serialization of ext4 file system. IOW, is there any
> filesystem operation which will wait for that DIO/AIO WRITE to finish
> before other filesystem can make progress (fsync, journalling etc?)

Truncate?

(XFS explicitly serialises truncate against in flight DIO,
regardless of whether ext4 does.)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
