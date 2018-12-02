Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:48380 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725554AbeLBTKo (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 14:10:44 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4E2AC2A7E5
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 19:10:41 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 19:10:40 +0000
Message-ID: <bug-201685-13602-nBmwkXw2Uq@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #156 from Guenter Roeck (linux@roeck-us.net) ---
Status update: I have not been able to reproduce the problem with v4.19.6 minus
the reverts from #99. I did see some failures, specifically exactly one per
affected file system, but I attribute those to false positives (I did not run
fsck as recommended prior to starting the test).

stats:

System 1:

uptime: 18h 45m

iostats:
Device             tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
loop0             0.00         0.00         0.00          0          0
nvme0n1         195.54         3.27         3.96     220723     267555
sda             128.88         0.36        18.91      24659    1277907
sdb             131.40        18.85         5.07    1273780     342404

nvme0n1 and sda were previously affected. sdb is a new drive.

System 2:

uptime: 14h 56m

iostats:
Device             tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
loop0             0.00         0.00         0.00          5          0
sda              26.45       538.25        87.87   28965283    4728576
sdb             108.87      2875.25      4351.42  154728917  234167724

Both sda and sdb were previously affected.

My next step will be to try v4.19.6 with the following reverts:

Revert "ext4: handle layout changes to pinned DAX mappings"
Revert "dax: remove VM_MIXEDMAP for fsdax and device dax"
Revert "ext4: close race between direct IO and ext4_break_layouts()"

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
