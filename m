From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 192131] Hang up at boot time [<c0c4d1ac>] (io_schedule_timeout)
 from [<c0c4e344>] (bit_wait_i)
Date: Tue, 10 Jan 2017 07:39:10 +0000
Message-ID: <bug-192131-13602-iA2uU79xz4@https.bugzilla.kernel.org/>
References: <bug-192131-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758104AbdAJHjP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 10 Jan 2017 02:39:15 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 9D52A20375
        for <linux-ext4@vger.kernel.org>; Tue, 10 Jan 2017 07:39:13 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id EE48720373
        for <linux-ext4@vger.kernel.org>; Tue, 10 Jan 2017 07:39:10 +0000 (UTC)
In-Reply-To: <bug-192131-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=192131

Myy <bugux@miouyouyou.fr> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |PATCH_ALREADY_AVAILABLE

--- Comment #2 from Myy <bugux@miouyouyou.fr> ---
It turns out that the bug was in the new MMC code. Thanks to this patch from
Ziyuan Xu, I was able to fix the problem :
https://patchwork.kernel.org/patch/9498527/

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
