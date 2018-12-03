Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60968 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725807AbeLCEbd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 23:31:33 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id E0FF42AA15
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 04:31:30 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 04:31:28 +0000
Message-ID: <bug-201685-13602-LZKd7zJ4kf@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #189 from Michael Orlitzky (michael@orlitzky.com) ---
(In reply to Theodore Tso from comment #179)
> Michael Orlitzky: In your report, you've indicated that you've only been
> seeing bugs in files that are being *read* and that these were files that
> were written long ago.    If you reboot, or drop caches using "echo 3 >
> /proc/sys/vm/drop_caches" do the files stay corrupted? 

Each time the corruption has been reported by the backup job that I run
overnight. When I see the failed report in the morning, I reboot into
SystemRescueCD (which is running 4.14.x) and then run fsck to fix things. The
fsck does indeed find a bunch of corruption, and appears to fix it.

The first couple of times I verified the corruption by running something like
"git gc" in the affected directory, and IIRC I got the same "structure needs
cleaning" error back. Before that, I hadn't touched that repo in a while. But
since then, I've just been rebooting immediately and running fsck -- each time
finding something wrong and (I hope) correcting it.

It takes about a week for the corruption to show up, but if there's some test
you need me to run I can boot back into 4.19.6 and roll the dice.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
