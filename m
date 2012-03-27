From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42986] ext2_fs.h requires undefined type umode_t
Date: Tue, 27 Mar 2012 05:33:47 GMT
Message-ID: <201203270533.q2R5Xl42031625@bugzilla.kernel.org>
References: <bug-42986-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:44588 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab2C0Fds (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Mar 2012 01:33:48 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q2R5XlNZ031626
	for <linux-ext4@vger.kernel.org>; Tue, 27 Mar 2012 05:33:47 GMT
In-Reply-To: <bug-42986-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42986





--- Comment #8 from H. Peter Anvin <hpa@zytor.com>  2012-03-27 05:33:47 ---
That's fine, but it's also a gratuitous change to previously working userspace.
 It sounds like the right thing would be to leave <linux/ext2_fs.h> in place
exporting only those constants as a backwards compatibility measure.

I can update Syslinux, but it isn't just about Syslinux; in general it's rude
to break userspace unnecessarily :-/

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
