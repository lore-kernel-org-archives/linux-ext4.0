From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29402] New: kernel panics while running ffsb scalability
 workloads on 2.6.38-rc1 through -rc5
Date: Fri, 18 Feb 2011 21:47:15 GMT
Message-ID: <bug-29402-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:54298 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab1BRVrQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Feb 2011 16:47:16 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p1ILlGtS002084
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 18 Feb 2011 21:47:16 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29402

           Summary: kernel panics while running ffsb scalability workloads
                    on 2.6.38-rc1 through -rc5
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.38-rc5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: eric.whitney@hp.com
        Regression: Yes


Created an attachment (id=48352)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=48352)
captured console output - spinlock bad magic: ext4lazyinit

The 2.6.38-rc5 kernel can panic while running any one of the ffsb profiles in
http://free.linux.hp.com/~enw/ext4/profiles on an ext4 filesystem on a 48 core
x86 system. These panics occur most frequently using the 48 or 192 thread
versions of those profiles.  The problem has been reproduced on a 16 core x86
system using identical storage, but occurs there at lower frequency.  On
average, it takes only two runs of "large_file_creates_threads-192.ffsb" to
produce a panic on the 48 core system.

The panics occur more or less equally frequently on a vanilla ext4 filesystem,
ext4 filesystem without a journal, and an ext4 filesystem with a journal but
mounted with mblk_io_submit.

With various debugging options enabled including spinlock debugging, panics or
oopses or BUGS occur in four varieties: protection violation, invalid opcode,
NULL pointer, and spinlock bad magic.  Typically, the first fault triggers a
cascade of subsequent oopses, etc.

These panics can be suppressed by using -E lazy_itable_init at mkfs time.  The
test system survived two series of 10 ffsb tests beginning with a single mkfs
each.  Subsequently, the system survived a run of about 16 hours in which a
complete scalability measurement pass was made

Repeated ffsb runs on ext3 and xfs filesystems on 2.6.38-rc* have not produced
panics.

Numerous previous ffsb scalability runs on ext4 and 2.6.37 did not produce
panics.

The panics can be produced using either HP SmartArray (backplane RAID) or
FibreChannel storage with no material difference in the panic backtraces.

Attempted bisection of the bug in 38-rc1 was inconclusive.  Repeatability was
lost the earlier in -rc1 I got.  The last clear indication was in the midst of
perf changes very early in the release (SHA id beginning with 006b20fe4c,
"Merge branch 'perf/urgent' into perf/core").  Preceding that are RCU and GFS
patches, plus a small number of x86 patches.

Relatively little useful spinlock debugging information was reported in
repeated tests in early 38 rc's - with later rc's, more information gradually
became visible (or maybe I was just getting progressively more lucky).

The first attachment contains the partial backtrace that most clearly suggests
lazy_itable_init involvement.  The softirq portion of this backtrace tends to
look the same across the panics I've seen.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
