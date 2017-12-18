From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198187] jbd2_log_wait_commit hangs
Date: Mon, 18 Dec 2017 23:39:10 +0000
Message-ID: <bug-198187-13602-uWQarARA54@https.bugzilla.kernel.org/>
References: <bug-198187-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58154 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759867AbdLRXjL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 18 Dec 2017 18:39:11 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B8FED28E05
        for <linux-ext4@vger.kernel.org>; Mon, 18 Dec 2017 23:39:10 +0000 (UTC)
In-Reply-To: <bug-198187-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=198187

Theodore Tso (tytso@mit.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #1 from Theodore Tso (tytso@mit.edu) ---
How often/frequently/reliably does the problem reproduce?

Can you get console messages either from dmesg or copied from a serial console
(if you have serial console monitoring)?   Also useful would be to get the
output from the following magic sysrq sequences: sysrq-l and sysrq-t  (this
involves using the break key if you are using a serial console, which is the
most desirable way to get the output since there is a huge amount of ouput).

Also, please let us know what the hardware configuration is, since it's
possible this is related to change in a block device driver.

Finally, please file a bug with Fedora since this may be something which is
caused by a Fedora specific patch and the Fedora kernel maintainers are more
likely to be able to notice clustering of symptoms from Fedora users.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
