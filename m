From: Eric Whitney <enwlinux@gmail.com>
Subject: generic/224 failures on 4.5 - encrypted test case
Date: Tue, 15 Mar 2016 17:37:27 -0400
Message-ID: <20160315213727.GA2635@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:36342 "EHLO
	mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbcCOVgq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Mar 2016 17:36:46 -0400
Received: by mail-qk0-f176.google.com with SMTP id s68so13141254qkh.3
        for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2016 14:36:46 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As mentioned in a recent concall, I've been seeing some unpleasant looking
failures of generic/224 when running the encryption test case on x86_64
with xfstest-bld's test appliance.  I first saw an outright failure of the
test accompanied by kernel errors in a 4.5-rc7 regression run, and was able
to reproduce the same on 4.5.

The test fails relatively rarely - about one in ten trials.  The set of
reported kernel errors varies considerably from run to run.  The one constant
is an ENOSPC complaint from ext4_bio_write_page() which appears whether the
test passes or fails.  This is sometimes followed by another error,
"JBD2: Detected IO errors while flushing file data on vdc-8", and in this
case the test also passes.

Generic/224 is intended to test delayed allocation behavior at ENOSPC, so
the ENOSPC condition itself is not necessarily surprising.

(The ext4_bio_write_page() messages appeared in test runs on earlier kernels,
such as 4.4, as well.)

Here's one example of the log from a failed test run:

generic/224 27s ...	[20:18:49][    3.684368] run fstests generic/224 at 2016-03-15 20:18:49
[    4.279852] EXT4-fs (vdc): Test dummy encryption mode enabled
[   18.146614] ext4_bio_write_page: ret = -12
[   18.150493] ext4_bio_write_page: ret = -12
[   18.150494] ext4_bio_write_page: ret = -12
[   18.165865] ext4_bio_write_page: ret = -12
[   19.131662] Aborting journal on device vdc-8.
[   19.152549] EXT4-fs error (device vdc): ext4_journal_check_start:56: Detected aborted journal
[   19.153998] EXT4-fs (vdc): Remounting filesystem read-only
[   19.169351] EXT4-fs error (device vdc) in ext4_writepages:2612: IO failure
[   19.178186] EXT4-fs error (device vdc): ext4_journal_check_start:56: Detected aborted journal
[   19.240552] JBD2: Detected IO errors while flushing file data on vdc-8
[   19.241859] __journal_remove_journal_head: freeing b_frozen_data
[   19.242915] __journal_remove_journal_head: freeing b_frozen_data
[   19.244072] __journal_remove_journal_head: freeing b_frozen_data
[   19.245130] __journal_remove_journal_head: freeing b_frozen_data
[   19.246178] __journal_remove_journal_head: freeing b_frozen_data
[   19.247234] __journal_remove_journal_head: freeing b_frozen_data
[   19.248423] __journal_remove_journal_head: freeing b_frozen_data
[   19.249556] __journal_remove_journal_head: freeing b_frozen_data
[   19.250670] __journal_remove_journal_head: freeing b_frozen_data
[   19.251551] __journal_remove_journal_head: freeing b_frozen_data
[   19.252061] __journal_remove_journal_head: freeing b_frozen_data
[   19.252694] __journal_remove_journal_head: freeing b_frozen_data
[   19.253789] __journal_remove_journal_head: freeing b_frozen_data
[   19.254933] __journal_remove_journal_head: freeing b_frozen_data
[   19.255823] __journal_remove_journal_head: freeing b_frozen_data
[   19.256883] __journal_remove_journal_head: freeing b_frozen_data
[   19.257944] __journal_remove_journal_head: freeing b_frozen_data
[   19.259006] __journal_remove_journal_head: freeing b_frozen_data
[   19.259957] __journal_remove_journal_head: freeing b_frozen_data
[   19.261021] __journal_remove_journal_head: freeing b_frozen_data
 [20:19:09] - output mismatch (see /results/results-encrypt/generic/224.out.bad)
    --- tests/generic/224.out	2015-10-25 10:50:34.000000000 +0000
    +++ /results/results-encrypt/generic/224.out.bad	2016-03-15 20:19:09.505673157 +0000
    @@ -1,2 +1,1003 @@
     QA output created by 224
     *** Silence is golden ***
    +rm: cannot remove '/vdc/testfile.0': Read-only file system
    +rm: cannot remove '/vdc/testfile.1': Read-only file system
    +rm: cannot remove '/vdc/testfile.10': Read-only file system
    +rm: cannot remove '/vdc/testfile.100': Read-only file system
    +rm: cannot remove '/vdc/testfile.1000': Read-only file system
    ...
    (Run 'diff -u tests/generic/224.out /results/results-encrypt/generic/224.out.bad'  to see the entire diff)
[   24.604435] __journal_remove_journal_head: freeing b_frozen_data
[   24.604950] __journal_remove_journal_head: freeing b_frozen_data
[   24.605441] __journal_remove_journal_head: freeing b_frozen_data
[   24.605929] __journal_remove_journal_head: freeing b_frozen_data
[   24.606419] __journal_remove_journal_head: freeing b_frozen_data
[   24.607149] __journal_remove_journal_head: freeing b_frozen_data
[   24.607703] __journal_remove_journal_head: freeing b_frozen_data
[   24.608190] __journal_remove_journal_head: freeing b_frozen_data
[   24.608676] __journal_remove_journal_head: freeing b_frozen_data
[   24.609161] __journal_remove_journal_head: freeing b_frozen_data
[   24.609645] __journal_remove_journal_head: freeing b_frozen_data
[   24.610388] __journal_remove_journal_head: freeing b_frozen_data
[   24.610893] __journal_remove_journal_head: freeing b_frozen_data
[   24.611390] __journal_remove_journal_head: freeing b_frozen_data
[   24.611875] __journal_remove_journal_head: freeing b_frozen_data
[   24.612359] __journal_remove_journal_head: freeing b_frozen_data
[   24.612841] __journal_remove_journal_head: freeing b_frozen_data
[   24.613325] __journal_remove_journal_head: freeing b_frozen_data
[   24.613945] __journal_remove_journal_head: freeing b_frozen_data
[   24.614456] __journal_remove_journal_head: freeing b_frozen_data
[   24.614946] __journal_remove_journal_head: freeing b_frozen_data
[   24.615466] __journal_remove_journal_head: freeing b_frozen_data
[   24.615953] __journal_remove_journal_head: freeing b_frozen_data
[   24.616448] __journal_remove_journal_head: freeing b_frozen_data
[   24.616970] __journal_remove_journal_head: freeing b_frozen_data
[   24.617488] __journal_remove_journal_head: freeing b_frozen_data
[   24.619602] EXT4-fs error (device vdc): ext4_put_super:838: Couldn't clean up the journal
[   24.643588] EXT4-fs (vdc): Test dummy encryption mode enabled
[   24.650443] EXT4-fs warning (device vdc): ext4_clear_journal_err:4442: Filesystem error recorded from previous mount: Out of memory
[   24.651523] EXT4-fs warning (device vdc): ext4_clear_journal_err:4443: Marking fs in need of filesystem check.
[   24.655258] EXT4-fs (vdc): warning: mounting fs with errors, running e2fsck is recommended
Ran: generic/224
Failures: generic/224
Failed 1 of 1 tests
