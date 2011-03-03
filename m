From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14972] [regression] msync() call on ext4 causes disk thrashing
Date: Thu, 3 Mar 2011 11:25:04 GMT
Message-ID: <201103031125.p23BP4wI003946@demeter2.kernel.org>
References: <bug-14972-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:55895 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757770Ab1CCLZE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Mar 2011 06:25:04 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p23BP4jC003947
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 3 Mar 2011 11:25:04 GMT
In-Reply-To: <bug-14972-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=14972


Sergiy Zuban <s.zuban@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |s.zuban@gmail.com




--- Comment #12 from Sergiy Zuban <s.zuban@gmail.com>  2011-03-03 11:25:02 ---
due to bad implementation of some apps/libs this bug cause continual disk
access (HDD led is always ON) and possible disk damage. Is there a chance to
somehow speed up release of fix for this bug (it's been reported over a year
ago)? I believe the first step to change status to CONFIRMED.

Many people noticed unusual disk activity after upgrade to ext4:
https://bbs.archlinux.org/viewtopic.php?pid=692073
http://bugs.winehq.org/show_bug.cgi?id=24044#c13
http://www.justlinux.com/forum/showthread.php?p=891737

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
