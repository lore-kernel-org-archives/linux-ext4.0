From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: EXT4: lockdep complaints on 3.1-rc4+
Date: Tue, 20 Sep 2011 10:55:51 -0700
Message-ID: <20110920175551.GA4187@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57216 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1ITRz5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Sep 2011 13:55:57 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Not sure if it has been reported but I just got the following lockdep
warning on 3.1-rc4+ + my input queue (which does not touch FS code at
all):

[  327.735223] =======================================================
[  327.735228] [ INFO: possible circular locking dependency detected ]
[  327.735230] 3.1.0-rc4+ #664
[  327.735232] -------------------------------------------------------
[  327.735234] kontact/2570 is trying to acquire lock:
[  327.735236]  (&sb->s_type->i_mutex_key#14){+.+.+.}, at: [<ffffffff811f79a9>] ext4_evict_inode+0x29/0x5c0
[  327.735247] 
[  327.735247] but task is already holding lock:
[  327.735249]  (&mm->mmap_sem){++++++}, at: [<ffffffff81142b78>] sys_munmap+0x48/0x80
[  327.735256] 
[  327.735256] which lock already depends on the new lock.
[  327.735257] 
[  327.735259] 
[  327.735259] the existing dependency chain (in reverse order) is:
[  327.735262] 
[  327.735262] -> #1 (&mm->mmap_sem){++++++}:
[  327.735266]        [<ffffffff8109914a>] check_prevs_add+0xda/0x140
[  327.735271]        [<ffffffff81099788>] validate_chain+0x5d8/0x700
[  327.735275]        [<ffffffff8109a191>] __lock_acquire+0x461/0x9c0
[  327.735278]        [<ffffffff8109ada0>] lock_acquire+0x90/0x1f0
[  327.735282]        [<ffffffff811393c0>] might_fault+0x80/0xb0
[  327.735285]        [<ffffffff8118b187>] filldir+0x77/0xe0
[  327.735289]        [<ffffffff811eb71a>] call_filldir+0x9a/0xd0
[  327.735292]        [<ffffffff811eb8d2>] ext4_dx_readdir+0x182/0x240
[  327.735296]        [<ffffffff811ebb6f>] ext4_readdir+0x6f/0x3e0
[  327.735299]        [<ffffffff8118b458>] vfs_readdir+0xb8/0xf0
[  327.735302]        [<ffffffff8118b589>] sys_getdents+0x89/0x100
[  327.735305]        [<ffffffff81568beb>] system_call_fastpath+0x16/0x1b
[  327.735311] 
[  327.735311] -> #0 (&sb->s_type->i_mutex_key#14){+.+.+.}:
[  327.735316]        [<ffffffff81099068>] check_prev_add+0x6b8/0x6c0
[  327.735319]        [<ffffffff8109914a>] check_prevs_add+0xda/0x140
[  327.735323]        [<ffffffff81099788>] validate_chain+0x5d8/0x700
[  327.735326]        [<ffffffff8109a191>] __lock_acquire+0x461/0x9c0
[  327.735329]        [<ffffffff8109ada0>] lock_acquire+0x90/0x1f0
[  327.735332]        [<ffffffff8155e903>] mutex_lock_nested+0x63/0x3a0
[  327.735337]        [<ffffffff811f79a9>] ext4_evict_inode+0x29/0x5c0
[  327.735340]        [<ffffffff811932d3>] evict+0xa3/0x1b0
[  327.735343]        [<ffffffff811934c2>] iput_final+0xe2/0x1e0
[  327.735346]        [<ffffffff811935fe>] iput+0x3e/0x50
[  327.735349]        [<ffffffff8118f028>] dentry_iput+0xa8/0x100
[  327.735353]        [<ffffffff8118fbd3>] dput+0x123/0x220
[  327.735356]        [<ffffffff81179293>] __fput+0x173/0x250
[  327.735360]        [<ffffffff81179395>] fput+0x25/0x30
[  327.735362]        [<ffffffff811402f1>] remove_vma+0x51/0x90
[  327.735366]        [<ffffffff81141743>] do_munmap+0x1f3/0x2f0
[  327.735369]        [<ffffffff81142b86>] sys_munmap+0x56/0x80
[  327.735373]        [<ffffffff81568beb>] system_call_fastpath+0x16/0x1b
[  327.735377] 
[  327.735377] other info that might help us debug this:
[  327.735378] 
[  327.735380]  Possible unsafe locking scenario:
[  327.735380] 
[  327.735382]        CPU0                    CPU1
[  327.735384]        ----                    ----
[  327.735385]   lock(&mm->mmap_sem);
[  327.735388]                                lock(&sb->s_type->i_mutex_key);
[  327.735391]                                lock(&mm->mmap_sem);
[  327.735394]   lock(&sb->s_type->i_mutex_key);
[  327.735397] 
[  327.735398]  *** DEADLOCK ***
[  327.735399] 
[  327.735401] 1 lock held by kontact/2570:
[  327.735402]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81142b78>] sys_munmap+0x48/0x80
[  327.735408] 
[  327.735409] stack backtrace:
[  327.735412] Pid: 2570, comm: kontact Not tainted 3.1.0-rc4+ #664
[  327.735414] Call Trace:
[  327.735418]  [<ffffffff8154b5cf>] print_circular_bug+0xd1/0xe2
[  327.735423]  [<ffffffff81099068>] check_prev_add+0x6b8/0x6c0
[  327.735427]  [<ffffffff8109914a>] check_prevs_add+0xda/0x140
[  327.735430]  [<ffffffff81099788>] validate_chain+0x5d8/0x700
[  327.735433]  [<ffffffff8109a191>] __lock_acquire+0x461/0x9c0
[  327.735437]  [<ffffffff8109ada0>] lock_acquire+0x90/0x1f0
[  327.735441]  [<ffffffff811f79a9>] ? ext4_evict_inode+0x29/0x5c0
[  327.735444]  [<ffffffff811f79a9>] ? ext4_evict_inode+0x29/0x5c0
[  327.735448]  [<ffffffff8155e903>] mutex_lock_nested+0x63/0x3a0
[  327.735451]  [<ffffffff811f79a9>] ? ext4_evict_inode+0x29/0x5c0
[  327.735454]  [<ffffffff8119329f>] ? evict+0x6f/0x1b0
[  327.735457]  [<ffffffff8109ab4d>] ? __lock_release+0xad/0xd0
[  327.735460]  [<ffffffff811932c1>] ? evict+0x91/0x1b0
[  327.735464]  [<ffffffff8104f0b3>] ? get_parent_ip+0x33/0x50
[  327.735468]  [<ffffffff811f79a9>] ext4_evict_inode+0x29/0x5c0
[  327.735471]  [<ffffffff811932d3>] evict+0xa3/0x1b0
[  327.735474]  [<ffffffff811934c2>] iput_final+0xe2/0x1e0
[  327.735477]  [<ffffffff811935fe>] iput+0x3e/0x50
[  327.735480]  [<ffffffff8118f028>] dentry_iput+0xa8/0x100
[  327.735483]  [<ffffffff8118fbd3>] dput+0x123/0x220
[  327.735486]  [<ffffffff81179293>] __fput+0x173/0x250
[  327.735489]  [<ffffffff81179395>] fput+0x25/0x30
[  327.735492]  [<ffffffff811402f1>] remove_vma+0x51/0x90
[  327.735496]  [<ffffffff81141743>] do_munmap+0x1f3/0x2f0
[  327.735499]  [<ffffffff81142b86>] sys_munmap+0x56/0x80
[  327.735503]  [<ffffffff81568beb>] system_call_fastpath+0x16/0x1b

Thanks.

-- 
Dmitry
