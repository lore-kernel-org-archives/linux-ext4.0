From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3] Add largedir feature
Date: Mon, 3 Jul 2017 12:04:27 -0400
Message-ID: <20170703160427.hbyoajunvueijp7x@thunk.org>
References: <A4690934-D680-4735-AEA6-8BF995990546@dilger.ca>
 <1494094761-19108-1-git-send-email-artem.blagodarenko@seagate.com>
 <19F5F19B-23F5-466A-B934-EB15896E1B15@dilger.ca>
 <20170622011142.gu5qdyqsmuox7v4f@thunk.org>
 <20170624054356.43nui7l6o27dphrr@thunk.org>
 <26440F1A-EA5F-4DE2-80D3-C18D80928E5B@gmail.com>
 <20170624113649.2c33s7huhgteofs3@thunk.org>
 <20170702233056.oommhqsip46fruuc@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?0JHQu9Cw0LPQvtC00LDRgNC10L3QutC+INCQ0YDRgtGR0Lw=?=
        <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42990 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751910AbdGCQEe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 3 Jul 2017 12:04:34 -0400
Content-Disposition: inline
In-Reply-To: <20170702233056.oommhqsip46fruuc@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 02, 2017 at 07:30:56PM -0400, Theodore Ts'o wrote:
> 
> I haven't figured out if this is a recent regression, or whether this
> is something that we're only seeing recently.  It also seems to be
> related to some SCSI tag aborts that we aren't seeing elsewhere, so it
> may have to do with how we are issuing discards.  Whether this is a
> GCE issue or something which doesn't show up because the KVM I am
> handles discards differently is another unknown issue.  But I thought
> I would at least ease your mind that this doesn't seem to be a
> specifically a largedir issue.

... It now appears that the ext4/021 failure is caused by a GCE PD
bug, and it was unmasked by using 2048 byte inodes.  I've worked
around it for now by using mke2fs -E lazy_itable_init=0.  (The bug
seems to be triggered by the call to sb_issue_zeroout in the lazy
inode table initialization, and doesn't show up with the standard 256
byte inodes.)

The next failure I'm running into can be replicated on kvm-xfstests as
well as gce-xfstests, but it seems to be an xattr related failure,
with a handle not getting started with enough credits.  I need to look
at that one a bit closer, since it's not clear it's a large_dir
related one.  It's only triggering on the lustre_mds configuration,
though.  It runs clean on the standard ext4 4k configuration, which is
curious because it appear that the largedir code is implicated.

						- Ted

generic/070		[10:18:14][   63.464178] run fstests generic/070 at 2017-07-03 10:18:14
[   64.279344] ------------[ cut here ]------------
[   64.280358] WARNING: CPU: 1 PID: 3122 at /usr/projects/linux/ext4/fs/ext4/ext4_jbd2.c:277 __ext4_handle_dirty_metadata+0x173/0x27b
[   64.282634] CPU: 1 PID: 3122 Comm: fsstress Tainted: G             L  4.12.0-rc2-ext4-00042-g037ee4110538 #450
[   64.284483] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
[   64.285871] task: ffff88005e552780 task.stack: ffff8800687d0000
[   64.286868] RIP: 0010:__ext4_handle_dirty_metadata+0x173/0x27b
[   64.287950] RSP: 0018:ffff8800687d76d8 EFLAGS: 00010286
[   64.288921] RAX: ffff88006c02a340 RBX: ffff88003a146f40 RCX: ffffffff813e5e4f
[   64.290085] RDX: 1ffff10007428deb RSI: dffffc0000000000 RDI: ffff88006c02a340
[   64.291393] RBP: ffff8800687d7720 R08: ffff88005fff71f8 R09: ffffed000fff9608
[   64.292627] R10: 0000000000000000 R11: ffff88007ffcb043 R12: ffff88005fff71f8
[   64.293587] R13: 00000000ffffffe4 R14: ffff880064cb3750 R15: 00000000000007e7
[   64.294449] FS:  00007f642d4b3700(0000) GS:ffff88006d400000(0000) knlGS:0000000000000000
[   64.295845] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   64.296851] CR2: 00007f642d4b0000 CR3: 0000000068cb6000 CR4: 00000000000006e0
[   64.298117] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   64.298962] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   64.299879] Call Trace:
[   64.300206]  ext4_xattr_block_set+0x1034/0x12bf
[   64.300780]  ? ext4_xattr_inode_array_free+0x51/0x51
[   64.301463]  ? do_get_write_access+0x5bb/0x685
[   64.302040]  ? jbd2_journal_put_journal_head+0x1e7/0x202
[   64.302629]  ? ext4_xattr_check_entries+0x67/0xf7
[   64.303159]  ? memcmp+0x2e/0x4e
[   64.303468]  ? ext4_xattr_ibody_set+0x5b/0x108
[   64.303893]  ext4_xattr_set_handle+0x45e/0x7d6
[   64.304319]  ? check_noncircular+0x31/0x31
[   64.304773]  ? ext4_xattr_block_set+0x12bf/0x12bf
[   64.305331]  ? __lock_is_held+0x33/0x94
[   64.305749]  ? __ext4_journal_start_sb+0x136/0x1c0
[   64.306252]  ext4_xattr_set+0x156/0x1ce
[   64.306620]  ? ext4_xattr_set_handle+0x7d6/0x7d6
[   64.307077]  ? check_noncircular+0x31/0x31
[   64.307467]  ? kvm_clock_read+0x1e/0x20
[   64.307910]  ? mark_lock+0xba/0x75b
[   64.308304]  ? find_held_lock+0x80/0x91
[   64.308622]  ext4_xattr_user_set+0x72/0x7c
[   64.308959]  __vfs_setxattr+0x7c/0x8c
[   64.309314]  __vfs_setxattr_noperm+0x9a/0x1f3
[   64.309782]  vfs_setxattr+0x8d/0xa9
[   64.310246]  setxattr+0x18d/0x1cb
[   64.310641]  ? vfs_setxattr+0xa9/0xa9
[   64.311193]  ? __lock_is_held+0x33/0x94
[   64.311654]  ? rcu_read_lock_sched_held+0x4c/0x53
[   64.312148]  ? rcu_sync_lockdep_assert+0x41/0x67
[   64.312614]  ? __mnt_is_readonly+0x34/0x41
[   64.313032]  ? __mnt_want_write+0x83/0x8e
[   64.313378]  path_setxattr+0xda/0x12f
[   64.313586]  ? setxattr+0x1cb/0x1cb
[   64.313790]  ? trace_hardirqs_on_thunk+0x1a/0x1c
[   64.314049]  SyS_lsetxattr+0x11/0x15
[   64.314271]  entry_SYSCALL_64_fastpath+0x1f/0xbe
[   64.314604] RIP: 0033:0x7f642cdb65b9
[   64.314963] RSP: 002b:00007ffc9d620a58 EFLAGS: 00000246 ORIG_RAX: 00000000000000bd
[   64.315693] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007f642cdb65b9
[   64.316322] RDX: 00007f6428000ab0 RSI: 00007ffc9d620a90 RDI: 00007f64280008c0
[   64.316948] RBP: ffff8800687d7f98 R08: 0000000000000000 R09: 00007ffc9d620d40
[   64.317575] R10: 00000000000007d0 R11: 0000000000000246 R12: 0000000000052000
[   64.318260] R13: 0000000000000003 R14: 000000000004a000 R15: 000000000000005f
[   64.318847] Code: ef ff 48 8b 45 c8 48 8b 00 48 89 c7 48 89 45 c8 e8 cd 22 ef ff 48 8b 45 c8 f6 00 02 0f 85 ff 00 00 00 45 85 ed 0f 84 ef fe ff ff <0f> ff 48 8b 7d d0 45 89 e8 48 89 d9 44 89 fe 48 c7 c2 20 37 11 
[   64.320670] ---[ end trace ab1bc60121ac1b7e ]---
[   64.321081] EXT4-fs: ext4_xattr_block_set:2023: aborting transaction: error 28 in __ext4_handle_dirty_metadata
[   64.321893] EXT4-fs error (device vdd): ext4_xattr_block_set:2023: inode #131076: block 589906: comm fsstress: journal_dirty_metadata failed: handle type 10 started at line 2411, credits 5/0, errcode -28
[   64.326370] EXT4-fs error (device vdd) in ext4_xattr_set:2419: error 28
