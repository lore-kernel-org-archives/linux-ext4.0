From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: page fault scalability (ext3, ext4, xfs)
Date: Wed, 14 Aug 2013 10:10:07 -0700
Message-ID: <520BB9EF.5020308@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>,
	david@fromorbit.com, Tim Chen <tim.c.chen@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>
Return-path: <xfs-bounces@oss.sgi.com>
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

We talked a little about this issue in this thread:

	http://marc.info/?l=linux-mm&m=137573185419275&w=2

but I figured I'd follow up with a full comparison.  ext4 is about 20%
slower in handling write page faults than ext3.  xfs is about 30% slower
than ext3.  I'm running on an 8-socket / 80-core / 160-thread system.
Test case is this:

	https://github.com/antonblanchard/will-it-scale/blob/master/tests/page_fault3.c

It's a little easier to look at the trends as you grow the number of
processes:

	http://www.sr71.net/~dave/intel/page-fault-exts/cmp.html?1=ext3&2=ext4&3=xfs&hide=linear,threads,threads_idle,processes_idle&rollPeriod=16

I recorded and diff'd some perf data (I've still got the raw data if
anyone wants it), and the main culprit of the ext4/xfs delta looks to be
spinlock contention (or at least bouncing) in xfs_log_commit_cil().
This looks to be a known problem:

	http://oss.sgi.com/archives/xfs/2013-07/msg00110.html

Here's a brief snippet of the ext4->xfs 'perf diff'.  Note that things
like page_fault() go down in the profile because we are doing _fewer_ of
them, not because it got faster:

> # Baseline    Delta          Shared Object                                          Symbol
> # ........  .......  .....................  ..............................................
> #
>     22.04%   -4.07%  [kernel.kallsyms]      [k] page_fault                                
>      2.93%  +12.49%  [kernel.kallsyms]      [k] _raw_spin_lock                            
>      8.21%   -0.58%  page_fault3_processes  [.] testcase                                  
>      4.87%   -0.34%  [kernel.kallsyms]      [k] __set_page_dirty_buffers                  
>      4.07%   -0.58%  [kernel.kallsyms]      [k] mem_cgroup_update_page_stat               
>      4.10%   -0.61%  [kernel.kallsyms]      [k] __block_write_begin                       
>      3.69%   -0.57%  [kernel.kallsyms]      [k] find_get_page                             

It's a bit of a bummer that things are so much less scalable on the
newer filesystems.  I expected xfs to do a _lot_ better than it did.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
