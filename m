Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60126 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725918AbeLCO5x (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2018 09:57:53 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id CD4882B080
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 14:57:51 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 14:57:49 +0000
Message-ID: <bug-201685-13602-D0Rob4JkIR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #200 from Ortwin Glück (odi@odi.ch) ---
Oh wow, qemu/KVM does support multi-queue disks!
-drive file=${DISK},cache=writeback,id=d0,if=none
-device virtio-blk-pci,drive=d0,num-queues=4

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
