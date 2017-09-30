From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197069] systemd service with ProtectHome=yes causes ELOOP when
 accessing /home
Date: Sat, 30 Sep 2017 07:40:36 +0000
Message-ID: <bug-197069-13602-qDhC6ppuHe@https.bugzilla.kernel.org/>
References: <bug-197069-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:59658 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750933AbdI3Hki (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 30 Sep 2017 03:40:38 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id E55DC29683
        for <linux-ext4@vger.kernel.org>; Sat, 30 Sep 2017 07:40:37 +0000 (UTC)
In-Reply-To: <bug-197069-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=197069

Jack (xxjack12xx@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |REOPENED
         Resolution|INVALID                     |---

--- Comment #5 from Jack (xxjack12xx@gmail.com) ---
Your opinion that I made a mistake in opening bug reports in random bug
trackers and trying to win friends in a place where I'm sure it wouldn't help
either way is very condescending. I'm reporting this bug because this bug
happens in the kernel series 4.4 and 4.9 lt series after the commit I had
mentioned previously. The bug does not happen in the same 4.4 and 4.9 series
before the commit.

Instead of closing my issue, how about helping me find the correct place to
report it? Obviously I don't know where I should file it under because I seem
to have posted it in a random place.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
