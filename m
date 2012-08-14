From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 27912] Set 'err' in ext4_init_fs() if kset_create_and_add()
 fails
Date: Tue, 14 Aug 2012 15:55:52 +0000 (UTC)
Message-ID: <20120814155552.9E6C111FC70@bugzilla.kernel.org>
References: <bug-27912-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45159 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021Ab2HNPz7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Aug 2012 11:55:59 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 385112023A
	for <linux-ext4@vger.kernel.org>; Tue, 14 Aug 2012 15:55:58 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 47B9920260
	for <linux-ext4@vger.kernel.org>; Tue, 14 Aug 2012 15:55:53 +0000 (UTC)
In-Reply-To: <bug-27912-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=27912


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|                            |CODE_FIX




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
