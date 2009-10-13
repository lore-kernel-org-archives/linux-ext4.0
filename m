From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Tue, 13 Oct 2009 20:55:22 GMT
Message-ID: <200910132055.n9DKtMXE002470@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41441 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934336AbZJMUz6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Oct 2009 16:55:58 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9DKtMPA002471
	for <linux-ext4@vger.kernel.org>; Tue, 13 Oct 2009 20:55:22 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #38 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-13 20:55:21 ---
@Theodore, i can reproduce datalost not readonly bug, this happened mostly with
2.6.32-rcX.

I had some problems with readonly root, but it seems to be other bug in karmik
upstart. See:
https://bugs.launchpad.net/ubuntu/+source/upstart/+bug/434358

In my datalost issue, if some thing going wrong and kernel oops or freeze ( i
need to poweroff the system) it seems like the _possability_ to lost some thing
is match bigger if i use 2.6.32-rcX kernel. For example i get corrupted files
which was written one week before the system was really broken.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
