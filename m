From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197069] systemd service with ProtectHome=yes causes ELOOP when
 accessing /home
Date: Sat, 30 Sep 2017 05:28:25 +0000
Message-ID: <bug-197069-13602-sDmO464eaG@https.bugzilla.kernel.org/>
References: <bug-197069-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45632 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750724AbdI3F2e (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 30 Sep 2017 01:28:34 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B88802977F
        for <linux-ext4@vger.kernel.org>; Sat, 30 Sep 2017 05:28:33 +0000 (UTC)
In-Reply-To: <bug-197069-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=197069

Theodore Tso (tytso@mit.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|REOPENED                    |RESOLVED
         Resolution|---                         |INVALID

--- Comment #4 from Theodore Tso (tytso@mit.edu) ---
According to Centos, it's not a bug in the Centos kernel.  That's why they
closed it.

And it's not an ext4 bug, which is why I'm closing it here.

Opening bugs in random bug trackers is not going to help you win friends, and
it's certainly not going to help you get it anyone to look at it.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
