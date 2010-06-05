From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16122] 2.6.35-rc1: WARNING at fs/fs-writeback.c:1142
 __mark_inode_dirty+0x103/0x170
Date: Sat, 5 Jun 2010 04:14:22 GMT
Message-ID: <201006050414.o554EMSG031692@demeter.kernel.org>
References: <bug-16122-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48933 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab0FEEOX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jun 2010 00:14:23 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o554EMJL031693
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 5 Jun 2010 04:14:22 GMT
In-Reply-To: <bug-16122-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16122





--- Comment #6 from Larry Finger <Larry.Finger@lwfinger.net>  2010-06-05 04:14:19 ---
It is "block". The messages are as follows:

[   30.303036] ---[ end trace a80f1425532f94da ]---
[   30.303039] bdi-block not registered
[   30.325691] loop: module loaded
[   30.427469] EXT3-fs: barriers not enabled
[   30.438818] kjournald starting.  Commit interval 5 seconds
[   30.439197] EXT3-fs (sda7): using internal journal

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
