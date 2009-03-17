From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12821] filesystem corrupts on heavy I/O
Date: Mon, 16 Mar 2009 23:30:39 -0700 (PDT)
Message-ID: <20090317063039.9C134108042@picon.linux-foundation.org>
References: <bug-12821-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522AbZCQGbr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Mar 2009 02:31:47 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2H6UdVa012351
	for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2009 23:31:16 -0700
In-Reply-To: <bug-12821-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12821





------- Comment #20 from lucent+lkml@gmail.com  2009-03-16 23:30 -------
As noted in attachments, I have applied the patch and completed my BitTorrent
download (which was problematic without the patch).

linux-image-2.6.28-8-generic (Ubuntu): Download unable to complete due to EXT4
error and non-responsive sync.

linux-image-2.6.28-9-generic (Ubuntu+potential fix patch), first try: Computer
is found unresponsive and screen dark, power and capslock blinking.

linux-image-2.6.28-9-generic (Ubuntu+potential fix patch), second try: Computer
is normal, no errors in dmesg about EXT4, download is successful.

The failure on first try is a new behavior I have not seen before with this
machine. I therefore am reporting inconclusively that the patch works for me.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
