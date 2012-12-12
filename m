From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: A huge latency in ext4 and xfs because of stable page write
Date: Wed, 12 Dec 2012 12:18:03 +0800
Message-ID: <20121212041803.GA29427@gmail.com>
References: <20121211084520.GA13277@gmail.com> <20121211111707.GU15784@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, darrick.wong@oracle.com, xfs@oss.sgi.com, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20121211111707.GU15784@dastard>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 11, 2012 at 10:17:07PM +1100, Dave Chinner wrote:
> On Tue, Dec 11, 2012 at 04:45:21PM +0800, Zheng Liu wrote:
> > Hi all,
> > 
> > At Tao Bao we meet a problem in our product system which causes a huge latency
> > because of stable page write.  This problem is easy to reproduce in a testing
> > environment, and I can reproduce it in my desktop with a SATA disk.  Here is the
> > fio config file that is used to reproduce this problem.
> > 
> > config file
> > -----------
> > [global]
> > iodepth=1
> > directory=/mnt/sda3
> > direct=0
> > group_reporting
> > thread
> > fallocate=0
> > runtime=120
> > 
> > [log-append]
> > ioengine=sync
> > rw=write
> > bs=1k
> 
> Sub-page sized IO. That's guaranteed to have noticable IO latency
> anomalies, regardless of stable data pages. If you are just
> doing appending writes, then you can easily buffer them till you
> have a page of data to write and avoid the problem altogether.

Hi Dave,

Thanks for your reply.  I agree with you that the application still
could be improved.  But, unfortunately, the real life is that we cannot
change the application.  We couldn't convince the application developers
that they need to change their program to adapt to the latest kernel
because the latest kernel has a new feature that is not useful for them.
That is unacceptable for them. :-(

> 
> > Hence, I wonder whether or not we could revert stable page write temporarily.
> > After it is improved, we could add it back again.
> 
> The plan is to turn it off for filesystems/devices that don't
> require it. That list of devices will grow in future, so you
> probably should plan to handle latencies in the application
> properly...

I wonder whether we can provide a sysctl to turn on/off stable page
write.  At least we need to give sysadmin an opportunity to control it.

Regards,
                                                - Zheng

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
