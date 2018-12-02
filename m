Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51870 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725825AbeLBKZl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 05:25:41 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id ABA8D2B22B
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 10:25:39 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 10:25:39 +0000
Message-ID: <bug-201685-13602-KGoNh1D8pI@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #131 from Reindl Harald (harry@rhsoft.net) ---
has anybody ever seen that bug within a virtual machine?

i currently run 4.19.x only inside VMs on VMware Workstation / VMware ESXi and
did not see any issues, my only phyiscal test was my homeserver which
completley crahsed 4 times like because of the VMware Workstation 14
kernel-modules lasted only for a weekend (RAID10, 2 Samsung Evo 850 2 TB, 2
Samsung Evo 860 2 TB) after the last crash left a 0 byte "firewall.sh" in the
nested VM i was working for hours

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
