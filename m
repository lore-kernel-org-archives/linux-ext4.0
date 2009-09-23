From: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [2.6.31] kernel BUG at fs/ext3/super.c:435
Date: Wed, 23 Sep 2009 12:41:11 +0200
Message-ID: <19129.64327.658046.610703@pilspetsen.it.uu.se>
References: <19127.11069.273003.421830@pilspetsen.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Mikael Pettersson <mikpe@it.uu.se>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fanny.its.uu.se ([130.238.4.241]:45008 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbZIWKrW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Sep 2009 06:47:22 -0400
In-Reply-To: <19127.11069.273003.421830@pilspetsen.it.uu.se>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mikael Pettersson writes:
 > One of my machines just oopsed in ext3_put_super()
 > during reboot after a glibc update:
 > 
 > >	if (!list_empty(&sbi->s_orphan))
 > >		dump_orphan_list(sb, sbi);
 > >	J_ASSERT(list_empty(&sbi->s_orphan));
 > 
 > Turning off swap:  
 > Turning off quotas:  quotaoff: Warning: No quota format detected in the kernel.
 > 
 > Unmounting file systems:  sb orphan head is 17
 > sb_info orphan list:
 >   inode sda2:17 at d7565a18: mode 100600, nlink 0, next 15
 >   inode sda2:15 at dd646ba0: mode 100600, nlink 0, next 0
 > kernel BUG at fs/ext3/super.c:435!

The exact same oops now happened on a different machine that
also had done a glibc rebuild + upgrade followed by a reboot:

Unmounting file systems:  sb orphan head is 14
sb_info orphan list:
  inode sda7:14 at c2621dc8: mode 100600, nlink 0, next 12
  inode sda7:12 at c2453c30: mode 100600, nlink 0, next 0
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c3bd8000
[00000000] *pgd=00000000
Internal error: Oops: 8f5 [#1]
Modules linked in: sunrpc af_packet ehci_hcd uhci_hcd ixp4xx_eth ixp4xx_npe firmware_class ixp4xx_qmgr e
CPU: 0    Not tainted  (2.6.31 #1)
PC is at ext3_put_super+0x170/0x1e0
LR is at release_console_sem+0x1b0/0x20c
pc : [<c00cb6b0>]    lr : [<c002ecd8>]    psr: 80000013
sp : c3945ec8  ip : c3945e08  fp : c3945ef4
r10: 00000000  r9 : c3945f60  r8 : 00000000
r7 : c38da484  r6 : c3adfc00  r5 : c38da3c0  r4 : c38da484
r3 : 00000000  r2 : c024ac9c  r1 : 000030a4  r0 : 00000040
Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 000039ff  Table: 03bd8000  DAC: 00000015
Process umount (pid: 21959, stack limit = 0xc3944270)
Stack: (0xc3945ec8 to 0xc3946000)
5ec0:                   00008180 00000000 00000000 c01c5164 c3adfc00 c01c5164 
5ee0: 00000000 c380ae20 c3945f0c c3945ef8 c0081aa4 c00cb54c c3402860 00000003 
5f00: c3945f24 c3945f10 c0081b58 c0081a34 c3adfc00 c024e3ec c3945f3c c3945f28 
5f20: c0082038 c0081b44 c380ae20 c3adfc00 c3945f5c c3945f40 c0094d04 c0081ffc 
5f40: c380ae18 c380ae18 c380ae20 c380ae38 c3945fa4 c3945f60 c009524c c0094ca0 
5f60: c3945f60 c3945f60 c3945f68 c3945f68 c380ae20 c15c1cb8 c002545c 00000000 
5f80: 2a008164 2a00a798 00000034 c001ffc4 c3944000 00000000 00000000 c3945fa8 
5fa0: c001fe40 c0094fb8 00000000 2a008164 2a00a798 00000001 00000001 00000274 
5fc0: 00000000 2a008164 2a00a798 00000034 2a00a1e8 2a00a788 00000000 bea5ef07 
5fe0: 00000000 bea5ea68 2a0020b4 401345cc 60000010 2a00a798 ffffffff ffffffff 
Backtrace: 
[<c00cb540>] (ext3_put_super+0x0/0x1e0) from [<c0081aa4>] (generic_shutdown_super+0x7c/0x110)
 r7:c380ae20 r6:00000000 r5:c01c5164 r4:c3adfc00
[<c0081a28>] (generic_shutdown_super+0x0/0x110) from [<c0081b58>] (kill_block_super+0x20/0x38)
 r5:00000003 r4:c3402860
[<c0081b38>] (kill_block_super+0x0/0x38) from [<c0082038>] (deactivate_super+0x48/0x60)
 r5:c024e3ec r4:c3adfc00
[<c0081ff0>] (deactivate_super+0x0/0x60) from [<c0094d04>] (mntput_no_expire+0x70/0xa8)
 r5:c3adfc00 r4:c380ae20
[<c0094c94>] (mntput_no_expire+0x0/0xa8) from [<c009524c>] (sys_umount+0x2a0/0x2d0)
 r6:c380ae38 r5:c380ae20 r4:c380ae18
[<c0094fac>] (sys_umount+0x0/0x2d0) from [<c001fe40>] (ret_fast_syscall+0x0/0x2c)

This kernel runs on a memory-constrained machine, so it has fewer
debugging features, but the oops location is the same J_ASSERT
as before.
