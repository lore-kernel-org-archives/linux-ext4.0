Return-Path: <SRS0=01R6=OJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53088 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725991AbeLAFPu (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2018 00:15:50 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3D8D230199
        for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2018 18:05:45 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Fri, 30 Nov 2018 18:05:45 +0000
Message-ID: <bug-201685-13602-GWTT9BkV13@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #94 from Jens Axboe (axboe@kernel.dk) ---
In terms of ext4 changes, it'd be interesting to just revert this one:

commit ac22b46a0b65dbeccbf4d458db95687e825bde90
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri Aug 17 15:45:42 2018 -0700

    ext4: readpages() should submit IO as read-ahead

as that guy is generally just not trust worthy. In all seriousness, though, it
shouldn't cause issues (or I would not have done it), and we already do this
for readpages in general, but I guess we could have an older bug in ext4 that
depends deeply on read-ahead NOT failing. Not sure how likely that is, Ted can
probably comment on that.

But it's a trivial revert, and it could potentially be implicated.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
