From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112631] Cannot open encrypted Luks filesystem. Cruptsetup
 error.
Date: Tue, 23 Feb 2016 08:34:39 +0000
Message-ID: <bug-112631-13602-jWRMrmdc4J@https.bugzilla.kernel.org/>
References: <bug-112631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43622 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932551AbcBWIen (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Feb 2016 03:34:43 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8BD75206DB
	for <linux-ext4@vger.kernel.org>; Tue, 23 Feb 2016 08:34:42 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A208E206A3
	for <linux-ext4@vger.kernel.org>; Tue, 23 Feb 2016 08:34:39 +0000 (UTC)
In-Reply-To: <bug-112631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=112631

STRSHR <strasharo2000@yahoo.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |strasharo2000@yahoo.com

--- Comment #15 from STRSHR <strasharo2000@yahoo.com> ---
(In reply to da_audiophile from comment #10)
> Regarding comment #9, Arch Linux ships cryptsetup-1.7.0-1 and when used with
> 4.1.18-1 does not fix this problem.
> 
> Enter passphrase for /dev/md0: 
> Failed to setup dm-crypt key mapping for device /dev/md0.
> Check that kernel supports aes-xts-plain64 cipher (check syslog for more
> info).
> 
> uname -r
> 4.1.18-1-lts
> 
> pacman -Qs cryptsetup
> local/cryptsetup 1.7.0-1 (base)

Does cryptsetup-1.7.0-2 resolve your issue?

https://projects.archlinux.org/svntogit/packages.git/commit/trunk?h=packages/cryptsetup&id=ea2c8f73c45aa239ed5f356a8ecd01aeba51ef1d

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
