From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89621] EXT4-fs error (device dm-1):
 ext4_mb_release_inode_pa:3773: group 24089, free 34, pa_free 32
Date: Tue, 11 Aug 2015 21:11:02 +0000
Message-ID: <bug-89621-13602-lC2JC5RCeC@https.bugzilla.kernel.org/>
References: <bug-89621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59006 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbbHKVLF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Aug 2015 17:11:05 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C9C49206B7
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2015 21:11:04 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id AF42A206AF
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2015 21:11:02 +0000 (UTC)
In-Reply-To: <bug-89621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89621

cwseys@physics.wisc.edu changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |cwseys@physics.wisc.edu

--- Comment #18 from cwseys@physics.wisc.edu ---
Hi John,
  Me too!  :p  We're having similar symptoms.  Running VMs with Wheezy (kernel
version 3.2), SL6 (kernel version 2.6), and Jessie (kernel version 3.16).

  Only Jessie VMs go read-only sporadically even when running on the same host.
 I'm recording which VM host this is happening on, hoping to find a pattern,
but so far not luck.

  Also, not easily reproducible.  E.g. for me (maybe not same bug!) the hosts
have both been running software RAID and have been using hardware RAID cards.
Not all the VMs running 3.16 have had this problem, but some have had it
multiple times.

If I hit on a reliable failure I will start git bisecting between 3.2 and 3.16.
 (A brute force approach, but maybe helpful.)

Chad.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
