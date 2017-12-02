From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Testing Ext4 encryption with fstests
Date: Sat, 02 Dec 2017 08:44:29 +0530
Message-ID: <2008991.n3x73QCyP8@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54438 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751031AbdLBDN3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Dec 2017 22:13:29 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vB239R4d059545
        for <linux-ext4@vger.kernel.org>; Fri, 1 Dec 2017 22:13:28 -0500
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ekhfn4vbp-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Fri, 01 Dec 2017 22:13:28 -0500
Received: from localhost
        by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sat, 2 Dec 2017 03:13:26 -0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I have now got an initial version of patch to get encryption to work on
blocksize < pagesize
(https://github.com/chandanr/linux/commit/343ef14a6c33fd3fc4bda11a2ffa6de8cd695f04).
There is still some error handling code to be written.

My fstests local.config has,

export TEST_DEV=/dev/loop0
export TEST_DIR=/mnt/btrfs-xfstest-test
export SCRATCH_DEV=/dev/loop1
export SCRATCH_MNT=/mnt/btrfs-xfstest-scratch
MKFS_OPTIONS="-O encrypt"
EXT_MOUNT_OPTIONS="-o test_dummy_encryption"
export FSTYPE=ext4

With the latest linux-next next-20171201 (i.e. without my changes applied)
on x86 I see some tests fail and also filesystem consistency almost always 
fails. E.g.

_check_generic_filesystem: filesystem on /dev/loop0 is inconsistent
(see /root/xfstests-dev/results//check.full for details)
generic/011 1s ... 0s
_check_generic_filesystem: filesystem on /dev/loop0 is inconsistent
(see /root/xfstests-dev/results//generic/011.full for details)
Ran: generic/011
Failures: generic/011
Failed 1 of 1 tests

FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 localhost 4.13.0-next-20170905-gf165385
MKFS_OPTIONS  -- -O encrypt /dev/loop1
MOUNT_OPTIONS -- -o acl,user_xattr -o test_dummy_encryption /dev/loop1 /mnt/btrfs-xfstest-scratch

_check_generic_filesystem: filesystem on /dev/loop0 is inconsistent
(see /root/xfstests-dev/results//check.full for details)
generic/012 0s ... [failed, exit status 1] - output mismatch (see /root/xfstests-dev/results//generic/012.out.bad)
    --- tests/generic/012.out   2016-11-22 09:11:59.000000000 +0530
    +++ /root/xfstests-dev/results//generic/012.out.bad 2017-12-01 11:14:08.826594934 +0530
    @@ -47,3 +47,5 @@
        14. data -> hole @ 0
     0: [0..95]: extent
     f1894a71ac539f6f90426d98a4990a47
    +_check_generic_filesystem: filesystem on /dev/loop0 is inconsistent
    +(see /root/xfstests-dev/results//generic/012.full for details)
    ...
    (Run 'diff -u tests/generic/012.out /root/xfstests-dev/results//generic/012.out.bad'  to see the entire diff)
_check_generic_filesystem: filesystem on /dev/loop0 is inconsistent
(see /root/xfstests-dev/results//generic/012.full for details)
Ran: generic/012
Failures: generic/012
Failed 1 of 1 tests

FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 localhost 4.13.0-next-20170905-gf165385
MKFS_OPTIONS  -- -O encrypt /dev/loop1
MOUNT_OPTIONS -- -o acl,user_xattr -o test_dummy_encryption /dev/loop1 /mnt/btrfs-xfstest-scratch


_check_generic_filesystem: filesystem on /dev/loop0 is inconsistent
(see /root/xfstests-dev/results//check.full for details)
generic/013 2s ... [failed, exit status 1] - output mismatch (see /root/xfstests-dev/results//generic/013.out.bad)
    --- tests/generic/013.out   2016-11-22 09:11:59.000000000 +0530
    +++ /root/xfstests-dev/results//generic/013.out.bad 2017-12-01 11:14:09.724595573 +0530
    @@ -1,14 +1,5 @@
     QA output created by 013
     brevity is wit...
    -
    ------------------------------------------------
    -fsstress.1 : -r
    ------------------------------------------------
    -
    ...
    (Run 'diff -u tests/generic/013.out /root/xfstests-dev/results//generic/013.out.bad'  to see the entire diff)
_check_generic_filesystem: filesystem on /dev/loop0 is inconsistent
(see /root/xfstests-dev/results//generic/013.full for details)
Ran: generic/013
Failures: generic/013
Failed 1 of 1 tests

Please let me know if the test setup described above is incorrect.

-- 
chandan
