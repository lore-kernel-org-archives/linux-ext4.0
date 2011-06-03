From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Query about DIO/AIO WRITE throttling and ext4 serialization
Date: Thu, 2 Jun 2011 20:27:14 -0400
Message-ID: <20110603002714.GA27129@redhat.com>
References: <20110601215049.GC17449@redhat.com>
 <20110602012209.GQ561@dastard>
 <20110602141716.GD18712@redhat.com>
 <20110602143633.GE18712@redhat.com>
 <20110602155610.GF18712@redhat.com>
 <20110602235153.GV561@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881Ab1FCA1X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Jun 2011 20:27:23 -0400
Content-Disposition: inline
In-Reply-To: <20110602235153.GV561@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 03, 2011 at 09:51:53AM +1000, Dave Chinner wrote:

[..]
> > > Dave,
> > > 
> > > I did a quick test of throttling a direct IO on one file and then
> > > doing "truncate -s 40 testfile" on a different file in different
> > > cgroup and it seems to work fine.
> > > 
> > > But I seem to be having issues with "sync". Looks like in ext4, if
> > > I throttle a DIO, sync does not hang but in XFS it does. I am 
> > > wondering if XFS is waiting for all inflight DIO to finish before
> > > sync completes.
> > 
> > "sync" on XFS seems to be livelocking as long as DIO write operation
> > is going on and same does not happen on ext4.
> > 
> > I ran "aio-stress -O aiofile1 -s 4G" and in other window I did "sync"
> > and it does not finish untile and unless aio-stress has finished.
> > On the other hand ext4 seems to be fine and it does finish earlier.
> 
> On XFS sync waits for the IO count on each inode to return to zero
> before continuing.  If you are blasting concurrent AIO/DIO at a
> file, then it is possible that the IO count never falls to zero.
> It's questionable whether this is necessary, but ISTR that the
> current behaviour has been there for a long time (though morphed
> about a bit in implementation).

In this case only a single thread is doing IO continuously. I am assuming
if there is a database using XFS, it is not unreasonable to have prolonged
periods of continuous IO activity. In that case I think by above design
sync will not finish until and unless there is a momentary pause in IO. This
does not sound like the best design choice.

Thanks
Vivek
