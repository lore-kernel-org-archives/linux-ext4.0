From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Need to potentially watch stack usage for ext4 and AIO...
Date: Wed, 24 Jun 2009 11:15:56 -0500
Message-ID: <4A42513C.6020607@redhat.com>
References: <E1MHiN1-0002TX-Cu@closure.thunk.org> <4A3C3F64.70007@redhat.com> <20090621004919.GA6798@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50303 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759007AbZFXQP4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Jun 2009 12:15:56 -0400
In-Reply-To: <20090621004919.GA6798@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Fri, Jun 19, 2009 at 08:46:12PM -0500, Eric Sandeen wrote:
>> if you got within 372 bytes on 32-bit (with 8k stacks) then that's
>> indeed pretty worrisome.
> 
> Fortunately this was with a 4k stack, but it's still not a good thing;
> the 8k stack also has to support interrupts / soft irq's, whereas the
> CONFIG_4KSTACK has a separate interrupt stack....

Hm I thought we had irq stacks for both but I guess not.

FWIW F11 has gone to 8k stacks ( \o/ )

> Anyone have statistics on what the worst, most evil proprietary
> SCSI/FC/10gigE driver might use in terms of stack space, combined with
> say, the most evil proprietary multipath product at interrupt/softirq
> time, by any chance?

well I'm inclined to ignore the proprietary stuff TBH, we can't control it.

> In any case, here are two stack dumps that I captured, the first using
> a 1k blocksize, and the second using a 4k blocksize (not that the
> blocksize should make a huge amount of difference).  This time, I got
> to within 200 bytes of disaster on the second stack dump.  Worse yet,
> the stack usage bloat isn't in any one place, it seems to be finally
> peanut-buttered across the call stack.
> 
> I can see some things we can do to optimize stack usage; for example,
> struct ext4_allocation_request is allocated on the stack, and the
> structure was laid out without any regard to space wastage caused by
> alignment requirements.  That won't help on x86 at all, but it will
> help substantially on x86_64 (since x86_64 requires that 8 byte
> variables must be 8-byte aligned, where as x86_64 only requires 4 byte
> alignment, even for unsigned long long's).  But it's going have to be
> a whole series of incremental improvements; I don't see any magic
> bullet solution to our stack usage.

XFS forces gcc to not inline any static function; it's extreme, but
maybe it'd help here too.

>        	   					- Ted
> 
> 
>         Depth    Size   Location    (38 entries)
>         -----    ----   --------
>   0)     3064      48   kvm_mmu_write+0x5f/0x67
>   1)     3016      16   kvm_set_pte+0x21/0x27
>   2)     3000     208   __change_page_attr_set_clr+0x272/0x73b

This looks like a victim of inlining

>   3)     2792      76   kernel_map_pages+0xd4/0x102
>   4)     2716      80   get_page_from_freelist+0x2dd/0x3b5
>   5)     2636     108   __alloc_pages_nodemask+0xf6/0x435
>   6)     2528      16   alloc_slab_page+0x20/0x26
>   7)     2512      60   __slab_alloc+0x171/0x470
>   8)     2452       4   kmem_cache_alloc+0x8f/0x127
>   9)     2448      68   radix_tree_preload+0x27/0x66
>  10)     2380      56   cfq_set_request+0xf1/0x2b4
>  11)     2324      16   elv_set_request+0x1c/0x2b
>  12)     2308      44   get_request+0x1b0/0x25f
>  13)     2264      60   get_request_wait+0x1d/0x135
>  14)     2204      52   __make_request+0x24d/0x34e
>  15)     2152      96   generic_make_request+0x28f/0x2d2
>  16)     2056      56   submit_bio+0xb2/0xba
>  17)     2000      20   submit_bh+0xe4/0x101
>  18)     1980     196   ext4_mb_init_cache+0x221/0x8ad

nothing obvious here, maybe inlining

>  19)     1784     232   ext4_mb_regular_allocator+0x443/0xbda

ditto

>  20)     1552      72   ext4_mb_new_blocks+0x1f6/0x46d
>  21)     1480     220   ext4_ext_get_blocks+0xad9/0xc68

ext4_allocation_request is largeish & holey as you said:

struct ext4_allocation_request {
	struct inode *             inode;              /*     0     8 */
	ext4_lblk_t                logical;            /*     8     4 */

	/* XXX 4 bytes hole, try to pack */

	ext4_fsblk_t               goal;               /*    16     8 */
	ext4_lblk_t                lleft;              /*    24     4 */

	/* XXX 4 bytes hole, try to pack */

	ext4_fsblk_t               pleft;              /*    32     8 */
	ext4_lblk_t                lright;             /*    40     4 */

	/* XXX 4 bytes hole, try to pack */

	ext4_fsblk_t               pright;             /*    48     8 */
	unsigned int               len;                /*    56     4 */
	unsigned int               flags;              /*    60     4 */
	/* --- cacheline 1 boundary (64 bytes) --- */

	/* size: 64, cachelines: 1, members: 9 */
	/* sum members: 52, holes: 3, sum holes: 12 */
};



>  22)     1260      68   ext4_get_blocks+0x10e/0x27e
>  23)     1192     244   mpage_da_map_blocks+0xa7/0x720

struct buffer_head new on the stack hurts here, it's 104 bytes.

I really dislike the whole abuse of buffer heads as handy containers for
mapping, we don't need all these fields, I think, but that's a battle
for another day.

>  24)      948     108   ext4_da_writepages+0x27b/0x3d3
>  25)      840      16   do_writepages+0x28/0x39
>  26)      824      72   __writeback_single_inode+0x162/0x333
>  27)      752      68   generic_sync_sb_inodes+0x2b6/0x426
>  28)      684      20   writeback_inodes+0x8a/0xd1
>  29)      664      96   balance_dirty_pages_ratelimited_nr+0x12d/0x237
>  30)      568      92   generic_file_buffered_write+0x173/0x23e
>  31)      476     124   __generic_file_aio_write_nolock+0x258/0x280
>  32)      352      52   generic_file_aio_write+0x6e/0xc2
>  33)      300      52   ext4_file_write+0xa8/0x12c
>  34)      248      36   aio_rw_vect_retry+0x72/0x135
>  35)      212      24   aio_run_iocb+0x69/0xfd
>  36)      188     108   sys_io_submit+0x418/0x4dc
>  37)       80      80   syscall_call+0x7/0xb

<snip>

-Eric
