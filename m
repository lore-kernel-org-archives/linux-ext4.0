From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42895] jbd2 makes all system unresponsive
Date: Sun, 13 May 2012 15:30:31 +0000 (UTC)
Message-ID: <20120513153031.7EB4111FCE2@bugzilla.kernel.org>
References: <bug-42895-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:56289 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457Ab2EMPag (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 May 2012 11:30:36 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4A44A203C2
	for <linux-ext4@vger.kernel.org>; Sun, 13 May 2012 15:30:35 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 85692203CD
	for <linux-ext4@vger.kernel.org>; Sun, 13 May 2012 15:30:31 +0000 (UTC)
In-Reply-To: <bug-42895-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42895





--- Comment #8 from Eugene <ivanovstm2@zmail.ru>  2012-05-13 15:30:31 ---
There's related jbd2 bug in Ubuntu:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/607560 - ext4 jbd2 writing
block every 5-10 seconds, preventing disk spin-down and making noise. Even when
PC is idle.
Bug report open 2010.08 and still active; includes newest Ubuntu 12.04.
+ half a dozen of threads on Ubuntu and Archlinux forums including thread for
this bug:
https://bbs.archlinux.org/viewtopic.php?id=139087 - Intense disk IO (jbd2 and
flush) blocks user interface.

I personally not sure that this is jbd2's fault. Something must be going on in
the system. The problem is that nobody is able to point a finger at the cause
except that jbd2 writes to disk.


Following instructions given by Theodore Ts'O, I don't see excessive usage of
fsync:
http://paste.ubuntu.com/981398

block_dump of my idle system doesn't shows something out of ordinary except
much of flush/jbd2 activity:
http://paste.ubuntu.com/983568/
(sda3 /, sda6 /home. Network Manager writes every 5min, xfconfd - every 10min;
open apps - terminal, gedit, xfce thunar and light screensaver; syslog
disabled).

When I watch /proc/meminfo "Dirty:" field, it shows that during and *following*
any system activity - memory being dirtied ~every 3-15 seconds (accompanied
with audible HDD clicks) and flushed to disk. This goes on for some time then
all quietens.
"iotop" shows jbd2 writes and writes of process which it can't properly
recognize.


Is there a way to find a cause of flush and jbd2 writes? Like apllication name
or PID?
Preferably without need to patch/compile new kernel, so that as many people as
possible can use it.


P.S. Subjective feeling is that any work done on system (and often idling too)
no matter how light is accompanied by noticeable HDD clicks every ~5sec. And
opening even relatively light apps like gedit leads to bursts of loud HDD
usage.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
