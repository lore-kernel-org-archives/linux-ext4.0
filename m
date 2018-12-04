Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:46838 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726056AbeLDRwD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 12:52:03 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B36262BEC0
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 17:52:02 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 17:52:01 +0000
Message-ID: <bug-201685-13602-SbewZKpROy@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #224 from Manfred (Manfred.Knick@T-Online.de) ---
(In reply to Guenter Roeck from comment #223)

> There is a key difference, though: With 4.18.20, cfq is active.
> 
> $ cat /sys/block/sd*/queue/scheduler
> noop deadline [cfq] 
> noop deadline [cfq] 
> 
> In 4.19, cfq is not available    <--- ?

# grep  -i cfq    config-4.19.3-gentoo

CONFIG_IOSCHED_CFQ=y                       < --- !
# CONFIG_CFQ_GROUP_IOSCHED is not set
CONFIG_DEFAULT_CFQ=y
CONFIG_DEFAULT_IOSCHED="cfq"

did not run me into trouble.

Being a production machine, reverted it to

### INFO:

# uname -a
Linux XXX 4.18.20-gentoo #1 SMP Wed Nov 28 12:30:28 CET 2018 
x86_64 Intel(R) Xeon(R) CPU E3-1276 v3 @ 3.60GHz GenuineIntel GNU/Linux

Running Gentoo "stable" (with *very* few exceptions)

# equery list gcc
[IP-] [  ] sys-devel/gcc-7.3.0-r3:7.3.0

Exploiting disks directly attached @ ASUS Workstation MoBo P9D-WS :
   Samsung SSD,
   multiple S-ATA HDD fom 5000 GB up to 6 TB, ...
as well as e.g. Adaptec SCSI Raid-1, 2 x WD 500

running stable till this evening.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
