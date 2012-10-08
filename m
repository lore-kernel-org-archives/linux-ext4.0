From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Oops with ext(3|4) and audit and Xen
Date: Mon, 08 Oct 2012 16:41:51 -0500
Message-ID: <5073489F.3010401@redhat.com>
References: <CALnj_=5eQ5vCmv8x3u-rJPzofqJr+WDJuYzkpZo8sLe0+B2AAw@mail.gmail.com> <50732492.4040705@redhat.com> <CALnj_=7kcNKox0qEO+n74KDEHBfz74pAmg-KOp+TRakNNCoW5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Peter Moody <pmoody@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab2JHVly (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Oct 2012 17:41:54 -0400
In-Reply-To: <CALnj_=7kcNKox0qEO+n74KDEHBfz74pAmg-KOp+TRakNNCoW5Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/8/12 4:03 PM, Peter Moody wrote:
> On Mon, Oct 8, 2012 at 12:08 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>> On 10/8/12 1:19 PM, Peter Moody wrote:
>>> Hey folks,
>>>
>>> I'm trying to track down a BUG() that seems to strike a particular
>>> system configuration (unfortunately, an increasingly common
>>> configuration), but does so with 100% reliability.
>>>
>>> The system in question is a Xen instance (6 vcpus, 32G memory) running
>>> 3.2 on essentially stock ubuntu (10.04) system.
>>>
>>> if I run the attached program with the crash dir set to any ext3 or
>>> ext4 file system with any audit rules installed, I get an oops on the
>>> second time through the while loop:
>>>
>>> kernel BUG at fs/buffer.c:1267!
>>> invalid opcode: 0000 [#1] SMP
>>> CPU 1
>>> Pid: 4146, comm: a.out Not tainted 3.2.5-will-break-2-ganetixenu #4
>>> RIP: e030:[<ffffffff81696a6c>]  [<ffffffff81696a6c>] check_irqs_on.part
>>> .10+0x17/0x19
>>> RSP: e02b:ffff8807c7339bf8  EFLAGS: 00010096
>>> RAX: 000000000000001e RBX: ffff8807970840b0 RCX: 00000000000000e7
>>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
>>> RBP: ffff8807c7339bf8 R08: 0000000000000000 R09: 0000000000000018
>>> R10: 0000000000006a5d R11: 0000000000000001 R12: 0000000000000400
>>> R13: ffff8807dee05040 R14: ffff8807c7339dc0 R15: 0000000000000124
>>> FS:  00007fe7cde057c0(0000) GS:ffff8807fff44000(0063) knlGS:00000000000
>>> 00000
>>> CS:  e033 DS: 002b ES: 002b CR0: 000000008005003b
>>> CR2: 00000000f76dc4b0 CR3: 00000007a769a000 CR4: 0000000000002660
>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> Process a.out (pid: 4146, threadinfo ffff8807c7338000, task ffff8807ab3
>>> 496b0)
>>> Stack:
>>>  ffff8807c7339c68 ffffffff81161dc9 ffff8807c7339c90 ffff8807b6b909f0
>>>  ffff8807ab23901a ffff8807c7339d60 ffff880700000000 ffff8807c7339d30
>>>  ffff8807c7339d60 ffff8807c7339e78 ffff8807970840b0 0000000000000400
>>> Call Trace:
>>>  [<ffffffff81161dc9>] __find_get_block+0x1f9/0x200
>>>  [<ffffffff81164c8f>] __getblk+0x1f/0x280
>>>  [<ffffffff811f35bb>] __ext4_get_inode_loc+0x10b/0x410
>>>  [<ffffffff81124935>] ? kmem_cache_alloc+0xa5/0x150
>>>  [<ffffffff811f9857>] ? ext4_evict_inode+0x177/0x450
>>>  [<ffffffff811f4cc7>] ext4_get_inode_loc+0x17/0x20
>>>  [<ffffffff811f75a8>] ext4_reserve_inode_write+0x28/0xa0
>>>  [<ffffffff811f9815>] ? ext4_evict_inode+0x135/0x450
>>>  [<ffffffff811f7673>] ext4_mark_inode_dirty+0x53/0x200
>>>  [<ffffffff811f9857>] ext4_evict_inode+0x177/0x450
>>>  [<ffffffff8114bfb1>] evict+0xa1/0x1a0
>>>  [<ffffffff8114cc61>] iput+0x101/0x210
>>>  [<ffffffff81148040>] d_kill+0xf0/0x130
>>>  [<ffffffff81148bd2>] dput+0xd2/0x1b0
>>>  [<ffffffff8113eb85>] path_put+0x15/0x30
>>>  [<ffffffff81693e39>] audit_free_names+0x96/0xb5
>>>  [<ffffffff810ac629>] audit_syscall_exit+0x139/0x1e0
>>>  [<ffffffff816a076a>] sysexit_audit+0x21/0x5f
>>> Code: 5c 48 89 df e8 b6 20 ab ff 5b 41 5c 5d c3 55 48 89 e5 0f 0b 55 be
>>>  08 00 00 00 48 c7 c7 c4 fe a0 81 31 c0 48 89 e5 e8 91 cb ff ff <0f>
>>> 0b 55 48 89 e5 0f
>>>  0b 55 48 89 e5 0f 0b 55 48 89 e5 0f 0b 55
>>> RIP  [<ffffffff81696a6c>] check_irqs_on.part.10+0x17/0x19
>>>  RSP <ffff8807c7339bf8>
>>>
>>> line 1267 of fs/buffer.c is
>>>
>>> static inline void check_irqs_on(void)
>>> {
>>> #ifdef irqs_disabled
>>>       BUG_ON(irqs_disabled());
>>> #endif
>>> }
>>>
>>> If I run the same code on the same system with the same audit rule(s)
>>> on an ext2 filesystem, I get no such oops.
>>>
>>> So it seems like something either in the ext3/ext4 or Xen codepath is
>>> disabling interrupts. I'm getting an updated test Xen instance to test
>>> on, but I while I'm waiting on that, I wanted to see if anyone one
>>> here might have an idea of the ext3/4 codepath. whether something
>>> there is doing the interrupt disabling or if there might be some other
>>> race condition going on. I haven't had a chance to test with the large
>>> "ext4 updates for v3.7" tytso recently posted, but I'll be doing that
>>> later today in case something there fixes this.
>>>
>>> So, does any one have any thoughts and/or pointers which might help me
>>> get to the bottom of this?
>>
>> I had suggested this on the other list, but will put it here too, though it
>> might be a long shot.  If threadinfo gets corrupted, the irqs_enabled()
>> test might give the wrong answer.
>>
>> Peter also mentioned that he had tried putting WARN_ON(irqs_disabled()) at
>> various places along the stack above and never got it to trip; until after
>> the BUG_ON() had fired; this makes me think corruption might be a possibility
>> after all.
>>
>> I suggested building with CONFIG_DEBUG_STACK_USAGE and watching
>> for stack messages, and building with CONFIG_STACK_TRACER on, and then:
>>
>> # mount -t debugfs none /sys/kernel/debug
>> # echo 1 > /proc/sys/kernel/stack_tracer_enabled
>> # <run your test w/o the panic, get the BUG_ON>
>> # cat /sys/kernel/debug/tracing/stack_trace
>>
>> to try to rule that out.
> 
> This is what I get. I'm not sure how to interpret this output:
> 
>         Depth    Size   Location    (31 entries)
>         -----    ----   --------
>   0)     3792     272   load_balance+0xaf/0x890

so it only got 3792 bytes into the (8k) stack, not bad at all I guess.
More than one way to corrupt a threadinfo but I guess this wasn't it.

-Eric

>   1)     3520     144   __schedule+0x7ee/0x870
>   2)     3376      16   schedule+0x3f/0x60
>   3)     3360      32   io_schedule+0x8f/0xd0
>   4)     3328      16   sleep_on_buffer+0xe/0x20
>   5)     3312      80   __wait_on_bit+0x5f/0x90
>   6)     3232     112   out_of_line_wait_on_bit+0x7c/0x90
>   7)     3120      16   __wait_on_buffer+0x2e/0x30
>   8)     3104      32   __bread+0x71/0xb0
>   9)     3072      96   ext3_get_branch+0x8b/0x150
>  10)     2976     384   ext3_get_blocks_handle+0xd2/0xe00
>  11)     2592      80   ext3_get_block+0xc4/0x120
>  12)     2512     208   do_mpage_readpage+0x3a2/0x5a0
>  13)     2304     272   mpage_readpages+0xee/0x140
>  14)     2032      16   ext3_readpages+0x1d/0x20
>  15)     2016     192   __do_page_cache_readahead+0x1af/0x250
>  16)     1824      16   ra_submit+0x21/0x30
>  17)     1808     112   filemap_fault+0x261/0x4a0
>  18)     1696     160   __do_fault+0x6f/0x500
>  19)     1536     208   handle_pte_fault+0xf7/0xac0
>  20)     1328      80   handle_mm_fault+0x164/0x260
>  21)     1248     272   do_page_fault+0x144/0x460
>  22)      976     208   page_fault+0x25/0x30
>  23)      768      16   clear_user+0x36/0x40
>  24)      752      16   padzero+0x2d/0x40
>  25)      736     304   load_elf_binary+0xa7f/0x1a10
>  26)      432      80   search_binary_handler+0xc8/0x1b0
>  27)      352     112   do_execve_common.isra.25+0x2b1/0x350
>  28)      240      16   do_execve+0x1b/0x20
>  29)      224      48   sys_execve+0x47/0x70
>  30)      176     176   stub_execve+0x6c/0xc0
> 
> and for good measure, here's the BUG() notice.
> 
> kernel BUG at fs/buffer.c:1265!
> invalid opcode: 0000 [#1] SMP
> CPU 1
> Pid: 3810, comm: a.out Not tainted 3.2.5-at20-ganetixenu #7
> RIP: e030:[<ffffffff816bd776>]  [<ffffffff816bd776>]
> check_irqs_on.part.9+0x9/0xb
> RSP: e02b:ffff8807aca81bf8  EFLAGS: 00010096
> RAX: ffff8807c7400000 RBX: ffff8807acf1c420 RCX: 0000000000000123
> RDX: 0000000000000400 RSI: 0000000000000124 RDI: ffff8807c9dec000
> RBP: ffff8807aca81bf8 R08: ffff8807c7401000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000400
> R13: ffff8807c9dec000 R14: ffff8807aca81dc0 R15: 0000000000000124
> FS:  00007f528f9df700(0000) GS:ffff8807fff44000(0063) knlGS:0000000000000000
> CS:  e033 DS: 002b ES: 002b CR0: 000000008005003b
> CR2: 00000000f76c14b0 CR3: 00000007a96d9000 CR4: 0000000000002660
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process a.out (pid: 3810, threadinfo ffff8807aca80000, task ffff8807acb42da0)
> Stack:
>  ffff8807aca81c68 ffffffff81170ed9 ffff8807acf1c420 ffff8807acf1c420
>  ffff8807c7402000 ffff8807aca81dc0 ffff8807aca81cc8 ffffffff816c5316
>  ffff8807c7401000 0000000000000123 ffff8807acf1c420 0000000000000400
> Call Trace:
>  [<ffffffff81170ed9>] __find_get_block+0x209/0x210
>  [<ffffffff816c5316>] ? ftrace_call+0x5/0x2b
>  [<ffffffff81173e64>] __getblk+0x24/0x280
>  [<ffffffff816c5316>] ? ftrace_call+0x5/0x2b
>  [<ffffffff81204b63>] __ext4_get_inode_loc+0x113/0x420
>  [<ffffffff8120af4f>] ? ext4_evict_inode+0x17f/0x450
>  [<ffffffff812062ac>] ext4_get_inode_loc+0x1c/0x20
>  [<ffffffff81208c5d>] ext4_reserve_inode_write+0x2d/0xa0
>  [<ffffffff81208d28>] ext4_mark_inode_dirty+0x58/0x210
>  [<ffffffff8120af4f>] ext4_evict_inode+0x17f/0x450
>  [<ffffffff8115a826>] evict+0xa6/0x1b0
>  [<ffffffff8115b521>] iput+0x101/0x210
>  [<ffffffff81156768>] d_kill+0xf8/0x130
>  [<ffffffff816baa34>] ? audit_free_names+0x6a/0xba
>  [<ffffffff8115732a>] dput+0xda/0x1b0
>  [<ffffffff8114d15a>] path_put+0x1a/0x30
>  [<ffffffff816baa65>] audit_free_names+0x9b/0xba
>  [<ffffffff810b09be>] audit_syscall_exit+0x13e/0x1e0
>  [<ffffffff816c7aea>] sysexit_audit+0x21/0x5f
> Code: ff ff 48 85 db 74 0b fe 43 5c 48 89 df e8 f3 9a a9 ff 5b 41 5c
> 5d c3 55 48 89 e5 e8 65 7b 00
> 00 0f 0b 55 48 89 e5 e8 5a 7b 00 00 <0f> 0b 55 48 89 e5 e8 4f 7b 00 00
> 0f 0b 55 48 89 e5 e8 44 7b 00
> RIP  [<ffffffff816bd776>] check_irqs_on.part.9+0x9/0xb
>  RSP <ffff8807aca81bf8>
> 
>> -Eric
>>
>>> Cheers,
>>> peter
>>>
>>
> 
> 
> 

