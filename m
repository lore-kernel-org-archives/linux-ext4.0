From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Fri, 16 Oct 2015 15:53:27 +0000
Message-ID: <bug-102731-13602-triBjCdro7@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42283 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932178AbbJPPxa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Oct 2015 11:53:30 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 27901207D3
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2015 15:53:29 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 9AAF4207BB
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2015 15:53:27 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #24 from cwseys@physics.wisc.edu ---
Hi John,
    Thanks for working on this!
    I've attempted to send debian infrastructure an email asking if they've 
noticed this problem.  If not, I'd like to find the difference.  (Maybe they 
don't use ext4 in VMs.)

> If I see the problem with host and guest at 4.2.3 I'll convert the
> filesystems (in place) to ext4.
> 
> If I see the problems with in-place converted ext4 I'll rebuild the
> filesysems as native ext4 and copy all the files over.

    I am using  formatted as ext4 "native ext4" and seem to see the same 
problem.  But will be interesting to hear your results over a couple months . 
:)

Chad.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
