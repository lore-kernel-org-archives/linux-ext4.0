From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16312] WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
Date: Mon, 26 Jul 2010 17:53:04 GMT
Message-ID: <201007261753.o6QHr4Gr004228@demeter.kernel.org>
References: <bug-16312-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45407 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab0GZRxH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jul 2010 13:53:07 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o6QHr5Kt004229
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 26 Jul 2010 17:53:05 GMT
In-Reply-To: <bug-16312-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16312





--- Comment #9 from Larry Finger <Larry.Finger@lwfinger.net>  2010-07-26 17:53:04 ---
These patches break my system (the one reported in Bug #16122). It obviously is
different.

After installing the patches. I get a NULL pointer dereference for address 0x30
as __mark_inode_dirty + 0xf0/0x1a0 (x86_64 system). The code offset 0xf30. I
have a 2.6.35-rc6 kernel.

The assembler code around that address is

/home/finger/linux-temp/fs/fs-writeback.c:960
     f28:       4d 8b ac 24 b0 01 00    mov    0x1b0(%r12),%r13
     f2f:       00 
/home/finger/linux-temp/fs/fs-writeback.c:962
     f30:       41 f6 45 30 02          testb  $0x2,0x30(%r13)
     f35:       75 31                   jne    f68 <__mark_inode_dirty+0x128>
     f37:       41 f6 45 28 10          testb  $0x10,0x28(%r13)
     f3c:       75 2a                   jne    f68 <__mark_inode_dirty+0x128>

The code at line 960 is:

        struct backing_dev_info *bdi = wb->bdi;

        if (bdi_cap_writeback_dirty(bdi) &&
            !test_bit(BDI_registered, &bdi->state)) {
                WARN_ON(1);
                printk(KERN_ERR "bdi-%s not registered\n",
                       bdi->name);
        }

and wb->bdi is NULL.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
