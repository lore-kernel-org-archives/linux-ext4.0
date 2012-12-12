From: Dave Chinner <david@fromorbit.com>
Subject: Re: A huge latency in ext4 and xfs because of stable page write
Date: Wed, 12 Dec 2012 15:49:49 +1100
Message-ID: <20121212044948.GW16353@dastard>
References: <20121211084520.GA13277@gmail.com>
 <20121211111707.GU15784@dastard>
 <20121212041803.GA29427@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, hch@infradead.org,
	darrick.wong@oracle.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121212041803.GA29427@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 12, 2012 at 12:18:03PM +0800, Zheng Liu wrote:
> On Tue, Dec 11, 2012 at 10:17:07PM +1100, Dave Chinner wrote:
> > On Tue, Dec 11, 2012 at 04:45:21PM +0800, Zheng Liu wrote:
> > > Hi all,
> > > 
> > > At Tao Bao we meet a problem in our product system which causes a huge latency
> > > because of stable page write.  This problem is easy to reproduce in a testing
> > > environment, and I can reproduce it in my desktop with a SATA disk.  Here is the
> > > fio config file that is used to reproduce this problem.
> > > 
> > > config file
> > > -----------
> > > [global]
> > > iodepth=1
> > > directory=/mnt/sda3
> > > direct=0
> > > group_reporting
> > > thread
> > > fallocate=0
> > > runtime=120
> > > 
> > > [log-append]
> > > ioengine=sync
> > > rw=write
> > > bs=1k
> > 
> > Sub-page sized IO. That's guaranteed to have noticable IO latency
> > anomalies, regardless of stable data pages. If you are just
> > doing appending writes, then you can easily buffer them till you
> > have a page of data to write and avoid the problem altogether.
> 
> Hi Dave,
> 
> Thanks for your reply.  I agree with you that the application still
> could be improved.  But, unfortunately, the real life is that we cannot
> change the application.  We couldn't convince the application developers
> that they need to change their program to adapt to the latest kernel
> because the latest kernel has a new feature that is not useful for them.
> That is unacceptable for them. :-(

Too bad for them, then. The kernel can't give everyone a pony....

> > > Hence, I wonder whether or not we could revert stable page write temporarily.
> > > After it is improved, we could add it back again.
> > 
> > The plan is to turn it off for filesystems/devices that don't
> > require it. That list of devices will grow in future, so you
> > probably should plan to handle latencies in the application
> > properly...
> 
> I wonder whether we can provide a sysctl to turn on/off stable page
> write.  At least we need to give sysadmin an opportunity to control it.

That's already been considered and discarded because turning off
stable pages on devices that require it will cause validation or
data corruption problems. The discussion was for these patches (and
I think a followup series as well):

http://www.spinics.net/lists/linux-fsdevel/msg59421.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
