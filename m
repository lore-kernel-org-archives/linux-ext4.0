Return-Path: <SRS0=jZge=PK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:46324 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729586AbfABPA3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jan 2019 10:00:29 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 70D9F2896D
        for <linux-ext4@vger.kernel.org>; Wed,  2 Jan 2019 15:00:29 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 198187] jbd2_log_wait_commit hangs
Date: Wed, 02 Jan 2019 15:00:28 +0000
Message-ID: <bug-198187-13602-8AtdGefzuM@https.bugzilla.kernel.org/>
In-Reply-To: <bug-198187-13602@https.bugzilla.kernel.org/>
References: <bug-198187-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=198187

pkb07815 (pankajcabs@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |pankajcabs@gmail.com

--- Comment #13 from pkb07815 (pankajcabs@gmail.com) ---
I am facing similar problem with 4.9.86 kernel, do we have the root cause for
IO hangs?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
