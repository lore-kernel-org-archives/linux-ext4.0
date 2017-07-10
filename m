From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196223] jdb2 journal - hung after suspend-resume test
Date: Mon, 10 Jul 2017 12:58:31 +0000
Message-ID: <bug-196223-13602-RXtzCr66F1@https.bugzilla.kernel.org/>
References: <bug-196223-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47316 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753497AbdGJM6d (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 10 Jul 2017 08:58:33 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A709328462
        for <linux-ext4@vger.kernel.org>; Mon, 10 Jul 2017 12:58:32 +0000 (UTC)
In-Reply-To: <bug-196223-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196223

--- Comment #18 from Tomi Sarvela (tomi.p.sarvela@intel.com) ---
I managed to reproduce the bug on next-20170626 and earlier by running
igt@gem_exec_suspend@basic-s3 test back-to-back, takes ~5 runs. Later
next-kernels reproduce this issue on 1-2 runs.

./scripts/run-tests.sh -vt igt@gem_exec_suspend@basic-s3 -x devices

Issue is seen when igt test returns 'pass', but doesn't drop back to command
line. Repeated Ctrl-C gets to the command prompt. Cached commands work, but
anything that needs disk access doesn't.

linus-v4.12 handled ~10 runs without a problem, then same issue.

Dmesg shows in usual case something like:

[  137.351829] nvme nvme0: I/O 197 QID 0 timeout, disable controller
[  137.464115] nvme nvme0: failed to set APST feature (-4)
[  137.861403] EXT4-fs warning (device nvme0n1p2): ext4_end_bio:322: I/O error
10 writing to inode 1453376 (offset 0 size 4096 starting block 5949696)
[  137.861406] Buffer I/O error on device nvme0n1p2, logical block 5818368

I'm concerned about the 'disable controller' part.

Setup on this testing: KBL-7700K on MSI Z170 mb. Ubuntu base, Intel 600p M.2,
one DP connected to monitor.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
