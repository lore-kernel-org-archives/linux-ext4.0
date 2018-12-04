Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47990 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725895AbeLDWSA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 17:18:00 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D5A1B2C845
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 22:17:59 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 22:17:58 +0000
Message-ID: <bug-201685-13602-ctNHMj3Fn1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #252 from Jens Axboe (axboe@kernel.dk) ---
(In reply to Guenter Roeck from comment #247)
> #245: Is there a means to log the possible error case ?

Yes, that's how I ended up verifying that this was indeed what was going on.
Example:

[  235.665576] issue_direct=13, 22080, ffff9ee3da59e400
[  235.931483] bio_attempt_back_merge: MERGE ON NO PREP ffff9ee3da59e400
[  235.931486] bio_attempt_back_merge: MERGE ON NO PREP ffff9ee3da59e400
[  235.931489] bio_attempt_back_merge: MERGE ON NO PREP ffff9ee3da59e400
[  235.934465] EXT4-fs error (device sda1): ext4_iget:4831: inode #7142: comm
dpkg-query: bad extra_isize 24937 (inode size 256)

Here we see req 0xffff9ee3da59e400 being rejected, due to resource starvation.
Shortly thereafter, we see us happily merging more IO into that request. Once
that request finishes, ext4 gets immediately unhappy as only a small part of
the request contents were valid. The rest simply contained garbage.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
