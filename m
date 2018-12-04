Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50380 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725839AbeLDSJC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 13:09:02 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5B9412BF67
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 18:09:01 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 18:09:00 +0000
Message-ID: <bug-201685-13602-zCzZQ2IEiP@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #226 from Manfred (Manfred.Knick@T-Online.de) ---
(In reply to Steven Noonan from comment #225)

Thanks for pointing this out  -  forgot to mention:

# grep CONFIG_SCSI_MQ_DEFAULT config-4.19.3-gentoo

# CONFIG_SCSI_MQ_DEFAULT is not set                     < ---

HTH

Respectfully

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
