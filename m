From: Theodore Tso <tytso@mit.edu>
Subject: Re: Need to potentially watch stack usage for ext4 and AIO...
Date: Sat, 20 Jun 2009 20:49:19 -0400
Message-ID: <20090621004919.GA6798@mit.edu>
References: <E1MHiN1-0002TX-Cu@closure.thunk.org> <4A3C3F64.70007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55185 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbZFUCBY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Jun 2009 22:01:24 -0400
Content-Disposition: inline
In-Reply-To: <4A3C3F64.70007@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 19, 2009 at 08:46:12PM -0500, Eric Sandeen wrote:
> if you got within 372 bytes on 32-bit (with 8k stacks) then that's
> indeed pretty worrisome.

Fortunately this was with a 4k stack, but it's still not a good thing;
the 8k stack also has to support interrupts / soft irq's, whereas the
CONFIG_4KSTACK has a separate interrupt stack....

Anyone have statistics on what the worst, most evil proprietary
SCSI/FC/10gigE driver might use in terms of stack space, combined with
say, the most evil proprietary multipath product at interrupt/softirq
time, by any chance?

In any case, here are two stack dumps that I captured, the first using
a 1k blocksize, and the second using a 4k blocksize (not that the
blocksize should make a huge amount of difference).  This time, I got
to within 200 bytes of disaster on the second stack dump.  Worse yet,
the stack usage bloat isn't in any one place, it seems to be finally
peanut-buttered across the call stack.

I can see some things we can do to optimize stack usage; for example,
struct ext4_allocation_request is allocated on the stack, and the
structure was laid out without any regard to space wastage caused by
alignment requirements.  That won't help on x86 at all, but it will
help substantially on x86_64 (since x86_64 requires that 8 byte
variables must be 8-byte aligned, where as x86_64 only requires 4 byte
alignment, even for unsigned long long's).  But it's going have to be
a whole series of incremental improvements; I don't see any magic
bullet solution to our stack usage.

       	   					- Ted


        Depth    Size   Location    (38 entries)
        -----    ----   --------
  0)     3064      48   kvm_mmu_write+0x5f/0x67
  1)     3016      16   kvm_set_pte+0x21/0x27
  2)     3000     208   __change_page_attr_set_clr+0x272/0x73b
  3)     2792      76   kernel_map_pages+0xd4/0x102
  4)     2716      80   get_page_from_freelist+0x2dd/0x3b5
  5)     2636     108   __alloc_pages_nodemask+0xf6/0x435
  6)     2528      16   alloc_slab_page+0x20/0x26
  7)     2512      60   __slab_alloc+0x171/0x470
  8)     2452       4   kmem_cache_alloc+0x8f/0x127
  9)     2448      68   radix_tree_preload+0x27/0x66
 10)     2380      56   cfq_set_request+0xf1/0x2b4
 11)     2324      16   elv_set_request+0x1c/0x2b
 12)     2308      44   get_request+0x1b0/0x25f
 13)     2264      60   get_request_wait+0x1d/0x135
 14)     2204      52   __make_request+0x24d/0x34e
 15)     2152      96   generic_make_request+0x28f/0x2d2
 16)     2056      56   submit_bio+0xb2/0xba
 17)     2000      20   submit_bh+0xe4/0x101
 18)     1980     196   ext4_mb_init_cache+0x221/0x8ad
 19)     1784     232   ext4_mb_regular_allocator+0x443/0xbda
 20)     1552      72   ext4_mb_new_blocks+0x1f6/0x46d
 21)     1480     220   ext4_ext_get_blocks+0xad9/0xc68
 22)     1260      68   ext4_get_blocks+0x10e/0x27e
 23)     1192     244   mpage_da_map_blocks+0xa7/0x720
 24)      948     108   ext4_da_writepages+0x27b/0x3d3
 25)      840      16   do_writepages+0x28/0x39
 26)      824      72   __writeback_single_inode+0x162/0x333
 27)      752      68   generic_sync_sb_inodes+0x2b6/0x426
 28)      684      20   writeback_inodes+0x8a/0xd1
 29)      664      96   balance_dirty_pages_ratelimited_nr+0x12d/0x237
 30)      568      92   generic_file_buffered_write+0x173/0x23e
 31)      476     124   __generic_file_aio_write_nolock+0x258/0x280
 32)      352      52   generic_file_aio_write+0x6e/0xc2
 33)      300      52   ext4_file_write+0xa8/0x12c
 34)      248      36   aio_rw_vect_retry+0x72/0x135
 35)      212      24   aio_run_iocb+0x69/0xfd
 36)      188     108   sys_io_submit+0x418/0x4dc
 37)       80      80   syscall_call+0x7/0xb

-------------

        Depth    Size   Location    (47 entries)
        -----    ----   --------
  0)     3556       8   kvm_clock_read+0x1b/0x1d
  1)     3548       8   sched_clock+0x8/0xb
  2)     3540      96   __lock_acquire+0x1c0/0xb21
  3)     3444      44   lock_acquire+0x94/0xb7
  4)     3400      16   _spin_lock_irqsave+0x37/0x6a
  5)     3384      28   clocksource_get_next+0x12/0x48
  6)     3356      96   update_wall_time+0x661/0x740
  7)     3260       8   do_timer+0x1b/0x22
  8)     3252      44   tick_do_update_jiffies64+0xed/0x127
  9)     3208      24   tick_sched_timer+0x47/0xa0
 10)     3184      40   __run_hrtimer+0x67/0x97
 11)     3144      56   hrtimer_interrupt+0xfe/0x151
 12)     3088      16   smp_apic_timer_interrupt+0x6f/0x82
 13)     3072      92   apic_timer_interrupt+0x2f/0x34
 14)     2980      48   kvm_mmu_write+0x5f/0x67
 15)     2932      16   kvm_set_pte+0x21/0x27
 16)     2916     208   __change_page_attr_set_clr+0x272/0x73b
 17)     2708      76   kernel_map_pages+0xd4/0x102
 18)     2632      32   free_hot_cold_page+0x74/0x1bc
 19)     2600      20   __pagevec_free+0x22/0x2a
 20)     2580     168   shrink_page_list+0x542/0x61a
 21)     2412     168   shrink_list+0x26a/0x50b
 22)     2244      96   shrink_zone+0x211/0x2a7
 23)     2148     116   try_to_free_pages+0x1db/0x2f3
 24)     2032      92   __alloc_pages_nodemask+0x2ab/0x435
 25)     1940      40   find_or_create_page+0x43/0x79
 26)     1900      84   __getblk+0x13a/0x2de
 27)     1816     164   ext4_ext_insert_extent+0x853/0xb56
 28)     1652     224   ext4_ext_get_blocks+0xb27/0xc68
 29)     1428      68   ext4_get_blocks+0x10e/0x27e
 30)     1360     244   mpage_da_map_blocks+0xa7/0x720
 31)     1116      32   __mpage_da_writepage+0x35/0x158
 32)     1084     132   write_cache_pages+0x1b1/0x293
 33)      952     112   ext4_da_writepages+0x262/0x3d3
 34)      840      16   do_writepages+0x28/0x39
 35)      824      72   __writeback_single_inode+0x162/0x333
 36)      752      68   generic_sync_sb_inodes+0x2b6/0x426
 37)      684      20   writeback_inodes+0x8a/0xd1
 38)      664      96   balance_dirty_pages_ratelimited_nr+0x12d/0x237
 39)      568      92   generic_file_buffered_write+0x173/0x23e
 40)      476     124   __generic_file_aio_write_nolock+0x258/0x280
 41)      352      52   generic_file_aio_write+0x6e/0xc2
 42)      300      52   ext4_file_write+0xa8/0x12c
 43)      248      36   aio_rw_vect_retry+0x72/0x135
 44)      212      24   aio_run_iocb+0x69/0xfd
 45)      188     108   sys_io_submit+0x418/0x4dc
 46)       80      80   syscall_call+0x7/0xb
