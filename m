From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195729] JBD2: Spotted dirty metadata buffer (dev = sda1,
 blocknr = 1766784).There's a risk of filesystem corruption in case of system
 crash.
Date: Fri, 12 May 2017 14:59:13 +0000
Message-ID: <bug-195729-13602-vgzAF8D4lM@https.bugzilla.kernel.org/>
References: <bug-195729-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43886 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756594AbdELO7T (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 12 May 2017 10:59:19 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D0CDA28834
        for <linux-ext4@vger.kernel.org>; Fri, 12 May 2017 14:59:13 +0000 (UTC)
In-Reply-To: <bug-195729-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195729

jqiaoulk@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |INVALID

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
