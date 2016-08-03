From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76261] ext4_da_writepages err -30 after remount ro during
 shutdown
Date: Wed, 03 Aug 2016 02:39:10 +0000
Message-ID: <bug-76261-13602-KFYX9tfNmC@https.bugzilla.kernel.org/>
References: <bug-76261-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54970 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312AbcHCCk1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Aug 2016 22:40:27 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1F747203A5
	for <linux-ext4@vger.kernel.org>; Wed,  3 Aug 2016 02:39:12 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id C709820398
	for <linux-ext4@vger.kernel.org>; Wed,  3 Aug 2016 02:39:10 +0000 (UTC)
In-Reply-To: <bug-76261-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=76261

--- Comment #17 from yongjun xiao <yongjun.xiao@spreadtrum.com> ---
(In reply to yongjun xiao from comment #16)
> Created attachment 227411 [details]
> some error log
> 
> There are two logs from different phone.

some logs are lost, so the only error logs as the attachement.
But we dump the crash file memory,this may be help.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
