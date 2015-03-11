From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 94641] Kernel source tarball download incomplete despite
 Firefox report of complete download
Date: Wed, 11 Mar 2015 21:05:49 +0000
Message-ID: <bug-94641-13602-fbiLPmclnt@https.bugzilla.kernel.org/>
References: <bug-94641-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49601 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbbCKVFw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Mar 2015 17:05:52 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4CAEF2041E
	for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2015 21:05:51 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 76E87203B0
	for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2015 21:05:49 +0000 (UTC)
In-Reply-To: <bug-94641-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=94641

Calvin Walton <calvin.walton@kepstin.ca> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |calvin.walton@kepstin.ca

--- Comment #2 from Calvin Walton <calvin.walton@kepstin.ca> ---
The most likely cause is that you're hitting this long-standing Firefox bug:
https://bugzilla.mozilla.org/show_bug.cgi?id=237623
(opened 2004, last marked fixed in February, marked as scheduled for FF 39)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
