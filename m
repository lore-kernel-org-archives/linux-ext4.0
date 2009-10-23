From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14422] EXT4 is corrupted after clean shutdown
Date: Fri, 23 Oct 2009 09:11:15 GMT
Message-ID: <200910230911.n9N9BFig009003@demeter.kernel.org>
References: <bug-14422-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42167 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbZJWJLK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Oct 2009 05:11:10 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9N9BFvR009004
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2009 09:11:15 GMT
In-Reply-To: <bug-14422-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14422





--- Comment #7 from okias <d.okias@gmail.com>  2009-10-23 09:11:13 ---
Sorry, I can't do that for now. I can offer you steps to reproduce problem

1. Install Kubuntu 9.10 32 or 64bit (for example from Beta image)
2. sda1 /boot about 100M ext2, sda2 / 10G ext4, sda3 swap, sda4 /home ext4...
3. download from this location kernel -
http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.32-rc5/
4. At least 20x correctly shudown machine, until you hit issue... you probably
hit this issue on every machine...

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
