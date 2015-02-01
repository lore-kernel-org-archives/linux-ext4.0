From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 92271] Provide a way to really delete files, please
Date: Sun, 01 Feb 2015 10:14:39 +0000
Message-ID: <bug-92271-13602-rS2dmH3FhI@https.bugzilla.kernel.org/>
References: <bug-92271-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48705 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbbBAKOn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Feb 2015 05:14:43 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 67ACF202A1
	for <linux-ext4@vger.kernel.org>; Sun,  1 Feb 2015 10:14:42 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 36CAF20218
	for <linux-ext4@vger.kernel.org>; Sun,  1 Feb 2015 10:14:40 +0000 (UTC)
In-Reply-To: <bug-92271-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=92271

--- Comment #14 from Alexander Holler <holler@ahsoftware.de> ---
The FS doesn't have to give a promise for the storage.

If the storage doesn't overwrite the same blocks (which it did for 25 years and
still does on most conventional HDs) and doesn't offer a way to really get rid
of stuff (like Secure Trim), then the storage can be blamed.

Using encryption is just a workaround. And what makes you believe that the used
encryption is secure? Or that the used encryption is still secure in some
years. Encryption often suffers under bugs in the implementation, bugs in the
algorithm itself and from Moore. Just think at all the "encrypted"
zip-archives. I a few years people might laught about the stuff used today to
encrypt.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
