From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42895] jbd2 makes all system unresponsive
Date: Wed, 16 May 2012 16:34:39 +0000 (UTC)
Message-ID: <20120516163439.916CD11FCF6@bugzilla.kernel.org>
References: <bug-42895-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38436 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682Ab2EPQem (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 May 2012 12:34:42 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 335AB20586
	for <linux-ext4@vger.kernel.org>; Wed, 16 May 2012 16:34:41 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id A2AB520536
	for <linux-ext4@vger.kernel.org>; Wed, 16 May 2012 16:34:39 +0000 (UTC)
In-Reply-To: <bug-42895-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42895





--- Comment #13 from Eugene <ivanovstm2@zmail.ru>  2012-05-16 16:34:39 ---
Thanks, now it works.
Traced system for around 10mins and I don't see previously unseen processes.
Just normal system activity. But there was a number of hdd writes (around 6 in
10mins) which doesn't have corresponding entries in trace results and separated
from entries by roughly 30sec (flush?) - that's not including 1-2 writes
closely following (~3-5sec) almost each entry (jbd2?).
http://paste.ubuntu.com/990927/

Can I trace some function which gives output in trace results when actual write
takes place but shows initial cause of the write (not just flush or jbd2)? Like
block_dump but more informative?

If it's not possible then for now I'm going to presume that it's just the way
how system works. But still it's lots of flushes/jbd2 following writes of even
small files:
https://launchpadlibrarian.net/101378473/15mins_almost_idle.txt

For example in above block_dump Network Manager's "timestamps" file is 4910
bytes long and followed by ~20 writes by jbd2 and then by 10 flushes.
Or xfconfd's "xfce4-panel.xml" is 9467 bytes long and followed by 8 writes by
jbd2 and then by 20 flushes all around the disk.
Is it normal?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
