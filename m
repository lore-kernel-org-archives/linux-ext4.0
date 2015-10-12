From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Mon, 12 Oct 2015 10:36:00 +0000
Message-ID: <bug-102731-13602-N0RBdgX8Io@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35415 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbbJLKgE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Oct 2015 06:36:04 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7AA85207F2
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2015 10:36:02 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id C143D205B6
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2015 10:36:00 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #18 from John Hughes <john@calva.com> ---
> I just realized something which I forgot to ask you --- what file system are
> you using on the *host*?  You said that on the guest you are using ext3 file
> systems with the ext4 driver --- but what about on the host OS side?

The volumes passed to the guest are just mdadm volumes, no fs from the 
point of view of the host.

The host filesystems are all ext3 (on lvm, on mdadm) , the host runs the 
debian 3.16 backport kernel, but it does very little filesystem I/O.

> I will say that using a full ext4 file system is far more stable on 3.18.21
> than using an ext3 file system in compatibility mode.
What's the magic command to convert an ext3 fs to ext4?  The wisdom of 
net seems to say:

tune2fs -O extents,uninit_bg,dir_index /dev/xxx
fsck.ext4 -yfD /dev/xxx

Or would it be better to make a new FS and copy the files?
> One of the reasons why I ask is that the PUNCH hole functionality was
> relatively new in the 3.18 kernel, and KVM uses it --- and I am suspicious that
> there might be some bug fixes that didn't land in the 3.18 kernel.
Was it used in 3.16?  I first saw the problem with debians 3.16 based 
kernel.

>     So one
> thing that might be worth trying is to get a 4.2.3 kernel for both your Host
> and Guest kernels, and see what that does for you.

Ok, I'll investigate that.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
