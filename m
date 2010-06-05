From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16122] 2.6.35-rc1: WARNING at fs/fs-writeback.c:1142
 __mark_inode_dirty+0x103/0x170
Date: Sat, 5 Jun 2010 14:55:10 GMT
Message-ID: <201006051455.o55EtAeo001326@demeter.kernel.org>
References: <bug-16122-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45733 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622Ab0FEOzK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jun 2010 10:55:10 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o55EtA61001327
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 5 Jun 2010 14:55:10 GMT
In-Reply-To: <bug-16122-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16122





--- Comment #8 from Larry Finger <Larry.Finger@lwfinger.net>  2010-06-05 14:54:58 ---
I'm willing to work on this, but don't know where to start.

Is there a simple explanation of when and where bdi_register() should be
called?

I put a test of the returned value of bdi_register_dev() in add_disk(), but
never got a non-zero result.

BTW, is this snippet in bdi_register() correct?

    if (bdi->dev)   /* The driver needs to use separate queues per device */
           goto exit;

This smells like an error, but returns zero.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
