From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151491] free space lossage on busy system with bigalloc enabled
 and 128KB cluster
Date: Fri, 17 Nov 2017 16:00:14 +0000
Message-ID: <bug-151491-13602-AG86kgGwKE@https.bugzilla.kernel.org/>
References: <bug-151491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56772 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933796AbdKQQAP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 17 Nov 2017 11:00:15 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 53DDC2AC5D
        for <linux-ext4@vger.kernel.org>; Fri, 17 Nov 2017 16:00:15 +0000 (UTC)
In-Reply-To: <bug-151491-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=151491

--- Comment #11 from Betacentauri (betacentauri@arcor.de) ---
nodelalloc mount options workarounds the problem in the test environment. But I
also checked with real ARM system with 4.1.37 kernel:

root@sf4008:/media# mount 
...
/dev/sda on /media/sda type ext4 (rw,relatime,nodelalloc,data=ordered)
root@sf4008:/media# ls -las sda/testfiles/
 10240 -rw-r--r--    1 root     root      10485760 Nov 17 16:47 test
 10304 -rw-r--r--    1 root     root      10485760 Nov 17 16:47 test1

Test is a little bit different. Only 10 MB files are generated. In most cases
file size (first column) is equal, but in some cases file size still differs
like in above example. It's not deterministic for me when it happens. But I
only see 2 sizes. 10240 or 10304. With delalloc the file size was much more
random.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
