Return-Path: <SRS0=G5ay=OI=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58030 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727114AbeK2WRg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 29 Nov 2018 17:17:36 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 64D092EE6A
        for <linux-ext4@vger.kernel.org>; Thu, 29 Nov 2018 11:12:36 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Thu, 29 Nov 2018 11:12:36 +0000
Message-ID: <bug-201685-13602-Yvx01xZljR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Ortwin Glück (odi@odi.ch) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |odi@odi.ch

--- Comment #71 from Ortwin Glück (odi@odi.ch) ---
If it helps, I do NOT see this bug and I've run all 4.18.y and 4.19.y kernels:
CONFIG_SCSI_MQ_DEFAULT=y
CONFIG_MQ_IOSCHED_DEADLINE=y

rootfs on RAID-0 on 2 SSDs:
cat /proc/mdstat 
Personalities : [raid0] 
md127 : active raid0 sdb1[1] sda3[0]
      499341824 blocks super 1.2 256k chunks

/dev/md127 on / type ext4 (rw,noatime,discard,stripe=128)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
