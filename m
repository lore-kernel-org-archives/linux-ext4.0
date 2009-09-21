From: Mikael Pettersson <mikpe@it.uu.se>
Subject: [2.6.31] kernel BUG at fs/ext3/super.c:435
Date: Mon, 21 Sep 2009 09:29:01 +0200
Message-ID: <19127.11069.273003.421830@pilspetsen.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754537AbZIUH3G@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

One of my machines just oopsed in ext3_put_super()
during reboot after a glibc update:

>	if (!list_empty(&sbi->s_orphan))
>		dump_orphan_list(sb, sbi);
>	J_ASSERT(list_empty(&sbi->s_orphan));

Turning off swap:  
Turning off quotas:  quotaoff: Warning: No quota format detected in the kernel.

Unmounting file systems:  sb orphan head is 17
sb_info orphan list:
  inode sda2:17 at d7565a18: mode 100600, nlink 0, next 15
  inode sda2:15 at dd646ba0: mode 100600, nlink 0, next 0
kernel BUG at fs/ext3/super.c:435!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = dfb90000
[00000000] *pgd=00000000
Internal error: Oops: 805 [#1]
Modules linked in:
CPU: 0    Not tainted  (2.6.31 #1)
PC is at __bug+0x20/0x2c
LR is at release_console_sem+0x1a4/0x204
pc : [<c0025128>]    lr : [<c0035fb4>]    psr: 60000013
sp : de827eb8  ip : de827df8  fp : de827ec4
r10: 00000000  r9 : de827f60  r8 : 00000000
r7 : df9335a4  r6 : df967200  r5 : df9335a4  r4 : df9334e0
r3 : 00000000  r2 : c03060c4  r1 : 002bdc93  r0 : 00000029
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0005397f  Table: 1fb90000  DAC: 00000015
Process umount (pid: 16089, stack limit = 0xde826270)
Stack: (0xde827eb8 to 0xde828000)
7ea0:                                                       de827ef4 de827ec8 
7ec0: c00d11b4 c0025118 00008180 00000000 00000000 c025d9f0 df967200 c025d9f0 
7ee0: 00000000 df80a1a0 de827f0c de827ef8 c0089518 c00d1068 df402660 00000003 
7f00: de827f24 de827f10 c00895cc c00894ac df967200 c030b234 de827f3c de827f28 
7f20: c0089aac c00895bc df80a1a0 df967200 de827f5c de827f40 c009c82c c0089a74 
7f40: df80a198 df80a198 df80a1a0 df80a1b8 de827fa4 de827f60 c009cd74 c009c7cc 
7f60: de827f60 de827f60 de827f68 de827f68 df80a1a0 df4373d8 c0027660 00000000 
7f80: 2a008164 2a00a798 00000034 c0022004 de826000 00000000 00000000 de827fa8 
7fa0: c0021e80 c009cae4 00000000 2a008164 2a00a798 00000001 00000001 00000274 
7fc0: 00000000 2a008164 2a00a798 00000034 2a00a1e8 2a00a788 00000000 bed3defa 
7fe0: 00000000 bed3da58 2a0020b4 4012c96c 60000010 2a00a798 00000000 00000000 
Backtrace: 
[<c0025108>] (__bug+0x0/0x2c) from [<c00d11b4>] (ext3_put_super+0x15c/0x1cc)
[<c00d1058>] (ext3_put_super+0x0/0x1cc) from [<c0089518>] (generic_shutdown_super+0x7c/0x110)
 r7:df80a1a0 r6:00000000 r5:c025d9f0 r4:df967200
[<c008949c>] (generic_shutdown_super+0x0/0x110) from [<c00895cc>] (kill_block_super+0x20/0x38)
 r5:00000003 r4:df402660
[<c00895ac>] (kill_block_super+0x0/0x38) from [<c0089aac>] (deactivate_super+0x48/0x60)
 r5:c030b234 r4:df967200
[<c0089a64>] (deactivate_super+0x0/0x60) from [<c009c82c>] (mntput_no_expire+0x70/0xa8)
 r5:df967200 r4:df80a1a0
[<c009c7bc>] (mntput_no_expire+0x0/0xa8) from [<c009cd74>] (sys_umount+0x2a0/0x2d0)
 r6:df80a1b8 r5:df80a1a0 r4:df80a198
[<c009cad4>] (sys_umount+0x0/0x2d0) from [<c0021e80>] (ret_fast_syscall+0x0/0x2c)
Code: e1a01000 e59f000c eb08bdc9 e3a03000 (e5833000) 

The machine came up Ok after the reboot with no noticeable
complaints from the kernel or mount (/dev/sda2 is /tmp).

/Mikael
