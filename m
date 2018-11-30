Return-Path: <SRS0=01R6=OJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44838 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725817AbeLAFzb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2018 00:55:31 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A74A830552
        for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2018 18:45:19 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Fri, 30 Nov 2018 18:45:19 +0000
Message-ID: <bug-201685-13602-eyptnrPR8r@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #97 from Guenter Roeck (linux@roeck-us.net) ---
#94 makes me wonder if the problem may be related to
https://lkml.org/lkml/2018/5/21/71. Just wondering, and I may be completely off
track, but that problem is still seen against the mainline kernel.

#96: commit ac22b46a0b65 can be reverted cleanly with "git revert".

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
