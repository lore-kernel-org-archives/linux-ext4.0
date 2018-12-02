Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:57650 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725856AbeLBOmN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 09:42:13 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 23A482A596
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 14:42:12 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 14:42:11 +0000
Message-ID: <bug-201685-13602-QQRuFuH32B@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #149 from Jens Axboe (axboe@kernel.dk) ---
(In reply to Jimmy.Jazz from comment #121)
> I have the problem again with kernel 4.19.5 (J. Axboe patches). Sorry I
> don't trust 4.19.x without Axboe patch because if some fs corruptions
> reappear they will be less violent than without the patch.

You had the issue with the full block patch applied, the one that includes both
the synchronize_rcu() and the quiesce? Or just the partial one I suggested
earlier?

> Result:
> The system doesn't see any error (fsck) on reboot (rescue and normal boot).

Interesting, so it didn't make it to media.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
