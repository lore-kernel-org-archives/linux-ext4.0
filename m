From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Tue, 12 Jan 2010 23:25:50 GMT
Message-ID: <201001122325.o0CNPoGF032033@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45377 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab0ALXZv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jan 2010 18:25:51 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0CNPoGK032034
	for <linux-ext4@vger.kernel.org>; Tue, 12 Jan 2010 23:25:50 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #23 from carlos.velasco@nimastelecom.com  2010-01-12 23:25:48 ---
It is something in the nptl (threads) subdir tests.

eglibc-build/nptl# make subdir=nptl -C ../../eglibc-2.10.1/nptl
objdir=/compile/eglibc-build tests
...
eglibc-build/nptl# umount /tmp 
Segmentation fault

Not sure about how to isolate the exact test from here now... will try to do my
best.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
