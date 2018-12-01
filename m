Return-Path: <SRS0=IALa=OK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34670 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725726AbeLBFkJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 00:40:09 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9840A2B7B4
        for <linux-ext4@vger.kernel.org>; Sat,  1 Dec 2018 18:27:02 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sat, 01 Dec 2018 18:27:02 +0000
Message-ID: <bug-201685-13602-OOivjxRANL@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #112 from Néstor A. Marchesini (nestorm_des@hotmail.com) ---

$ zcat /proc/config.gz |grep DAX
CONFIG_DAX=m
# CONFIG_FS_DAX is not set

DAX I have it as a module, but I've never seen it loaded with lsmod.

$ cat /sys/block/sda/queue/scheduler
[none]

Always use the mounting parameters in my partitions  barrier=1,data=ordered

$ cat /etc/fstab |grep LABEL
LABEL=GentooBoot  /boot    ext4   noatime,noauto,barrier=1,data=ordered    0 2
LABEL=GentooSwap  none     swap   swap  0 0
LABEL=GentooRaiz  /        ext4   noatime,barrier=1,data=ordered   0 1
LABEL=GentooHome  /home    ext4   noatime,barrier=1,data=ordered   0 2

Excellent point given by Guenter Roeck in comment 93
I would have to try to create several trees 4.19.5 and be removed one or two at
a time,
to isolate the fault.
I still use 4.19.5 with the ext4 folder of 4.18.20 and zero problems.

Regards

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
