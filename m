From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16165] Wrong data returned on read after write if file size was
 changed with ftruncate before
Date: Fri, 20 Jul 2012 12:58:13 +0000 (UTC)
Message-ID: <20120720125813.A6D4B11FA36@bugzilla.kernel.org>
References: <bug-16165-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58970 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394Ab2GTM6Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Jul 2012 08:58:16 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2F06F20244
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2012 12:58:15 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id A8ECD20220
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2012 12:58:13 +0000 (UTC)
In-Reply-To: <bug-16165-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16165


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
