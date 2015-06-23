From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 100321] General protection fault (stalls the machine) with jbd2
 and raid456
Date: Tue, 23 Jun 2015 02:07:51 +0000
Message-ID: <bug-100321-13602-jCF3PL4FoG@https.bugzilla.kernel.org/>
References: <bug-100321-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47852 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822AbbFWCH4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Jun 2015 22:07:56 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EA944205F9
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2015 02:07:54 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B229A205FA
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2015 02:07:51 +0000 (UTC)
In-Reply-To: <bug-100321-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=100321

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #3 from Theodore Tso <tytso@mit.edu> ---
This crash is deep inside the md code.  So it looks like a software RAID bug.  
I would suggest that you send this report to dm-devel@redhat.com, since I don't
believe the devicemapper / md developers use the kernel bugzilla.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
