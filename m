From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 84201] mount doesn't clear usrjquota / grpjqouta options
Date: Tue, 16 Sep 2014 20:23:55 +0000
Message-ID: <bug-84201-13602-mOxHjWJud5@https.bugzilla.kernel.org/>
References: <bug-84201-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57140 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbaIPUX6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Sep 2014 16:23:58 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 81F49201F5
	for <linux-ext4@vger.kernel.org>; Tue, 16 Sep 2014 20:23:57 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 20DE0201B4
	for <linux-ext4@vger.kernel.org>; Tue, 16 Sep 2014 20:23:56 +0000 (UTC)
In-Reply-To: <bug-84201-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=84201

--- Comment #8 from Jan Kara <jack@suse.cz> ---
Ah, OK. I've checked the code again and now I see the problem. The message is
about jqfmt being specified but no quota file name. But there's no way to zero
out jqfmt on remount. So the only way to get rid of quota options is to unmount
the filesystem (= reboot for you since this is your root filesystem).

Attached patch should fix your problem.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
