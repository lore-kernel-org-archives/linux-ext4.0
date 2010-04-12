From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15768] Incorrectly calculated free blocks result in ENOSPC from
 writepage
Date: Mon, 12 Apr 2010 11:32:48 GMT
Message-ID: <201004121132.o3CBWmtZ016819@demeter.kernel.org>
References: <bug-15768-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39903 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab0DLLcu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Apr 2010 07:32:50 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3CBWnpx016821
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 12 Apr 2010 11:32:49 GMT
In-Reply-To: <bug-15768-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15768





--- Comment #1 from Dmitry Monakhov <dmonakhov@openvz.org>  2010-04-12 11:32:41 ---
dmesg after testcase check 

kjournald2 starting: pid 1310, dev sdb1:8, commit interval 5 seconds
EXT4-fs (sdb1): internal journal on sdb1:8
EXT4-fs (sdb1): delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs (sdb1): recovery complete
EXT4-fs (sdb1): mounted filesystem with ordered data mode
mpage_da_map_blocks block allocation failed for inode 14 at logical offset 4667
with max blocks 5192 with error -28
This should not happen.!! Data will be lost
Total free blocks count 0
Free/Dirty block details
free_blocks=7222
dirty_blocks=5209
Block reservation details
i_reserved_data_blocks=5192
i_reserved_meta_blocks=17

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
