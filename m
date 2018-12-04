Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44656 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725797AbeLDS7k (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 13:59:40 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 919502BDC7
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 18:59:39 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 18:59:38 +0000
Message-ID: <bug-201685-13602-SSs6JSn4Wp@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #236 from Guenter Roeck (linux@roeck-us.net) ---
Excellent. Finally getting somewhere. FWIW, I am not able to reproduce the
problem (anymore) with v4.19.6 and SCSI_MQ_DEFAULT=n. At this point I am not
sure if my earlier test that saw it failing was a false positive. I'll try with
the two reverts suggested in #232  next.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
