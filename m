From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Sun, 11 Oct 2015 04:05:31 +0000
Message-ID: <bug-102731-13602-vsVtnvw9Tt@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35975 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbbJKEFh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Oct 2015 00:05:37 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0609F2092B
	for <linux-ext4@vger.kernel.org>; Sun, 11 Oct 2015 04:05:36 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 58B7020953
	for <linux-ext4@vger.kernel.org>; Sun, 11 Oct 2015 04:05:32 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #17 from Theodore Tso <tytso@mit.edu> ---
I just realized something which I forgot to ask you --- what file system are
you using on the *host*?  You said that on the guest you are using ext3 file
systems with the ext4 driver --- but what about on the host OS side?

I will say that using a full ext4 file system is far more stable on 3.18.21
than using an ext3 file system in compatibility mode.   Ext4 with the 4.2
kernel will support ext3 with zero unexpected test failures, but there are a
handful of test failures that are showing up with the 3.18.21 kernel.  I've
backported a few bug fixes, but they haven't shown up in the stable kernel
series yet, and there are still a half-dozen test failures that I haven't had
time to characterized yet.  (Note: support for long-term stable kernel is
something I do as a very low priority background task.  My priority is upstream
regressions and upstream development, and ideally someone would help with
testing the stable kernels and identifying patches that require manual
backports, but I haven't found a sucker yet.)

One of the reasons why I ask is that the PUNCH hole functionality was
relatively new in the 3.18 kernel, and KVM uses it --- and I am suspicious that
there might be some bug fixes that didn't land in the 3.18 kernel.   So one
thing that might be worth trying is to get a 4.2.3 kernel for both your Host
and Guest kernels, and see what that does for you.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
