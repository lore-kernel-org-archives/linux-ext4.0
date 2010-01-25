From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Mon, 25 Jan 2010 10:29:03 GMT
Message-ID: <201001251029.o0PAT3lf005480@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49106 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab0AYK3G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Jan 2010 05:29:06 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0PAT3MU005481
	for <linux-ext4@vger.kernel.org>; Mon, 25 Jan 2010 10:29:03 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #43 from Mikael Pettersson <mikpe@it.uu.se>  2010-01-25 10:28:58 ---
Please clarify exactly what you do to trigger the busy /.

Did you run the glibc test suite or the specific tst-mutex9 program?
If so, then without the futex_lock_pi() patch you wouldn't even get to a normal
shutdown due to the oops, so the busy / may be normal and caused by something
else.

Also, does the busy / prevent the shutdown from succeeding?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
