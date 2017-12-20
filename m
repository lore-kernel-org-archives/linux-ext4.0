From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198187] jbd2_log_wait_commit hangs
Date: Wed, 20 Dec 2017 05:35:56 +0000
Message-ID: <bug-198187-13602-bbqdpBzaKY@https.bugzilla.kernel.org/>
References: <bug-198187-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:33860 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751649AbdLTFf6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 20 Dec 2017 00:35:58 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 748FD288FD
        for <linux-ext4@vger.kernel.org>; Wed, 20 Dec 2017 05:35:58 +0000 (UTC)
In-Reply-To: <bug-198187-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=198187

--- Comment #2 from Alexander V. Lukyanov (lav@yar.ru) ---
It happens every few days, maybe during logrotate at night. I have not found a
reliable sequence leading to the problem.

On the console or in dmesg output there were no unusual messages.

Hardware info attached as two files.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
