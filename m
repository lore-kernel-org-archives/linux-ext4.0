From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15420] EXT4_USE_FOR_EXT23 causes wrong free space calculation
 on ext2 and ext3
Date: Mon, 18 Jun 2012 15:10:12 +0000 (UTC)
Message-ID: <20120618151012.DA2D011FE41@bugzilla.kernel.org>
References: <bug-15420-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53960 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab2FRPKT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Jun 2012 11:10:19 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D80AA202C2
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jun 2012 15:10:14 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id E3BC920262
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jun 2012 15:10:12 +0000 (UTC)
In-Reply-To: <bug-15420-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15420


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
