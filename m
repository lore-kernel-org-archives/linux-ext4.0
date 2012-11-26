From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 50981] ext4 : DATA CORRUPTION read and write on same 4096 page
 range
Date: Mon, 26 Nov 2012 11:27:04 +0000 (UTC)
Message-ID: <20121126112704.E2F2011FB81@bugzilla.kernel.org>
References: <bug-50981-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37395 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab2KZL1H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 06:27:07 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 128A720264
	for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2012 11:27:06 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 3E0A52025F
	for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2012 11:27:05 +0000 (UTC)
In-Reply-To: <bug-50981-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=50981





--- Comment #6 from Lukas Czerner <lczerner@redhat.com>  2012-11-26 11:27:04 ---
It might be, as I said the problem appears to be in mm code, most likely there
is a problem with page locking. However I am not familiar enough with the mm
code to know that for sure.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
