From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89621] EXT4-fs error (device dm-1):
 ext4_mb_release_inode_pa:3773: group 24089, free 34, pa_free 32
Date: Wed, 12 Aug 2015 09:08:36 +0000
Message-ID: <bug-89621-13602-BCkQGMDjIt@https.bugzilla.kernel.org/>
References: <bug-89621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58639 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933425AbbHLJIk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Aug 2015 05:08:40 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CA30220713
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2015 09:08:38 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 5FA7020710
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2015 09:08:36 +0000 (UTC)
In-Reply-To: <bug-89621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89621

--- Comment #19 from John Hughes <john@calva.com> ---
(In reply to Theodore Tso from comment #17)
> John, are you willing to give us a lot more details about your set up?  
> Hardware, software, details of the host OS, details of the guest OS, what is
> the workload where the problem is happening, etc?
> 
> And it might be helpful if you opened a separate bug which we use
> exclusively for tracking your particular issue.

Ok, I've opened https://bugzilla.kernel.org/show_bug.cgi?id=102731

Please let me know if you need more info.

> One thing to keep in mind when we are talking about problems found in the
> guest OS is that misconfigurations at the host OS level can be
> indistinguishable from hardware problems.   So for example, depending on the
> caching policy used by KVM in the host OS issues, it may be that cache flush
> commands in the guest OS don't peculate down all the way down to the actual
> hardware platters.   Thus, after a power fail event, even if everything is
> configured correctly at the guest OS, it can result in an inconsistent file
> system image because the KVM / the host OS didn't make sure everything got
> pushed to the disk after a journal commit.

I have had one power fail, but since then mdadm has run a consistency check and
found no inconsistencies.

I'm also running regular (once a week) fsck's on (snapshots of) my filesystems.
 So far the fsck have never found a problem.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
