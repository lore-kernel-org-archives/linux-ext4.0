Return-Path: <SRS0=yRHK=OD=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49094 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726372AbeKXX4Y (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 24 Nov 2018 18:56:24 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 53E642AB97
        for <linux-ext4@vger.kernel.org>; Sat, 24 Nov 2018 13:08:00 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sat, 24 Nov 2018 13:07:59 +0000
Message-ID: <bug-201685-13602-ks3g5ECvT6@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

AdamB (abennett72@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |abennett72@gmail.com

--- Comment #39 from AdamB (abennett72@gmail.com) ---
I also experienced an ext4 file system corruption with 4.19.1, after resuming
from suspend-to-ram.

I've ran 4.12, 13, 14, 16, 17, and 18 on the same machine with near identical
.config and never had a file system corruption.

For all those kernels, I've had CONFIG_SCSI_MQ_DEFAULT=y.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
