From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42895] jbd2 makes all system unresponsive
Date: Mon, 14 May 2012 10:44:02 +0000 (UTC)
Message-ID: <20120514104402.0CD7F11FCE1@bugzilla.kernel.org>
References: <bug-42895-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:48547 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755461Ab2ENKoF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 May 2012 06:44:05 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3F12820404
	for <linux-ext4@vger.kernel.org>; Mon, 14 May 2012 10:44:04 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 12AF8203FD
	for <linux-ext4@vger.kernel.org>; Mon, 14 May 2012 10:44:02 +0000 (UTC)
In-Reply-To: <bug-42895-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42895





--- Comment #9 from Hugues Tranli <huguelectro@hotmail.fr>  2012-05-14 10:44:01 ---
What command did you use to watch block_dump?

Even if I switched to Firefox and reduced the HDD writes, iotop shows me often
jbd2/flush and I would like to see if something is wrong.

About your question, I can't help you but maybe it's related to a
daemon/software running in the background.

What distribution are you using? Paste the ouput of "uname -a" and your
/etc/fstab would be a good start.

You can try noatime option, in your fstab and see if it's better.
https://wiki.archlinux.org/index.php/Fstab#atime_options

Regards.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
