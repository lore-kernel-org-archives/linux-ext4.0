From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51431] ext4_mb_generate_buddy self ext4 errors
Date: Sat,  8 Dec 2012 16:55:28 +0000 (UTC)
Message-ID: <20121208165528.8BF7711FC70@bugzilla.kernel.org>
References: <bug-51431-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50701 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964937Ab2LHQzc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Dec 2012 11:55:32 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 670C2201AA
	for <linux-ext4@vger.kernel.org>; Sat,  8 Dec 2012 16:55:31 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 95DAC201AB
	for <linux-ext4@vger.kernel.org>; Sat,  8 Dec 2012 16:55:28 +0000 (UTC)
In-Reply-To: <bug-51431-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51431





--- Comment #6 from Eric Sandeen <sandeen@redhat.com>  2012-12-08 16:55:28 ---
Ok, this is a known bug, fixed upstream, and should be fixed in a future RHEL5
release.  (fixed as far as not panicing, but instead reporting the underlying
corruption).  It may be a result of your ext3->ext4 conversion, not sure. 
That's not something we support in RHEL.

Unless you can reproduce whatever the underlying error was, we should probably
close this bug - old kernel & a mishmash of Centos5 and older upstream kernels
...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
