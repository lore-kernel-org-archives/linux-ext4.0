From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sat, 17 Oct 2009 06:43:48 GMT
Message-ID: <200910170643.n9H6hmvD012209@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54338 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbZJQGno (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 Oct 2009 02:43:44 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9H6hmMZ012210
	for <linux-ext4@vger.kernel.org>; Sat, 17 Oct 2009 06:43:48 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #76 from Maxim Levitsky <maximlevitsky@gmail.com>  2009-10-17 06:43:47 ---
Happened on my desktop system. It has ubuntu 9.04, ext4, and intel drivers.

I was troubleshooting a GPU hang that happened after I switch modes in an SDL
game.

Same pattern, few crashes, duplicated blocks, and now I set the fsck to run
after each reboot.

And I had a crash before this, and thus it very likely that indeed free block
bitmap is corrupted.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
