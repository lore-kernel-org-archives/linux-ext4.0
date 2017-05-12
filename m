From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195733] JBD2: [Suggested Patch]Spotted dirty metadata buffer
 (dev = sda1, blocknr = 1766784).There's a risk of filesystem corruption in
 case of system crash.
Date: Fri, 12 May 2017 15:26:42 +0000
Message-ID: <bug-195733-13602-V5GgMqeghR@https.bugzilla.kernel.org/>
References: <bug-195733-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47074 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756678AbdELP0n (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 12 May 2017 11:26:43 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 988E328842
        for <linux-ext4@vger.kernel.org>; Fri, 12 May 2017 15:26:42 +0000 (UTC)
In-Reply-To: <bug-195733-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195733

jqiaoulk@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|JBD2: Spotted dirty         |JBD2: [Suggested
                   |metadata buffer (dev =      |Patch]Spotted dirty
                   |sda1, blocknr =             |metadata buffer (dev =
                   |1766784).There's a risk of  |sda1, blocknr =
                   |filesystem corruption in    |1766784).There's a risk of
                   |case of system crash.       |filesystem corruption in
                   |                            |case of system crash.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
