From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198187] jbd2_log_wait_commit hangs
Date: Mon, 18 Dec 2017 12:57:14 +0000
Message-ID: <bug-198187-13602-UMUZMzoVph@https.bugzilla.kernel.org/>
References: <bug-198187-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45598 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759391AbdLRM5Q (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 18 Dec 2017 07:57:16 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4CF5328F4C
        for <linux-ext4@vger.kernel.org>; Mon, 18 Dec 2017 12:57:16 +0000 (UTC)
In-Reply-To: <bug-198187-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=198187

Alexander V. Lukyanov (lav@yar.ru) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
               Tree|Mainline                    |Fedora

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
