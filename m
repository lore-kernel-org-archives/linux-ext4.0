From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14734] BUG: unable to handle kernel NULL pointer dereference at
 0000000000000808
Date: Mon, 18 Jun 2012 13:01:35 +0000 (UTC)
Message-ID: <20120618130135.2EEBD11FE46@bugzilla.kernel.org>
References: <bug-14734-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45537 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab2FRNBm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Jun 2012 09:01:42 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4CBB9202B7
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jun 2012 13:01:41 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 9C781202C8
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jun 2012 13:01:36 +0000 (UTC)
In-Reply-To: <bug-14734-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=14734


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|                            |UNREPRODUCIBLE




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
