From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61601] rootflags=noatime causes kernel panic when booting
 without initrd.
Date: Mon, 07 Apr 2014 15:27:25 +0000
Message-ID: <bug-61601-13602-aJWRwCllQB@https.bugzilla.kernel.org/>
References: <bug-61601-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43931 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbaDGP12 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Apr 2014 11:27:28 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2B4312039D
	for <linux-ext4@vger.kernel.org>; Mon,  7 Apr 2014 15:27:27 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 8E0812037D
	for <linux-ext4@vger.kernel.org>; Mon,  7 Apr 2014 15:27:25 +0000 (UTC)
In-Reply-To: <bug-61601-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61601

Johannes Hirte <johannes.hirte@datenkhaos.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |johannes.hirte@datenkhaos.d
                   |                            |e

--- Comment #4 from Johannes Hirte <johannes.hirte@datenkhaos.de> ---
This isn't ext4 specific, I have the same problem with btrfs. And from a short
search, this problem isn't new at all:
http://forums.gentoo.org/viewtopic-p-7238926.html?sid=6e8180da852b6b71dea57abf4bf58bce#6894398

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
