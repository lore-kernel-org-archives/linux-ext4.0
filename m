From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 121631] New: generic/299 test failures in nojournal test case
Date: Thu, 07 Jul 2016 15:28:23 +0000
Message-ID: <bug-121631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60370 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbcGGP2i (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Jul 2016 11:28:38 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4B67F2014A
	for <linux-ext4@vger.kernel.org>; Thu,  7 Jul 2016 15:28:26 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 4BDF020145
	for <linux-ext4@vger.kernel.org>; Thu,  7 Jul 2016 15:28:24 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=121631

            Bug ID: 121631
           Summary: generic/299 test failures in nojournal test case
           Product: File System
           Version: 2.5
    Kernel Version: 4.7-rc6
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: enwlinux@gmail.com
        Regression: No

Created attachment 222371
  --> https://bugzilla.kernel.org/attachment.cgi?id=222371&action=edit
xfstest generic/299 modified to improve failure reproducibility

In my test environment, generic/299 fails in the nojournal test case with
a good degree of repeatability when run with recent versions of the
xfstests-bld test appliance.  It's possible this is the result of a latent
aio/dio write / truncate race, as discussed in recent ext4 concalls.

Using xfstests-bld from 28 June 2016 (commit 1c6de6467ef3) with the latest
x86-64 root file system image for the test appliance (posted on 30 June 2016)
and running a 4.7-rc6 kernel, generic/299 failed in the nojournal test case in
6 out of 10 trials in my test environment.  I've not observed failures in the
other test cases included in xfstests-bld.

The error message produced by generic/299 is:

     failed: '/root/xfstests/bin/fio /tmp/25773.fio'
     (see /results/results-nojournal/generic/299.full for details)

299.full contains a failure message from fio indicating that the checksum
it's reading in the test's aio-dio-verifier thread isn't what it expects
(this example from a run with the test appliance on 4.7-rc6):

     verify: bad magic header 0, wanted acca at file /vdc/aio-dio-verifier
     offset 577712128, length 4096

There are no direct indications of kernel failure - no messages in dmesg, etc.

The value of the bad magic header varies from run to run, but always looks
like the data written by the direct_aio random writer threads.  I modified
the fio profile in the test to use a fixed verification pattern (0xFFFFFFF)
in the verification thread to make it easier to see damage in the
aio-dio-verifier file.  When the modified test fails, examining the block
at the offset noted in the error message reveals that the 4K block at that
location contains data similar to that found in the direct_aio.<n>.0 files.
There's no occurrence of the fixed verification pattern in that block at all.

It's possible that the parallel truncation activity on the direct_aio
files is triggering a race where the aio-dio-verifier is picking up and
writing to blocks that have been recently truncated from the direct_aio files,
but ongoing writes from the direct_aio threads are then applied to those
truncated blocks before the verification thread reads them.

I've been able to reproduce this failure on kernels as far back as I've
tried using the test appliance - to version 3.16.

My test system is an Intel NUC (5i7RYB) equipped with a dual core, dual
threaded i7-5557U processor, 16 GB of DDR3 SDRAM clocked at 1866 MHz, and
a 500 GB SATA (6 Gb/sec) SSD.  It's installed with a fully updated Debian 8.

And regarding fio:

I first observed generic/299 nojournal failures during 4.6-rc1 regression
testing after upgrading to a new version of the test appliance.  It used a
more recent version of fio - fio-2.6.8-ge698 rather than fio-2.1.3.  Further
testing made it clear that the change in fio version lead to the appearance
of the test failure.

I was able to bisect the change in fio's behavior to commit f8b0bd1036 -
"verify: fix a bug with verify_async".  This fixed a race that made async
verify threads unreliable.

Getting a clean bisection did require modifications to the test because
the failure rate declined as the bisection proceeded, leading to an
inconclusive result the first time through.  I commented out the
buffered aio-dio-verifier thread in the fio profile, and the code that
attempted to fallocate all the available space, and then got a clean
bisection.  The modified test may make it easier for others to reproduce
the failure;  Ted has reported that he can't see it.  I've attached the
modified test as I used it below.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
