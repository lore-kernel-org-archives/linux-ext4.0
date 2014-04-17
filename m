From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 74171] Attempting to build recent version of e2fsprogs from git
 repo gives config.h missing
Date: Thu, 17 Apr 2014 17:22:27 +0000
Message-ID: <bug-74171-13602-KRlv1xQcV5@https.bugzilla.kernel.org/>
References: <bug-74171-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58992 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbaDQRWa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Apr 2014 13:22:30 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 725EB2035D
	for <linux-ext4@vger.kernel.org>; Thu, 17 Apr 2014 17:22:29 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 0FBE020320
	for <linux-ext4@vger.kernel.org>; Thu, 17 Apr 2014 17:22:28 +0000 (UTC)
In-Reply-To: <bug-74171-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=74171

--- Comment #2 from George R. Goffe <grgoffe@yahoo.com> ---
Theodore,

Thanks for your response and the time you spent formulating it.

I have found the problem.

By the way, I did read INSTALL and followed it's directives.

The problem is that when I build software I run make distclean then configure
then make clean depend then make then make install.

The make clean in this case removes the config.h file, hence the failures. My
thoughts about make clean are that this removes build products, object files,
etc.

I've seen other software that has this problem as well and have no-oped the
make clean in my build scripts.

My question to you is, "Should the config.h file and whatever configure
generates be part of the clean target or should it be part of make distclean"?

Regards,

George...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
