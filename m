Return-Path: <SRS0=dqau=MX=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46602 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728239AbeJLCaj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 11 Oct 2018 22:30:39 -0400
Date: Thu, 11 Oct 2018 15:02:01 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        joel@joelfernandes.org, paulmck@linux.ibm.com,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH -v3] ext4: fix use-after-free race in ext4_remount()'s
 error path
Message-ID: <20181011190201.GA565@thunk.org>
References: <20181007030706.9094-1-tytso@mit.edu>
 <20181011102800.GB9467@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181011102800.GB9467@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 11, 2018 at 12:28:00PM +0200, Jan Kara wrote:
> Well, honestly the fact that ->show_options can be called while remount is
> changing stuff under you looks problematic to me and I bet ext4 is not the
> only one that would have issues with that. So I believe we might be better
> off with just synchronizing ->show_options with umount / remount properly.
> What were the lock dependency problems that made you switch to use RCU?

Agreed that "cat /proc/mounts" racing with "mount -o remount" could
result in inconsistent results getting printed, but other
inconsistencies should not result in an outright crash.  (It's
actually hard to get the crash in the first place, since it requires
really malicious syzbot^H^H^H^H^H^H program to trigger it at all, and
even syzbot was not able to hit this reliably, so it couldn't create a
repro.)

As far as the lock dependency problem is concerned, introducing
down_read(&sb->s_umount) to ->show_options() creates the potential
3-way circular deadlock:

        CPU0                    CPU1
        ----                    ----
   down_write(&inode->i_rwsem)
                                down_read(&sb->s_umount);
                                down_write(&inode->i_rwsem)
   down_write(&namespace_sem);

					- Ted

root: ext4/4k run xfstest generic/306

EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: acl,user_xattr,block_validity
EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: acl,user_xattr,block_validity
EXT4-fs (dm-1): re-mounted. Opts: (null)

======================================================
WARNING: possible circular locking dependency detected
4.19.0-rc6-xfstests-00017-g97536a3f5dff #644 Not tainted
------------------------------------------------------
mount/25708 is trying to acquire lock:
00000000556213f2 (namespace_sem){++++}, at: lock_mount+0x3b/0x100

but task is already holding lock:
000000006492cd73 (&sb->s_type->i_mutex_key#11){++++}, at: lock_mount+0x2b/0x100

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&sb->s_type->i_mutex_key#11){++++}:
       down_write+0x48/0xb0
       vfs_load_quota_inode+0x45b/0x4d0
       ext4_quota_on+0x126/0x260
       kernel_quotactl+0x6ce/0x860
       __x64_sys_quotactl+0x1a/0x20
       do_syscall_64+0x56/0x190
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #1 (&type->s_umount_key#26){++++}:
       down_read+0x3f/0xa0
       _ext4_show_options+0x3ba/0x7f0
       show_mountinfo+0x1f1/0x2a0
       seq_read+0x15e/0x400
       __vfs_read+0x36/0x190
       vfs_read+0x9f/0x130
       ksys_read+0x52/0xc0
       do_syscall_64+0x56/0x190
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #0 (namespace_sem){++++}:
       lock_acquire+0xa6/0x180
       down_write+0x48/0xb0
       lock_mount+0x3b/0x100
       do_mount+0x49c/0xdf0
       ksys_mount+0xba/0xd0
       __x64_sys_mount+0x21/0x30
       do_syscall_64+0x56/0x190
       entry_SYSCALL_64_after_hwframe+0x49/0xbe

other info that might help us debug this:

Chain exists of:
  namespace_sem --> &type->s_umount_key#26 --> &sb->s_type->i_mutex_key#11

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&sb->s_type->i_mutex_key#11);
                               lock(&type->s_umount_key#26);
                               lock(&sb->s_type->i_mutex_key#11);
  lock(namespace_sem);

 *** DEADLOCK ***

1 lock held by mount/25708:
 #0: 000000006492cd73 (&sb->s_type->i_mutex_key#11){++++}, at: lock_mount+0x2b/0x100

stack backtrace:
CPU: 1 PID: 25708 Comm: mount Not tainted 4.19.0-rc6-xfstests-00017-g97536a3f5dff #644
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 dump_stack+0x85/0xc0
 print_circular_bug.isra.19.cold.39+0x1c3/0x21f
 check_prev_add.constprop.27+0x4ec/0x730
 __lock_acquire+0xbbd/0xf40
 lock_acquire+0xa6/0x180
 ? lock_mount+0x3b/0x100
 down_write+0x48/0xb0
 ? lock_mount+0x3b/0x100
 lock_mount+0x3b/0x100
 do_mount+0x49c/0xdf0
 ksys_mount+0xba/0xd0
 __x64_sys_mount+0x21/0x30
 do_syscall_64+0x56/0x190
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f7cd5d0824a
Code: 48 8b 0d 51 fc 2a 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 1e fc 2a 00 f7 d8 64 89 01 48
RSP: 002b:00007fffe6526c48 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 000055c88728d060 RCX: 00007f7cd5d0824a
RDX: 000055c88728ff30 RSI: 000055c88728d260 RDI: 000055c88728d240
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000020
R10: 00000000c0ed1000 R11: 0000000000000206 R12: 000055c88728d240
R13: 000055c88728ff30 R14: 0000000000000000 R15: 00000000ffffffff
EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: acl,user_xattr,block_validity
EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: acl,user_xattr,block_validity
