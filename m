From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47151] provide a file system block size of 8KB for certain
 SSDs.
Date: Wed, 10 Oct 2012 10:14:16 +0000 (UTC)
Message-ID: <20121010101416.E61B311FB04@bugzilla.kernel.org>
References: <bug-47151-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37675 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755719Ab2JJKOY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Oct 2012 06:14:24 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E9B2C203C3
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2012 10:14:22 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 05D71203CC
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2012 10:14:22 +0000 (UTC)
In-Reply-To: <bug-47151-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47151


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|REOPENED                    |RESOLVED
         Resolution|                            |WILL_NOT_FIX




--- Comment #15 from Alan <alan@lxorguk.ukuu.org.uk>  2012-10-10 10:14:16 ---
I have talked to  folks in the SSD world and the view seems to be

- bigger than 4K block size is not a concern because the real device is just
making up the disk block sizes anyway
- alignment according to the identify data is important (and is a matter for
fdisk etc)
- this isn't particularly likely to change

So I think we should just close this as WONTFIX. Anyone who cares sufficiently
and has a use case should instead submit patches.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
