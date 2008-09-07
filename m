From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: [Bug 11506] oops during unmount - ext3? (2.6.27-rc5)
Date: Sun, 7 Sep 2008 13:27:45 +0200
Message-ID: <20080907112740.GA5530@joi>
References: <20080904191356.GA7799@joi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:54793 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbYIGL2P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Sep 2008 07:28:15 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1145829fgg.17
        for <linux-ext4@vger.kernel.org>; Sun, 07 Sep 2008 04:28:13 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20080904191356.GA7799@joi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Another one:

* Deactivating swap
* Unmounting filesystems
general protection fault: 0000 [1] PREEMPT
CPU 0
Modules linked in: af_packet usbhid tuner tea5767 tda8290 tuner_xc2028 xc5000 tda9887 tuner_simple tuner_types mt20xx tea5761 tda9875 uhci_hcd ehci_hcd usbcore bttv ir_common compat_ioctl32 ac97_bus videodev v4l1_compat v4l2_common videobuf_dma_sg videobuf_core btcx_risc tveeprom i2c_viapro soundcode [last unloaded: snd_page_alloc]
Pid: 10420, comm: umount Not tainted 2.6.27-rc5 #362
RIP: 0010:[<ffffffff802f0770>] [<ffffffff802f0770>] journal_invalidatepage+0x4d/0x373
RSP: 0018:ffff88003c923c68  EFLAGS: 00010203
RAX: 0000000005200000 RBX: 1000c20d02020000 RCX: 000000000000003c
RDX: 0000000000000002 RSI: ffff88000000ff30 RDI: ffff880001001340
RBP: ffff88003c923db8 R08: ffff88003c923cd8 R09: 0000000000000001
R10: ffff880035bc37b0 R11: ffff88003a0ca828 R12: 0000000000026358
R13: 0000000000000001 R14: ffff88003cddf4f8 R15: 0000000000000001
FS:  00007f2ce7744750(0000) GS:ffffffff80623200(0000) knlGS:00000000f74d56d0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000015c70d0 CR3: 000000003cd0e000 CD4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process umount (pid: 10420, threadinfo ffff88003c922000, task ffff88003a8ca140)
Stack:  0000000000000000 ffffe20000294098 1000c20d02020000 0520000000000001
 ffff88000000ff30 ffffe20000294098 0000000000026358 0000000000000001
 0000000000026358 ffff880035bc3798 ffff88003c923cc8 ffffffff802e2da7
Call Trace:
 [<ffffffff802e2da7>] ext3_invalidatepage+0x3c/0x3e
 [<ffffffff80272ad0>] do_invalidatepage+0x28/0x2a
 [<ffffffff80272f7a>] truncate_complete_page+0x2e/0x53
 [<ffffffff8027307d>] truncate_inode_pages_range+0xde/0x36b
 [<ffffffff8027331c>] truncate_inode_pages+0x12/0x16
 [<ffffffff802a4f62>] dispose_list+0x55/0x103
 [<ffffffff802a5301>] invalidate_inodes+0xe9/0x107
 [<ffffffff802932fd>] generic_shutdown_super+0x3f/0xfd
 [<ffffffff802933d5>] kill_block_super+0x1a/0x2f
 [<ffffffff802934a6>] ? deactivate_super+0x49/0x66
 [<ffffffff802934ae>] deactivate_super+0x51/0x66
 [<ffffffff802a7e18>] mntput_no_expire+0xbf/0xf1
 [<ffffffff802a83dc>] sys_umount+0x2ba/0x30b
 [<ffffffff8020b54b>] system_call_fastpath+0x16/0x1b


Code: 8b 06 a8 01 75 04 0f 0b eb fe f6 c4 08 0f 84 2f 03 00 00 48 8b 45 b8 48 8b 40 10 c7 45 c8 01 00 00 00 48 89 45 d0 48 89 c3 31 c0 <8b> 53 20 01 c2 89 c0 48 39 45 b0 89 55 cc 48 9b 53 08 48 89 55
RIP  [<ffffffff802f0770>] journal_invalidatepage+0x4d/0x373
 RSP <ffff88003c923c68>
---[end trace fd08b13862f53eb2 ]---

I had to transcribe it from screenshots.
(They are at: http://www.kadu.net/~joi/kernel/2008.09.07/ if you want to verify it)

Output of decodecode:
/tmp/tmp.bb6hqpz9LT.o:     file format elf64-x86-64

Disassembly of section .text:

0000000000000000 <.text>:
   0:   8b 06                   mov    (%rsi),%eax
   2:   a8 01                   test   $0x1,%al
   4:   75 04                   jne    0xa
   6:   0f 0b                   ud2a
   8:   eb fe                   jmp    0x8
   a:   f6 c4 08                test   $0x8,%ah
   d:   0f 84 2f 03 00 00       je     0x342
  13:   48 8b 45 b8             mov    -0x48(%rbp),%rax
  17:   48 8b 40 10             mov    0x10(%rax),%rax
  1b:   c7 45 c8 01 00 00 00    movl   $0x1,-0x38(%rbp)
  22:   48 89 45 d0             mov    %rax,-0x30(%rbp)
  26:   48 89 c3                mov    %rax,%rbx
  29:   31 c0                   xor    %eax,%eax

/tmp/tmp.bb6hqpz9LT.o:     file format elf64-x86-64

Disassembly of section .text:

0000000000000000 <.text>:
   0:   8b 53 20                mov    0x20(%rbx),%edx
   3:   01 c2                   add    %eax,%edx
   5:   89 c0                   mov    %eax,%eax
   7:   48 39 45 b0             cmp    %rax,-0x50(%rbp)
   b:   89 55 cc                mov    %edx,-0x34(%rbp)
   e:   48                      rex.W
   f:   9b                      fwait
  10:   53                      push   %rbx
  11:   08 48 89                or     %cl,-0x77(%rax)
  14:   55                      push   %rbp
