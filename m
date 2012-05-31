From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43292] jdb2 lockup with ext3 and nfs
Date: Thu, 31 May 2012 22:44:19 +0000 (UTC)
Message-ID: <20120531224419.C8E0C11FD1B@bugzilla.kernel.org>
References: <bug-43292-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:56819 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab2EaWoW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 May 2012 18:44:22 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 71095202A0
	for <linux-ext4@vger.kernel.org>; Thu, 31 May 2012 22:44:21 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id D10A120326
	for <linux-ext4@vger.kernel.org>; Thu, 31 May 2012 22:44:19 +0000 (UTC)
In-Reply-To: <bug-43292-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43292





--- Comment #12 from Jan Kara <jack@suse.cz>  2012-05-31 22:44:19 ---
Oh, that explains it. I wanted blktrace around the moment when nfsd hangs. So
just start blktrace and let it run until nfsd hangs... Thanks.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
