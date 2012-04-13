From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42986] ext2_fs.h requires undefined type umode_t
Date: Fri, 13 Apr 2012 06:48:53 GMT
Message-ID: <201204130648.q3D6mrb3007044@bugzilla.kernel.org>
References: <bug-42986-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:42777 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab2DMGsx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Apr 2012 02:48:53 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q3D6mrt9007045
	for <linux-ext4@vger.kernel.org>; Fri, 13 Apr 2012 06:48:53 GMT
In-Reply-To: <bug-42986-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42986


Artem Bityutskiy <dedekind1@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dedekind1@gmail.com




--- Comment #15 from Artem Bityutskiy <dedekind1@gmail.com>  2012-04-13 06:48:52 ---
(In reply to comment #13)
> For the record: busybox's mkfs_ext2.c uses linux/ext2_fs.h.
> If its include is commented out, the following errors pop out:

The idea is that file-system on-disk layout is stable, so it should be easy for
you to have a copy, and you do not need to ever update it unless you add
support of a new feature in busybox which requeres an up-to-date header file,
and this should be a rare event.

>From the FS'es POW - the on-disk layout is not kernel-userspace API so kernel
should not export it to user-space. This will also make things easier for the
kernel people - we can freely clean-up/rename/shuffle things in the header
without being afraid of breaking busybox or any other tool.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
