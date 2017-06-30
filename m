From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196223] New: jdb2 journal - hung after suspend-resume test
Date: Fri, 30 Jun 2017 06:11:18 +0000
Message-ID: <bug-196223-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:36624 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751744AbdF3GLZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Jun 2017 02:11:25 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F143728504
        for <linux-ext4@vger.kernel.org>; Fri, 30 Jun 2017 06:11:24 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196223

            Bug ID: 196223
           Summary: jdb2 journal - hung after suspend-resume test
           Product: File System
           Version: 2.5
    Kernel Version: 4.12.0-rc7-next-20170629
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: marta.lofstedt@intel.com
        Regression: No

Created attachment 257243
  --> https://bugzilla.kernel.org/attachment.cgi?id=257243&action=edit
backtraces jdb2/ext4 hang

While running IGT graphics test on linux-next various x86 machines hang. The
issue is reproducible with running the fastfeedback.testlist of
IGT(https://cgit.freedesktop.org/xorg/app/intel-gpu-tools)
Example backtrace from BDW NUCi5, more backtraces from other machines in
attachment.

<3>[ 1330.158734] INFO: task jbd2/sda2-8:208 blocked for more than 120 seconds.
<3>[ 1330.158814]       Tainted: G     U  W       4.12.0-rc7-next-20170629 #1
<3>[ 1330.158877] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
<6>[ 1330.158950] jbd2/sda2-8     D    0   208      2 0x00000000
<4>[ 1330.158956] Call Trace:
<4>[ 1330.158969]  __schedule+0x3c7/0x830
<4>[ 1330.158974]  schedule+0x36/0x80
<4>[ 1330.158979]  io_schedule+0x16/0x40
<4>[ 1330.158984]  wait_on_page_bit_common+0x10e/0x1d0
<4>[ 1330.158988]  ? page_cache_tree_insert+0xf0/0xf0
<4>[ 1330.158992]  __filemap_fdatawait_range+0x114/0x180
<4>[ 1330.158998]  ? submit_bio+0x73/0x150
<4>[ 1330.159002]  ? submit_bio+0x73/0x150
<4>[ 1330.159007]  ? jbd2_journal_begin_ordered_truncate+0xb0/0xb0
<4>[ 1330.159012]  filemap_fdatawait_keep_errors+0x27/0x50
<4>[ 1330.159016]  jbd2_journal_commit_transaction+0x89e/0x16d0
<4>[ 1330.159024]  kjournald2+0xd2/0x270
<4>[ 1330.159028]  ? kjournald2+0xd2/0x270
<4>[ 1330.159033]  ? wait_woken+0x80/0x80
<4>[ 1330.159039]  kthread+0x109/0x140
<4>[ 1330.159044]  ? commit_timeout+0x10/0x10
<4>[ 1330.159049]  ? kthread_create_on_node+0x70/0x70
<4>[ 1330.159053]  ret_from_fork+0x25/0x30
<4>[ 1330.159057] NMI backtrace for cpu 0
<4>[ 1330.159061] CPU: 0 PID: 36 Comm: khungtaskd Tainted: G     U  W      
4.12.0-rc7-next-20170629 #1
<4>[ 1330.159063] Hardware name:                  /NUC5i5RYB, BIOS
RYBDWi35.86A.0249.2015.0529.1640 05/29/2015
<4>[ 1330.159064] Call Trace:
<4>[ 1330.159070]  dump_stack+0x63/0x8d
<4>[ 1330.159076]  nmi_cpu_backtrace+0xca/0xd0
<4>[ 1330.159081]  ? irq_force_complete_move+0x140/0x140
<4>[ 1330.159087]  nmi_trigger_cpumask_backtrace+0xde/0x110
<4>[ 1330.159092]  arch_trigger_cpumask_backtrace+0x19/0x20
<4>[ 1330.159096]  watchdog+0x2dd/0x360
<4>[ 1330.159103]  kthread+0x109/0x140
<4>[ 1330.159106]  ? reset_hung_task_detector+0x20/0x20
<4>[ 1330.159111]  ? kthread_create_on_node+0x70/0x70
<4>[ 1330.159115]  ret_from_fork+0x25/0x30

This issue is blocking linux-next testing for i915 driver.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
