From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76821] jbd2 write on disk each 2/3 seconds
Date: Sat, 24 May 2014 13:14:05 +0000
Message-ID: <bug-76821-13602-FgzNQ05va8@https.bugzilla.kernel.org/>
References: <bug-76821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40353 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbaEXNOJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 May 2014 09:14:09 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 41112201DD
	for <linux-ext4@vger.kernel.org>; Sat, 24 May 2014 13:14:08 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 1652E2024D
	for <linux-ext4@vger.kernel.org>; Sat, 24 May 2014 13:14:06 +0000 (UTC)
In-Reply-To: <bug-76821-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=76821

--- Comment #1 from Abdelhak Bougouffa <abdelhak@cryptolab.net> ---
Hi,
I have observed that "kworker" is writing to the disk even when no program
opened >.<, when I ran `iotop -Po` I see that "kworker" write more than jbd2
:-(

I have no idea how to solve this!

I searched the web and I found that many users have the same problem

https://bbs.archlinux.org/viewtopic.php?id=171608

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
