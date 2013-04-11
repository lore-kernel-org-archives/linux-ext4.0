From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: FYI: journal corruption after 305'th xfstest
Date: Thu, 11 Apr 2013 10:53:23 +0400
Message-ID: <87hajd4kyk.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:38649 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab3DKGx2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Apr 2013 02:53:28 -0400
Received: by mail-lb0-f177.google.com with SMTP id r10so1254406lbi.22
        for <linux-ext4@vger.kernel.org>; Wed, 10 Apr 2013 23:53:26 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I use recent ext4.git/dev head (9d35f846aa9ea)
Looks like this is a regression.

FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 sandy 3.9.0-rc5+
MKFS_OPTIONS  -- -b1024 -O ^extents /dev/mapper/vzvg-scratch_dev
MOUNT_OPTIONS -- -o acl,user_xattr /dev/mapper/vzvg-scratch_dev
/mnt_scratch

shared/305       [failed, exit status 1] - output mismatch (see
/root/xfstests-dev.git/results/shared/305.out.bad)
    --- tests/shared/305.out    2013-04-09 15:53:12.000000000 +0400
    +++ /root/xfstests-dev.git/results/shared/305.out.bad     2013-04-11
    10:42:20.000000000 +0400
    @@ -6,4 +6,5 @@
     Start fio..
     Force SCRATCH_DEV device failure
     Make SCRATCH_DEV device operable again
    -Disallow global fail_make_request feature
    +failed: '_scratch_mount'
    +(see /root/xfstests-dev.git/results/shared/305.full for details)
     ...
     (Run 'diff -u tests/shared/305.out
     /root/xfstests-dev.git/results/shared/305.out.bad' to see the
     entire diff)
Ran: shared/305
Failures: shared/305
Failed 1 of 1 tests

Mount failed due to bad journal: EXT4-fs (dm-3): error loading journal
last two commits in a journal:
Found expected sequence 395, type 2 (commit block) at block 30358
Found expected sequence 396, type 5 (revoke table) at block 30359
Found expected sequence 396, type 1 (descriptor block) at block 30360
Found expected sequence 396, type 1 (descriptor block) at block 30445
Found expected sequence 396, type 1 (descriptor block) at block 30530
Found expected sequence 396, type 1 (descriptor block) at block 30615
Found expected sequence 396, type 1 (descriptor block) at block 30700
Found expected sequence 396, type 1 (descriptor block) at block 30785
Found expected sequence 396, type 1 (descriptor block) at block 30870
Found expected sequence 396, type 2 (commit block) at block 30879
Found expected sequence 397, type 5 (revoke table) at block 30880
Found expected sequence 397, type 1 (descriptor block) at block 30881
Found expected sequence 397, type 1 (descriptor block) at block 30966
Found expected sequence 397, type 1 (descriptor block) at block 31051
Found expected sequence 397, type 1 (descriptor block) at block 31136
Found expected sequence 397, type 1 (descriptor block) at block 31221
Found expected sequence 397, type 1 (descriptor block) at block 31306
Found expected sequence 397, type 1 (descriptor block) at block 31391
Found expected sequence 397, type 1 (descriptor block) at block 31476
Found expected sequence 397, type 2 (commit block) at block 31500
No magic number at block 31501: end of journal.


