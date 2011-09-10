From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
Date: Sat, 10 Sep 2011 14:07:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1109101403400.3905-100000@netrider.rowland.org>
References: <20110909191354.GC3818@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: bugzilla-daemon@bugzilla.kernel.org, <linux-ext4@vger.kernel.org>,
	<rockorequin@hotmail.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:57328 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933598Ab1IJSHD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 10 Sep 2011 14:07:03 -0400
In-Reply-To: <20110909191354.GC3818@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 9 Sep 2011, Ted Ts'o wrote:

> commit 6e478d46e58181ec4814f25a2fd91c6323e16ad4
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Fri Sep 9 15:02:54 2011 -0400
> 
>     ext4: add ext4-specific kludge to avoid an oops after the disk disappears
>     
>     The del_gendisk() function uninitializes the disk-specific data
>     structures, including the bdi structure, without telling anyone
>     else.  Once this happens, any attempt to call mark_buffer_dirty()
>     (for example, by ext4_commit_super), will cause a kernel OOPS.
>     
>     Fix this for now until we can fix things in an architecturally correct
>     way.
>     
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Further testing revealed the following problem.  I changed the test 
script so that after the USB device is unbound, the script tries to 
write a file before unmounting the ext4 filesystem.

There was no drastic failure; the unregistered bdi structure wasn't
accessed.  But lockdep complained.  This is what I got:

[  166.932194] end_request: I/O error, dev uba, sector 136
[  166.940903] EXT4-fs error (device uba): ext4_find_entry:934: inode #2: comm sh: reading directory lblock 0
[  166.949284] end_request: I/O error, dev uba, sector 164
[  166.952084] EXT4-fs error (device uba): ext4_read_inode_bitmap:161: comm sh: Cannot read inode bitmap - block_group = 0, inode_bitmap = 82
[  166.952906] EXT4-fs error (device uba) in ext4_new_inode:1073: IO failure
[  166.953357] 
[  166.953381] =============================================
[  166.953624] [ INFO: possible recursive locking detected ]
[  166.953958] 3.1.0-rc4 #34
[  166.954099] ---------------------------------------------
[  166.954295] sh/819 is trying to acquire lock:
[  166.954613]  (&sb->s_type->i_mutex_key#9){+.+.+.}, at: [<c1101290>] ext4_evict_inode+0x17/0x288
[  166.955947] 
[  166.955969] but task is already holding lock:
[  166.956281]  (&sb->s_type->i_mutex_key#9){+.+.+.}, at: [<c10aeb45>] do_last+0x165/0x4ff
[  166.956586] 
[  166.956586] other info that might help us debug this:
[  166.956586]  Possible unsafe locking scenario:
[  166.956586] 
[  166.956586]        CPU0
[  166.956586]        ----
[  166.956586]   lock(&sb->s_type->i_mutex_key);
[  166.956586]   lock(&sb->s_type->i_mutex_key);
[  166.956586] 
[  166.956586]  *** DEADLOCK ***
[  166.956586] 
[  166.956586]  May be due to missing lock nesting notation
[  166.956586] 
[  166.956586] 2 locks held by sh/819:
[  166.956586]  #0:  (&sb->s_type->i_mutex_key#9){+.+.+.}, at: [<c10aeb45>] do_last+0x165/0x4ff
[  166.956586]  #1:  (jbd2_handle){+.+...}, at: [<c112469f>] start_this_handle+0x3c2/0x41e
[  166.956586] 
[  166.956586] stack backtrace:
[  166.956586] Pid: 819, comm: sh Not tainted 3.1.0-rc4 #34
[  166.956586] Call Trace:
[  166.956586]  [<c135f26e>] ? printk+0xf/0x11
[  166.956586]  [<c105223c>] __lock_acquire+0x875/0xbe7
[  166.956586]  [<c1361600>] ? _raw_spin_unlock_irq+0x2d/0x30
[  166.956586]  [<c105183a>] ? mark_lock+0x26/0x1b3
[  166.956586]  [<c105183a>] ? mark_lock+0x26/0x1b3
[  166.956586]  [<c1052944>] lock_acquire+0x59/0x70
[  166.956586]  [<c1101290>] ? ext4_evict_inode+0x17/0x288
[  166.956586]  [<c13601f9>] __mutex_lock_common+0x38/0x2d4
[  166.956586]  [<c1101290>] ? ext4_evict_inode+0x17/0x288
[  166.956586]  [<c1360573>] mutex_lock_nested+0x32/0x3b
[  166.956586]  [<c1101290>] ? ext4_evict_inode+0x17/0x288
[  166.956586]  [<c1101290>] ext4_evict_inode+0x17/0x288
[  166.956586]  [<c10b5f63>] evict+0x7b/0x11c
[  166.956586]  [<c10b6136>] iput+0x132/0x137
[  166.956586]  [<c10fc467>] ext4_new_inode+0xa53/0xa92
[  166.956586]  [<c1108942>] ? ext4_journal_start_sb+0xdd/0xec
[  166.956586]  [<c10b4afb>] ? d_splice_alias+0xa9/0xb1
[  166.956586]  [<c11045ec>] ext4_create+0xa6/0x10b
[  166.956586]  [<c10ae2d7>] vfs_create+0x61/0x7b
[  166.956586]  [<c10aebd7>] do_last+0x1f7/0x4ff
[  166.956586]  [<c10aefa1>] path_openat+0x9d/0x2b7
[  166.956586]  [<c1052636>] ? lock_release_non_nested+0x88/0x1f7
[  166.956586]  [<c10af1f3>] do_filp_open+0x21/0x5d
[  166.956586]  [<c1361666>] ? _raw_spin_unlock+0x1d/0x2a
[  166.956586]  [<c10b78b1>] ? alloc_fd+0xc0/0xcb
[  166.956586]  [<c10a4207>] do_sys_open+0x54/0xcd
[  166.956586]  [<c10a429e>] sys_open+0x1e/0x26
[  166.956586]  [<c1361820>] syscall_call+0x7/0xb
[  167.175766] end_request: I/O error, dev uba, sector 16534
[  167.177204] Aborting journal on device uba-8.
[  167.179255] end_request: I/O error, dev uba, sector 16516
[  167.179768] Buffer I/O error on device uba, logical block 8258
[  167.179983] lost page write due to I/O error on uba
[  167.180866] JBD2: I/O error detected when updating journal superblock for uba-8.
[  167.181956] journal commit I/O error
[  167.195334] EXT4-fs error (device uba): ext4_put_super:817: Couldn't clean up the journal
[  167.195777] EXT4-fs (uba): Remounting filesystem read-only

It appears to be an unrelated error, but worth looking at.

Alan Stern

