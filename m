Return-Path: <SRS0=EV/E=O6=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:35294 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725781AbeLULwh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 21 Dec 2018 06:52:37 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id AAFB12850F
        for <linux-ext4@vger.kernel.org>; Fri, 21 Dec 2018 11:52:36 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Fri, 21 Dec 2018 11:52:36 +0000
Message-ID: <bug-201631-13602-byTU9xnOH7@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #36 from erhard_f@mailbox.org ---
(In reply to Benjamin Herrenschmidt from comment #29)
> [...]
> Talking of which, I noticed the AMD GPU driver in the call traces above,
> could it be a similar case of fun with GUP ?

If you are talking about the "[    4.883250] radeon: No suitable DMA available"
message, this has also been the case before kernel 4.20-rc*. There also have
been some DMA-related patches from
https://git.raptorengineering.com/git/op-kernel-dev/log/?h=raptor-dma-dev-4.18-pre.
Don't know if they reslove this error message of if they have been taken
upstream already.

The card is BTW a Radeon HD 6450, which is running fine on the Talos II.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
