Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55974 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726486AbeLDVuG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 16:50:06 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 134CB2C81E
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 21:50:06 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 21:50:03 +0000
Message-ID: <bug-201685-13602-3Gm8jh3bML@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #246 from Michel Roelofs (michel@michelroelofs.nl) ---
With 4.19.6, setting CONFIG_SCSI_MQ_DEFAULT=n seems to resolve the issue on my
system, going back to CONFIG_SCSI_MQ_DEFAULT=y makes it show up again. Indeed
all schedulers in /sys/devices/virtual/block/*/queue/scheduler are none.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
