From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42895] jbd2 makes all system unresponsive
Date: Thu, 17 May 2012 18:34:58 +0000 (UTC)
Message-ID: <20120517183458.DB51F11FCF6@bugzilla.kernel.org>
References: <bug-42895-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57783 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762291Ab2EQSfC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 May 2012 14:35:02 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3E60B205C3
	for <linux-ext4@vger.kernel.org>; Thu, 17 May 2012 18:35:01 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id E31CE2058E
	for <linux-ext4@vger.kernel.org>; Thu, 17 May 2012 18:34:58 +0000 (UTC)
In-Reply-To: <bug-42895-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42895





--- Comment #17 from Theodore Tso <tytso@mit.edu>  2012-05-17 18:34:58 ---
Eugene,

I suspect this is much more of a change with the userspace components of the
distribution.  Ext3 hasn't changed much since 2.6.38, and everything I've said
about how jbd2 works also applies to ext3 and jbd.   So people who are
convinced this is a jbd2 problem can certainly try building a kernel with ext3
(for those distro's who are using ext4 for ext3 and ext4 file system formats).

My experience is that when comparing ext3 and ext4, I haven't found a situation
where ext4 has been slower than ext3.  If you can demonstrate a situation where
using ext3 you get one speed, and then using exactly the same configuration,
ext4 is slower, please let me know and we'll certainly take a look at it.

Something else you might try is dropping a modern (3.2 or 3.3) kernel unto an
older distribution.  I'm currently typing this on a Ubuntu LTS 10.04 system
running with a 3.2 kernel.  That would allow for a controlled experiment.  But
all I can say is if Network Manager is doing something as crazy as writing to a
Timestamp file every n seconds, there really is nothing you can do at the
kernel level.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
