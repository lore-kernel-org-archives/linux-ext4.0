From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 182261] New: Deleted files reappear
Date: Tue, 25 Oct 2016 13:10:15 +0000
Message-ID: <bug-182261-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758853AbcJYNK1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 25 Oct 2016 09:10:27 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 8C16220306
        for <linux-ext4@vger.kernel.org>; Tue, 25 Oct 2016 13:10:21 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id C2299202F8
        for <linux-ext4@vger.kernel.org>; Tue, 25 Oct 2016 13:10:15 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=182261

            Bug ID: 182261
           Summary: Deleted files reappear
           Product: File System
           Version: 2.5
    Kernel Version: 3.14 - 4.8.4
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: shomari.sharpe@gmail.com
        Regression: No

Hi I have been noticing this problem intermittently for a while now starting
with kernel 3.14. Files I delete days/weeks ago reappear mysteriously and they
are fully intact. My most recent encounter is using my Xubuntu system with the
following config:

ext2 = /boot
luks/ext4 = / (root) 


I deleted 4.7.6 / 4.8.0 kernels from my boot and also the /lib/modules for each
and compiled and installed 4.8.4 only to notice that the files reappeared.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
