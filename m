Return-Path: <SRS0=G5ay=OI=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51030 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726393AbeK3Jpf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Nov 2018 04:45:35 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id BE308288EC
        for <linux-ext4@vger.kernel.org>; Thu, 29 Nov 2018 22:38:31 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Thu, 29 Nov 2018 22:38:21 +0000
Message-ID: <bug-201685-13602-sJb3Lm1PNR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Michael Orlitzky (michael@orlitzky.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |michael@orlitzky.com

--- Comment #74 from Michael Orlitzky (michael@orlitzky.com) ---
(In reply to Laurent Bonnaud from comment #67)
> I am also experiencing ext4 corruptions with 4.19.x kernels.
> 
> One way to trigger this bug that works almost every time on my system is to
> backup the whole FS with BorgBackup using this command:
> 

Ouch, me too. I've already been through two hard drives and a new SATA
controller. I was just about to resign myself to replacing the whole PC.

My system is an older AMD Phenom, with absolutely nothing fancy going on.
Boring spinning disks, no RAID, and exactly the symptom above.

After upgrading to 4.19.0 everything was fine for a week, and then Borg started
reporting these errors. If I boot to a rescue CD and fsck, things go back to
"normal," but then after a few more days I get corruption again. IIRC I skipped
4.19.1 but had the same problem with 4.19.2, and now again on 4.19.3.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
