From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 92271] Provide a way to really delete files, please
Date: Thu, 29 Jan 2015 20:59:20 +0000
Message-ID: <bug-92271-13602-AOBlyS3Bjb@https.bugzilla.kernel.org/>
References: <bug-92271-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33178 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbbA2U7X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Jan 2015 15:59:23 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 384F72025A
	for <linux-ext4@vger.kernel.org>; Thu, 29 Jan 2015 20:59:22 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id C2B962024D
	for <linux-ext4@vger.kernel.org>; Thu, 29 Jan 2015 20:59:20 +0000 (UTC)
In-Reply-To: <bug-92271-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=92271

--- Comment #4 from Alexander Holler <holler@ahsoftware.de> ---
But I have to admit that ext4 seems to be better than btrfs in regard to that
problem.

At lease the quick test I just did makes me believe that using shred on ext4
might overwrite the previously used blocks.

See bug #92271 to see what I did to quickly test it.

But the problem with SSDs and similiar still exists.

Besides that the FS should somehow promise, that it really has overwritten the
old blocks (even if it hasn't really control about what the device does (if not
using something like "Secure Trim").

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
