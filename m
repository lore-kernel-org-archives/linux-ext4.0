From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42986] ext2_fs.h requires undefined type umode_t
Date: Tue, 27 Mar 2012 05:58:48 GMT
Message-ID: <201203270558.q2R5wmf3032269@bugzilla.kernel.org>
References: <bug-42986-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:44650 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab2C0F6t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Mar 2012 01:58:49 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q2R5wnv8032270
	for <linux-ext4@vger.kernel.org>; Tue, 27 Mar 2012 05:58:49 GMT
In-Reply-To: <bug-42986-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42986





--- Comment #9 from Theodore Tso <tytso@mit.edu>  2012-03-27 05:58:48 ---
Breaking things at compile-time (as opposed to breaking already created
executables) is not something I worry that much about --- especially if they
are flags that are fairly specialized.   In fact I was quite surprised there
were programs other than lsattr/chattr that were using these ioctls.....

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
