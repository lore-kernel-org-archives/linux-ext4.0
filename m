From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47611] NULL pointer dereference in ext4_ext_remove_space on
 3.5.1
Date: Mon, 17 Sep 2012 11:33:56 +0000 (UTC)
Message-ID: <20120917113356.19E4B11FB08@bugzilla.kernel.org>
References: <bug-47611-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50501 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755786Ab2IQLd6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Sep 2012 07:33:58 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A1EE02029E
	for <linux-ext4@vger.kernel.org>; Mon, 17 Sep 2012 11:33:57 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 1D6BC20297
	for <linux-ext4@vger.kernel.org>; Mon, 17 Sep 2012 11:33:56 +0000 (UTC)
In-Reply-To: <bug-47611-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47611


Dan Carpenter <error27@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Blocks|                            |47401




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
