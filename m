From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 44731] ext4 deadlock under heavy io?
Date: Wed, 29 Aug 2012 16:38:24 +0000 (UTC)
Message-ID: <20120829163824.38B6B11FB38@bugzilla.kernel.org>
References: <bug-44731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55282 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab2H2Qib (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Aug 2012 12:38:31 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 26B4F20291
	for <linux-ext4@vger.kernel.org>; Wed, 29 Aug 2012 16:38:30 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 42F8F202A8
	for <linux-ext4@vger.kernel.org>; Wed, 29 Aug 2012 16:38:29 +0000 (UTC)
In-Reply-To: <bug-44731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=44731





--- Comment #8 from Mirek Rusin <mirek@me.com>  2012-08-29 16:38:23 ---
Nick, yes it does - for software raid, right?

I'm using hardware raid.

This code is not even loaded into kernel (I've got it in kernel config as
(m)odule, and it doesn't appear in /proc/modules - this code is not used at all
in my case).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
