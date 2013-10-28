From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 63981] Bad: Buffer I/O errors make disk unusable
Date: Mon, 28 Oct 2013 22:35:09 +0000
Message-ID: <bug-63981-13602-vlcGS82C9n@https.bugzilla.kernel.org/>
References: <bug-63981-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39803 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab3J1WfM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Oct 2013 18:35:12 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 150DE2037D
	for <linux-ext4@vger.kernel.org>; Mon, 28 Oct 2013 22:35:11 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 9638220364
	for <linux-ext4@vger.kernel.org>; Mon, 28 Oct 2013 22:35:09 +0000 (UTC)
In-Reply-To: <bug-63981-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=63981

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |tytso@mit.edu
         Resolution|---                         |INVALID

--- Comment #1 from Theodore Tso <tytso@mit.edu> ---
>From the errors listed in the dmesg, looks like it is a hardware problem with
the SSD, not an ext4 bug.

I'd suggest doing a full backup of your disk while you still can, and try
replacing the SSD....

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
