From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 114821] Frequent and recurring ext4 "bad header invalid magic"
 errors on a healthy drive
Date: Fri, 18 Mar 2016 05:17:17 +0000
Message-ID: <bug-114821-13602-qUviac8L8F@https.bugzilla.kernel.org/>
References: <bug-114821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46365 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984AbcCRFRV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Mar 2016 01:17:21 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A615820397
	for <linux-ext4@vger.kernel.org>; Fri, 18 Mar 2016 05:17:19 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id D29002038F
	for <linux-ext4@vger.kernel.org>; Fri, 18 Mar 2016 05:17:17 +0000 (UTC)
In-Reply-To: <bug-114821-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=114821

--- Comment #2 from Lukas <dse.ssd@gmail.com> ---

I was suspecting hardware problems initially, but now I don't think that's the
case - both short and long SMART self-tests as well as vendor diagnostic tests
(including a 10 hour scan of every sector) produced no errors. All SMART
attributes that would indicate electromechanical failure are at zero raw
values.

I've also just verified that the 'clunk sound' is a head load cycle. By copying
a certain file I can trigger the error and if I check the SMART attributes
before and after, I see the 'Load Cycle Count (ID #193)' increased by 2.
Currently it is at 1823.

Unfortunately, I'm not skilled enough to quickly test with a vanilla kernel on
the same OS. Would it be useful if I'd tested using Raspbian Jessie with 4.1
kernel instead? I can exchange the SD card with the OS while keeping everything
else the same.

The stackexchange post is indeed mine and I have not posted this to the
linux-ext4 mailing list. Should I do so? I apologize if I'm doing things out of
order here, I have little experience in official linux bug reporting.

Attaching dmesg ans syslog files.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
