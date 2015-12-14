From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 109331] EXT4-fs (sda1): couldn't mount as ext3 due to feature
 incompatibilities
Date: Mon, 14 Dec 2015 21:19:27 +0000
Message-ID: <bug-109331-13602-B9gl8Udf9Q@https.bugzilla.kernel.org/>
References: <bug-109331-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35601 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207AbbLNVTc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Dec 2015 16:19:32 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 69D4C202AE
	for <linux-ext4@vger.kernel.org>; Mon, 14 Dec 2015 21:19:31 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 30126202C8
	for <linux-ext4@vger.kernel.org>; Mon, 14 Dec 2015 21:19:28 +0000 (UTC)
In-Reply-To: <bug-109331-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=109331

--- Comment #4 from KernelBug <3fdd1e5d@opayq.com> ---
I'm running Slackware 14.1 x86_64 I formatted during the install as ext4.


file -s /dev/sda1

/dev/sda1: Linux rev 1.0 ext4 filesystem data,
UUID=7d75a56d-fa34-48c5-a278-45ede11df261 (needs journal recovery) (extents)
(large files) (huge files)

I don't claim to know everything as a Slacker, LOL, so either I forgot, or
didn't realize that the kernel is going to try each FS until it finds the one
compiled in.

Either way, this message shouldn't be appearing, telling us what we know
already, which is of course you can't load ext3 when you have it compiled for
ext4, such a pointless message...

Please let's get this fixed or silenced...

thanks

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
