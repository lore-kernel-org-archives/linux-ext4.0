From: Dave Jones <davej@redhat.com>
Subject: kernel BUG at fs/ext4/inode.c:2982!
Date: Thu, 16 Oct 2014 01:57:18 -0400
Message-ID: <20141016055718.GA17655@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Just hit this on Linus' current tree while running my fuzz-tester.
(No logs unfortunatly, so no idea what actually happened).

kernel BUG at fs/ext4/inode.c:2982!
invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
Modules linked in: hidp rfcomm af_key llc2 can_bcm sctp libcrc32c can_raw nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 p8022 psnap llc ax25 nouveau cfg80211 rfkill kvm_intel kvm video backlight mxm_wmi wmi i2c_algo_bit drm_kms_helper ttm drm microcode tg3 serio_raw pcspkr ptp pps_core libphy i2c_core lpc_ich mfd_core rtc_cmos shpchp nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc raid0 floppy
CPU: 3 PID: 24261 Comm: trinity-c10 Not tainted 3.17.0+ #5 
Hardware name: Dell Inc.                 Precision WorkStation 490    /0DT031, BIOS A08 04/25/2008
task: ffff8802094ccb40 ti: ffff8800bc168000 task.ti: ffff8800bc168000
RIP: 0010:[<ffffffff9a27cf83>]  [<ffffffff9a27cf83>] ext4_direct_IO+0x713/0x750
RSP: 0018:ffff8800bc16ba78  EFLAGS: 00010246
RAX: 0000000000020000 RBX: 0000000000000001 RCX: 000000000000000f
RDX: 0000000000000008 RSI: ffff880033e368d0 RDI: ffff8802094cd3b8
RBP: ffff8800bc16baf8 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: ffff8800bc16bd40
R13: ffff880033e368d0 R14: ffff8800bc16bb30 R15: 000000000000001f
FS:  00007f8cc4e8f740(0000) GS:ffff880226400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000001 CR3: 00000000b7747000 CR4: 00000000000007e0
DR0: 0000000001c16000 DR1: 000000000160a000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Stack:
 ffffea000560a600 ffffea00060dc480 ffffea000503d880 ffffea0005cbfc80
 ffffea00056e6500 ffffea00049b1780 ffff880033e368d0 ffffea0005da7980
 0000000000010000 0000000000010000 ffff8800bc16baf8 ffff880033e36ae0
Call Trace:
 [<ffffffff9a1838d9>] generic_file_direct_write+0xa9/0x170
 [<ffffffff9a183c4c>] __generic_file_write_iter+0x2ac/0x350
 [<ffffffff9a275df9>] ext4_file_write_iter+0x109/0x3f0
 [<ffffffff9a1d8adc>] ? __kmalloc+0x39c/0x420
 [<ffffffff9a0a89e8>] ? sched_clock_cpu+0xa8/0xd0
 [<ffffffff9a227881>] ? iter_file_splice_write+0x91/0x450
 [<ffffffff9a0a8a66>] ? local_clock+0x16/0x30
 [<ffffffff9a227a53>] iter_file_splice_write+0x263/0x450
 [<ffffffff9a226d06>] direct_splice_actor+0x36/0x40
 [<ffffffff9a2272d3>] splice_direct_to_actor+0xc3/0x1f0
 [<ffffffff9a226cd0>] ? generic_pipe_buf_nosteal+0x10/0x10
 [<ffffffff9a229032>] do_splice_direct+0x82/0xb0
 [<ffffffff9a1f454f>] do_sendfile+0x1af/0x3a0
 [<ffffffff9a1f533a>] SyS_sendfile64+0x8a/0xa0
 [<ffffffff9a6ea82a>] ? tracesys_phase2+0x75/0xd9
 [<ffffffff9a6ea889>] tracesys_phase2+0xd4/0xd9
Code: e8 83 57 e4 ff 85 c0 0f 85 a0 fc ff ff e9 47 ff ff ff 48 c7 c7 e0 f4 c3 9a e8 6a 57 e4 ff 85 c0 0f 85 e7 fc ff ff e9 6c ff ff ff <0f> 0b be fe 0b 00 00 48 c7 c7 f9 4d a2 9a e8 7a 3b df ff e9 c8 
RIP  [<ffffffff9a27cf83>] ext4_direct_IO+0x713/0x750
 RSP <ffff8800bc16ba78>
---[ end trace d80209ec68bf10b8 ]---


That BUG_ON is..

2982         BUG_ON(iocb->private == NULL);

I'll try and reproduce it in the morning.

	Dave
