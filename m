From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Tue, 12 Jan 2010 16:03:33 GMT
Message-ID: <201001121603.o0CG3XFP025344@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33556 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab0ALQDe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jan 2010 11:03:34 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0CG3Xxf025345
	for <linux-ext4@vger.kernel.org>; Tue, 12 Jan 2010 16:03:33 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #20 from Jan Kara <jack@suse.cz>  2010-01-12 16:03:29 ---
OK, now "make -k check" have been doing something for a reasonable time but I
don't see problems with orphan files you see. Only at the end there are a few
ld-linux-... processes hanging so that I cannot umount the filesystem (I have
to kill them to umount the filesystem) - do you also observe such processes?

Also if you can still reproduce the problem - could you please find which test
does exactly cause the problem so that I can concentrate on it? Thanks.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
