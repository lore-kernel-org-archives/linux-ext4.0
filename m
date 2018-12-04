Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:52478 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725874AbeLDU7v (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 15:59:51 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 72CC92C773
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 20:59:50 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 20:59:49 +0000
Message-ID: <bug-201685-13602-QHTM1shKUH@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #240 from Guenter Roeck (linux@roeck-us.net) ---
As mentioned earlier, I only ever saw the problem on two of four systems (see
#57), all running the same kernel and the same version of Ubuntu. The only
differences are mainboard, CPU, and attached drive types.

I don't think we know for sure what it takes to trigger the problem. We have
seen various guesses, from gcc version to l1tf mitigation to CPU type, broken
hard drives, and whatnot. At this time evidence points to the block subsystem,
with bisect pointing to a commit which relies on the state of the HW queue
(empty or not) in conjunction with the 'none' io scheduler. This may suggest
that drive speed and access timing may be involved. That guess may of course be
just as wrong as all the others.

Let's just hope that Jens will be able to track down and fix the problem. Then
we may be able to get a better idea what it actually takes to trigger it.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
