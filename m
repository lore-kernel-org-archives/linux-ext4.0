From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13549] Kernel oops while online resizing of an ext4 filesystem
Date: Mon, 22 Mar 2010 17:00:33 GMT
Message-ID: <201003221700.o2MH0XNp010351@demeter.kernel.org>
References: <bug-13549-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40640 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab0CVRAf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Mar 2010 13:00:35 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2MH0XHa010354
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 22 Mar 2010 17:00:33 GMT
In-Reply-To: <bug-13549-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=13549





--- Comment #7 from Alessandro Polverini <alex@nibbles.it>  2010-03-22 17:00:22 ---
Hello Eric,
here is the output of dumpe2fs (the file system was mounted when running it).
Please note that now the FS has been expanded, but the operation has been done
(like the other times) offline (unmounted). The kernel hangs when trying to do
it online (mounted).

dumpe2fs 1.41.3 (12-Oct-2008)
Filesystem volume name:   <none>
Last mounted on:          /mnt/disk2
Filesystem UUID:          b0e46f62-5ac9-48f5-8582-f602652385d3
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype
needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg
dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              62259200
Block count:              249036800
Reserved block count:     0
Free blocks:              23664521
Free inodes:              55316695
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      964
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Filesystem created:       Sun Nov 16 15:50:37 2008
Last mount time:          Mon Mar 22 07:22:00 2010
Last write time:          Mon Mar 22 07:22:00 2010
Mount count:              2
Maximum mount count:      32
Last checked:             Sun Mar 21 09:28:05 2010
Check interval:           15552000 (6 months)
Next check after:         Fri Sep 17 10:28:05 2010
Lifetime writes:          7204 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      7aad3588-6b5c-4bcb-b60f-0227bef217b7
Journal backup:           inode blocks
Journal size:             128M

Please tell me if I can be of further assistance,
Alex

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
