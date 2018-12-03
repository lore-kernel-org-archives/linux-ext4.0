Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51536 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726046AbeLCKrH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2018 05:47:07 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 82D1B2B149
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 10:46:36 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 10:46:35 +0000
Message-ID: <bug-201685-13602-KiT5PtqLIR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #193 from Ortwin Glück (odi@odi.ch) ---
I am desperately trying to reproduce this in a qemu/KVM virtual machine with
the configs given by those users. But until now to no avail.

If anybody has seen this issue in a VM please share your .config, mount options
of all filesystems, kernel command line, and possibly workload that you are
running.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
