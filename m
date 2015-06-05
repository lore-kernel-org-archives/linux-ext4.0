From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Fri, 05 Jun 2015 14:54:18 +0000
Message-ID: <bug-89511-13602-tQM9qfAxyV@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46683 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbbFEOyW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Jun 2015 10:54:22 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 893D82071A
	for <linux-ext4@vger.kernel.org>; Fri,  5 Jun 2015 14:54:21 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 5B0F2206BE
	for <linux-ext4@vger.kernel.org>; Fri,  5 Jun 2015 14:54:19 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #51 from Alan Stern <stern@rowland.harvard.edu> ---
For those new to this bug report, the interesting part starts here:

    https://bugzilla.kernel.org/show_bug.cgi?id=89511#c19

In short, these are USB drive adapters that doesn't support the
SYNCHRONIZE CACHE command but claim to be write-back.  (In at least 
one case, it initially claims to be write-through but then changes to 
write-back following a reset, or something like that.)

On Thu, 4 Jun 2015 bugzilla-daemon@bugzilla.kernel.org wrote:

> --- Comment #50 from Markus Rathgeb <maggu2810@gmail.com> ---
> I ran in the same trouble with an old USB case for 2.5'' IDE hard discs.
> 
> The drive cache_type is set to "write back" if it plugged in.
> The drive is working using if I set the cache type to "temporary write
> through".
> 
> So, I think this is the exact same problem discussed here.
> 
> At the moment I tested the workaround using v3.18.2 (gentoo-sources).
> Without the workaround the problem also exists using the Kernel v4.0.4 (used
> gentoo-sources, but I think that should not be related to the problem at all).
> 
> Is there anything I / we can do, to solve this problem at all in the kernel
> space (e.g. if SYNCHRONIZE CACHE command is not working, fallback to write
> through)?

This is up to the SCSI developers.

The real question is what should happen when a drive really does have a
write cache but doesn't recognize the SYNCHRONIZE CACHE command.  I
don't know what the kernel can do in this case -- maybe just log a
one-time error message and turn off sdkp->WCE?

Alan Stern

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
