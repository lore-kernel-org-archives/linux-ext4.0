From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60667] resizing ext4 with small block size corrupts filesystem
Date: Fri, 13 Feb 2015 14:02:36 +0000
Message-ID: <bug-60667-13602-clzpHMvzDo@https.bugzilla.kernel.org/>
References: <bug-60667-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47787 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbbBMOCk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Feb 2015 09:02:40 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id ECC2420172
	for <linux-ext4@vger.kernel.org>; Fri, 13 Feb 2015 14:02:38 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 0B60F20263
	for <linux-ext4@vger.kernel.org>; Fri, 13 Feb 2015 14:02:37 +0000 (UTC)
In-Reply-To: <bug-60667-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=60667

Trevor Jones <trevor.w.jones@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #1 from Trevor Jones <trevor.w.jones@gmail.com> ---
as of kernel 3.18.2 and e2fstools 1.42.10 this no longer happens.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
