Return-Path: <SRS0=ry50=O5=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43232 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729693AbeLTIVL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 20 Dec 2018 03:21:11 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 8FB4928595
        for <linux-ext4@vger.kernel.org>; Thu, 20 Dec 2018 08:21:10 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Thu, 20 Dec 2018 08:21:10 +0000
Message-ID: <bug-201631-13602-TaYmXcvzQk@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #29 from Benjamin Herrenschmidt (benh@kernel.crashing.org) ---
The problem is of course that not everybody *can* use the MMU notifiers.

Say I am KVM on POWER9, with the currently work-in-progress feature (unmerged
patches) of exploiting the new HW support for interrupt virtualization.

In that context, the guest allocates a page for receiving interrupt events
(it's a ring buffer) and "registers" it with the hypervisor (a hypercall). The
HV gups it and passes the physical address to the HW, which will write to it
from then on.

There's *nothing* KVM can do when getting the MMU notifier. The MM simply MUST
NOT try to get rid of that page, it's going to be actively under HW use until
the VM terminates.

How do we do that safely ?

There is a very similar problem when doing PCI pass-through. The guest pages
are GUP'ed and put into the IOMMU so the devices can DMA to them. Here too,
there's nothing useful KVM can do on an MMU notifier, those pages must remain
pinned until either the guest is terminated or the IOMMU mapping is removed (in
the case where it's done via hypercalls).

So how do we do that in such a way that doesn't involve all the crashes, data
loss etc... that you mention ?

Talking of which, I noticed the AMD GPU driver in the call traces above, could
it be a similar case of fun with GUP ?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
