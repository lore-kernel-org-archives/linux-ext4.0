Return-Path: <SRS0=01R6=OJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53530 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725893AbeLAFRM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2018 00:17:12 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id AB61C30250
        for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2018 18:07:06 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Fri, 30 Nov 2018 18:07:06 +0000
Message-ID: <bug-201685-13602-08UqJFaW6d@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #95 from Jens Axboe (axboe@kernel.dk) ---
BTW, if that patch is to blame, then the bug is elsewhere in ext4 as there
should be no way that read-ahead failing should cause corruption.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
