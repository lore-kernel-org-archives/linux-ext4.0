From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151491] free space lossage on busy system with bigalloc enabled
 and 128KB cluster
Date: Mon, 20 Nov 2017 15:50:09 +0000
Message-ID: <bug-151491-13602-4iiHF8y1RA@https.bugzilla.kernel.org/>
References: <bug-151491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60056 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751301AbdKTPuM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 20 Nov 2017 10:50:12 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9229528D6A
        for <linux-ext4@vger.kernel.org>; Mon, 20 Nov 2017 15:50:11 +0000 (UTC)
In-Reply-To: <bug-151491-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=151491

--- Comment #12 from Eric Whitney (enwlinux@gmail.com) ---
After many attempts, I'm unable to reproduce the newly reported behavior for
the delalloc workaround in comment 11 on my x86-64 test system (which is not an
xfstests-bld test appliance) running either a current 4.14 kernel or an older
Debian Jessie 4.8 kernel.  I consistently get a reported value of 10240 1k
units, which is correct for the reported size.

However, in the process of running my trials I arrived at a simpler reproducer
that should be helpful in identifying the source of the original space
reporting problem.  There's no need to copy the first test file if the test
system's free memory is sufficiently limited relative to the size of the test
file - a simple sequential write of a single test file suffices.  In fact, the
tighter the free memory, the more likely the problem occurs and the likelihood
of larger reporting errors increases.  A test system with ample free memory
won't exhibit the problem at all.

I'm getting workable kernel traces with the simpler reproducer, and the free
memory-related behavior suggests a direction, so I'll see where that takes me.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
