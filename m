From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 94641] Kernel source tarball download incomplete despite
 Firefox report of complete download
Date: Tue, 10 Mar 2015 18:41:56 +0000
Message-ID: <bug-94641-13602-MsL2dEgr94@https.bugzilla.kernel.org/>
References: <bug-94641-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:51863 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267AbbCJSl6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Mar 2015 14:41:58 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D316E2022D
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2015 18:41:57 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 7C9402020F
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2015 18:41:56 +0000 (UTC)
In-Reply-To: <bug-94641-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=94641

Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz

--- Comment #1 from Jan Kara <jack@suse.cz> ---
Can you attach here content of /proc/mounts, df, and /var/log/messages from
around the time when the problem happened? Also what kernel version do you run
(uname -a).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
