From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Tue, 8 Dec 2009 11:47:42 GMT
Message-ID: <200912081147.nB8BlgHT016885@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39297 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbZLHLrf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Dec 2009 06:47:35 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nB8BlgXP016886
	for <linux-ext4@vger.kernel.org>; Tue, 8 Dec 2009 11:47:42 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #13 from Mikael Pettersson <mikpe@it.uu.se>  2009-12-08 11:47:41 ---
(In reply to comment #12)
> Ah, I've noticed that Mikael was not on CC of this bug so he didn't see my
> messages. Mikael, could you please try running the debugging patch from comment
> #8/#9? Thanks.

I'll test the debug patch this weekend, right now I'm away from the machines
that trigger the problem.

(Since I issued all my bug reports on LKML it never occurred to me to add a cc:
to myself in this bugzilla entry. Sorry about that.)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
