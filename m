From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14562] On umount warn in page_alloc.c:1751
 __alloc_pages_slowpath
Date: Thu, 14 Jun 2012 16:50:47 +0000 (UTC)
Message-ID: <20120614165047.79FD811FBF6@bugzilla.kernel.org>
References: <bug-14562-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53696 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340Ab2FNQuv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Jun 2012 12:50:51 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4BE782049D
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jun 2012 16:50:50 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 7C3F3204AC
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jun 2012 16:50:47 +0000 (UTC)
In-Reply-To: <bug-14562-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=14562


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
