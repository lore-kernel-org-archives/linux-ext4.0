From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Tue, 27 Oct 2009 10:38:19 GMT
Message-ID: <200910271038.n9RAcJgD028430@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60747 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbZJ0KiP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Oct 2009 06:38:15 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9RAcJte028431
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2009 10:38:19 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #124 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-27 10:38:18 ---
I tested this two patches together, after first crush i get fs corruption:
"Block bitmap differences" and "blocks count wrong". The strange thing is - the
journal patch still working for me. I didn't get any evidence it hitting "w/
s_journal
NULL", so i will continue killing my system with this patch, will see if i get
any fs corruptions.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
