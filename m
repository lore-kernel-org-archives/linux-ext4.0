Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53358 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726391AbeLDXiu (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 18:38:50 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D44712B66C
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 23:38:49 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 23:38:48 +0000
Message-ID: <bug-201685-13602-RmU4fF9iOL@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #257 from Jens Axboe (axboe@kernel.dk) ---
(In reply to Eric Benoit from comment #256)
> Over an hour now on 4.19.0 with commits 8824f62246 and 6ce3dd6eec reverted,
> and ZFS is happy. Plenty of IO and not a single checksum error.

Can you try 4.19.x with the patch from comment #255? Thanks!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
