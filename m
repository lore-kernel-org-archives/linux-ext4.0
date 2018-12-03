Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60204 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726146AbeLCLDt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2018 06:03:49 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 343DD2B217
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 11:03:15 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 11:03:14 +0000
Message-ID: <bug-201685-13602-jUuTCu0a0I@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #195 from Rainer Fiebig (jrf@mailbox.org) ---
#193
>I am desperately trying to reproduce this in a qemu/KVM virtual machine with
>the configs >given by those users. But until now to no avail.

Good luck, Mr. Glück! ;)
My VirtualBox-VM seems immune to this issue. Perhaps VMs have just the right
"hardware".

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
