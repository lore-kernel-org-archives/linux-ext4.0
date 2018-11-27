Return-Path: <SRS0=F3Rs=OG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:38708 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726277AbeK1Ixz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 28 Nov 2018 03:53:55 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 480A72C8EC
        for <linux-ext4@vger.kernel.org>; Tue, 27 Nov 2018 21:54:37 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 27 Nov 2018 21:54:37 +0000
Message-ID: <bug-201685-13602-6bpm3M7oJ0@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Guenter Roeck (linux@roeck-us.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |linux@roeck-us.net

--- Comment #57 from Guenter Roeck (linux@roeck-us.net) ---
I have seen the problem on two of four systems running v4.19.4. All systems are 

System 1:
  MSI B450 TOMAHAWK (MS-7C02)
  Ryzen 2700X
  Drive 1: NVME (500GB)
  Drive 2: SATA HDD (WD4001FAEX-00MJRA0, 4TB)
  Problem seen on SATA HDD, with both 4.19.3 and 4.19.4

System 2:
  MSI B350M MORTAR (MS-7A37)
  Ryzen 1700X
  Drive 1: SSD Samsung SSD 840 PRO 250GB
  Drive 2: SSD Samsung SSD 840 EVO 250GB
  Problem seen on both drives, with both 4.19.3 and 4.19.4

System 3:
  Gigabyte AB350M-Gaming 3
  Ryzen 1700X
  Drive 1: SSD Samsung SSD 840 PRO 250GB
  Drive 2: SSD M4-CT256M4SSD2 (250GB)
  Problem not seen (yet)

System 4:
  MSI B350M MORTAR (MS-7A37)
  Ryzen 1700X
  Drive 1: NVME (500GB)
  Problem not seen (yet)

Default configuration was CONFIG_SCSI_MQ_DEFAULT=y. I tried with
CONFIG_SCSI_MQ_DEFAULT=n on system 2 (with 4.19.4) and hit the problem again
almost immediately.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
