From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Mon, 12 Oct 2009 18:29:57 GMT
Message-ID: <200910121829.n9CITvIF022813@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40163 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757556AbZJLSae (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Oct 2009 14:30:34 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9CITvM3022814
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2009 18:29:57 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #26 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-12 18:29:57 ---
I'm not pretty sure about lvm, i do not use lvm on my laptop, but i had
corruption problem on it too. Only bad thing happened here was ext4 oops
durning bisect. But corruption happened aboun one week after this oops. 
I use lvm on my PC but i had corrupted sector on home partition too (home is
not lvm).

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
