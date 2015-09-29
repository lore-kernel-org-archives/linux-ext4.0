From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101011] Kernel Oops when disconnecting a mounted ext4 usb stick
Date: Tue, 29 Sep 2015 16:33:42 +0000
Message-ID: <bug-101011-13602-INssOGbETM@https.bugzilla.kernel.org/>
References: <bug-101011-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39909 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932398AbbI2Qdp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Sep 2015 12:33:45 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D4FC920747
	for <linux-ext4@vger.kernel.org>; Tue, 29 Sep 2015 16:33:43 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 60CA8206E0
	for <linux-ext4@vger.kernel.org>; Tue, 29 Sep 2015 16:33:42 +0000 (UTC)
In-Reply-To: <bug-101011-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=101011

--- Comment #14 from Ronny Standtke <ronny.standtke@gmx.net> ---
> The revert is upstream as commit bdfe0cbd746aa9

Thanks for the info! I will apply the revert to 4.2.1.

> Especially if you are receiving paid support from the distribution, they are 
> much more likely to listen to you.  :-)

It's the other way around. I am maintaining a distribution and get paid for
supporting it. :-)

-- 
You are receiving this mail because:
You are on the CC list for the bug.
