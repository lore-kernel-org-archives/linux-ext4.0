From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43292] jdb2 lockup with ext3 and nfs
Date: Fri,  1 Jun 2012 15:40:50 +0000 (UTC)
Message-ID: <20120601154050.7E1A411FD1B@bugzilla.kernel.org>
References: <bug-43292-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:48308 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964838Ab2FAPk4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Jun 2012 11:40:56 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 81A95202D3
	for <linux-ext4@vger.kernel.org>; Fri,  1 Jun 2012 15:40:55 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 83EAE202DF
	for <linux-ext4@vger.kernel.org>; Fri,  1 Jun 2012 15:40:50 +0000 (UTC)
In-Reply-To: <bug-43292-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43292





--- Comment #15 from Florian Pritz <flo@xssn.at>  2012-06-01 15:40:50 ---
Created an attachment (id=73488)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=73488)
2nd blktrace

(In reply to comment #14)
> dd if=/dev/dm-2 of=/dev/null bs=512 count=8 skip=485490688

Finishes before and after the hang. 

I've attached another blktrace, but I let it run for like 20 seconds after nfsd
hung up this time instead of only a few seconds.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
