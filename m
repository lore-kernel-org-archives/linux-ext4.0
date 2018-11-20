Return-Path: <SRS0=dvF+=N7=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34744 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730710AbeKTQY4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 20 Nov 2018 11:24:56 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2F91B2A2F2
        for <linux-ext4@vger.kernel.org>; Tue, 20 Nov 2018 05:57:36 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 20 Nov 2018 05:57:36 +0000
Message-ID: <bug-201685-13602-e8CWRHaZRX@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

m@maltris.org changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |m@maltris.org

--- Comment #7 from m@maltris.org ---
Confirming for now, similar problems with 4.19.1, 4.19.2, 4.20-rc1, 4.20-rc2
and 4.20-rc3 from the Ubuntu mainline-kernel repository
(http://kernel.ubuntu.com/~kernel-ppa/mainline/).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
