From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Date: Thu, 15 Aug 2013 08:09:26 -0700
Message-ID: <520CEF26.50804@intel.com>
References: <520BB9EF.5020308@linux.intel.com> <20130815002436.GI6023@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Andy Lutomirski <luto@amacapital.net>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130815002436.GI6023@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 08/14/2013 05:24 PM, Dave Chinner wrote:
> On Wed, Aug 14, 2013 at 10:10:07AM -0700, Dave Hansen wrote:
>> We talked a little about this issue in this thread:
>>
>> 	http://marc.info/?l=linux-mm&m=137573185419275&w=2
>>
>> but I figured I'd follow up with a full comparison.  ext4 is about 20%
>> slower in handling write page faults than ext3.  xfs is about 30% slower
>> than ext3.  I'm running on an 8-socket / 80-core / 160-thread system.
>> Test case is this:
>>
>> 	https://github.com/antonblanchard/will-it-scale/blob/master/tests/page_fault3.c
> 
> So, it writes a 128MB file sequentially via mmap page faults. This
> isn't a page fault benchmark, as such...

Call it what you will. :)

The other half of the benchmark (the threaded case) looks _completely_
different since it's dominated by per-mm VM structures while doing page
faults.

>>> # Baseline    Delta          Shared Object                                          Symbol
>>> # ........  .......  .....................  ..............................................
>>> #
>>>     22.04%   -4.07%  [kernel.kallsyms]      [k] page_fault                                
>>>      2.93%  +12.49%  [kernel.kallsyms]      [k] _raw_spin_lock                            
>>>      8.21%   -0.58%  page_fault3_processes  [.] testcase                                  
>>>      4.87%   -0.34%  [kernel.kallsyms]      [k] __set_page_dirty_buffers                  
>>>      4.07%   -0.58%  [kernel.kallsyms]      [k] mem_cgroup_update_page_stat               
>>>      4.10%   -0.61%  [kernel.kallsyms]      [k] __block_write_begin                       
>>>      3.69%   -0.57%  [kernel.kallsyms]      [k] find_get_page                             
>>
>> It's a bit of a bummer that things are so much less scalable on the
>> newer filesystems.
> 
> Sorry, what? What filesystems are you comparing here? XFS is
> anything but new...

As I said in the first message:
> Here's a brief snippet of the ext4->xfs 'perf diff'.  Note that things
> like page_fault() go down in the profile because we are doing _fewer_ of
> them, not because it got faster:

And, yes, I probably shouldn't be calling xfs "newer".

>> I expected xfs to do a _lot_ better than it did.
> 
> perf diff doesn't tell me anything about how you should expect the
> workload to scale.

Click on the little "Linear scaling" checkbox.  That's what I _want_ it
to do.  It's completely unscientific, but I _expected_ xfs to do better
than ext4 here.

> This workload appears to be a concurrent write workload using
> mmap(), so performance is going to be determined by filesystem
> configuration, storage capability and the CPU overhead of the
> page_mkwrite() path through the filesystem. It's not a page fault
> benchmark at all - it's simply a filesystem write bandwidth
> benchmark.
> 
> So, perhaps you could describe the storage you are using, as that
> would shed more light on your results.

The storage is a piddly little laptop disk.  If I do this on a
ramfs-hosted loopback, the things actually looks the same (or even a wee
bit worse).  The reason is that nobody is waiting on the disk to finish
any of the writeback (we're way below the dirty limits), so we're not
actually limited by the storage.

> And FWIW, it's no secret that XFS has more per-operation overhead
> than ext4 through the write path when it comes to allocation, so
> it's no surprise that on a workload that is highly dependent on
> allocation overhead that ext4 is a bit faster....

Oh, I didn't mean to be spilling secrets here or anything.  I'm
obviously not a filesystem developer and I have zero deep understanding
of what the difference in overhead of the write paths is.  It confused
me, so I reported it.
