Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:33036 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730053AbeKVHMC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Nov 2018 02:12:02 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 977B12C459
        for <linux-ext4@vger.kernel.org>; Wed, 21 Nov 2018 20:36:09 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 21 Nov 2018 20:36:09 +0000
Message-ID: <bug-201685-13602-YcUQ3iJ86m@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #21 from Claude Heiland-Allen (claude@mathr.co.uk) ---
My kernels have this:

    4.18.19.config:CONFIG_SCSI_MQ_DEFAULT=y
    4.19.2.config:CONFIG_SCSI_MQ_DEFAULT=y
    4.20-rc3.config:CONFIG_SCSI_MQ_DEFAULT=y

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
