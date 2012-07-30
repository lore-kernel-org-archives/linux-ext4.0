From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42895] jbd2 makes all system unresponsive
Date: Mon, 30 Jul 2012 20:00:49 +0000 (UTC)
Message-ID: <20120730200049.AF4CF11FC62@bugzilla.kernel.org>
References: <bug-42895-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59129 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755586Ab2G3UAw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jul 2012 16:00:52 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 220BF2031B
	for <linux-ext4@vger.kernel.org>; Mon, 30 Jul 2012 20:00:51 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 2F215202D6
	for <linux-ext4@vger.kernel.org>; Mon, 30 Jul 2012 20:00:50 +0000 (UTC)
In-Reply-To: <bug-42895-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42895


Nicolas Ecarnot <nicolas.ecarnot@free.fr> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |nicolas.ecarnot@free.fr




--- Comment #21 from Nicolas Ecarnot <nicolas.ecarnot@free.fr>  2012-07-30 20:00:49 ---
Hi,

I eventually found the thread I was looking for and I feel the need to testify
what I'm experiencing.

I have some IT skills but here I won't go deep into details.
I'm a very conservative user and my setups and software usage are *very*
stable. The set of apps I'm using month after month do not change, and I'm not
the kind of people that installs a new app or plugin every day.
That allows me to observe the improvement or flows of system upgrades as time
goes by.

I'm using Xubuntu Precise 12.04 on a 64 bits cpu :
| root@xxxxx:~# uname -a
| Linux xxxxx 3.2.0-27-generic #43-Ubuntu SMP Fri Jul 6 14:25:57 UTC 2012
x86_64 x86_64 x86_64 GNU/Linux
and I'm running the common almost daily/weekly upgrades.

Since say one week, every action I do leads to a massive disk I/O activity that
freezes my whole system (GUI or via ssh, same punishment). The action I'm
talking about are very complex : open a new tab in firefox, launch xterm,
create a new mail, close xterm, click to expand the menu (!)...
To post the message you are reading, I had to create an account.
Clicking on the "Send" button to submit my form took a solid two minutes to
complete. This makes no sense.

Read my lips : my setup was very simple and efficient, and all of a sudden, it
became unusable.

As other tried it, I tried to play with iotop, htop and so on. I tried to blame
my home partition in btrfs, but I'm using it with no issue for months. I tried
to blame some specific apps, and thought I found it when disabling a
iphone-automount related bin, but issue arose since.
I discovered the recent use of cgroups, but I've no clue whether this deserves
blaming. From times to times, iotop is showing my jbd2 activity, of btrfs
caching, but this is not related to 100% of freeze events.
Googling showed me this was not an ubuntu-specific issue.
Experts will have to decide if this is a filesystem-specific issue...

This bug appears to me quite serious and deserves attention. I'm very surprised
such a thing isn't more widely spread and then fixed.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
