Return-Path: <SRS0=z94b=OO=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:59182 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729312AbeLEJv2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Dec 2018 04:51:28 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F0D552CD3D
        for <linux-ext4@vger.kernel.org>; Wed,  5 Dec 2018 09:51:27 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 05 Dec 2018 09:51:26 +0000
Message-ID: <bug-201685-13602-X2e5DC7srh@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #266 from Rafał Miłecki (zajec5@gmail.com) ---
> So a workaround is to just disable blk-mq with SCIS: scsi_mod.use_blk_mq=1

I wasn't sure if that's a reliable workaround as it was being discussed before
the fix was provided. Thank you for clarifying that!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
