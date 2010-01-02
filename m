From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14972] [regression] msync() call on ext4 causes disk thrashing
Date: Sat, 2 Jan 2010 15:10:04 GMT
Message-ID: <201001021510.o02FA4bL006185@demeter.kernel.org>
References: <bug-14972-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41624 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab0ABPKF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Jan 2010 10:10:05 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o02FA4sg006186
	for <linux-ext4@vger.kernel.org>; Sat, 2 Jan 2010 15:10:04 GMT
In-Reply-To: <bug-14972-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14972





--- Comment #3 from Artem S. Tashkinov <t.artem@mailcity.com>  2010-01-02 15:10:03 ---
(In reply to comment #2)
> Regression from what?  Ext3?  Or some earlier kernel version?

Regression from ext3.

> 
> What arguments are you giving to this test program of yours?   It looks like it
> does some number of reads and/or writes to the file, and then calls 10,000
> msyncs with 50ms wait between each msync.

While doing those msync()s mmap file is unchanged, but ...

> 
> I'm not seeing any disk activity as a result.   Was anything else reading or
> writing to the file or to the file system at the same time?

... my HDD led keeps flashing continuously which certainly means some disk
activity. Should I attach a video showing this abnormality on kernel 2.6.32.2
on runlevel 1 with no application running except bash and this application?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
