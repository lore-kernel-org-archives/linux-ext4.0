From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197069] systemd service with ProtectHome=yes causes ELOOP when
 accessing /home
Date: Sat, 30 Sep 2017 01:04:11 +0000
Message-ID: <bug-197069-13602-i7COQuZ1Am@https.bugzilla.kernel.org/>
References: <bug-197069-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50630 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752579AbdI3BEV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 29 Sep 2017 21:04:21 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B3D5E29248
        for <linux-ext4@vger.kernel.org>; Sat, 30 Sep 2017 01:04:20 +0000 (UTC)
In-Reply-To: <bug-197069-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=197069

--- Comment #2 from Jack (xxjack12xx@gmail.com) ---
According to CentOS, they say it's not a systemd bug
https://bugs.centos.org/view.php?id=13927

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
