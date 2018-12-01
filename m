Return-Path: <SRS0=IALa=OK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34578 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726458AbeLBBdg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2018 20:33:36 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 23F512E0BA
        for <linux-ext4@vger.kernel.org>; Sat,  1 Dec 2018 14:20:59 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sat, 01 Dec 2018 14:20:59 +0000
Message-ID: <bug-201685-13602-dQyXeJQF5v@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #106 from Guenter Roeck (linux@roeck-us.net) ---
I have seen the problem again tonight, but I am not sure if I cleaned the
affected file system correctly with an older kernel before I started the test.
I'll keep running with the same reverts for another day.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
