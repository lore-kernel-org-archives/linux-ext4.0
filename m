From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Mon, 09 Nov 2015 14:31:37 +0000
Message-ID: <bug-107301-13602-XGAxpfxiiZ@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35624 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbbKIObl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Nov 2015 09:31:41 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B695C20697
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2015 14:31:39 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 246F82068C
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2015 14:31:38 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

Sage Weil <sage@newdream.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sage@newdream.net

--- Comment #10 from Sage Weil <sage@newdream.net> ---
The most common Ceph xattr is ~270 bytes and always has a unique value.  There
are also a couple that are a few bytes each (and always the same), but i would
expect the little ones get inlined in the inode?

Anyway, it sounds like disabling mbcache would be a win!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
