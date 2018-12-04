Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:37310 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725875AbeLDXuT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 18:50:19 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 772372C9BD
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 23:50:18 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 23:50:17 +0000
Message-ID: <bug-201685-13602-QTQzeLuwRo@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #258 from Guenter Roeck (linux@roeck-us.net) ---
So far 30 minutes on two system running the patch from #255. Prior to that,
close to two hours running patch v1. No issues so far.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
