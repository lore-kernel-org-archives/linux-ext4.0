From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43292] jdb2 lockup with ext3 and nfs
Date: Thu, 31 May 2012 21:40:38 +0000 (UTC)
Message-ID: <20120531214038.4714111FD1B@bugzilla.kernel.org>
References: <bug-43292-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55616 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918Ab2EaVkm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 May 2012 17:40:42 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 22DFB20338
	for <linux-ext4@vger.kernel.org>; Thu, 31 May 2012 21:40:41 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 4D34C2032D
	for <linux-ext4@vger.kernel.org>; Thu, 31 May 2012 21:40:38 +0000 (UTC)
In-Reply-To: <bug-43292-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43292





--- Comment #11 from Florian Pritz <flo@xssn.at>  2012-05-31 21:40:38 ---
Created an attachment (id=73480)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=73480)
output of dumpe2fs /dev/dm-2

(In reply to comment #10)
> I have to say I'm puzzled. Everything looks normal, the IO is submitted and
> completed, no sign of any hang. Just the last request - read - has been only
> submitted to disk and not yet completed but that can be just a coincidence. To
> check what has been read, can you attach here output of dumpe2fs /dev/dm-2?

I've run it without the hanging nfsd, is that correct?

> When the lockup happens, those nfsd threads are sitting there doing nothing for
> a long time, am I right?

Yeah. All nfs activity is frozen, but local system activity on the same file
system works just fine.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
