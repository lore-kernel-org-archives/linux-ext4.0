From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 45621] Kernel ooops: BUG: unable to handle kernel paging
 request at 000000080000001c
Date: Wed,  7 Nov 2012 12:42:49 +0000 (UTC)
Message-ID: <20121107124249.2BD4511FB6C@bugzilla.kernel.org>
References: <bug-45621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35455 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242Ab2KGMmx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Nov 2012 07:42:53 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E9BD02023E
	for <linux-ext4@vger.kernel.org>; Wed,  7 Nov 2012 12:42:51 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 58B2820241
	for <linux-ext4@vger.kernel.org>; Wed,  7 Nov 2012 12:42:49 +0000 (UTC)
In-Reply-To: <bug-45621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=45621


Dmitry Monakhov <dmonakhov@openvz.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dmonakhov@openvz.org




--- Comment #8 from Dmitry Monakhov <dmonakhov@openvz.org>  2012-11-07 12:42:48 ---
So you use raiser4(which is known to have such type of corruption) and
wondering that other parts of dcache becomes corrupted? Have you ever reproduce
this w/o raiser4-pc ? I'm pretty sure that his is raiser's bug and absolutely
not related with ext4

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
