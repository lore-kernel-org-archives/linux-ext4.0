From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16312] WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
Date: Thu, 5 Aug 2010 18:07:57 GMT
Message-ID: <201008051807.o75I7vFd014811@demeter.kernel.org>
References: <bug-16312-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34284 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559Ab0HESH6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Aug 2010 14:07:58 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o75I7vZU014812
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 5 Aug 2010 18:07:58 GMT
In-Reply-To: <bug-16312-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16312





--- Comment #23 from Jan Kara <jack@suse.cz>  2010-08-05 18:07:50 ---
Thanks for the patch Tejun! Larry, could you please try it?

Well, my naive opinion rather is that userspace shouldn't be able to access a
device node which isn't fully set up. That could have unexpected pitfalls for
the process and the kernel as well, couldn't it? Technically, it's also hard to
switch BDI under a living device inode - the BDI pointer could be cached in
various places...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
