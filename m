From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Mon, 26 Oct 2009 21:46:33 GMT
Message-ID: <200910262146.n9QLkXOj029512@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54228 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbZJZVq3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Oct 2009 17:46:29 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9QLkXYQ029513
	for <linux-ext4@vger.kernel.org>; Mon, 26 Oct 2009 21:46:33 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #120 from Jindrich Makovicka <makovick@gmail.com>  2009-10-26 21:46:32 ---
(In reply to comment #119)
> It seems to be only after an unclean shutdown for me, judging by some judicious
> grepping of /var/log/messgaes. At least the ext4 error messages in dmesg only
> seem to happen when I don't see the line "Kernel logging (proc) stopped." in
> the messages file before the new boot.
> 
> Of course, maybe the problem is caused by - or even just made visible by - not
> the unclean shutdown itself, but the fsck or the journal replay which is just
> triggered by the unclean shutdown. IOW, it could be secondary damage. That
> sounds unlikely, though.

I thought that it could be the cause, but in one case of an unclean shutdown, I
rebooted into 2.6.31.1, hoping I could avoid the damage, but the fs ended up
corrupted anyway.

However, I didn't run fsck on each boot, so I cannot be sure the fs has been
clean before.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
