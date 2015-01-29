From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 92271] Provide a way to really delete files, please
Date: Thu, 29 Jan 2015 19:49:51 +0000
Message-ID: <bug-92271-13602-33GMbVggfT@https.bugzilla.kernel.org/>
References: <bug-92271-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58512 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbbA2Ttz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Jan 2015 14:49:55 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 58E932025B
	for <linux-ext4@vger.kernel.org>; Thu, 29 Jan 2015 19:49:54 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 6BE1520254
	for <linux-ext4@vger.kernel.org>; Thu, 29 Jan 2015 19:49:52 +0000 (UTC)
In-Reply-To: <bug-92271-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=92271

--- Comment #3 from Alexander Holler <holler@ahsoftware.de> ---
It doesn't work for on FLASH based devices which have their own logic (e.g.
SD-cards or SSDs, there "Secure Trim" is needed). 

And just overwriting a file by using open(); write(); close(); likely doesn't
work with ext4 on traditional harddisks (or similiar blockdevices) too.

Also I'm not sure about the last fact, as I'm not really aware of the internal
workings of ext4.

At least I've never read anywhere a statement, that by writing the same amount
of bytes to a file as already there, the fs will for sure overwrite the same
blocks on disk as already occupied/used by the file.

So a special syscall or similiar is needed to instruct the fs to overwrite the
same, already used blocks (even if they are stored only in the metadata because
the file is small enough).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
