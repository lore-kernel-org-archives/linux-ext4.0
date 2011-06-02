From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Query about DIO/AIO WRITE throttling and ext4 serialization
Date: Thu, 2 Jun 2011 11:56:10 -0400
Message-ID: <20110602155610.GF18712@redhat.com>
References: <20110601215049.GC17449@redhat.com>
 <20110602012209.GQ561@dastard>
 <20110602141716.GD18712@redhat.com>
 <20110602143633.GE18712@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab1FBP4Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Jun 2011 11:56:16 -0400
Content-Disposition: inline
In-Reply-To: <20110602143633.GE18712@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 02, 2011 at 10:36:33AM -0400, Vivek Goyal wrote:
> On Thu, Jun 02, 2011 at 10:17:16AM -0400, Vivek Goyal wrote:
> > On Thu, Jun 02, 2011 at 11:22:09AM +1000, Dave Chinner wrote:
> > > On Wed, Jun 01, 2011 at 05:50:49PM -0400, Vivek Goyal wrote:
> > > > Hi,
> > > > 
> > > > If I throttle a DIO/AIO WRITE bio at block device in a cgroup, will it
> > > > lead to any kind of serialization of ext4 file system. IOW, is there any
> > > > filesystem operation which will wait for that DIO/AIO WRITE to finish
> > > > before other filesystem can make progress (fsync, journalling etc?)
> > > 
> > > Truncate?
> > > 
> > > (XFS explicitly serialises truncate against in flight DIO,
> > > regardless of whether ext4 does.)
> > > 
> > 
> > Dave,
> > 
> > Does this serialization happens against that particular inode on which
> > truncate has been called? If yes, then I think I will still be fine
> > as in common use case I am not expecting much sharing of inodes across
> > cgroups.
> 
> Dave,
> 
> I did a quick test of throttling a direct IO on one file and then
> doing "truncate -s 40 testfile" on a different file in different
> cgroup and it seems to work fine.
> 
> But I seem to be having issues with "sync". Looks like in ext4, if
> I throttle a DIO, sync does not hang but in XFS it does. I am 
> wondering if XFS is waiting for all inflight DIO to finish before
> sync completes.

"sync" on XFS seems to be livelocking as long as DIO write operation
is going on and same does not happen on ext4.

I ran "aio-stress -O aiofile1 -s 4G" and in other window I did "sync"
and it does not finish untile and unless aio-stress has finished.
On the other hand ext4 seems to be fine and it does finish earlier.

Thanks
Vivek
