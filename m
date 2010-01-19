From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Tue, 19 Jan 2010 19:56:43 GMT
Message-ID: <201001191956.o0JJuhVV011988@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41497 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab0AST4o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jan 2010 14:56:44 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0JJuhZs011989
	for <linux-ext4@vger.kernel.org>; Tue, 19 Jan 2010 19:56:43 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dvhltc@us.ibm.com




--- Comment #26 from Jan Kara <jack@suse.cz>  2010-01-19 19:56:41 ---
OK, I've spent some time looking into this. It's definitely a futex problem -
futexes take reference to inode and apparently this test case takes some code
path where we don't drop all the inode references we have acquired. I've tried
to find that place by looking into the code but wasn't successful.

I think the problem is caused by futex rewrite that happened between 2.6.30 and
2.6.31 so I'm adding Darren to CC (who was author of most of the patches).
Darren, I'm able to reproduce the problem with 2.6.33-rc3 kernel so apparently
the problem isn't fixed yet. I'll attach here a minimal test program that
triggers the problem.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
