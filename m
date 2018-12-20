Return-Path: <SRS0=ry50=O5=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53798 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732766AbeLTJ3n (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 20 Dec 2018 04:29:43 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5482A2866F
        for <linux-ext4@vger.kernel.org>; Thu, 20 Dec 2018 09:29:42 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Thu, 20 Dec 2018 09:29:42 +0000
Message-ID: <bug-201631-13602-B4GvfjpR0W@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #32 from Jan Kara (jack@suse.cz) ---
(In reply to Benjamin Herrenschmidt from comment #29)
> The problem is of course that not everybody *can* use the MMU notifiers.

Yes, I'm aware of that. So my comment about "well-behaved users" was probably a
bit overstated ;)

> Say I am KVM on POWER9, with the currently work-in-progress feature
> (unmerged patches) of exploiting the new HW support for interrupt
> virtualization.
> 
> In that context, the guest allocates a page for receiving interrupt events
> (it's a ring buffer) and "registers" it with the hypervisor (a hypercall).
> The HV gups it and passes the physical address to the HW, which will write
> to it from then on.
> 
> There's *nothing* KVM can do when getting the MMU notifier. The MM simply
> MUST NOT try to get rid of that page, it's going to be actively under HW use
> until the VM terminates.
> 
> How do we do that safely ?

Well, unless that page allocated by KVM comes from shared file mapping (and
from what you write there's no reason for it to be from such mapping), there's
nothing to worry about. GUP will get you page reference so that stops page
reclaim from reclaiming the page and for anonymous pages, there's no filesystem
trying to do anything clever about the page (like writing it back to disk).

> There is a very similar problem when doing PCI pass-through. The guest pages
> are GUP'ed and put into the IOMMU so the devices can DMA to them. Here too,
> there's nothing useful KVM can do on an MMU notifier, those pages must
> remain pinned until either the guest is terminated or the IOMMU mapping is
> removed (in the case where it's done via hypercalls).
> 
> So how do we do that in such a way that doesn't involve all the crashes,
> data loss etc... that you mention ?

This case is more difficult as often the pages you want to DMA into can
eventually come from userspace and thus can be from a shared file mapping (if
not, then again there's no problem). Essentially what you describe seems to be
a similar problem like RDMA (Infiniband and similar drivers) currently has. And
currently there's no good solution for that. We're trying to figure out how to
fix this but it's difficult - tons of GUP users, tons of filesystems, some GUP
users are very performance sensitive, and it's not like you have much space in
struct page for any tracking...

> Talking of which, I noticed the AMD GPU driver in the call traces above,
> could it be a similar case of fun with GUP ?

Where did you see AMD GPU? I didn't find it in the last dmesg and .config
doesn't seem to have anything GPU-related enabled. Also this particular problem
seems to be triggered by heavy compilation so it seems to be something else
than these GUP issues.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
