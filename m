Return-Path: <SRS0=G5ay=OI=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-qk1-f181.google.com ([209.85.222.181]:38515 "EHLO
        mail-qk1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728826AbeK3Dhg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Nov 2018 22:37:36 -0500
Received: by mail-qk1-f181.google.com with SMTP id d19so1408744qkg.5
        for <linux-ext4@vger.kernel.org>; Thu, 29 Nov 2018 08:31:40 -0800 (PST)
Date: Thu, 29 Nov 2018 11:31:37 -0500
From: Eric Whitney <enwlinux@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
Subject: 4.20-rc4 kvm-xfstests regression testing results
Message-ID: <20181129163137.autzcb3vppdtn3s4@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As requested a few weeks ago in an ext4 concall, I'm posting the results of
my weekly kvm-xfstests regression run on an upstream kernel (in this case,
4.20-rc4).  Currently, my test system is an Intel NUC with i7 CPU, 16 GB of
memory, and a 500 GB SATA SSD.  The test appliance file system image I'm
running is the latest available, dated 9 Aug 2018, and the kvm-xfstests
bits I'm using were also last modified on 9 Aug.

I have made modifications to the test appliance to allow zero range
testing using fsx, fsstress, and xfs_io for the bigalloc and bigalloc_1k
test cases.  These changes have also been made upstream in kvm-xfstests, but
have not yet propagated to the official test appliance image.  Doing this
applies a little more stress and adds a little more coverage to those test
cases.

The test results I've gotten from -rc4 are much the same as those I've seen
in 4.20-rc1, -rc2, and -rc3.  All test runs have completed uneventfully.
The problems I've reported previously in earlier concalls involving long
bursts of test failures possibly involving the device mapper in 4.19's -rc's
have not occurred in my 4.20 testing to date.

Most of the test failures below are known.  For example, generic/388 can fail
in any kvm-xfstests test case due to a narrow race well known to Ted.

-------------------- Summary report
KERNEL:    kernel 4.20.0-rc4 #1 SMP Sun Nov 25 20:09:03 EST 2018 x86_64
CPUS:      2
MEM:       1980.69

ext4/4k: 436 tests, 1 failures, 45 skipped, 4598 seconds
  Failures: generic/388 
ext4/1k: 447 tests, 4 failures, 57 skipped, 5586 seconds
  Failures: ext4/033 generic/219 generic/388 generic/454 
ext4/ext3: 493 tests, 2 failures, 105 skipped, 4876 seconds
  Failures: generic/388 generic/475 
ext4/encrypt: 503 tests, 125 skipped, 2927 seconds
ext4/nojournal: 479 tests, 1 failures, 91 skipped, 4299 seconds
  Failures: ext4/301 
ext4/ext3conv: 435 tests, 2 failures, 45 skipped, 5099 seconds
  Failures: generic/347 generic/371 
ext4/adv: 440 tests, 3 failures, 51 skipped, 4864 seconds
  Failures: generic/388 generic/399 generic/477 
ext4/dioread_nolock: 435 tests, 1 failures, 45 skipped, 4874 seconds
  Failures: generic/388 
ext4/data_journal: 482 tests, 4 failures, 93 skipped, 8037 seconds
  Failures: generic/347 generic/371 generic/388 generic/475 
ext4/bigalloc: 423 tests, 6 failures, 53 skipped, 5921 seconds
  Failures: generic/051 generic/204 generic/219 generic/235 
    generic/273 generic/456 
ext4/bigalloc_1k: 436 tests, 4 failures, 66 skipped, 5851 seconds
  Failures: generic/204 generic/235 generic/273 generic/454 
Totals: 4233 tests, 776 skipped, 28 failures, 0 errors, 56839s

FSTESTVER: f2fs-tools v1.3.0-398-gc58e7d3 (Tue, 1 May 2018 21:09:36 -0400)
FSTESTVER: fio  fio-3.2 (Fri, 3 Nov 2017 15:23:49 -0600)
FSTESTVER: fsverity 2a7dbea (Mon, 23 Apr 2018 15:40:32 -0700)
FSTESTVER: ima-evm-utils 5fa7d35 (Mon, 7 May 2018 07:51:32 -0400)
FSTESTVER: quota  59b280e (Mon, 5 Feb 2018 16:48:22 +0100)
FSTESTVER: xfsprogs v4.17.0 (Thu, 28 Jun 2018 11:52:21 -0500)
FSTESTVER: xfstests-bld efd9dab (Thu, 9 Aug 2018 18:00:42 -0400)
FSTESTVER: xfstests linux-v3.8-2118-g34977a44 (Mon, 6 Aug 2018 09:43:16 -0400)
FSTESTCFG: all
FSTESTSET: -g auto
FSTESTOPT: aex

A note regarding the bigalloc and bigalloc_1k test failures - most of these
tests fail simply because the test assumes that the file system allocates
space in block unit chunks.  However, bigalloc file systems allocate space
in cluster chunks which are multiples of the block size - 64k for the bigalloc,
and 16k for the bigalloc_1k test cases.  generic/204, generic/235, generic/219,
and generic/273 are all in this category.  Another test fails because it
performs operations (like collapse range) not aligned on a cluster boundary -
generic/456.

One test seen failing here in the bigalloc test case also failed from time to
time in other test cases in 4.19 - generic/051.  This test fails relatively
rarely in regression, but the failure is a concern because e2fsck reports
filesystem damage at the end of the test run.  That includes a bad iblocks
overcount for one file (two clusters), and a single negative block bitmap
difference.  The test itself is a log recovery stress test based on fsstress
and involving a file system shutdown and restart/recovery.  A quick check
of the failure rate showed 1 failure in 10 trials.

Eric
