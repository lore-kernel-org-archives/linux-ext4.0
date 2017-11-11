From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151491] free space lossage on busy system with bigalloc enabled
 and 128KB cluster
Date: Sat, 11 Nov 2017 19:20:17 +0000
Message-ID: <bug-151491-13602-ytnS0SpV3X@https.bugzilla.kernel.org/>
References: <bug-151491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51616 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751757AbdKKTUV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 11 Nov 2017 14:20:21 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 0B682297D0
        for <linux-ext4@vger.kernel.org>; Sat, 11 Nov 2017 19:20:21 +0000 (UTC)
In-Reply-To: <bug-151491-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=151491

Theodore Tso (tytso@mit.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #5 from Theodore Tso (tytso@mit.edu) ---
Can you try replicating this on an upstream kernel, running in a controlled
environment (e.g., using kvm) and then give us reliable reproduction
instructions --- e.g., using simple shell scripts, and which doesn't depend on
the vagaries of the settop box software, and random versions of du, df, etc.

For bonus points, use get a copy of kvm-xfstests[1][2], and run the test using
scripts cut and pasted into "kvm-xfstests shell".   That way we will be able to
reproduce *exactly* what you are doing.

[1] https://github.com/tytso/xfstests-bld
[2]
https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-xfstests.md

Thanks!!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
