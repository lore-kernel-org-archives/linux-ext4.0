From: Da-Chang Guan <dcguan@gmail.com>
Subject: Ext4 jbd2 state lock race condition
Date: Fri, 25 Mar 2016 18:32:47 +0800
Message-ID: <CAF=9w3kK=kupvjVnG+dyiwYHnf530EDnQZqb+T+N+4FwW3GpfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:33470 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbcCYKcs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Mar 2016 06:32:48 -0400
Received: by mail-ob0-f170.google.com with SMTP id xj3so56696881obb.0
        for <linux-ext4@vger.kernel.org>; Fri, 25 Mar 2016 03:32:48 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, all,

  We have a 4 core Android device has system hang issue. The stack
trace shows system hang may caused by jbd2 state lock racing.

  The stack trace is:

  03-24 00:24:00[26516.738548] INFO: rcu_sched self-detected stall on
CPU { 2}  (t=380280 jiffies g=631554 c=631553 q=6057)
  03-24 00:24:00[26516.748298] Sending NMI to all CPUs:
  03-24 00:24:00[26516.753286] NMI backtrace for cpu 0
  03-24 00:24:00[26516.756854]
  03-24 00:24:00[26516.758380] CPU: 0 PID: 587 Comm: system_server
Tainted: P           O 3.10.19-mag2+ #12
  03-24 00:24:00[26516.766655] task: deb14c00 ti: debce000 task.ti: debce000
  03-24 00:24:00[26516.772178] PC is at _raw_read_lock+0x18/0x30
  03-24 00:24:00[26516.776635] LR is at start_this_handle+0xd0/0x570
  03-24 00:24:00[26516.781447] pc : [<c0745c94>]    lr : [<c02e26fc>]
  psr: 800b0013
  03-24 00:24:00[26516.787857] sp : debcfc10  ip : debcfc20  fp : debcfc1c
  03-24 00:24:00[26516.793201] r10: c0eac5d8  r9 : dfa23400  r8 : debce000
  03-24 00:24:00[26516.798545] r7 : 00000002  r6 : dfa23414  r5 :
00000000  r4 : dfa23400
  03-24 00:24:00[26516.805221] r3 : 80000000  r2 : c0cba0c0  r1 :
d5675788  r0 : dfa23414
  03-24 00:24:00[26516.811897] Flags: Nzcv  IRQs on  FIQs on  Mode
SVC_32  ISA ARM  Segment user
  03-24 00:24:00[26516.819196] Control: 10c5383d  Table: 1ee1c06a  DAC: 00000015
  03-24 00:24:00[26516.825073] CPU: 0 PID: 587 Comm: system_server
Tainted: P           O 3.10.19-mag2+ #12
  03-24 00:24:00[26516.833349] [<c011b878>]
(unwind_backtrace+0x0/0x124) from [<c0117688>] (show_stack+0x20/0x24)
  03-24 00:24:00[26516.842157] [<c0117688>] (show_stack+0x20/0x24)
from [<c0740840>] (dump_stack+0x20/0x28)
  03-24 00:24:00[26516.850432] [<c0740840>] (dump_stack+0x20/0x28)
from [<c0114e80>] (show_regs+0x2c/0x34)
  03-24 00:24:00[26516.858619] [<c0114e80>] (show_regs+0x2c/0x34) from
[<c03cf574>] (nmi_cpu_backtrace+0x68/0x9c)
  03-24 00:24:00[26516.867428] [<c03cf574>]
(nmi_cpu_backtrace+0x68/0x9c) from [<c01194e0>]
(handle_IPI+0x3a8/0x3ec)
  03-24 00:24:00[26516.876503] [<c01194e0>] (handle_IPI+0x3a8/0x3ec)
from [<c010855c>] (gic_handle_irq+0x64/0x6c)
  03-24 00:24:00[26516.885312] [<c010855c>] (gic_handle_irq+0x64/0x6c)
from [<c0113340>] (__irq_svc+0x40/0x50)
  03-24 00:24:00[26516.893853] Exception stack(0xdebcfbc8 to 0xdebcfc10)
  03-24 00:24:00[26516.899021] fbc0:                   dfa23414
d5675788 c0cba0c0 80000000 dfa23400 00000000
  03-24 00:24:00[26516.907385] fbe0: dfa23414 00000002 debce000
dfa23400 c0eac5d8 debcfc1c debcfc20 debcfc10
  03-24 00:24:00[26516.915749] fc00: c02e26fc c0745c94 800b0013 ffffffff
  03-24 00:24:00[26516.920916] [<c0113340>] (__irq_svc+0x40/0x50) from
[<c0745c94>] (_raw_read_lock+0x18/0x30)
  03-24 00:24:00[26516.929459] [<c0745c94>] (_raw_read_lock+0x18/0x30)
from [<c02e26fc>] (start_this_handle+0xd0/0x570)
  03-24 00:24:00[26516.938801] [<c02e26fc>]
(start_this_handle+0xd0/0x570) from [<c02e2c44>]
(jbd2__journal_start+0xa8/0x170)
  03-24 00:24:00[26516.948675] [<c02e2c44>]
(jbd2__journal_start+0xa8/0x170) from [<c02cbf24>]
(__ext4_journal_start_sb+0x104/0x124)
  03-24 00:24:00[26516.959171] [<c02cbf24>]
(__ext4_journal_start_sb+0x104/0x124) from [<c02af284>]
(ext4_dirty_inode+0x2c/0x58)
  03-24 00:24:00[26516.969312] [<c02af284>]
(ext4_dirty_inode+0x2c/0x58) from [<c02614e8>]
(__mark_inode_dirty+0x84/0x288)
  03-24 00:24:00[26516.978921] [<c02614e8>]
(__mark_inode_dirty+0x84/0x288) from [<c0254e04>]
(update_time+0xac/0xb4)
  03-24 00:24:00[26516.988084] [<c0254e04>] (update_time+0xac/0xb4)
from [<c0255054>] (file_update_time+0xd0/0xf4)
  03-24 00:24:00[26516.996982] [<c0255054>]
(file_update_time+0xd0/0xf4) from [<c01ff150>]
(__generic_file_aio_write+0x268/0x3dc)
  03-24 00:24:00[26517.007212] [<c01ff150>]
(__generic_file_aio_write+0x268/0x3dc) from [<c01ff32c>]
(generic_file_aio_write+0x68/0xc8)
  03-24 00:24:00[26517.017975] [<c01ff32c>]
(generic_file_aio_write+0x68/0xc8) from [<c02a4ca0>]
(ext4_file_write+0x1d0/0x468)
  03-24 00:24:00[26517.027938] [<c02a4ca0>]
(ext4_file_write+0x1d0/0x468) from [<c023b760>]
(do_sync_write+0x84/0xa8)
  03-24 00:24:00[26517.037101] [<c023b760>] (do_sync_write+0x84/0xa8)
from [<c023beb8>] (vfs_write+0xe4/0x184)
  03-24 00:24:00[26517.045643] [<c023beb8>] (vfs_write+0xe4/0x184)
from [<c023c4ec>] (SyS_pwrite64+0x70/0x90)
  03-24 00:24:00[26517.054096] [<c023c4ec>] (SyS_pwrite64+0x70/0x90)
from [<c0113740>] (ret_fast_syscall+0x0/0x30)
  03-24 00:24:00[26517.062992] NMI backtrace for cpu 1

  The 4 cores seem stuck on waiting a lock:

  03-24 00:24:00[26516.929459] [<c0745c94>] (_raw_read_lock+0x18/0x30)
from [<c02e26fc>] (start_this_handle+0xd0/0x570)
  03-24 00:24:00[26516.938801] [<c02e26fc>]
(start_this_handle+0xd0/0x570) from [<c02e2c44>]
(jbd2__journal_start+0xa8/0x170)
  03-24 00:24:00[26516.948675] [<c02e2c44>]
(jbd2__journal_start+0xa8/0x170) from [<c02cbf24>]
(__ext4_journal_start_sb+0x104/0x124)

   We check the source code and it seems hang here:

   static int start_this_handle(journal_t *journal, handle_t *handle,
gfp_t gfp_mask)

    ...
   repeat:
         read_lock(&journal->j_state_lock);

   Linux kernel version is 3.7.2.

   We want to know who acquires the lock at that time so we can fix
it.  But we don't even know how to start debug.
   Any help would be appreciated.

Regards,
David Guan
