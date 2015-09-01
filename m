From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Tue, 01 Sep 2015 10:28:53 +0000
Message-ID: <bug-102731-13602-Fhk90EFygd@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36822 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbbIAK24 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Sep 2015 06:28:56 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8EA73205C2
	for <linux-ext4@vger.kernel.org>; Tue,  1 Sep 2015 10:28:55 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 4A3AC20574
	for <linux-ext4@vger.kernel.org>; Tue,  1 Sep 2015 10:28:54 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #9 from John Hughes <john@calva.com> ---
> How many guest VM's are you running

One at the moment.

> how often does the file system corruption happens?   It sounds like it's about once every 2-3 weeks?

With the Debian 3.16 kernel it was happening about once every 4 days.

I installed my 3.18.19 kernel on 24/7/2015 and have seen the bug twice:
11/8/2015 and 31/8/2015.

> Would you be willing to experiment running the VM without using the RAID1 so we're bypassing the MD layer?

I guess I'll have to try that.  It's going to be a monumental pain in the arse:

The guests /home is a 160GiB LVM volume striped across 4 mdadm raid1's.

What I can try first is just disabling one side of the mdadm mirrors, if the
problem re-occurs I can get rid of mdadm completely.

(This will be the first time I've run one of my servers without disk mirroring
since 1986.  Ugh.)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
