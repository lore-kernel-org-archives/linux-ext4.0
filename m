From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 109331] EXT4-fs (sda1): couldn't mount as ext3 due to feature
 incompatibilities
Date: Mon, 14 Dec 2015 05:02:25 +0000
Message-ID: <bug-109331-13602-SG5dT03AQc@https.bugzilla.kernel.org/>
References: <bug-109331-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57673 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbbLNFC2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Dec 2015 00:02:28 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 226D22058E
	for <linux-ext4@vger.kernel.org>; Mon, 14 Dec 2015 05:02:27 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 955E720534
	for <linux-ext4@vger.kernel.org>; Mon, 14 Dec 2015 05:02:25 +0000 (UTC)
In-Reply-To: <bug-109331-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=109331

--- Comment #2 from KernelBug <3fdd1e5d@opayq.com> ---
I do not have CONFIG_EXT4_USE_FOR_EXT23 compiled in the kernel.

After some reading, I'm seeing that the kernel looks for the filesystem, trying
them until it finds the one compiled in, hence the message?

>From what I've always thought, it's only going to look and see what is compiled
in, so I'm still not sure why I'm seeing this message.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
