From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16122] 2.6.35-rc1: WARNING at fs/fs-writeback.c:1142
 __mark_inode_dirty+0x103/0x170
Date: Wed, 9 Jun 2010 10:46:10 GMT
Message-ID: <201006091046.o59Ak9T4020375@demeter.kernel.org>
References: <bug-16122-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53336 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab0FIKqM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jun 2010 06:46:12 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o59AkANR020377
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jun 2010 10:46:10 GMT
In-Reply-To: <bug-16122-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16122





--- Comment #10 from Jens Axboe <axboe@kernel.dk>  2010-06-09 10:45:50 ---
This puzzles me... Larry, can you try .34? I don't think this is a regression
from .34.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
