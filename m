From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 92271] Provide a way to really delete files, please
Date: Sat, 31 Jan 2015 20:56:12 +0000
Message-ID: <bug-92271-13602-dvmHTZ5ez0@https.bugzilla.kernel.org/>
References: <bug-92271-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38118 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbbAaU4Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 31 Jan 2015 15:56:16 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 680B12027D
	for <linux-ext4@vger.kernel.org>; Sat, 31 Jan 2015 20:56:14 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 55F7A201F4
	for <linux-ext4@vger.kernel.org>; Sat, 31 Jan 2015 20:56:12 +0000 (UTC)
In-Reply-To: <bug-92271-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=92271

--- Comment #12 from Alexander Holler <holler@ahsoftware.de> ---
I've took the time to write a bit more.

As already said, this bug isn't about the little problem which lead me to
write this bug.

It's a general problem.

People should be able to give away their phones, tablets, laptops or other
electronic devices by beeing able to delete everything they don't want
to give away, including but not restricted to, contact lists, photos,
messages and any other documents with informations they don't want to
share with others or even become public.

And it doesn't help if filesystem developers now blame storage for not
offering a way do delete blccks. Storage people just will answer that
filesystems didn't deleted files anyway in the past 30 years, so why
should storage offer a way to do so? And they are right, at least I'm
not aware of any filesystem which offers the user a way to selectively
delete a file.

So we are now in a catch 22, which is more bad than ever as it becomes
increasingly hard, if not impossible, to erase storage, especially because
storage will be more and more fixed (soldered) to devices, and devices
often don't offer a way to destroy the content on the storage.

Maybe you will think again about it, the next time you want to give away
your old phone or tablet.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
