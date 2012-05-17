From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42895] jbd2 makes all system unresponsive
Date: Thu, 17 May 2012 20:02:06 +0000 (UTC)
Message-ID: <20120517200206.0B1F911FCF7@bugzilla.kernel.org>
References: <bug-42895-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60490 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932405Ab2EQUCI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 May 2012 16:02:08 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E654C204D8
	for <linux-ext4@vger.kernel.org>; Thu, 17 May 2012 20:02:06 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 17EB120394
	for <linux-ext4@vger.kernel.org>; Thu, 17 May 2012 20:02:06 +0000 (UTC)
In-Reply-To: <bug-42895-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42895





--- Comment #18 from Fabio Varesano <fabio.varesano@gmail.com>  2012-05-17 20:02:05 ---
I'm the one who firstly opened this issue.. the problem showed up all at a
time, probably after one upgrade. I'm running ArchLinux on my system and it
used ext4 also on ext3 partitions by default. I did tried to recompile the
kernel to allow mounting fs as native ext3... no difference at all.. still slow
and always working.

Personally, I "fixed" the problem by switching my /home fs to reiser3. After
that system became fast as it was before.

IMHO this is really kernel stuff...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
