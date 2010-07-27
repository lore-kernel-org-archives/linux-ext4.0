From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16312] WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
Date: Tue, 27 Jul 2010 14:20:45 GMT
Message-ID: <201007271420.o6REKjLj018703@demeter.kernel.org>
References: <bug-16312-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45267 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab0G0OUq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jul 2010 10:20:46 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o6REKjdZ018704
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 27 Jul 2010 14:20:45 GMT
In-Reply-To: <bug-16312-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16312





--- Comment #13 from Larry Finger <Larry.Finger@lwfinger.net>  2010-07-27 14:20:44 ---
The log will have to be hand written. The system would not boot, neither a
netconsole or serial console is possible, and the pictures I took of the screen
are really blurry.

The beginning of the dump is:

Inode devices at sysfs has uninit bdi
Mapping bdi sysfs, caps 131
inode_to_bdi returns bdi noop, caps 0
bdi=noop not registered
BUG: unable to handle NULL pointer at offset 0x8
__mark_inode_dirty+0x159/0x240

The above NULL pointer is in the expansion of

      list_move(&inode->i_list, &wb->b_dirty);

at the statement next->prev = new

Beyond this point, it generates lots of other errors and eventually hangs.

Good luck.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
