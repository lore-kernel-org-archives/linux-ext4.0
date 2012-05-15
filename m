From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42895] jbd2 makes all system unresponsive
Date: Tue, 15 May 2012 14:40:06 +0000 (UTC)
Message-ID: <20120515144006.400F011FCF2@bugzilla.kernel.org>
References: <bug-42895-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53002 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758305Ab2EOOkN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 May 2012 10:40:13 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CDD6B2054E
	for <linux-ext4@vger.kernel.org>; Tue, 15 May 2012 14:40:07 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 459D920548
	for <linux-ext4@vger.kernel.org>; Tue, 15 May 2012 14:40:06 +0000 (UTC)
In-Reply-To: <bug-42895-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42895


Eugene <ivanovstm2@zmail.ru> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |ivanovstm2@zmail.ru




--- Comment #11 from Eugene <ivanovstm2@zmail.ru>  2012-05-15 14:40:05 ---
Thanks for the answers guys.

to Hugues Tranli:

>maybe it's related to a daemon/software running in the background.
Well, that's pretty much what everybody want to find out. But seems it's not
that easy.

I'm on Xubuntu 11.10 on 3.0.0-17-generic #30-Ubuntu SMP Thu Mar 8 20:45:39 UTC
2012 x86_64 x86_64 x86_64 GNU/Linux on AMD CPU.
cat /etc/fstab and cat /proc/mounts give me usual default settings:
/ ext4 rw,noatime,errors=remount-ro,user_xattr,barrier=1,data=ordered
Except that I changed relatime to noatime. Though it's almost the same and on
desktop it doesn't give noticeable change in disk usage.

Block_dump:
See message 73 in https://bugs.launchpad.net/ubuntu/+source/linux/+bug/607560
but overall it's like this:
echo 1 > /proc/sys/vm/block_dump
Watch results in syslog (note that syslog will frequently write to disk) or by
periodically running dmesg. To get more "clean" results - disable kernel
logging in syslog, enable block_dump, wait some time or do something in the
system, then reenable kernel logging - results of block_dump should appear in
syslog.
I'm not aware of convenient way to watch it in realtime.


to Jan Kara:

Enabling ext4_mark_inode_dirty gives me constant flood of events where
xfce4-terminal dirties mostly two same inodes:
http://paste.ubuntu.com/988896/
Is it expected behavior? This is default terminal in Xubuntu.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
