From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 53951] race condition on mounting local disks with autofs
Date: Thu, 06 Feb 2014 00:19:07 +0000
Message-ID: <bug-53951-13602-Q37bA1X04I@https.bugzilla.kernel.org/>
References: <bug-53951-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52630 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbaBFATL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Feb 2014 19:19:11 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E04CA20142
	for <linux-ext4@vger.kernel.org>; Thu,  6 Feb 2014 00:19:08 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 59E6D20145
	for <linux-ext4@vger.kernel.org>; Thu,  6 Feb 2014 00:19:07 +0000 (UTC)
In-Reply-To: <bug-53951-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=53951

--- Comment #3 from Ian Kent <raven@themaw.net> ---
On Wed, 2014-02-05 at 12:49 -0500, Theodore Ts'o wrote:
> Original bug report, from https://bugzilla.kernel.org/show_bug.cgi?id=53951:
> 
> Harald Dunkel 2013-02-16 15:55:40 UTC
> 
> I am using autofs to mount a local disk to /misc/data6 on
> request. Problem: It seems that the first access silently fails, if
> the disk is not yet mounted.

Does it!

Or is it the mix of system calls that are made, some of which won't
trigger the mount and others that will. I know from experience that
find(1) does a fairly unusual mix of these calls.

Does it still happen if you append a "/" to /misc/data6.

Since there are a number of system calls that won't trigger mounts,
which is required to avoid mount storms, there needs to be some way to
selectively force mount triggering and appending a "/" to a path is the
way it's done (at least it should function that way).

Mind you the mix of calls won't matter if the automount is mounted
"nobrowse" since mount point directories that don't yet exist should
trigger a mount on any access.

The default installed autofs configuration sets this but if you wiped
out the configuration and didn't retain that setting then the automount
will be mounted "browse", the internal program default.

What are you using for that setting?

Ian

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
