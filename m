From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 93031] root becomes read-only at boot due to
 journal_async_commit in /etc/fstab
Date: Tue, 18 Aug 2015 10:55:18 +0000
Message-ID: <bug-93031-13602-hC0lQIb906@https.bugzilla.kernel.org/>
References: <bug-93031-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52076 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbbHRKzV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Aug 2015 06:55:21 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4F0EA2078E
	for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2015 10:55:20 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E449220783
	for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2015 10:55:18 +0000 (UTC)
In-Reply-To: <bug-93031-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=93031

Armin Mohring <armin_mohring@web.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |armin_mohring@web.de

--- Comment #2 from Armin Mohring <armin_mohring@web.de> ---
I am using kernel 3.16.7 from Opensuse.

If I mistype noatime to noatiem the root filesystem mounts read-only.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
