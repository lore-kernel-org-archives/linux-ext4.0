From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 114301] New: "Oops: Kernel access of bad area, sig: 11 [#1]"
 (check log for details)
Date: Thu, 10 Mar 2016 13:44:39 +0000
Message-ID: <bug-114301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52825 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbcCJNos (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Mar 2016 08:44:48 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4FBBD20377
	for <linux-ext4@vger.kernel.org>; Thu, 10 Mar 2016 13:44:42 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 64D4120361
	for <linux-ext4@vger.kernel.org>; Thu, 10 Mar 2016 13:44:40 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=114301

            Bug ID: 114301
           Summary: "Oops: Kernel access of bad area, sig: 11 [#1]" (check
                    log for details)
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.32-573.7.1.el6.ppc64
          Hardware: PPC-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: xierui1010@sina.com.cn
        Regression: No

Created attachment 208631
  --> https://bugzilla.kernel.org/attachment.cgi?id=208631&action=edit
backtrace.txt

KERNEL: /usr/lib/debug/lib/modules/2.6.32-573.7.1.el6.ppc64/vmlinux
    DUMPFILE: vmcore  [PARTIAL DUMP]
        CPUS: 32
        DATE: Wed Mar  9 22:17:09 2016
      UPTIME: 61 days, 16:55:25
LOAD AVERAGE: 1.28, 1.27, 1.34
       TASKS: 2741
    NODENAME: pow-bss-jf23
     RELEASE: 2.6.32-573.7.1.el6.ppc64
     VERSION: #1 SMP Thu Sep 10 13:44:06 EDT 2015
     MACHINE: ppc64  (4228 Mhz)
      MEMORY: 251.8 GB
       PANIC: "Oops: Kernel access of bad area, sig: 11 [#1]" (check log for
details)
         PID: 1840
     COMMAND: "jbd2/dm-13-8"
        TASK: c000003e8a130f60  [THREAD_INFO: c000003e845d4000]
         CPU: 4
       STATE: TASK_RUNNING (PANIC)

crash> bt
PID: 1840   TASK: c000003e8a130f60  CPU: 4   COMMAND: "jbd2/dm-13-8"
 #0 [c000003e845d7500] .crash_kexec at c0000000000ec0c4
 #1 [c000003e845d7700] .die at c000000000031638
 #2 [c000003e845d77b0] .bad_page_fault at c000000000044bd8
 #3 [c000003e845d7830] handle_page_fault at c000000000005228
 Data Access error  [300] exception frame:
 R0:  0000000000000001    R1:  c000003e845d7b20    R2:  d0000000198de328   
 R3:  c0000019e95753d0    R4:  c000003e853bf180    R5:  0000000000000005   
 R6:  c0000019e9575440    R7:  c0000000016958c8    R8:  c000003eefec1f00   
 R9:  0000000000000010    R10: 0000000000000000    R11: c000001c751f4be0   
 R12: d0000000198cf750    R13: c000000001072f00    R14: 0000000000000000   
 R15: 0000000000000000    R16: ffffffffc03b3998    R17: 0000000000000005   
 R18: c000003e853bf180    R19: 0000000000000441    R20: c000003e966c3388   
 R21: 0000000000020000    R22: 0000000000000002    R23: 0000000000000001   
 R24: c0000019e95753d0    R25: c0000019e95753d0    R26: d0000000198d6360   
 R27: 0000000000000010    R28: c000003e88907590    R29: c000003e8a8b1e00   
 R30: d0000000198dd0d8    R31: 1fc67f012a980061   
 NIP: d0000000198c77c4    MSR: 8000000000009032    OR3: d0000000198d6370
 CTR: d0000000198c0880    LR:  d0000000198c791c    XER: 0000000000000000
 CCR: 0000000024008044    MQ:  0000000000000001    DAR: 1fc67f012a980079
 DSISR: 0000000040000000     Syscall Result: 0000000000000000

 #4 [c000003e845d7b20] .jbd2_journal_write_revoke_records at d0000000198c77c4
[jbd2]
 [Link Register ]  [c000003e845d7b20] .jbd2_journal_write_revoke_records at
d0000000198c791c  (unreliable)
 #5 [c000003e845d7c10] .jbd2_journal_commit_transaction at d0000000198c39ec
[jbd2]
 #6 [c000003e845d7de0] .kjournald2 at d0000000198cc51c [jbd2]
 #7 [c000003e845d7ed0] .kthread at c0000000000c17ec
 #8 [c000003e845d7f90] .kernel_thread at c000000000033c34

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
