From: Arun Bhanu <ab@arunbhanu.com>
Subject: [BUG?] [Ext4] INFO: suspicious rcu_dereference_check() usage
Date: Sun, 21 Nov 2010 19:26:11 +0800
Message-ID: <20101121112611.GB4267@deepthought.bhanu.net>
Reply-To: Arun Bhanu <ab@arunbhanu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Paul McKenney <paulmck@linux.vnet.ibm.com>,
	Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:51420 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab0KUL0T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Nov 2010 06:26:19 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I saw this in kernel log messages while testing 2.6.37-rc2. I think it
appeared while mounting an external hard-disk. I can't seem to
reproduce it.

Please let me know if you need more info.

[47064.272151] ===================================================
[47064.273474] [ INFO: suspicious rcu_dereference_check() usage. ]
[47064.273956] ---------------------------------------------------
[47064.274431] include/linux/radix-tree.h:145 invoked rcu_dereference_check() without protection!
[47064.274905] 
[47064.274906] other info that might help us debug this:
[47064.274907] 
[47064.276303] 
[47064.276303] rcu_scheduler_active = 1, debug_locks = 0
[47064.277202] 2 locks held by mount/21199:
[47064.277635]  #0:  (&type->s_umount_key#20/1){+.+.+.}, at: [<c05007f0>] sget+0x21f/0x35d
[47064.278078]  #1:  (&(&inode->i_data.tree_lock)->rlock){..-.-.}, at: [<c04f5e67>] migrate_page_move_mapping+0x3a/0x120
[47064.278529] 
[47064.278529] stack backtrace:
[47064.279409] Pid: 21199, comm: mount Not tainted 2.6.37-rc2-ab2-589136bfa784a4558b397f017ca2f06f0ca9080e+ #1
[47064.279864] Call Trace:
[47064.280313]  [<c0822e61>] ? printk+0x2d/0x34
[47064.280765]  [<c04709c8>] lockdep_rcu_dereference+0x97/0x9f
[47064.281220]  [<c04f5e28>] radix_tree_deref_slot+0x4a/0x4f
[47064.281680]  [<c04f5ea7>] migrate_page_move_mapping+0x7a/0x120
[47064.282129]  [<c04f6323>] migrate_page+0x1f/0x35
[47064.282573]  [<c04f6464>] move_to_new_page+0x12b/0x164
[47064.283017]  [<c04f6773>] migrate_pages+0x1e1/0x2ee
[47064.283463]  [<c04eed89>] ? compaction_alloc+0x0/0x1ef
[47064.283918]  [<c04eebdc>] compact_zone+0x24f/0x3fc
[47064.284363]  [<c04ef0f4>] try_to_compact_pages+0x17c/0x1e6
[47064.284820]  [<c04cac33>] __alloc_pages_nodemask+0x397/0x6b7
[47064.285276]  [<c04caf75>] __get_free_pages+0x22/0x33
[47064.285729]  [<c04f4304>] __kmalloc+0x2f/0x112
[47064.286193]  [<c0435adc>] ? should_resched+0xd/0x28
[47064.286655]  [<c0578ca9>] kzalloc.clone.58+0x12/0x14
[47064.287118]  [<c057c7f1>] ext4_fill_super+0x1090/0x2521
[47064.287573]  [<c040ea02>] ? native_sched_clock+0x14/0x52
[47064.288029]  [<c054774a>] ? disk_name+0x86/0x90
[47064.288477]  [<c0523bfa>] ? set_blocksize+0x33/0x78
[47064.288930]  [<c0500aed>] mount_bdev+0x123/0x16d
[47064.289385]  [<c057b761>] ? ext4_fill_super+0x0/0x2521
[47064.289842]  [<c05776fd>] ? ext4_mount+0x0/0x24
[47064.290300]  [<c057771c>] ext4_mount+0x1f/0x24
[47064.290760]  [<c057b761>] ? ext4_fill_super+0x0/0x2521
[47064.291222]  [<c05003e1>] vfs_kern_mount+0xa1/0x1ad
[47064.291687]  [<c0511c36>] ? get_fs_type+0x38/0x91
[47064.292149]  [<c0500546>] do_kern_mount+0x3d/0xc8
[47064.292615]  [<c05142b2>] do_mount+0x614/0x640
[47064.293056]  [<c04d69f0>] ? strndup_user+0x2e/0x3f
[47064.293489]  [<c05144a1>] sys_mount+0x6d/0x99
[47064.293925]  [<c040971f>] sysenter_do_call+0x12/0x38
[47064.368116] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: (null)

-Arun
