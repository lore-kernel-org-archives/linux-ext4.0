Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60320 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728001AbeK2CTO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 28 Nov 2018 21:19:14 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 284612D747
        for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2018 15:17:15 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 28 Nov 2018 15:17:14 +0000
Message-ID: <bug-201685-13602-f1LvCh9i7S@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #64 from Jens Axboe (axboe@kernel.dk) ---
(In reply to Jimmy.Jazz from comment #62)
> In that case, Jens Axboe 4.19.4 patch does its work. I'm bisecting the
> kernel on a 4.19.4 patched kernel version. The only fs that's stay corrupt
> after each reboot is my backup partition (sig).
> Could someone investigate in that direction please ?

How certain are you that my 4.19 patch fixes the issue completely for you? If
100%, can you also try with 4.19.4 + just the first hunk of that patch? In
other words, only apply the part to block/blk-core.c, not the one to
block/blk-mq.c

Thanks!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
