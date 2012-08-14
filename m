From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23682] kernel BUG at fs/jbd/commit.c:770!
Date: Tue, 14 Aug 2012 13:24:26 +0000 (UTC)
Message-ID: <20120814132426.B075A11FC6E@bugzilla.kernel.org>
References: <bug-23682-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34266 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab2HNNYa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Aug 2012 09:24:30 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 94CF020240
	for <linux-ext4@vger.kernel.org>; Tue, 14 Aug 2012 13:24:28 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id B45852023D
	for <linux-ext4@vger.kernel.org>; Tue, 14 Aug 2012 13:24:26 +0000 (UTC)
In-Reply-To: <bug-23682-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23682


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|                            |OBSOLETE




--- Comment #1 from Alan <alan@lxorguk.ukuu.org.uk>  2012-08-14 13:24:26 ---
Mulitple fixes in this area have occurred

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
