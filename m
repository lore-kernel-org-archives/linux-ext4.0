From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 66161] many application blocked
Date: Wed, 04 Dec 2013 13:11:00 +0000
Message-ID: <bug-66161-13602-ycPeHblkHI@https.bugzilla.kernel.org/>
References: <bug-66161-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50267 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932270Ab3LDNLH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Dec 2013 08:11:07 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 407382021F
	for <linux-ext4@vger.kernel.org>; Wed,  4 Dec 2013 13:11:06 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 82FB0203B4
	for <linux-ext4@vger.kernel.org>; Wed,  4 Dec 2013 13:11:00 +0000 (UTC)
In-Reply-To: <bug-66161-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=66161

Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz
             Status|NEW                         |NEEDINFO

--- Comment #2 from Jan Kara <jack@suse.cz> ---
Yeah, is this reproducible? If yes, can you do 'echo w >/proc/sysrq-trigger'
and attach full kernel log here (output of dmesg command) please? Thanks.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
