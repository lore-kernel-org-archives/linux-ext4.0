From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14696] EXT4-fs error (device dm-3): ext4_mb_release_inode_pa:
 free 777, pa_free 778
Date: Mon, 18 Jun 2012 12:45:12 +0000 (UTC)
Message-ID: <20120618124512.9AAA911FE41@bugzilla.kernel.org>
References: <bug-14696-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44099 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab2FRMpP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Jun 2012 08:45:15 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 03EAE20285
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jun 2012 12:45:14 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 21D612027E
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jun 2012 12:45:13 +0000 (UTC)
In-Reply-To: <bug-14696-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=14696


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|                            |OBSOLETE




--- Comment #2 from Alan <alan@lxorguk.ukuu.org.uk>  2012-06-18 12:45:12 ---
Closing as obsolete - ext4 has changed extensively since 2.6.30

If this is still seen with modern kernels please update the bug

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
