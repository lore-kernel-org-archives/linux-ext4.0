From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194739] New: fallocate --collapse-range causes temporal data
 corruption on fragmented file
Date: Wed, 01 Mar 2017 00:00:51 +0000
Message-ID: <bug-194739-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40370 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751673AbdCAAIb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 28 Feb 2017 19:08:31 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 6C78B27F60
        for <linux-ext4@vger.kernel.org>; Wed,  1 Mar 2017 00:00:54 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 0CA9927F60
        for <linux-ext4@vger.kernel.org>; Wed,  1 Mar 2017 00:00:54 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=194739

            Bug ID: 194739
           Summary: fallocate --collapse-range causes temporal data
                    corruption on fragmented file
           Product: File System
           Version: 2.5
    Kernel Version: 4.10.1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: iive@yahoo.com
        Regression: No

I use `fallocate -c` to cut the start of the file without having to copy the
whole file again.

However recently, after collapsing the file it seems to repeat a portion of the
data, that should have been moved. That is, the new start of the file is found
somewhere around its old location.

Restarting the computer (or just hibernate) seems to fix the file.

Doing:
`echo 3 > /proc/sys/vm/drop_caches`

also seems to fix the issue. Using just `echo 1` fixes some of the data, but
the file still might be broken.


I've noticed this problem on 4.9 kernel. I'm not sure if it is regression,
because the problem might be triggered by high fragmentation. This partition
got quite full and the files are quite big, thus they are always very
fragmented.

Just want to make it clear.
Data on disk is not damaged.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
