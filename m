From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 45621] Kernel ooops: BUG: unable to handle kernel paging
 request at 000000080000001c
Date: Wed,  7 Nov 2012 14:18:31 +0000 (UTC)
Message-ID: <20121107141831.8C1BB11FB59@bugzilla.kernel.org>
References: <bug-45621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37807 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab2KGOSe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Nov 2012 09:18:34 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0C6FD201EC
	for <linux-ext4@vger.kernel.org>; Wed,  7 Nov 2012 14:18:33 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 1185D201C7
	for <linux-ext4@vger.kernel.org>; Wed,  7 Nov 2012 14:18:32 +0000 (UTC)
In-Reply-To: <bug-45621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=45621


Shapovalov Ivan <ishapic@mail.ru> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |ishapic@mail.ru




--- Comment #9 from Shapovalov Ivan <ishapic@mail.ru>  2012-11-07 14:18:31 ---
(In reply to comment #8)
> So you use raiser4(which is known to have such type of corruption) and
> wondering that other parts of dcache becomes corrupted? Have you ever reproduce
> this w/o raiser4-pc ? I'm pretty sure that his is raiser's bug and absolutely
> not related with ext4

Could you please elaborate - which type of corruption reiser4 is known to have?
I'm not aware of these...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
