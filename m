From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43292] jdb2 lockup with ext3 and nfs
Date: Thu, 31 May 2012 22:49:02 +0000 (UTC)
Message-ID: <20120531224902.9392611FD1B@bugzilla.kernel.org>
References: <bug-43292-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:56872 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994Ab2EaWtF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 May 2012 18:49:05 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5D1A220370
	for <linux-ext4@vger.kernel.org>; Thu, 31 May 2012 22:49:04 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 9A3AE20339
	for <linux-ext4@vger.kernel.org>; Thu, 31 May 2012 22:49:02 +0000 (UTC)
In-Reply-To: <bug-43292-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43292





--- Comment #13 from Florian Pritz <flo@xssn.at>  2012-05-31 22:49:02 ---
(In reply to comment #12)
> Oh, that explains it. I wanted blktrace around the moment when nfsd hangs. So
> just start blktrace and let it run until nfsd hangs... Thanks.

I meant, I ran dumpe2fs without nfsd hanging. As for blktrace, I ran that
before nfsd hung and waited a few seconds after it hung before I killed it.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
