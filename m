From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Mon, 25 Jan 2010 07:38:54 GMT
Message-ID: <201001250738.o0P7csQi010309@demeter.kernel.org>
References: <bug-14830-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33267 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab0AYHi4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Jan 2010 02:38:56 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0P7csMJ010310
	for <linux-ext4@vger.kernel.org>; Mon, 25 Jan 2010 07:38:54 GMT
In-Reply-To: <bug-14830-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14830





--- Comment #7 from Michael Godfrey <godfrey@isl.stanford.edu>  2010-01-25 07:38:52 ---
I tried the advice above about nodelalloc using a newer kernel.
It had no observable effect, but did not cause problems as it
had before. So, I left it turned off.  And, I installed kernel
2.6.31.12-174.2.3.fc12.x86_64.

None of this helped.  sync times still at 20 minutes during rsync,
and task (sync or rsync) timeouts in /var/log/messages.

I guess that patience is called for here.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
