From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 1/2] ext4: Pass in DIO_SKIP_DIO_COUNT flag if
 inode_dio_begin() called
Date: Sat, 16 Apr 2016 08:19:18 +1000
Message-ID: <20160415221918.GA21184@destitution>
References: <1460484775-33359-1-git-send-email-Waiman.Long@hpe.com>
 <1460484775-33359-2-git-send-email-Waiman.Long@hpe.com>
 <20160414031634.GJ10643@dastard>
 <570FC379.7000107@hpe.com>
 <20160415081757.GK10643@dastard>
 <57112235.1090201@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>
To: Waiman Long <waiman.long@hpe.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57112235.1090201@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Apr 15, 2016 at 01:17:41PM -0400, Waiman Long wrote:
> On 04/15/2016 04:17 AM, Dave Chinner wrote:
> >On Thu, Apr 14, 2016 at 12:21:13PM -0400, Waiman Long wrote:
> >>On 04/13/2016 11:16 PM, Dave Chinner wrote:
> >>>On Tue, Apr 12, 2016 at 02:12:54PM -0400, Waiman Long wrote:
> >>>>When performing direct I/O, the current ext4 code does
> >>>>not pass in the DIO_SKIP_DIO_COUNT flag to dax_do_io() or
> >>>>__blockdev_direct_IO() when inode_dio_begin() has, in fact, been
> >>>>called. This causes dax_do_io()/__blockdev_direct_IO() to invoke
> >>>>inode_dio_begin()/inode_dio_end() internally.  This doubling of
> >>>>inode_dio_begin()/inode_dio_end() calls are wasteful.
> >>>>
> >>>>This patch removes the extra internal inode_dio_begin()/inode_dio_end()
> >>>>calls when those calls are being issued by the caller directly. For
> >>>>really fast storage systems like NVDIMM, the removal of the extra
> >>>>inode_dio_begin()/inode_dio_end() can give a meaningful boost to
> >>>>I/O performance.
> >>>Doesn't this break truncate IO serialisation?
> >>>
> >>>i.e. it appears to me that the ext4 use of inode_dio_begin()/
> >>>inode_dio_end() does not cover AIO, where the IO is still in flight
> >>>when submission returns. i.e. the inode_dio_end() call
> >>>needs to be in IO completion, not in the submitter context. The only
> >>>reason it doesn't break right now is that the duplicate accounting
> >>>in the DIO code is correct w.r.t. AIO. Hence bypassing the DIO
> >>>accounting will cause AIO writes to race with truncate.
> >>>
> >>>Same AIO vs truncate problem occurs with the indirect read case you
> >>>modified to skip the direct IO layer accounting.
> >>I don't quite understand how the duplicate accounting is correct wrt
> >>AIO. Both the direct and indirect paths are something like:
> >>
> >>     inode_dio_begin()
> >>     ...
> >>         inode_dio_begin()
> >>         ...
> >>         inode_dio_end()
> >>     ...
> >>     inode_dio_end()
> >With AIO:
> >
> >	inode_dio_begin()
> >	...
> >		inode_dio_begin()
> >		<submit IO, no wait>
> >	...
> >	inode_dio_end()
> ><ext4 returns to userspace with AIO+DIO in progress>
> >
> ><some time later DIO completes>
> >	dio_complete
> >		  inode_dio_end()
> >
> >IOWs, the ext4 accounting is broken w.r.t. AIO, where IO submission
> >does not wait for IO completion before returning.
> >
> >>What the patch does is to eliminate the innermost
> >>inode_dio_begin/end pair.
> >Yes, and with that change inode_dio_wait() no longer waits for
> >AIO+DIO writes on ext4, hence breaking truncate IO barrier
> >requirements of inode_dio_wait().
> >
> >Cheers,
> >
> >Dave.
> 
> You are right and thank for pointing this out to me. I think I focus too
> much on the dax_do_io() internal and didn't realize that inode_dio_end() can
> be deferred in __blockdev_direct_IO(). I will update my patch to eliminate
> the extra inode_dio_begin/end pair only for dax_do_io().

Even there there is the risk that a future change will break ext4.
the ext4 code needs fixing first, then you can look at skipping the
DIO based counting everywhere.

i.e. fix the root cause of the problem, don't hack around it or
throw band-aids over it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
