From: Theodore Ts'o <tytso@mit.edu>
Subject: memory leak: data=journal and {collapse,insert,zero}_range
Date: Sat, 17 Oct 2015 12:02:30 -0400
Message-ID: <20151017160230.GA19968@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Namjae Jeon <namjae.jeon@samsung.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56082 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbbJQQCd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Oct 2015 12:02:33 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On the last conference call I mentioned that I had recently been
running into memory leaks with data=journal.  I've traced it down to
{collapse,insert,zero}_range calls.

It bisected down to 1ce01c4a199: "ext4: fix COLLAPSE_RANGE test
failure in data journalling mode", and specifically, this bit of code
the collapse/insert/zero range functions:

	/* Call ext4_force_commit to flush all data in case of data=journal. */
	if (ext4_should_journal_data(inode)) {
		ret = ext4_force_commit(inode->i_sb);
		if (ret)
			return ret;
	}

This is needed to prevent data from being lost with the insert and
collapse range calls.  (It is not obvious to me whether this bit of
code, and the filemap_write_and_wait_range() call, is needed for
zero_range, but I haven't had a chance to investigate this more
deeply.)

Further investigation shows that the problem seems to be a buffer_head
leak.  Running generic/091 with data=journal in a loop, and using the
following between each test runs:

#!/bin/sh
# /tmp/hooks/logger
echo 3 > /proc/sys/vm/drop_caches
logger $(grep MemFree /proc/meminfo)
logger $(grep buffer_head /proc/slabinfo)
logger $(grep jbd2_journal_head /proc/slabinfo)

what we find is:

logger: MemFree: 7348684 kB
logger: buffer_head 608 1600 128 32 1 : tunables 32 16 8 : slabdata 50 50 0 : globalstat 108003 36592 3294 0 0 1 0 0 0 : cpustat 102424 6803 101863 6760
logger: jbd2_journal_head 120 120 136 30 1 : tunables 32 16 8 : slabdata 4 4 0 : globalstat 203 120 4 0 0 0 0 0 0 : cpustat 179 14 84 0

logger: MemFree: 7155576 kB
logger: buffer_head 45008 65920 128 32 1 : tunables 32 16 8 : slabdata 2060 2060 0 : globalstat 207971 79408 5753 0 0 1 0 0 0 : cpustat 354158 14482 311984 11664
logger: jbd2_journal_head 206 690 136 30 1 : tunables 32 16 8 : slabdata 23 23 128 : globalstat 38817 11086 1142 0 0 0 0 0 0 : cpustat 68275 3482 68402 3326

kernel: logger (5838): drop_caches: 3
logger: MemFree: 6967656 kB
logger: buffer_head 89552 111616 128 32 1 : tunables 32 16 8 : slabdata 3488 3488 0 : globalstat 308435 124352 7589 0 0 1 0 0 0 : cpustat 606287 22193 522363 16591
logger: jbd2_journal_head 210 660 136 30 1 : tunables 32 16 8 : slabdata 22 22 128 : globalstat 77205 11086 2158 0 0 0 0 0 0 : cpustat 136335 6954 136593 6669

logger: MemFree: 6780176 kB
logger: buffer_head 134080 155328 128 32 1 : tunables 32 16 8 : slabdata 4854 4854 0 : globalstat 408163 168144 9369 0 0 1 0 0 0 : cpustat 857710 29874 732032 21489
logger: jbd2_journal_head 210 570 136 30 1 : tunables 32 16 8 : slabdata 19 19 128 : globalstat 115685 11086 3198 0 0 0 0 0 0 : cpustat 204408 10417 204798 9998

The problem then appears to be with the buffer heads associated with
pages that have been recently written in data=journal mode are not
getting freed.  I haven't had time to take this any further, but I
wanted to document what I've found to date as a checkpoint.  If
someone has time to take this further, or has any additional insight,
I'd certainly appreciate it!

							- Ted

P.S.  I will shortly be releasing an enhancement to kvm-xfstests and
gce-xfstests which allows collapse/insert/zero range to be easily
disabled, like this:

gce-xfstests --hooks /tmp/hooks  -C 20 -c data_journal --no-collapse --no-zero --no-insert generic/091

(The above traces were taken without --no-collapse --no-zero and
--noinsert.  With those options added, the memory leak goes away.)
