From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 56821] an ext4 commit ee0906f causes weird disk hangs
Date: Fri, 19 Apr 2013 12:40:50 +0000 (UTC)
Message-ID: <20130419124050.B6D0C11FA4E@bugzilla.kernel.org>
References: <bug-56821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:56832 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968316Ab3DSMky (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Apr 2013 08:40:54 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A842C20647
	for <linux-ext4@vger.kernel.org>; Fri, 19 Apr 2013 12:40:53 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 7C4E32064B
	for <linux-ext4@vger.kernel.org>; Fri, 19 Apr 2013 12:40:51 +0000 (UTC)
In-Reply-To: <bug-56821-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=56821


Tommi Kyntola <kynde@ts.ray.fi> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kynde@ts.ray.fi
           Platform|All                         |x86-64
     Kernel Version|                            |3.8.5




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
