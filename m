From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 93031] root becomes read-only at boot due to
 journal_async_commit in /etc/fstab
Date: Thu, 22 Oct 2015 22:06:33 +0000
Message-ID: <bug-93031-13602-KJiUN8yj2A@https.bugzilla.kernel.org/>
References: <bug-93031-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34918 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964967AbbJVWGg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Oct 2015 18:06:36 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C58FB20824
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2015 22:06:35 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 216C220811
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2015 22:06:34 +0000 (UTC)
In-Reply-To: <bug-93031-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=93031

Andrey Lelikov <bugzillakernel1@lelik.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bugzillakernel1@lelik.org

--- Comment #3 from Andrey Lelikov <bugzillakernel1@lelik.org> ---
I also experience same behaviour. The system is unbootable. Please note, that i
do NOT have journal_checksum in fstab. On a kernel that works I have the
following:

/etc/fstab:
/dev/mapper/root_crypt /               ext4   
errors=remount-ro,data=writeback,noatime,nobarrier,journal_async_commit,commit=120,dioread_nolock

/proc/mounts:
/dev/disk/by-uuid/a3dc1a73-42b9-4295-b0b0-93934b57d317 / ext4
rw,noatime,dioread_nolock,journal_checksum,journal_async_commit,nobarrier,errors=remount-ro,commit=120,data=writeback

On 3.18 (ubuntu trusty) I can't boot any way - regular boot fails to mount,
mount -o remount doesn't work with any options - with or without
journal_async_commit and/or journal_checksum.

Note that on 3.13 everything works, all flags are properly applied and they are
NOT silently ignored.

So this is a bug, but it is yet in denial stage. "remove journal_checksum from
fstab, or add it to rootflags, everything works, la-la-la". Pedantic idiots.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
