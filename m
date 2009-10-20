From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Tue, 20 Oct 2009 20:21:03 GMT
Message-ID: <200910202021.n9KKL32h029379@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54263 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbZJTUU6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Oct 2009 16:20:58 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9KKL3VI029380
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2009 20:21:03 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #95 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-20 20:21:01 ---
Created an attachment (id=23480)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23480)
kernel config

How about my kernel config? i use almost the same config on all my pc's on
different platforms i386/amd64. CPU - pentium M, athom, core2duo E8400O; RAM -
1.5G, 2G, 4G; i915/ich6, g945/ich7, g45/ich10r. ...

So i don't think , it is about hardware... probably it is about kernel config.

Alexey

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
