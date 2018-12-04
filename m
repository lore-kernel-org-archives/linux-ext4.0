Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34914 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726309AbeLDPDN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 10:03:13 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9FBB52BD5A
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 15:03:10 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 15:03:09 +0000
Message-ID: <bug-201685-13602-ZRkcAfMl0g@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #223 from Guenter Roeck (linux@roeck-us.net) ---
4.18.20 seems to be ok, except that my script overburdens it a bit.

[ 1088.450369] INFO: task systemd-tmpfile:31954 blocked for more than 120
seconds.
[ 1088.450374]       Not tainted 4.18.20+ #1
[ 1088.450375] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 1088.450377] systemd-tmpfile D    0 31954      1 0x00000000
[ 1088.450380] Call Trace:
[ 1088.450389]  __schedule+0x3f1/0x8c0
[ 1088.450392]  ? bit_wait+0x60/0x60
[ 1088.450394]  schedule+0x36/0x80
[ 1088.450398]  io_schedule+0x16/0x40
[ 1088.450400]  bit_wait_io+0x11/0x60
[ 1088.450403]  __wait_on_bit+0x63/0x90
[ 1088.450405]  out_of_line_wait_on_bit+0x8e/0xb0
[ 1088.450408]  ? init_wait_var_entry+0x50/0x50
[ 1088.450411]  __wait_on_buffer+0x32/0x40
[ 1088.450414]  __ext4_get_inode_loc+0x19f/0x3e0
[ 1088.450416]  ext4_iget+0x8f/0xc30

There is a key difference, though: With 4.18.20, cfq is active.

$ cat /sys/block/sd*/queue/scheduler
noop deadline [cfq] 
noop deadline [cfq] 

In 4.19, cfq is not available due to commit d5038a13eca72 ("scsi: core: switch
to scsi-mq by default"). I'll repeat my tests with SCSI_MQ_DEFAULT disabled on
v4.19, and with it enabled on v4.18.20. We know that disabling SCSI_MQ_DEFAULT
alone does not help, but maybe there is more than one problem.

Any takers for a round of bisects as suggested in #221 ?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
