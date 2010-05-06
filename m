From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15906] performance regression in "umount" of filesystems using
 barriers
Date: Thu, 6 May 2010 03:49:03 GMT
Message-ID: <201005060349.o463n3Nf004098@demeter.kernel.org>
References: <bug-15906-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37777 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab0EFDtG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 May 2010 23:49:06 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o463n3f6004099
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 6 May 2010 03:49:03 GMT
In-Reply-To: <bug-15906-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15906





--- Comment #17 from Dmitry Monakhov <dmonakhov@openvz.org>  2010-05-06 03:48:58 ---
(In reply to comment #15)
> The summary for this patch should probably be changed, yes?   It should happen
> with filesystems other than ext4 that use barriers (i.e., btrfs, XFS), and it
> should happen on a single disk just as easily as a LVM.  The latter I can
> confirm --- you can see the performance degradation quite easily on a single
> disk, so the mention of LVM in the summary is probably misleading.

Just a note, performance degradation is not that huge for XFS, as soon as i
understand this is because it batch several inode writes in to one 'log' so
less barriers required
But nor than less this is generic writeback issue.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
