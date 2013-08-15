From: Dave Chinner <david@fromorbit.com>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Date: Thu, 15 Aug 2013 12:10:28 +1000
Message-ID: <20130815021028.GM6023@dastard>
References: <520BB9EF.5020308@linux.intel.com>
 <20130814194359.GA22316@thunk.org>
 <520BED7A.4000903@intel.com>
 <20130814230648.GD22316@thunk.org>
 <CALCETrVaRQ3WQ5++Uu_0JTaVnjUugAaAhqQK__7r5YWvLxpAhw@mail.gmail.com>
 <20130815011101.GA3572@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
	Andy Lutomirski <luto@amacapital.net>,
	Dave Hansen <dave.hansen@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130815011101.GA3572@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 14, 2013 at 09:11:01PM -0400, Theodore Ts'o wrote:
> On Wed, Aug 14, 2013 at 04:38:12PM -0700, Andy Lutomirski wrote:
> > > It would be better to write zeros to it, so we aren't measuring the
> > > cost of the unwritten->written conversion.
> > 
> > At the risk of beating a dead horse, how hard would it be to defer
> > this part until writeback?
> 
> Part of the work has to be done at write time because we need to
> update allocation statistics (i.e., so that we don't have ENOSPC
> problems).  The unwritten->written conversion does happen at writeback
> (as does the actual block allocation if we are doing delayed
> allocation).
> 
> The point is that if the goal is to measure page fault scalability, we
> shouldn't have this other stuff happening as the same time as the page
> fault workload.

Sure, but the real problem is not the block mapping or allocation
path - even if the test is changed to take that out of the picture,
we still have timestamp updates being done on every single page
fault. ext4, XFS and btrfs all do transactional timestamp updates
and have nanosecond granularity, so every page fault is resulting in
a transaction to update the timestamp of the file being modified.

That's why on XFS the log is showing up in the profiles.

So, even if we narrow the test down to just overwriting existing
blocks, we've still got a filesystem transaction per page fault
being done. IOWs, it's still just a filesystem overhead test....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
