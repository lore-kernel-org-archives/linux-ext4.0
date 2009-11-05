From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Thu, 5 Nov 2009 16:07:34 GMT
Message-ID: <200911051607.nA5G7YRH002658@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59155 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802AbZKEQH3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Nov 2009 11:07:29 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA5G7Y2b002659
	for <linux-ext4@vger.kernel.org>; Thu, 5 Nov 2009 16:07:34 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz




--- Comment #6 from Jan Kara <jack@suse.cz>  2009-11-05 16:07:31 ---
Eric, have you succeeded in reproducing this?

What seems to happen is that while we are in ext3_put_super(), there are still
some inode references held and therefore the inodes (regular files) don't get
deleted and we complain about them in ext3_put_super. The question is who holds
the reference... I did a quick audit of the code and couldn't find iget()
unmatched with iput() or a similar problem.

I guess I can create a debugging patch which might be able to show us who holds
the reference. Will try to code it next week. Mikael, will you be able to run
such debugging patch?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
