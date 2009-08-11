From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13604] cascade of "mpage_da_map_blocks block allocation failed"
 errors
Date: Tue, 11 Aug 2009 11:00:32 GMT
Message-ID: <200908111100.n7BB0WTG018576@demeter.kernel.org>
References: <bug-13604-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42442 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbZHKMgb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Aug 2009 08:36:31 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7BB0WgY018577
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2009 11:00:32 GMT
In-Reply-To: <bug-13604-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13604


Cyber <MadLoisae@gmx.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |MadLoisae@gmx.net




--- Comment #1 from Cyber <MadLoisae@gmx.net>  2009-08-11 11:00:31 ---
Hello! (:

same problem here with kernel 2.6.30.4.

my partition was filled completly.
my partition table is correct, all partitions were never resized, they were
created new with ext4 (not migrated from ext3).

[941998.471199] mpage_da_map_blocks block allocation failed for inode 36 at
logical offset 3544 with max blocks 1 with error -28
[941998.471345] This should not happen.!! Data will be lost
[941998.471444] Total free blocks count 0
[941998.471524] Free/Dirty block details
[941998.471603] free_blocks=0
[941998.471680] dirty_blocks=0
[941998.471757] Block reservation details
[941998.471838] i_reserved_data_blocks=2
[941998.471918] i_reserved_meta_blocks=2
[941998.472638] mpage_da_map_blocks block allocation failed for inode 36 at
logical offset 3865 with max blocks 1 with error -28
[941998.472799] This should not happen.!! Data will be lost
[941998.472898] Total free blocks count 0
[941998.472978] Free/Dirty block details
[941998.473058] free_blocks=0
[941998.473135] dirty_blocks=0
[941998.473213] Block reservation details
[941998.473294] i_reserved_data_blocks=2
[941998.473374] i_reserved_meta_blocks=2

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
