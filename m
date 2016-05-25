From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118511] Corruption of VM qcow2 image file on EXT4 with crypto
 enabled
Date: Wed, 25 May 2016 17:45:44 +0000
Message-ID: <bug-118511-13602-uoMtlifVDx@https.bugzilla.kernel.org/>
References: <bug-118511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55619 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbcEYRps (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 May 2016 13:45:48 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C23DC2040F
	for <linux-ext4@vger.kernel.org>; Wed, 25 May 2016 17:45:46 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id E0B2F203F1
	for <linux-ext4@vger.kernel.org>; Wed, 25 May 2016 17:45:44 +0000 (UTC)
In-Reply-To: <bug-118511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118511

--- Comment #2 from ass3mbler@gmail.com ---
Hi Navin,

thank you a lot for your help, I'll upgrade the kernel to the v4.6 today's
night to see if it gets better!

I have some doubt about a real out-of-memory condition since the Hypervisor has
8GB of RAM, the Guest is hard-limited to 4GB and the only other "big" process
running on the Hypervisor is a simple (mostly idle) opensshd server instance...
so I really hope that the patch will solve the issue.

I'll let you know very shortly, thank you again for your precious help and best
regards,

Andrew



(In reply to Navin from comment #1)
> Can you check the memory state of Host/Hypervisor if is full around the
> range [596476,596478.]  so that 596477.535490 when ext4_bio_write_page is
> not able to get memory ? 
> 
> If your hypervisor is using encryption then this patch may help (already
> present in 4.6 mainline)
> 
> https://patchwork.ozlabs.org/patch/602204/
> 
> If that doesn't work then ,You need to your system stats logged and check
> and check when ENOMEM is returned. It could genuinely out of memory or there
> could be something wrong with code.
> 
> Hypervisor/Host cannot write/commit/allocate buffers because it is out of
> memory. 
> 
> Hence your guest is in a transient state where the change are not committed
> and most probably journal is aborted.
> 
> 
> [[Hypervisor]]
> [596477.535490] ext4_bio_write_page: ret = -12
> 
> http://lxr.free-electrons.com/source/include/uapi/asm-generic/errno-base.
> h#L15
> 
>  15 #define ENOMEM          12      /* Out of memory */

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
