From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51391] BUG: unable to handle kernel NULL pointer dereference
Date: Fri,  7 Dec 2012 17:39:53 +0000 (UTC)
Message-ID: <20121207173953.0BD0511FB80@bugzilla.kernel.org>
References: <bug-51391-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52933 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423392Ab2LGRjz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Dec 2012 12:39:55 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 45DC72036E
	for <linux-ext4@vger.kernel.org>; Fri,  7 Dec 2012 17:39:54 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 275E2202D7
	for <linux-ext4@vger.kernel.org>; Fri,  7 Dec 2012 17:39:53 +0000 (UTC)
In-Reply-To: <bug-51391-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51391





--- Comment #5 from Karen <ktsirunyan@gmail.com>  2012-12-07 17:39:52 ---
I was executing a system called Spruce(which is performing a verification of
Linux file System drivers). The crash come out on the test which is performing
a mount of the current device on the current mount point with MS_NODEV flag
activated. Also program was compiled as a 32-bit program (with Ubuntu Multilib)
but on 64 bit architecture. Hope that helps.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
