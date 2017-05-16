From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195733] JBD2: [Suggested Patch]Spotted dirty metadata buffer
 (dev = sda1, blocknr = 1766784).There's a risk of filesystem corruption in
 case of system crash.
Date: Tue, 16 May 2017 12:19:01 +0000
Message-ID: <bug-195733-13602-yaXvVuIGgQ@https.bugzilla.kernel.org/>
References: <bug-195733-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45178 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751974AbdEPMTJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 16 May 2017 08:19:09 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9B16828A0D
        for <linux-ext4@vger.kernel.org>; Tue, 16 May 2017 12:19:03 +0000 (UTC)
In-Reply-To: <bug-195733-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195733

--- Comment #1 from jqiaoulk@gmail.com ---
Looks
https://github.com/torvalds/linux/commit/3b136499e906460919f0d21a49db1aaccf0ae963

did the similar change.

So will do the test.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
