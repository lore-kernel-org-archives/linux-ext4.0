From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60667] resizing ext4 with small block size corrupts filesystem
Date: Fri, 13 Feb 2015 15:58:03 +0000
Message-ID: <bug-60667-13602-y2nwtTVHjM@https.bugzilla.kernel.org/>
References: <bug-60667-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52411 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811AbbBMP6H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Feb 2015 10:58:07 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 22D5920268
	for <linux-ext4@vger.kernel.org>; Fri, 13 Feb 2015 15:58:05 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E0AE220256
	for <linux-ext4@vger.kernel.org>; Fri, 13 Feb 2015 15:58:03 +0000 (UTC)
In-Reply-To: <bug-60667-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=60667

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #2 from Theodore Tso <tytso@mit.edu> ---
... and there was even more resize2fs bugs (and even a security bug or two)
fixed in 1.42.12.

(Wow, a Gentoo user not using a bleeding edge release.  :-)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
