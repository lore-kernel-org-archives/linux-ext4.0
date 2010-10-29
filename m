From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 20902] High IO wait when writing to ext4
Date: Fri, 29 Oct 2010 16:11:02 GMT
Message-ID: <201010291611.o9TGB2xa006844@demeter2.kernel.org>
References: <bug-20902-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:42974 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab0J2QLD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Oct 2010 12:11:03 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o9TGB2Sa006846
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 29 Oct 2010 16:11:02 GMT
In-Reply-To: <bug-20902-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=20902


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #8 from Eric Sandeen <sandeen@redhat.com>  2010-10-29 16:10:59 ---
Any chance you can test w/o LUKS to see how that affects things?

If I had to guess I'd say things are stuck behind here:

[  554.110652] flush-252:1   D ffff880001e14cc0     0  2186      2 0x00000000
[  554.110679] Call Trace:
[  554.110686]  [<ffffffff81586503>] io_schedule+0x73/0xc0
[  554.110692]  [<ffffffff81180ab5>] sync_buffer+0x45/0x50
[  554.110714]  [<ffffffff81586e8d>] out_of_line_wait_on_bit+0x7d/0x90
[  554.110725]  [<ffffffff811809f8>] __wait_on_buffer+0x28/0x30
[  554.110732]  [<ffffffff81217199>] ext4_mb_init_cache+0x389/0x900

I guess ext4_mb_init_cache() is in:

        /* wait for I/O completion */
        for (i = 0; i < groups_per_page && bh[i]; i++)
                wait_on_buffer(bh[i]);

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
