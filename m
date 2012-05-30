From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12793] ext4 gives wrong errno with too long extended attribute
 values
Date: Wed, 30 May 2012 14:19:35 +0000 (UTC)
Message-ID: <20120530141935.ED96C11FD1C@bugzilla.kernel.org>
References: <bug-12793-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60232 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041Ab2E3OT6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 May 2012 10:19:58 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D5302203F9
	for <linux-ext4@vger.kernel.org>; Wed, 30 May 2012 14:19:41 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id EF16E203E4
	for <linux-ext4@vger.kernel.org>; Wed, 30 May 2012 14:19:35 +0000 (UTC)
In-Reply-To: <bug-12793-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=12793


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|                            |OBSOLETE




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
