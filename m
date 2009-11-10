From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14562] On umount warn in page_alloc.c:1751
 __alloc_pages_slowpath
Date: Tue, 10 Nov 2009 21:24:39 GMT
Message-ID: <200911102124.nAALOdii017486@demeter.kernel.org>
References: <bug-14562-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35691 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbZKJVYe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Nov 2009 16:24:34 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAALOdZf017487
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2009 21:24:39 GMT
In-Reply-To: <bug-14562-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14562





--- Comment #3 from Torsten Krah <tkrah@fachschaft.imn.htwk-leipzig.de>  2009-11-10 21:24:36 ---
At the moment it reads:

UUID=64cde1ce-04f7-4392-8d6b-427aba6a6f0e /home           ext4   
defaults,relatime,errors=remount-ro,auto_da_alloc

Same output:

[   10.747524] ------------[ cut here ]------------
[   10.747540] WARNING: at /build/buildd/linux-2.6.31/mm/page_alloc.c:1751
__alloc_pages_slowpath+0x459/0x480()
[   10.747544] Hardware name: CoronaR
[   10.747546] Modules linked in: dm_raid45 xor fbcon tileblit font bitblit
softcursor radeon ttm drm 8139too radeonfb fb_ddc i2c_algo_bit 8139cp mii
ohci1394 ieee1394 video output intel_agp agpgart
[   10.747573] Pid: 479, comm: mount Tainted: G        W  2.6.31-15-generic
#49-Ubuntu
[   10.747576] Call Trace:
[   10.747586]  [<c014518d>] warn_slowpath_common+0x6d/0xa0
[   10.747591]  [<c01b8429>] ? __alloc_pages_slowpath+0x459/0x480
[   10.747595]  [<c01b8429>] ? __alloc_pages_slowpath+0x459/0x480
[   10.747600]  [<c01451d5>] warn_slowpath_null+0x15/0x20
[   10.747605]  [<c01b8429>] __alloc_pages_slowpath+0x459/0x480
[   10.747682]  [<c01b7e50>] ? get_page_from_freelist+0x1e0/0x360
[   10.747688]  [<c01b855f>] __alloc_pages_nodemask+0x10f/0x120
[   10.747692]  [<c01b85b7>] __get_free_pages+0x17/0x30
[   10.747699]  [<c01e088f>] __kmalloc+0xdf/0x180
[   10.747705]  [<c0319c0e>] match_number+0x2e/0xa0
[   10.747709]  [<c0319caa>] match_int+0xa/0x10
[   10.747715]  [<c02745c2>] parse_options+0x152/0x810
[   10.747721]  [<c0209b46>] ? __wait_on_buffer+0x26/0x30
[   10.747726]  [<c027c356>] ext4_fill_super+0x3f6/0x1900
[   10.747733]  [<c01ea585>] get_sb_bdev+0x135/0x170
[   10.747738]  [<c027bf60>] ? ext4_fill_super+0x0/0x1900
[   10.747742]  [<c01b8500>] ? __alloc_pages_nodemask+0xb0/0x120
[   10.747747]  [<c02732e1>] ext4_get_sb+0x21/0x30
[   10.747751]  [<c027bf60>] ? ext4_fill_super+0x0/0x1900
[   10.747755]  [<c01ea17e>] vfs_kern_mount+0x5e/0x120
[   10.747760]  [<c01ea299>] do_kern_mount+0x39/0xd0
[   10.747765]  [<c01ff2ee>] do_new_mount+0x6e/0xa0
[   10.747770]  [<c01ffcb9>] do_mount+0x1c9/0x1e0
[   10.747774]  [<c01ffd36>] sys_mount+0x66/0xa0
[   10.747779]  [<c010336c>] syscall_call+0x7/0xb
[   10.747782] ---[ end trace a7919e7f17c0a727 ]---
[   11.095569] EXT4-fs (sda5): barriers enabled
[   11.468196] kjournald2 starting: pid 668, dev sda5:8, commit interval 5
seconds
[   11.661199] EXT4-fs (sda5): internal journal on sda5:8
[   11.661207] EXT4-fs (sda5): delayed allocation enabled
[   11.661211] EXT4-fs: file extents enabled
[   11.661991] EXT4-fs: mballoc enabled
[   11.662010] EXT4-fs (sda5): mounted filesystem with ordered data mode

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
