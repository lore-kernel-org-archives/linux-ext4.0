From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 55651] New: Non-atomic short write problem with O_APPEND
Date: Sat, 23 Mar 2013 01:19:24 +0000 (UTC)
Message-ID: <bug-55651-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44366 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422788Ab3CWBT1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Mar 2013 21:19:27 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 980DC20193
	for <linux-ext4@vger.kernel.org>; Sat, 23 Mar 2013 01:19:26 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id D7D69201A2
	for <linux-ext4@vger.kernel.org>; Sat, 23 Mar 2013 01:19:24 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=55651

           Summary: Non-atomic short write problem with O_APPEND
           Product: File System
           Version: 2.5
    Kernel Version: 3.8.4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: qbarnes@gmail.com
        Regression: No


Created an attachment (id=96041)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=96041)
C program to demonstrate problem with non-atomic short writes.

With recent kernels, short writes to a regular file opened with
O_APPEND can be non-atomic when receiving a signal, and the write
syscall is still returning bytes written == nbytes.

I tried this with v3.8.4 (latest stable) and as far back as v3.2.41
and a smattering in between.  All show this problem.  However, it
does not reproduce on v3.0.70 or earlier kernels.  All testing was
done with on x86_64 SMP systems and on an ext3 or ext4 file system.
(I also tried running with only a single CPU enabled.  It made no
difference.)

This is likely going to not be a problem specifically with the ext
file system, but it seemed the best Bugzilla match that I saw
based on the information gathered so far.

The problem did not reproduce on an OpenSUSE 12.1 system
(3.1.10-1.19-default).  In the world of RHEL kernels, this problem
does not appear with RHEL5.7 or earlier RHEL kernels I tried.
However, it does appear starting with RHEL5.8 and 5.9 and also on
RHEL6 kernels that I tried (6.2 & 6.4).

I can't find anything wrong with the attached demo program, or find
anything in the POSIX standard or with the Linux open(2) man pages
that might allow for this apparent erroneous behavior.

To reproduce the problem, compile and run the program below.  After
it's been running a say 4-6 seconds, press ^C.  Notice there's been
no output from the program (for every write call made, all returned
success and with scnt==wcnt).  Now run "grep '^P.*P' test.log".  If
there is no problem, there will be no output.  If you see output,
you'll see lines that were stepped on or otherwise not fully written
out.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
