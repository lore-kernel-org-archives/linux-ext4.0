From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Oops with ext(3|4) and audit and Xen
Date: Mon, 08 Oct 2012 14:08:02 -0500
Message-ID: <50732492.4040705@redhat.com>
References: <CALnj_=5eQ5vCmv8x3u-rJPzofqJr+WDJuYzkpZo8sLe0+B2AAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Peter Moody <pmoody@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab2JHTIE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Oct 2012 15:08:04 -0400
In-Reply-To: <CALnj_=5eQ5vCmv8x3u-rJPzofqJr+WDJuYzkpZo8sLe0+B2AAw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/8/12 1:19 PM, Peter Moody wrote:
> Hey folks,
> 
> I'm trying to track down a BUG() that seems to strike a particular
> system configuration (unfortunately, an increasingly common
> configuration), but does so with 100% reliability.
> 
> The system in question is a Xen instance (6 vcpus, 32G memory) running
> 3.2 on essentially stock ubuntu (10.04) system.
> 
> if I run the attached program with the crash dir set to any ext3 or
> ext4 file system with any audit rules installed, I get an oops on the
> second time through the while loop:
> 
> kernel BUG at fs/buffer.c:1267!
> invalid opcode: 0000 [#1] SMP
> CPU 1
> Pid: 4146, comm: a.out Not tainted 3.2.5-will-break-2-ganetixenu #4
> RIP: e030:[<ffffffff81696a6c>]  [<ffffffff81696a6c>] check_irqs_on.part
> .10+0x17/0x19
> RSP: e02b:ffff8807c7339bf8  EFLAGS: 00010096
> RAX: 000000000000001e RBX: ffff8807970840b0 RCX: 00000000000000e7
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
> RBP: ffff8807c7339bf8 R08: 0000000000000000 R09: 0000000000000018
> R10: 0000000000006a5d R11: 0000000000000001 R12: 0000000000000400
> R13: ffff8807dee05040 R14: ffff8807c7339dc0 R15: 0000000000000124
> FS:  00007fe7cde057c0(0000) GS:ffff8807fff44000(0063) knlGS:00000000000
> 00000
> CS:  e033 DS: 002b ES: 002b CR0: 000000008005003b
> CR2: 00000000f76dc4b0 CR3: 00000007a769a000 CR4: 0000000000002660
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process a.out (pid: 4146, threadinfo ffff8807c7338000, task ffff8807ab3
> 496b0)
> Stack:
>  ffff8807c7339c68 ffffffff81161dc9 ffff8807c7339c90 ffff8807b6b909f0
>  ffff8807ab23901a ffff8807c7339d60 ffff880700000000 ffff8807c7339d30
>  ffff8807c7339d60 ffff8807c7339e78 ffff8807970840b0 0000000000000400
> Call Trace:
>  [<ffffffff81161dc9>] __find_get_block+0x1f9/0x200
>  [<ffffffff81164c8f>] __getblk+0x1f/0x280
>  [<ffffffff811f35bb>] __ext4_get_inode_loc+0x10b/0x410
>  [<ffffffff81124935>] ? kmem_cache_alloc+0xa5/0x150
>  [<ffffffff811f9857>] ? ext4_evict_inode+0x177/0x450
>  [<ffffffff811f4cc7>] ext4_get_inode_loc+0x17/0x20
>  [<ffffffff811f75a8>] ext4_reserve_inode_write+0x28/0xa0
>  [<ffffffff811f9815>] ? ext4_evict_inode+0x135/0x450
>  [<ffffffff811f7673>] ext4_mark_inode_dirty+0x53/0x200
>  [<ffffffff811f9857>] ext4_evict_inode+0x177/0x450
>  [<ffffffff8114bfb1>] evict+0xa1/0x1a0
>  [<ffffffff8114cc61>] iput+0x101/0x210
>  [<ffffffff81148040>] d_kill+0xf0/0x130
>  [<ffffffff81148bd2>] dput+0xd2/0x1b0
>  [<ffffffff8113eb85>] path_put+0x15/0x30
>  [<ffffffff81693e39>] audit_free_names+0x96/0xb5
>  [<ffffffff810ac629>] audit_syscall_exit+0x139/0x1e0
>  [<ffffffff816a076a>] sysexit_audit+0x21/0x5f
> Code: 5c 48 89 df e8 b6 20 ab ff 5b 41 5c 5d c3 55 48 89 e5 0f 0b 55 be
>  08 00 00 00 48 c7 c7 c4 fe a0 81 31 c0 48 89 e5 e8 91 cb ff ff <0f>
> 0b 55 48 89 e5 0f
>  0b 55 48 89 e5 0f 0b 55 48 89 e5 0f 0b 55
> RIP  [<ffffffff81696a6c>] check_irqs_on.part.10+0x17/0x19
>  RSP <ffff8807c7339bf8>
> 
> line 1267 of fs/buffer.c is
> 
> static inline void check_irqs_on(void)
> {
> #ifdef irqs_disabled
> 	BUG_ON(irqs_disabled());
> #endif
> }
> 
> If I run the same code on the same system with the same audit rule(s)
> on an ext2 filesystem, I get no such oops.
> 
> So it seems like something either in the ext3/ext4 or Xen codepath is
> disabling interrupts. I'm getting an updated test Xen instance to test
> on, but I while I'm waiting on that, I wanted to see if anyone one
> here might have an idea of the ext3/4 codepath. whether something
> there is doing the interrupt disabling or if there might be some other
> race condition going on. I haven't had a chance to test with the large
> "ext4 updates for v3.7" tytso recently posted, but I'll be doing that
> later today in case something there fixes this.
> 
> So, does any one have any thoughts and/or pointers which might help me
> get to the bottom of this?

I had suggested this on the other list, but will put it here too, though it
might be a long shot.  If threadinfo gets corrupted, the irqs_enabled()
test might give the wrong answer.

Peter also mentioned that he had tried putting WARN_ON(irqs_disabled()) at
various places along the stack above and never got it to trip; until after
the BUG_ON() had fired; this makes me think corruption might be a possibility
after all.

I suggested building with CONFIG_DEBUG_STACK_USAGE and watching
for stack messages, and building with CONFIG_STACK_TRACER on, and then:

# mount -t debugfs none /sys/kernel/debug
# echo 1 > /proc/sys/kernel/stack_tracer_enabled
# <run your test w/o the panic, get the BUG_ON>
# cat /sys/kernel/debug/tracing/stack_trace

to try to rule that out.

-Eric

> Cheers,
> peter
> 

