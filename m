From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 66881] [3.12.1][ext4]kernel BUG at
 fs/ext4/extents_status.c:709!
Date: Sat, 21 Dec 2013 12:22:03 +0000
Message-ID: <bug-66881-13602-F4QlBoRSS7@https.bugzilla.kernel.org/>
References: <bug-66881-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50031 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790Ab3LUMWG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 21 Dec 2013 07:22:06 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6B10F2070A
	for <linux-ext4@vger.kernel.org>; Sat, 21 Dec 2013 12:22:05 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id E6CE1206F3
	for <linux-ext4@vger.kernel.org>; Sat, 21 Dec 2013 12:22:03 +0000 (UTC)
In-Reply-To: <bug-66881-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=66881

--- Comment #3 from Zheng Liu <gnehzuil.liu@gmail.com> ---
(In reply to R.Nageswara Sastry from comment #2)
> (In reply to Zheng Liu from comment #1)
> > This commit (0826a7e1) has been applied to the latest ext4/dev branch, and
> > will be merged into upstream kernel.
> > 
> > Regards,
> >                                                 - Zheng
> 
> Hello Zheng,
> Could not found the relevant link to the commit. Requesting to share the
> same. Thanks in advance.

Ah, sorry, I forgot to mention that this commit is still under ext4 tree.  It
doesn't be applied into mainline kernel.  So that is why you couldn't find it. 
Here it is.

https://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/commit/?h=dev&id=0826a7e1ffac96eaced919fcef9994cff9853ef2

Regards,
                                                 - Zheng

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
