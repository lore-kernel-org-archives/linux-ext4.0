From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 109331] EXT4-fs (sda1): couldn't mount as ext3 due to feature
 incompatibilities
Date: Mon, 14 Dec 2015 04:30:38 +0000
Message-ID: <bug-109331-13602-zOY5eqcVEn@https.bugzilla.kernel.org/>
References: <bug-109331-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56545 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbbLNEal (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Dec 2015 23:30:41 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 089CC20524
	for <linux-ext4@vger.kernel.org>; Mon, 14 Dec 2015 04:30:40 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id AB4522051A
	for <linux-ext4@vger.kernel.org>; Mon, 14 Dec 2015 04:30:38 +0000 (UTC)
In-Reply-To: <bug-109331-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=109331

--- Comment #1 from KernelBug <3fdd1e5d@opayq.com> ---
This is my fstab;

/dev/sda1        /                ext4        defaults           1 1
#/dev/cdrom      /mnt/cdrom       auto       
noauto,owner,ro,comment=x-gvfs-show 0 0
devpts           /dev/pts         devpts      gid=5,mode=620     0 0
proc             /proc            proc        defaults           0 0
tmpfs            /dev/shm         tmpfs       defaults           0 0

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
