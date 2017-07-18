From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Tue, 18 Jul 2017 21:07:37 +0000
Message-ID: <bug-196405-13602-nFjg3kP9ne@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60846 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752013AbdGRVHl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 18 Jul 2017 17:07:41 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C2006285F0
        for <linux-ext4@vger.kernel.org>; Tue, 18 Jul 2017 21:07:40 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

--- Comment #2 from michelbach94@gmail.com ---
Thank you, Ted.

Is it necessary for it to "break" (quotes because 1 seems to be a kind-of
wildcard) at such a low and weird value?

This behavior doesn't occur with ext4 ram disks. Run the same command, possibly
with an even higher number, but within an ext4 ram disk, created via

    $ sudo mount -t ramfs -o size=4G ext4 <path>

Example output:

    $ ll
    total 4
    drwxr-xr-x      3 christoph root         0 Jul 18 22:59 ./
    drwxrwxrwt     18 root      root      4096 Jul 18 23:00 ../
    drwxrwxr-x 446639 christoph christoph    0 Jul 18 23:05 d/

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
