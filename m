From: Dave Chinner <david@fromorbit.com>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Date: Thu, 15 Aug 2013 10:24:36 +1000
Message-ID: <20130815002436.GI6023@dastard>
References: <520BB9EF.5020308@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <ak@linux.intel.com>, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	Andy Lutomirski <luto@amacapital.net>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <520BB9EF.5020308@linux.intel.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 14, 2013 at 10:10:07AM -0700, Dave Hansen wrote:
> We talked a little about this issue in this thread:
> 
> 	http://marc.info/?l=linux-mm&m=137573185419275&w=2
> 
> but I figured I'd follow up with a full comparison.  ext4 is about 20%
> slower in handling write page faults than ext3.  xfs is about 30% slower
> than ext3.  I'm running on an 8-socket / 80-core / 160-thread system.
> Test case is this:
> 
> 	https://github.com/antonblanchard/will-it-scale/blob/master/tests/page_fault3.c

So, it writes a 128MB file sequentially via mmap page faults. This
isn't a page fault benchmark, as such...

> 
> It's a little easier to look at the trends as you grow the number of
> processes:
> 
> 	http://www.sr71.net/~dave/intel/page-fault-exts/cmp.html?1=ext3&2=ext4&3=xfs&hide=linear,threads,threads_idle,processes_idle&rollPeriod=16
> 
> I recorded and diff'd some perf data (I've still got the raw data if
> anyone wants it), and the main culprit of the ext4/xfs delta looks to be
> spinlock contention (or at least bouncing) in xfs_log_commit_cil().
> This looks to be a known problem:
> 
> 	http://oss.sgi.com/archives/xfs/2013-07/msg00110.html

Yup, apparently they've been pulled into the xfsdev tree, but i
haven't seen it updated since they were pulled in so the linux-next
builds aren't picking up the fixes yet.

> Here's a brief snippet of the ext4->xfs 'perf diff'.  Note that things
> like page_fault() go down in the profile because we are doing _fewer_ of
> them, not because it got faster:
> 
> > # Baseline    Delta          Shared Object                                          Symbol
> > # ........  .......  .....................  ..............................................
> > #
> >     22.04%   -4.07%  [kernel.kallsyms]      [k] page_fault                                
> >      2.93%  +12.49%  [kernel.kallsyms]      [k] _raw_spin_lock                            
> >      8.21%   -0.58%  page_fault3_processes  [.] testcase                                  
> >      4.87%   -0.34%  [kernel.kallsyms]      [k] __set_page_dirty_buffers                  
> >      4.07%   -0.58%  [kernel.kallsyms]      [k] mem_cgroup_update_page_stat               
> >      4.10%   -0.61%  [kernel.kallsyms]      [k] __block_write_begin                       
> >      3.69%   -0.57%  [kernel.kallsyms]      [k] find_get_page                             
> 
> It's a bit of a bummer that things are so much less scalable on the
> newer filesystems.

Sorry, what? What filesystems are you comparing here? XFS is
anything but new...

> I expected xfs to do a _lot_ better than it did.

perf diff doesn't tell me anything about how you should expect the
workload to scale.

This workload appears to be a concurrent write workload using
mmap(), so performance is going to be determined by filesystem
configuration, storage capability and the CPU overhead of the
page_mkwrite() path through the filesystem. It's not a page fault
benchmark at all - it's simply a filesystem write bandwidth
benchmark.

So, perhaps you could describe the storage you are using, as that
would shed more light on your results. A good summary of what
information is useful to us is here:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

And FWIW, it's no secret that XFS has more per-operation overhead
than ext4 through the write path when it comes to allocation, so
it's no surprise that on a workload that is highly dependent on
allocation overhead that ext4 is a bit faster....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
