From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Mon, 09 Nov 2015 08:50:58 +0000
Message-ID: <bug-107301-13602-wfM2NtuuTF@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41040 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbbKIIvC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Nov 2015 03:51:02 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D02DC205EC
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2015 08:51:00 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 83663204A0
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2015 08:50:58 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

--- Comment #7 from Jan Kara <jack@suse.cz> ---
Yeah, that would test what the performance would look like without mbcache.
BTW: Among xattrs ceph is using how many of them are the same? Mbcache is a win
for the common case where xattrs are mostly used for ACLs or SE Linux labels
and thus the reuse is big (mbcache is essentially a deduplication layer for
xattrs). 

And yes, it is in a need of some updates to meet current scalability demands (I
don't think what you hit is a bug as such, rather an inefficiency that becomes
lethal at your scale) - other users than ceph occasionally report issues as
well. Probably we should track things per-fs, not globally, hook each per-fs
mbcache into the shrinker framework and don't introduce artificial upper bounds
on the number of entries and instead let natural memory pressure deal with it.

For now I'm not convinced adding a mount option to disable mbcache is the right
way to go. Rather we should make it lightweight enough that it doesn't add too
much overhead for the cases where it is not needed. With the mount option there
is always the trouble that someone has to know it to turn it on/off and
sometimes there even isn't a good choice as you can have heavy xattr reuse for
some inodes and also quite a few unique xattrs for other inodes...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
