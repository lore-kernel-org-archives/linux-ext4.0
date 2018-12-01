Return-Path: <SRS0=IALa=OK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34948 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725740AbeLBK5y (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 05:57:54 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 63FBD2BDB4
        for <linux-ext4@vger.kernel.org>; Sat,  1 Dec 2018 23:44:13 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sat, 01 Dec 2018 23:44:13 +0000
Message-ID: <bug-201685-13602-i2GUBdYLVE@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #115 from Guenter Roeck (linux@roeck-us.net) ---
Still playing. I have now seen the problem several times with the patches per
#99 reverted, I am just not 100% sure if I see false positives.

For those claiming that upstream developers don't care: I for my part do plan
to spend as much time on this as needed to nail down the problem, though I have
to admit that the comment in #87 almost made me quit (and wonder why I spend
time, energy, and money running kerneltests.org).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
