From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 50981] ext4 : DATA CORRUPTION read and write on same 4096 page
 range
Date: Mon, 26 Nov 2012 11:32:35 +0000 (UTC)
Message-ID: <20121126113235.C0ADD11FB80@bugzilla.kernel.org>
References: <bug-50981-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37705 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab2KZLci (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 06:32:38 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 687A020235
	for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2012 11:32:37 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id C9C2120251
	for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2012 11:32:35 +0000 (UTC)
In-Reply-To: <bug-50981-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=50981





--- Comment #7 from Zheng Liu <gnehzuil.liu@gmail.com>  2012-11-26 11:32:35 ---
(In reply to comment #6)
> It might be, as I said the problem appears to be in mm code, most likely there
> is a problem with page locking. However I am not familiar enough with the mm
> code to know that for sure.

Understood, thanks. :-)

Regards,
Zheng

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
