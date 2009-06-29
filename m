From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13676] New: unmount after fsstress on a ramdisk causes orphan
 inode list corruption
Date: Mon, 29 Jun 2009 18:38:30 GMT
Message-ID: <bug-13676-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53201 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbZF2Si1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Jun 2009 14:38:27 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5TIcU2A022657
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2009 18:38:30 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13676

           Summary: unmount after fsstress on a ramdisk causes orphan
                    inode list corruption
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.30-6.fc12
          Platform: All
        OS/Version: Linux
              Tree: Fedora
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: sandeen@redhat.com
        Regression: No


Created an attachment (id=22143)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=22143)
debug messages & oops.

Running a test like this on 2.6.30-6.fc12 :

#!/bin/bash

mkfs.ext3 /dev/ram0

i=0
while (true); do
    i=`expr $i + 1`
    echo -------------------------------------------------------------
    echo Cycle $i
    date
    echo Mounting
    sleep 1
    mount -t ext3 /dev/ram0 /mnt/test || exit 1
    echo Removing old fsstress data
    rm -rf /mnt/test/work
    mkdir /mnt/test/work || exit 1
    echo Starting fsstress
    fsstress -d /mnt/test/work -p 3 -n 100000000 &
    echo Sleeping 30 seconds
    sleep 30
    echo Stopping fsstress
    while (ps -e | grep fsstress);do
        pkill fsstress
        sleep 1
    done
    echo Unmounting
    umount /mnt/test || exit 1
    echo Checking
    sleep 1
    e2fsck -fvp /dev/ram0 || exit 1
done

I get an assertion failure on the unmount, see attachment.

This testcase was originally reported at http://lkml.org/lkml/2008/11/14/121,
though the end result was different, in that case corruption was found.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
