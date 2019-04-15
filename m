Return-Path: <SRS0=3Woa=SR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 239FEC10F11
	for <linux-ext4@archiver.kernel.org>; Mon, 15 Apr 2019 08:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F135520652
	for <linux-ext4@archiver.kernel.org>; Mon, 15 Apr 2019 08:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbfDOIEL convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 15 Apr 2019 04:04:11 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49506 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725779AbfDOIEL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 15 Apr 2019 04:04:11 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A69F82888C
        for <linux-ext4@vger.kernel.org>; Mon, 15 Apr 2019 08:04:09 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 99E052889E; Mon, 15 Apr 2019 08:04:09 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 203319] New: [xfstests generic/538]: unaligned direct AIO find
 ext4 corruption
Date:   Mon, 15 Apr 2019 08:04:08 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-203319-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203319

            Bug ID: 203319
           Summary: [xfstests generic/538]: unaligned direct AIO find ext4
                    corruption
           Product: File System
           Version: 2.5
    Kernel Version: 5.1.0-rc4+
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: zlang@redhat.com
        Regression: No

After we fixed:
commit 372a03e01853f860560eade508794dd274e9b390
Author: Lukas Czerner <lczerner@redhat.com>
Date:   Thu Mar 14 23:20:25 2019 -0400

    ext4: fix data corruption caused by unaligned direct AIO

generic/538 still can trigger a failure on ext4, I hit it once on ppc64le
machine:

Running test generic/538
#! /bin/bash
# SPDX-License-Identifier: GPL-2.0
# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
#
# FS QA Test No. 538
#
# Non-block-aligned direct AIO write test with an initial truncate i_size.
#
# Uncover "ext4: Fix data corruption caused by unaligned direct AIO":
# (Ext4 needs to serialize unaligned direct AIO because the zeroing of
FSTYP         -- ext4
PLATFORM      -- Linux/ppc64le ibm-p8-kvm-11-guest-02 5.1.0-rc4+
MKFS_OPTIONS  -- /dev/vda5
MOUNT_OPTIONS -- -o acl,user_xattr -o context=system_u:object_r:nfs_t:s0
/dev/vda5 /mnt/xfstests/mnt2

generic/538     - output mismatch (see
/var/lib/xfstests/results//generic/538.out.bad)
    --- tests/generic/538.out   2019-04-14 05:10:30.200092759 -0400
    +++ /var/lib/xfstests/results//generic/538.out.bad  2019-04-14
07:20:09.996795190 -0400
    @@ -1,2 +1,20 @@
     QA output created by 538
    +Data verification fails
    +Find corruption
    +00000000  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
    +*
    +00000200  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 
ZZZZZZZZZZZZZZZZ
    +00002000
    ...
    (Run 'diff -u /var/lib/xfstests/tests/generic/538.out
/var/lib/xfstests/results//generic/538.out.bad'  to see the entire diff)
Ran: generic/538
Failures: generic/538
Failed 1 of 1 tests

# cat 538.out.bad
QA output created by 538
Data verification fails
Find corruption
00000000  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
*
00000200  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
00002000
FAIL: [8704, 8192, 512, 0]
-------------------------------------------------
Data verification fails
Find corruption
00002000  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
*
00002200  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
*
00003000  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
00004000
FAIL: [8704, 8192, 512, 8192]
-------------------------------------------------
Silence is golden

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
