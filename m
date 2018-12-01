Return-Path: <SRS0=IALa=OK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47162 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726717AbeLBCsE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2018 21:48:04 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F19EF2D8DD
        for <linux-ext4@vger.kernel.org>; Sat,  1 Dec 2018 15:35:17 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sat, 01 Dec 2018 15:35:16 +0000
Message-ID: <bug-201685-13602-boz2ru6bMz@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #110 from Bart Van Assche (bvanassche@acm.org) ---
(In reply to Marc Koschewski from comment #109)
> Could it be hardware related like ie. blacklisted "trim" for ie. Samsung 850
> Pro? Are the 4 machines absoutely equal hardware-wise (at least on the block
> layer)? Maybe such a quirk is needed for just another device...

Marc, are you using an I/O scheduler? I'm not using an I/O scheduler:

$ cat /sys/block/sda/queue/scheduler 
[none]

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
