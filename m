From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: Ext4 Kernel Crash
Date: Tue, 31 Jan 2012 15:43:42 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1201311541430.7601@dhcp-27-109.brq.redhat.com>
References: <20120129175057.GA4699@dinofilaria.home> <alpine.LNX.2.00.1201292251500.27749@swampdragon.chaosbits.net> <alpine.LFD.2.00.1201311524050.7601@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jesper Juhl <jj@chaosbits.net>,
	Nanakos Chrysostomos <nanakos@wired-net.gr>,
	linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783Ab2AaOnr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Jan 2012 09:43:47 -0500
In-Reply-To: <alpine.LFD.2.00.1201311524050.7601@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Just a follow-up, if you are a Red Hat customer, please, refer this
issue trough the appropriate channels so we can get this issue solved
for you.

Thanks!
-Lukas

On Tue, 31 Jan 2012, Lukas Czerner wrote:

> Hi,
> 
> this problem is likely to be already resolved in the recent distribution
> kernel and it is unlikely to be an upstream issue.
> 
> Also there is no crash but just a hang.
> 
> Thanks!
> -Lukas
> 
> On Sun, 29 Jan 2012, Jesper Juhl wrote:
> 
> > On Sun, 29 Jan 2012, Nanakos Chrysostomos wrote:
> > 
> > > Dear Linux Kernel Developers,
> > > I am writing to report a kernel or ext4 bug.
> > > I have two servers populated with 2 LUNs from the main storage facility,
> > > each server has one LUN which is about 1.2TB. On top of that I am
> > > utilizing glusterfs and samba to mount the 2.4TB created space to a
> > > Windows server and other Linux machines (via glusterfs native client). 
> > > Yesterday I tried to copy to the new storage glusterfs space about 788GB 
> > > and in the morning I got from both machines the attached kernel messages.
> > > I have to mention that the first machine runs samba and mounts the
> > > allocated glusterfs space with the help of FUSE glusterfs driver. The
> > > second machine doesn't mount/export anything and simply runs the glusterfs
> > > service.
> > > I have to also add that similar problems have happened to another system
> > > which is used as a TIF to JP2 converter. The conversion path starts from
> > > the conversion of a pdf file to png and then to jp2. As you can imagine
> > > this process produces hundreds of thousands of files. Similarly the
> > > machine crashes and I get similar kernel messages concerning ext4. I can't
> > > give you more information on that because the machine crashes, I have to
> > > take a photo and send it back to you next time.
> > > What do you believe about the kernel messages? Is this a ext4 bug when
> > > thousands of files are created? How can I help resolve that?
> > > 
> > > Please Cc me because I am not in the list.
> > > 
> > > With kind regards,
> > > Chris.
> > > 
> > 
> > 1. Adding ext4 people to CC.
> > 
> > 2. Took a quick look (without knowing much about ext4, mind you), and I 
> > noticed something that is, probably unrelated, but just in case it is not:
> > 
> > In ext4_new_inode(), at the 'got:' label we have this code:
> > 
> > [...]
> > got:
> >         /* We may have to initialize the block bitmap if it isn't already */
> >         if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&
> >             gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
> >                 struct buffer_head *block_bitmap_bh;
> > 
> >                 block_bitmap_bh = ext4_read_block_bitmap(sb, group);
> >                 BUFFER_TRACE(block_bitmap_bh, "get block bitmap access");
> >                 err = ext4_journal_get_write_access(handle, block_bitmap_bh);
> >                 if (err) {
> >                         brelse(block_bitmap_bh);
> >                         goto fail;
> >                 }
> > 
> >                 BUFFER_TRACE(block_bitmap_bh, "dirty block bitmap");
> >                 err = ext4_handle_dirty_metadata(handle, NULL, block_bitmap_bh);
> > [...]
> > 
> > In the above, ext4_read_block_bitmap() may return NULL. If it does, then 
> > the calls to ext4_journal_get_write_access() and 
> > ext4_handle_dirty_metadata() are not safe, since both those functions may 
> > call other functions that may end up dereferencing their argument (the 
> > ext4_read_block_bitmap() return value).
> > 
> > Whether or not that will ever actually happen and whether or not it's 
> > related to your problem, I don't know.
> > But I thought I'd share the info.
> > 
> > > 
> > > PS: Are there any ext4 kernel optimization's for avoiding that or
> > > narrowing down the problem if this is not so obvious?
> > > 
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > glusterfsd    D 0000000000000000     0  2070      1 0x00000000
> > >  ffff88003daa5c68 0000000000000082 0000000000000000 000000010000000b
> > >  ffff88003daa5d18 ffff88003daa5c98 ffff88003daa5bf8 ffffffff81090957
> > >  ffff88003a912638 ffff88003daa5fd8 000000000000f4e8 ffff88003a912638
> > > Call Trace:
> > >  [<ffffffff81090957>] ? bit_waitqueue+0x17/0xd0
> > >  [<ffffffffa00de09d>] do_get_write_access+0x29d/0x520 [jbd2]
> > >  [<ffffffff81090ad0>] ? wake_bit_function+0x0/0x50
> > >  [<ffffffffa013293b>] ? __ext4_handle_dirty_metadata+0x7b/0x100 [ext4]
> > >  [<ffffffffa00de471>] jbd2_journal_get_write_access+0x31/0x50 [jbd2]
> > >  [<ffffffffa0132b78>] __ext4_journal_get_write_access+0x38/0x80 [ext4]
> > >  [<ffffffffa0114fb9>] ext4_orphan_add+0xb9/0x1f0 [ext4]
> > >  [<ffffffffa01146b9>] ? ext4_delete_entry+0xf9/0x110 [ext4]
> > >  [<ffffffffa0116a8b>] ext4_unlink+0x29b/0x2b0 [ext4]
> > >  [<ffffffff81183edf>] vfs_unlink+0x9f/0xe0
> > >  [<ffffffff81182c2a>] ? lookup_hash+0x3a/0x50
> > >  [<ffffffff81186463>] do_unlinkat+0x183/0x1c0
> > >  [<ffffffff81183601>] ? path_put+0x31/0x40
> > >  [<ffffffff8119ad11>] ? sys_lgetxattr+0x61/0x80
> > >  [<ffffffff811864b6>] sys_unlink+0x16/0x20
> > >  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> > > INFO: task glusterfsd:2322 blocked for more than 120 seconds.
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > glusterfsd    D 0000000000000000     0  2322      1 0x00000000
> > >  ffff88003c70dc48 0000000000000082 0000000000000000 00000001810949db
> > >  0000000000000000 0000000000000000 ffff88003c70dcb0 0000000000000000
> > >  ffff88003b18baf8 ffff88003c70dfd8 000000000000f4e8 ffff88003b18baf8
> > > Call Trace:
> > >  [<ffffffffa00de09d>] do_get_write_access+0x29d/0x520 [jbd2]
> > >  [<ffffffff81090ad0>] ? wake_bit_function+0x0/0x50
> > >  [<ffffffffa00de471>] jbd2_journal_get_write_access+0x31/0x50 [jbd2]
> > >  [<ffffffffa0132b78>] __ext4_journal_get_write_access+0x38/0x80 [ext4]
> > >  [<ffffffffa010e253>] ext4_reserve_inode_write+0x73/0xa0 [ext4]
> > >  [<ffffffffa0107158>] ? call_filldir+0x78/0xe0 [ext4]
> > >  [<ffffffffa010e2cc>] ext4_mark_inode_dirty+0x4c/0x1d0 [ext4]
> > >  [<ffffffffa010e5c0>] ext4_dirty_inode+0x40/0x60 [ext4]
> > >  [<ffffffff8119fceb>] __mark_inode_dirty+0x3b/0x160
> > >  [<ffffffff8119040d>] touch_atime+0x12d/0x170
> > >  [<ffffffff8118a290>] ? filldir+0x0/0xe0
> > >  [<ffffffff8118a526>] vfs_readdir+0xd6/0xe0
> > >  [<ffffffff8118a699>] sys_getdents+0x89/0xf0
> > >  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> > > INFO: task smbd:2585 blocked for more than 120 seconds.
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > smbd          D 0000000000000000     0  2585   1998 0x00000000
> > >  ffff88003b299bb8 0000000000000082 000000000000007a 0000000000000286
> > >  ffff88003b23b8c0 000000000000007e ffff88003b299b98 ffff88003b23b8c0
> > >  ffff88003a913ab8 ffff88003b299fd8 000000000000f4e8 ffff88003a913ab8
> > > Call Trace:
> > >  [<ffffffff814ee01e>] __mutex_lock_slowpath+0x13e/0x180
> > >  [<ffffffff8118d11f>] ? d_free+0x3f/0x60
> > >  [<ffffffff814edebb>] mutex_lock+0x2b/0x50
> > >  [<ffffffff811848af>] do_lookup+0xef/0x1e0
> > >  [<ffffffff811851d4>] __link_path_walk+0x734/0x1030
> > >  [<ffffffff81183795>] ? path_to_nameidata+0x45/0x60
> > >  [<ffffffff81185d5a>] path_walk+0x6a/0xe0
> > >  [<ffffffff81185f2b>] do_path_lookup+0x5b/0xa0
> > >  [<ffffffff81186b97>] user_path_at+0x57/0xa0
> > >  [<ffffffff81042c24>] ? __do_page_fault+0x1e4/0x480
> > >  [<ffffffff81182fc5>] ? putname+0x35/0x50
> > >  [<ffffffff81186ba2>] ? user_path_at+0x62/0xa0
> > >  [<ffffffff8117b786>] vfs_fstatat+0x46/0x80
> > >  [<ffffffff81195630>] ? mntput_no_expire+0x30/0x110
> > >  [<ffffffff8117b8eb>] vfs_stat+0x1b/0x20
> > >  [<ffffffff8117b914>] sys_newstat+0x24/0x50
> > >  [<ffffffff814f23fe>] ? do_page_fault+0x3e/0xa0
> > >  [<ffffffff814ef7b5>] ? page_fault+0x25/0x30
> > >  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> > > INFO: task smbd:2586 blocked for more than 120 seconds.
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > smbd          D 0000000000000000     0  2586   1998 0x00000000
> > >  ffff88003b1e7bb8 0000000000000082 0000000000000088 0000000000000286
> > >  ffff88003b619380 000000000000008c ffff88003b1e7b98 ffff88003b619380
> > >  ffff880037a59af8 ffff88003b1e7fd8 000000000000f4e8 ffff880037a59af8
> > > Call Trace:
> > >  [<ffffffff8141ccde>] ? release_sock+0xce/0xe0
> > >  [<ffffffff814ee01e>] __mutex_lock_slowpath+0x13e/0x180
> > >  [<ffffffff814edebb>] mutex_lock+0x2b/0x50
> > >  [<ffffffff811848af>] do_lookup+0xef/0x1e0
> > >  [<ffffffff811851d4>] __link_path_walk+0x734/0x1030
> > >  [<ffffffff81183795>] ? path_to_nameidata+0x45/0x60
> > >  [<ffffffff81185d5a>] path_walk+0x6a/0xe0
> > >  [<ffffffff81185f2b>] do_path_lookup+0x5b/0xa0
> > >  [<ffffffff81186b97>] user_path_at+0x57/0xa0
> > >  [<ffffffff81042c24>] ? __do_page_fault+0x1e4/0x480
> > >  [<ffffffff81182fc5>] ? putname+0x35/0x50
> > >  [<ffffffff81186ba2>] ? user_path_at+0x62/0xa0
> > >  [<ffffffff8117b786>] vfs_fstatat+0x46/0x80
> > >  [<ffffffff81195630>] ? mntput_no_expire+0x30/0x110
> > >  [<ffffffff8117b8eb>] vfs_stat+0x1b/0x20
> > >  [<ffffffff8117b914>] sys_newstat+0x24/0x50
> > >  [<ffffffff814f23fe>] ? do_page_fault+0x3e/0xa0
> > >  [<ffffffff814ef7b5>] ? page_fault+0x25/0x30
> > >  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> > > INFO: task smbd:2587 blocked for more than 120 seconds.
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > smbd          D 0000000000000001     0  2587   1998 0x00000000
> > >  ffff88003d5efbb8 0000000000000086 0000000000000000 0000000000000286
> > >  ffff880037047cc0 000000000000007e ffff88003d5efb98 ffff880037047cc0
> > >  ffff88003b04f038 ffff88003d5effd8 000000000000f4e8 ffff88003b04f038
> > > Call Trace:
> > >  [<ffffffff814ee01e>] __mutex_lock_slowpath+0x13e/0x180
> > >  [<ffffffff814edebb>] mutex_lock+0x2b/0x50
> > >  [<ffffffff811848af>] do_lookup+0xef/0x1e0
> > >  [<ffffffff811851d4>] __link_path_walk+0x734/0x1030
> > >  [<ffffffff81183795>] ? path_to_nameidata+0x45/0x60
> > >  [<ffffffff81185d5a>] path_walk+0x6a/0xe0
> > >  [<ffffffff81185f2b>] do_path_lookup+0x5b/0xa0
> > >  [<ffffffff81186b97>] user_path_at+0x57/0xa0
> > >  [<ffffffff81042c24>] ? __do_page_fault+0x1e4/0x480
> > >  [<ffffffff81182fc5>] ? putname+0x35/0x50
> > >  [<ffffffff81186ba2>] ? user_path_at+0x62/0xa0
> > >  [<ffffffff8117b786>] vfs_fstatat+0x46/0x80
> > >  [<ffffffff81195630>] ? mntput_no_expire+0x30/0x110
> > >  [<ffffffff8117b8eb>] vfs_stat+0x1b/0x20
> > >  [<ffffffff8117b914>] sys_newstat+0x24/0x50
> > >  [<ffffffff814f23fe>] ? do_page_fault+0x3e/0xa0
> > >  [<ffffffff814ef7b5>] ? page_fault+0x25/0x30
> > >  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> > > INFO: task smbd:2588 blocked for more than 120 seconds.
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > smbd          D 0000000000000001     0  2588   1998 0x00000000
> > >  ffff88003b093bb8 0000000000000082 0000000000000000 0000000000000286
> > >  ffff88003a9e69c0 000000000000007e ffff88003b093b98 ffff88003a9e69c0
> > >  ffff8800376f9b38 ffff88003b093fd8 000000000000f4e8 ffff8800376f9b38
> > > Call Trace:
> > >  [<ffffffff814ee01e>] __mutex_lock_slowpath+0x13e/0x180
> > >  [<ffffffff814edebb>] mutex_lock+0x2b/0x50
> > >  [<ffffffff811848af>] do_lookup+0xef/0x1e0
> > >  [<ffffffff811851d4>] __link_path_walk+0x734/0x1030
> > >  [<ffffffff81183795>] ? path_to_nameidata+0x45/0x60
> > >  [<ffffffff81185d5a>] path_walk+0x6a/0xe0
> > >  [<ffffffff81185f2b>] do_path_lookup+0x5b/0xa0
> > >  [<ffffffff81186b97>] user_path_at+0x57/0xa0
> > >  [<ffffffff81042c24>] ? __do_page_fault+0x1e4/0x480
> > >  [<ffffffff81182fc5>] ? putname+0x35/0x50
> > >  [<ffffffff81186ba2>] ? user_path_at+0x62/0xa0
> > >  [<ffffffff8117b786>] vfs_fstatat+0x46/0x80
> > >  [<ffffffff81195630>] ? mntput_no_expire+0x30/0x110
> > >  [<ffffffff8117b8eb>] vfs_stat+0x1b/0x20
> > >  [<ffffffff8117b914>] sys_newstat+0x24/0x50
> > >  [<ffffffff814f23fe>] ? do_page_fault+0x3e/0xa0
> > >  [<ffffffff814ef7b5>] ? page_fault+0x25/0x30
> > >  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> > > INFO: task smbd:2589 blocked for more than 120 seconds.
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > smbd          D 0000000000000001     0  2589   1998 0x00000000
> > >  ffff8800374c1bb8 0000000000000086 0000000000000088 0000000000000286
> > >  ffff880037bf50c0 000000000000008c ffff8800374c1b98 ffff880037bf50c0
> > >  ffff88003b18a678 ffff8800374c1fd8 000000000000f4e8 ffff88003b18a678
> > > Call Trace:
> > >  [<ffffffff8141ccde>] ? release_sock+0xce/0xe0
> > >  [<ffffffff814ee01e>] __mutex_lock_slowpath+0x13e/0x180
> > >  [<ffffffff814edebb>] mutex_lock+0x2b/0x50
> > >  [<ffffffff811848af>] do_lookup+0xef/0x1e0
> > >  [<ffffffff811851d4>] __link_path_walk+0x734/0x1030
> > >  [<ffffffff81183795>] ? path_to_nameidata+0x45/0x60
> > >  [<ffffffff81185d5a>] path_walk+0x6a/0xe0
> > >  [<ffffffff81185f2b>] do_path_lookup+0x5b/0xa0
> > >  [<ffffffff81186b97>] user_path_at+0x57/0xa0
> > >  [<ffffffff81042c24>] ? __do_page_fault+0x1e4/0x480
> > >  [<ffffffff81182fc5>] ? putname+0x35/0x50
> > >  [<ffffffff81186ba2>] ? user_path_at+0x62/0xa0
> > >  [<ffffffff8117b786>] vfs_fstatat+0x46/0x80
> > >  [<ffffffff81195630>] ? mntput_no_expire+0x30/0x110
> > >  [<ffffffff8117b8eb>] vfs_stat+0x1b/0x20
> > >  [<ffffffff8117b914>] sys_newstat+0x24/0x50
> > >  [<ffffffff814f23fe>] ? do_page_fault+0x3e/0xa0
> > >  [<ffffffff814ef7b5>] ? page_fault+0x25/0x30
> > >  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> > > INFO: task glusterfsd:2322 blocked for more than 120 seconds.
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > glusterfsd    D 0000000000000001     0  2322      1 0x00000000
> > >  ffff88003c70da28 0000000000000082 ffff880000020f58 ffff88003b8615a8
> > >  ffff88003c70d9a8 ffffffff81467515 ffff88003b8615a8 ffff88003b8615a8
> > >  ffff88003b18baf8 ffff88003c70dfd8 000000000000f4e8 ffff88003b18baf8
> > > Call Trace:
> > >  [<ffffffff81467515>] ? ip_local_out+0x25/0x30
> > >  [<ffffffff81090d7e>] ? prepare_to_wait+0x4e/0x80
> > >  [<ffffffffa00de09d>] do_get_write_access+0x29d/0x520 [jbd2]
> > >  [<ffffffff81090ad0>] ? wake_bit_function+0x0/0x50
> > >  [<ffffffffa00de471>] jbd2_journal_get_write_access+0x31/0x50 [jbd2]
> > >  [<ffffffffa0132b78>] __ext4_journal_get_write_access+0x38/0x80 [ext4]
> > >  [<ffffffffa010e253>] ext4_reserve_inode_write+0x73/0xa0 [ext4]
> > >  [<ffffffffa010e2cc>] ext4_mark_inode_dirty+0x4c/0x1d0 [ext4]
> > >  [<ffffffffa0141ccd>] ? ext4_init_security+0x2d/0x296 [ext4]
> > >  [<ffffffffa012d73e>] ext4_ext_tree_init+0x3e/0x60 [ext4]
> > >  [<ffffffffa010a500>] ext4_new_inode+0x1150/0x1190 [ext4]
> > >  [<ffffffffa0117c90>] ext4_create+0xc0/0x150 [ext4]
> > >  [<ffffffff811822a3>] ? generic_permission+0x23/0xb0
> > >  [<ffffffff81183c84>] vfs_create+0xb4/0xe0
> > >  [<ffffffff8118788f>] do_filp_open+0xb2f/0xd60
> > >  [<ffffffff81193482>] ? alloc_fd+0x92/0x160
> > >  [<ffffffff81173a49>] do_sys_open+0x69/0x140
> > >  [<ffffffff8119ad11>] ? sys_lgetxattr+0x61/0x80
> > >  [<ffffffff81173b60>] sys_open+0x20/0x30
> > >  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> > > INFO: task smbd:2614 blocked for more than 120 seconds.
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > smbd          D 0000000000000001     0  2614   1998 0x00000000
> > >  ffff88003c63dbb8 0000000000000086 0000000000000000 0000000000000286
> > >  ffff88003b6014c0 000000000000007c ffff88003c63db98 ffff88003b6014c0
> > >  ffff88003a913ab8 ffff88003c63dfd8 000000000000f4e8 ffff88003a913ab8
> > > Call Trace:
> > >  [<ffffffff814ee01e>] __mutex_lock_slowpath+0x13e/0x180
> > >  [<ffffffff8118e957>] ? __d_lookup+0xa7/0x150
> > >  [<ffffffff814edebb>] mutex_lock+0x2b/0x50
> > >  [<ffffffff811848af>] do_lookup+0xef/0x1e0
> > >  [<ffffffff811851d4>] __link_path_walk+0x734/0x1030
> > >  [<ffffffff81183795>] ? path_to_nameidata+0x45/0x60
> > >  [<ffffffff81185d5a>] path_walk+0x6a/0xe0
> > >  [<ffffffff81185f2b>] do_path_lookup+0x5b/0xa0
> > >  [<ffffffff81186b97>] user_path_at+0x57/0xa0
> > >  [<ffffffff81042c24>] ? __do_page_fault+0x1e4/0x480
> > >  [<ffffffff81182fc5>] ? putname+0x35/0x50
> > >  [<ffffffff81186ba2>] ? user_path_at+0x62/0xa0
> > >  [<ffffffff8117b786>] vfs_fstatat+0x46/0x80
> > >  [<ffffffff81195630>] ? mntput_no_expire+0x30/0x110
> > >  [<ffffffff8117b8eb>] vfs_stat+0x1b/0x20
> > >  [<ffffffff8117b914>] sys_newstat+0x24/0x50
> > >  [<ffffffff814f23fe>] ? do_page_fault+0x3e/0xa0
> > >  [<ffffffff814ef7b5>] ? page_fault+0x25/0x30
> > >  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> > > INFO: task smbd:2615 blocked for more than 120 seconds.
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > smbd          D 0000000000000001     0  2615   1998 0x00000000
> > >  ffff88003d9bbbb8 0000000000000086 0000000000000000 0000000000000286
> > >  ffff88003720f580 000000000000008a ffff88003d9bbb98 ffff88003720f580
> > >  ffff880037a59af8 ffff88003d9bbfd8 000000000000f4e8 ffff880037a59af8
> > > Call Trace:
> > >  [<ffffffff814ee01e>] __mutex_lock_slowpath+0x13e/0x180
> > >  [<ffffffff814edebb>] mutex_lock+0x2b/0x50
> > >  [<ffffffff811848af>] do_lookup+0xef/0x1e0
> > >  [<ffffffff811851d4>] __link_path_walk+0x734/0x1030
> > >  [<ffffffff81183795>] ? path_to_nameidata+0x45/0x60
> > >  [<ffffffff81185d5a>] path_walk+0x6a/0xe0
> > >  [<ffffffff81185f2b>] do_path_lookup+0x5b/0xa0
> > >  [<ffffffff81186b97>] user_path_at+0x57/0xa0
> > >  [<ffffffff81042c24>] ? __do_page_fault+0x1e4/0x480
> > >  [<ffffffff81182fc5>] ? putname+0x35/0x50
> > >  [<ffffffff81186ba2>] ? user_path_at+0x62/0xa0
> > >  [<ffffffff8117b786>] vfs_fstatat+0x46/0x80
> > >  [<ffffffff81195630>] ? mntput_no_expire+0x30/0x110
> > >  [<ffffffff8117b8eb>] vfs_stat+0x1b/0x20
> > >  [<ffffffff8117b914>] sys_newstat+0x24/0x50
> > >  [<ffffffff814f23fe>] ? do_page_fault+0x3e/0xa0
> > >  [<ffffffff814ef7b5>] ? page_fault+0x25/0x30
> > >  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> > > [root@gluster00 ~]#
> > > 
> > > 
> > > [root@gluster00 ~]# mount
> > > /dev/sda3 on / type ext4 (rw)
> > > proc on /proc type proc (rw)
> > > sysfs on /sys type sysfs (rw)
> > > devpts on /dev/pts type devpts (rw,gid=5,mode=620)
> > > tmpfs on /dev/shm type tmpfs (rw)
> > > /dev/sda1 on /boot type ext4 (rw)
> > > /dev/sdb1 on /GLUSTER00 type ext4 (rw)
> > > none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
> > > sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
> > > gluster00:/mm-volume on /mmvolume type fuse.glusterfs (rw,allow_other,default_permissions,max_read=131072)
> > > 
> > > [root@gluster00 ~]# df -h
> > > Filesystem            Size  Used Avail Use% Mounted on
> > > /dev/sda3              18G  2.0G   15G  13% /
> > > tmpfs                 499M     0  499M   0% /dev/shm
> > > /dev/sda1             248M  103M  133M  44% /boot
> > > /dev/sdb1             960G  200M  911G   1% /GLUSTER00
> > > gluster00:/mm-volume  2.4T  397M  2.2T   1% /mmvolume
> > > 
> > > 
> > > [root@gluster00 ~]# gluster -V
> > > glusterfs 3.2.5 built on Dec  7 2011 18:41:39
> > > Repository revision: git://git.gluster.com/glusterfs.git
> > > Copyright (c) 2006-2011 Gluster Inc. <http://www.gluster.com>
> > > GlusterFS comes with ABSOLUTELY NO WARRANTY.
> > > You may redistribute copies of GlusterFS under the terms of the GNU General Public License.
> > > 
> > > [root@gluster00 ~]# uname -a
> > > Linux gluster00.prod 2.6.32-220.4.1.el6.x86_64 #1 SMP Tue Jan 24 02:13:44 GMT 2012 x86_64 x86_64 x86_64 GNU/Linux
> > > 
> > > [root@gluster00 ~]# smbd -V
> > > Version 3.5.10-114.el6
> > > 
> > > 
> > > THE MACHINE RUNS CENTOS 6.2
> > > 
> > > INFO: task glusterfsd:1878 blocked for more than 120 seconds.
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > glusterfsd    D 0000000000000000     0  1878      1 0x00000000
> > >  ffff88003b683c68 0000000000000086 0000000000000000 000000010000000b
> > >  ffff88003b683d18 ffff88003b683c98 ffff88003b683bf8 ffffffff81090957
> > >  ffff880037a9e6b8 ffff88003b683fd8 000000000000f4e8 ffff880037a9e6b8
> > > Call Trace:
> > >  [<ffffffff81090957>] ? bit_waitqueue+0x17/0xd0
> > >  [<ffffffffa00de09d>] do_get_write_access+0x29d/0x520 [jbd2]
> > >  [<ffffffff81090ad0>] ? wake_bit_function+0x0/0x50
> > >  [<ffffffffa013293b>] ? __ext4_handle_dirty_metadata+0x7b/0x100 [ext4]
> > >  [<ffffffffa00de471>] jbd2_journal_get_write_access+0x31/0x50 [jbd2]
> > >  [<ffffffffa0132b78>] __ext4_journal_get_write_access+0x38/0x80 [ext4]
> > >  [<ffffffffa0114fb9>] ext4_orphan_add+0xb9/0x1f0 [ext4]
> > >  [<ffffffffa01146b9>] ? ext4_delete_entry+0xf9/0x110 [ext4]
> > >  [<ffffffffa0116a8b>] ext4_unlink+0x29b/0x2b0 [ext4]
> > >  [<ffffffff81183edf>] vfs_unlink+0x9f/0xe0
> > >  [<ffffffff81182c2a>] ? lookup_hash+0x3a/0x50
> > >  [<ffffffff81186463>] do_unlinkat+0x183/0x1c0
> > >  [<ffffffff81183601>] ? path_put+0x31/0x40
> > >  [<ffffffff8119ad11>] ? sys_lgetxattr+0x61/0x80
> > >  [<ffffffff811864b6>] sys_unlink+0x16/0x20
> > >  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> > > INFO: task glusterfsd:1878 blocked for more than 120 seconds.
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > glusterfsd    D 0000000000000000     0  1878      1 0x00000000
> > >  ffff88003b683c68 0000000000000086 0000000000000000 000000010000000b
> > >  ffff88003b683d18 ffff88003b683c98 ffff88003b683bf8 ffffffff81090957
> > >  ffff880037a9e6b8 ffff88003b683fd8 000000000000f4e8 ffff880037a9e6b8
> > > Call Trace:
> > >  [<ffffffff81090957>] ? bit_waitqueue+0x17/0xd0
> > >  [<ffffffffa00de09d>] do_get_write_access+0x29d/0x520 [jbd2]
> > >  [<ffffffff81090ad0>] ? wake_bit_function+0x0/0x50
> > >  [<ffffffffa013293b>] ? __ext4_handle_dirty_metadata+0x7b/0x100 [ext4]
> > >  [<ffffffffa00de471>] jbd2_journal_get_write_access+0x31/0x50 [jbd2]
> > >  [<ffffffffa0132b78>] __ext4_journal_get_write_access+0x38/0x80 [ext4]
> > >  [<ffffffffa0114fb9>] ext4_orphan_add+0xb9/0x1f0 [ext4]
> > >  [<ffffffffa01146b9>] ? ext4_delete_entry+0xf9/0x110 [ext4]
> > >  [<ffffffffa0116a8b>] ext4_unlink+0x29b/0x2b0 [ext4]
> > >  [<ffffffff81183edf>] vfs_unlink+0x9f/0xe0
> > >  [<ffffffff81182c2a>] ? lookup_hash+0x3a/0x50
> > >  [<ffffffff81186463>] do_unlinkat+0x183/0x1c0
> > >  [<ffffffff81183601>] ? path_put+0x31/0x40
> > >  [<ffffffff8119ad11>] ? sys_lgetxattr+0x61/0x80
> > >  [<ffffffff811864b6>] sys_unlink+0x16/0x20
> > >  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> > > INFO: task glusterfsd:1878 blocked for more than 120 seconds.
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > glusterfsd    D 0000000000000000     0  1878      1 0x00000000
> > >  ffff88003b683c68 0000000000000086 0000000000000000 000000010000000b
> > >  ffff88003b683d18 ffff88003b683c98 ffff88003b683bf8 ffffffff81090957
> > >  ffff880037a9e6b8 ffff88003b683fd8 000000000000f4e8 ffff880037a9e6b8
> > > Call Trace:
> > >  [<ffffffff81090957>] ? bit_waitqueue+0x17/0xd0
> > >  [<ffffffffa00de09d>] do_get_write_access+0x29d/0x520 [jbd2]
> > >  [<ffffffff81090ad0>] ? wake_bit_function+0x0/0x50
> > >  [<ffffffffa013293b>] ? __ext4_handle_dirty_metadata+0x7b/0x100 [ext4]
> > >  [<ffffffffa00de471>] jbd2_journal_get_write_access+0x31/0x50 [jbd2]
> > >  [<ffffffffa0132b78>] __ext4_journal_get_write_access+0x38/0x80 [ext4]
> > >  [<ffffffffa0114fb9>] ext4_orphan_add+0xb9/0x1f0 [ext4]
> > >  [<ffffffffa01146b9>] ? ext4_delete_entry+0xf9/0x110 [ext4]
> > >  [<ffffffffa0116a8b>] ext4_unlink+0x29b/0x2b0 [ext4]
> > >  [<ffffffff81183edf>] vfs_unlink+0x9f/0xe0
> > >  [<ffffffff81182c2a>] ? lookup_hash+0x3a/0x50
> > >  [<ffffffff81186463>] do_unlinkat+0x183/0x1c0
> > >  [<ffffffff81183601>] ? path_put+0x31/0x40
> > >  [<ffffffff8119ad11>] ? sys_lgetxattr+0x61/0x80
> > >  [<ffffffff811864b6>] sys_unlink+0x16/0x20
> > >  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> > > INFO: task glusterfsd:1878 blocked for more than 120 seconds.
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > glusterfsd    D 0000000000000000     0  1878      1 0x00000000
> > >  ffff88003b683c68 0000000000000086 0000000000000000 000000010000000b
> > >  ffff88003b683d18 ffff88003b683c98 ffff88003b683bf8 ffffffff81090957
> > >  ffff880037a9e6b8 ffff88003b683fd8 000000000000f4e8 ffff880037a9e6b8
> > > Call Trace:
> > >  [<ffffffff81090957>] ? bit_waitqueue+0x17/0xd0
> > >  [<ffffffffa00de09d>] do_get_write_access+0x29d/0x520 [jbd2]
> > >  [<ffffffff81090ad0>] ? wake_bit_function+0x0/0x50
> > >  [<ffffffffa013293b>] ? __ext4_handle_dirty_metadata+0x7b/0x100 [ext4]
> > >  [<ffffffffa00de471>] jbd2_journal_get_write_access+0x31/0x50 [jbd2]
> > >  [<ffffffffa0132b78>] __ext4_journal_get_write_access+0x38/0x80 [ext4]
> > >  [<ffffffffa0114fb9>] ext4_orphan_add+0xb9/0x1f0 [ext4]
> > >  [<ffffffffa01146b9>] ? ext4_delete_entry+0xf9/0x110 [ext4]
> > >  [<ffffffffa0116a8b>] ext4_unlink+0x29b/0x2b0 [ext4]
> > >  [<ffffffff81183edf>] vfs_unlink+0x9f/0xe0
> > >  [<ffffffff81182c2a>] ? lookup_hash+0x3a/0x50
> > >  [<ffffffff81186463>] do_unlinkat+0x183/0x1c0
> > >  [<ffffffff81183601>] ? path_put+0x31/0x40
> > >  [<ffffffff8119ad11>] ? sys_lgetxattr+0x61/0x80
> > >  [<ffffffff811864b6>] sys_unlink+0x16/0x20
> > >  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> > > INFO: task glusterfsd:1754 blocked for more than 120 seconds.
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > glusterfsd    D 0000000000000000     0  1754      1 0x00000000
> > >  ffff88003b479c48 0000000000000086 ffff880000000001 000000013712d580
> > >  0000000000000000 ffff88003f810080 ffff88003faacc00 ffff88003f8224c0
> > >  ffff88003712db38 ffff88003b479fd8 000000000000f4e8 ffff88003712db38
> > > Call Trace:
> > >  [<ffffffff81090d7e>] ? prepare_to_wait+0x4e/0x80
> > >  [<ffffffffa00de09d>] do_get_write_access+0x29d/0x520 [jbd2]
> > >  [<ffffffff81090ad0>] ? wake_bit_function+0x0/0x50
> > >  [<ffffffffa00de471>] jbd2_journal_get_write_access+0x31/0x50 [jbd2]
> > >  [<ffffffffa0132b78>] __ext4_journal_get_write_access+0x38/0x80 [ext4]
> > >  [<ffffffffa010e253>] ext4_reserve_inode_write+0x73/0xa0 [ext4]
> > >  [<ffffffffa0107158>] ? call_filldir+0x78/0xe0 [ext4]
> > >  [<ffffffffa010e2cc>] ext4_mark_inode_dirty+0x4c/0x1d0 [ext4]
> > >  [<ffffffffa010e5c0>] ext4_dirty_inode+0x40/0x60 [ext4]
> > >  [<ffffffff8119fceb>] __mark_inode_dirty+0x3b/0x160
> > >  [<ffffffff8119040d>] touch_atime+0x12d/0x170
> > >  [<ffffffff8118a290>] ? filldir+0x0/0xe0
> > >  [<ffffffff8118a526>] vfs_readdir+0xd6/0xe0
> > >  [<ffffffff8118a699>] sys_getdents+0x89/0xf0
> > >  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> > > INFO: task glusterfsd:1754 blocked for more than 120 seconds.
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > glusterfsd    D 0000000000000000     0  1754      1 0x00000000
> > >  ffff88003b479c48 0000000000000086 ffff880000000001 000000013712d580
> > >  0000000000000000 ffff88003f810080 ffff88003faacc00 ffff88003f8224c0
> > >  ffff88003712db38 ffff88003b479fd8 000000000000f4e8 ffff88003712db38
> > > Call Trace:
> > >  [<ffffffff81090d7e>] ? prepare_to_wait+0x4e/0x80
> > >  [<ffffffffa00de09d>] do_get_write_access+0x29d/0x520 [jbd2]
> > >  [<ffffffff81090ad0>] ? wake_bit_function+0x0/0x50
> > >  [<ffffffffa00de471>] jbd2_journal_get_write_access+0x31/0x50 [jbd2]
> > >  [<ffffffffa0132b78>] __ext4_journal_get_write_access+0x38/0x80 [ext4]
> > >  [<ffffffffa010e253>] ext4_reserve_inode_write+0x73/0xa0 [ext4]
> > >  [<ffffffffa0107158>] ? call_filldir+0x78/0xe0 [ext4]
> > >  [<ffffffffa010e2cc>] ext4_mark_inode_dirty+0x4c/0x1d0 [ext4]
> > >  [<ffffffffa010e5c0>] ext4_dirty_inode+0x40/0x60 [ext4]
> > >  [<ffffffff8119fceb>] __mark_inode_dirty+0x3b/0x160
> > >  [<ffffffff8119040d>] touch_atime+0x12d/0x170
> > >  [<ffffffff8118a290>] ? filldir+0x0/0xe0
> > >  [<ffffffff8118a526>] vfs_readdir+0xd6/0xe0
> > >  [<ffffffff8118a699>] sys_getdents+0x89/0xf0
> > >  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> > > INFO: task glusterfsd:1754 blocked for more than 120 seconds.
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > glusterfsd    D 0000000000000000     0  1754      1 0x00000000
> > >  ffff88003b479c48 0000000000000086 ffff880000000001 000000013712d580
> > >  0000000000000000 ffff88003f810080 ffff88003faacc00 ffff88003f8224c0
> > >  ffff88003712db38 ffff88003b479fd8 000000000000f4e8 ffff88003712db38
> > > Call Trace:
> > >  [<ffffffff81090d7e>] ? prepare_to_wait+0x4e/0x80
> > >  [<ffffffffa00de09d>] do_get_write_access+0x29d/0x520 [jbd2]
> > >  [<ffffffff81090ad0>] ? wake_bit_function+0x0/0x50
> > >  [<ffffffffa00de471>] jbd2_journal_get_write_access+0x31/0x50 [jbd2]
> > >  [<ffffffffa0132b78>] __ext4_journal_get_write_access+0x38/0x80 [ext4]
> > >  [<ffffffffa010e253>] ext4_reserve_inode_write+0x73/0xa0 [ext4]
> > >  [<ffffffffa0107158>] ? call_filldir+0x78/0xe0 [ext4]
> > >  [<ffffffffa010e2cc>] ext4_mark_inode_dirty+0x4c/0x1d0 [ext4]
> > >  [<ffffffffa010e5c0>] ext4_dirty_inode+0x40/0x60 [ext4]
> > >  [<ffffffff8119fceb>] __mark_inode_dirty+0x3b/0x160
> > >  [<ffffffff8119040d>] touch_atime+0x12d/0x170
> > >  [<ffffffff8118a290>] ? filldir+0x0/0xe0
> > >  [<ffffffff8118a526>] vfs_readdir+0xd6/0xe0
> > >  [<ffffffff8118a699>] sys_getdents+0x89/0xf0
> > >  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> > > INFO: task glusterfsd:1878 blocked for more than 120 seconds.
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > glusterfsd    D 0000000000000000     0  1878      1 0x00000000
> > >  ffff88003b683c48 0000000000000086 0000000000000000 00000001810949db
> > >  0000000000000000 0000000000000000 ffff88003b683cb0 0000000000000000
> > >  ffff880037a9e6b8 ffff88003b683fd8 000000000000f4e8 ffff880037a9e6b8
> > > Call Trace:
> > >  [<ffffffffa00de09d>] do_get_write_access+0x29d/0x520 [jbd2]
> > >  [<ffffffff81090ad0>] ? wake_bit_function+0x0/0x50
> > >  [<ffffffffa00de471>] jbd2_journal_get_write_access+0x31/0x50 [jbd2]
> > >  [<ffffffffa0132b78>] __ext4_journal_get_write_access+0x38/0x80 [ext4]
> > >  [<ffffffffa010e253>] ext4_reserve_inode_write+0x73/0xa0 [ext4]
> > >  [<ffffffffa0107158>] ? call_filldir+0x78/0xe0 [ext4]
> > >  [<ffffffffa010e2cc>] ext4_mark_inode_dirty+0x4c/0x1d0 [ext4]
> > >  [<ffffffffa010e5c0>] ext4_dirty_inode+0x40/0x60 [ext4]
> > >  [<ffffffff8119fceb>] __mark_inode_dirty+0x3b/0x160
> > >  [<ffffffff8119040d>] touch_atime+0x12d/0x170
> > >  [<ffffffff8118a290>] ? filldir+0x0/0xe0
> > >  [<ffffffff8118a526>] vfs_readdir+0xd6/0xe0
> > >  [<ffffffff8118a699>] sys_getdents+0x89/0xf0
> > >  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> > > INFO: task glusterfsd:1878 blocked for more than 120 seconds.
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > glusterfsd    D 0000000000000000     0  1878      1 0x00000000
> > >  ffff88003b683c48 0000000000000086 0000000000000000 00000001810949db
> > >  0000000000000000 0000000000000000 ffff88003b683cb0 0000000000000000
> > >  ffff880037a9e6b8 ffff88003b683fd8 000000000000f4e8 ffff880037a9e6b8
> > > Call Trace:
> > >  [<ffffffffa00de09d>] do_get_write_access+0x29d/0x520 [jbd2]
> > >  [<ffffffff81090ad0>] ? wake_bit_function+0x0/0x50
> > >  [<ffffffffa00de471>] jbd2_journal_get_write_access+0x31/0x50 [jbd2]
> > >  [<ffffffffa0132b78>] __ext4_journal_get_write_access+0x38/0x80 [ext4]
> > >  [<ffffffffa010e253>] ext4_reserve_inode_write+0x73/0xa0 [ext4]
> > >  [<ffffffffa0107158>] ? call_filldir+0x78/0xe0 [ext4]
> > >  [<ffffffffa010e2cc>] ext4_mark_inode_dirty+0x4c/0x1d0 [ext4]
> > >  [<ffffffffa010e5c0>] ext4_dirty_inode+0x40/0x60 [ext4]
> > >  [<ffffffff8119fceb>] __mark_inode_dirty+0x3b/0x160
> > >  [<ffffffff8119040d>] touch_atime+0x12d/0x170
> > >  [<ffffffff8118a290>] ? filldir+0x0/0xe0
> > >  [<ffffffff8118a526>] vfs_readdir+0xd6/0xe0
> > >  [<ffffffff8118a699>] sys_getdents+0x89/0xf0
> > >  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> > > INFO: task glusterfsd:1878 blocked for more than 120 seconds.
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > glusterfsd    D 0000000000000000     0  1878      1 0x00000000
> > >  ffff88003b683c48 0000000000000086 0000000000000000 00000001810949db
> > >  0000000000000000 0000000000000000 ffff88003b683cb0 0000000000000000
> > >  ffff880037a9e6b8 ffff88003b683fd8 000000000000f4e8 ffff880037a9e6b8
> > > Call Trace:
> > >  [<ffffffffa00de09d>] do_get_write_access+0x29d/0x520 [jbd2]
> > >  [<ffffffff81090ad0>] ? wake_bit_function+0x0/0x50
> > >  [<ffffffffa00de471>] jbd2_journal_get_write_access+0x31/0x50 [jbd2]
> > >  [<ffffffffa0132b78>] __ext4_journal_get_write_access+0x38/0x80 [ext4]
> > >  [<ffffffffa010e253>] ext4_reserve_inode_write+0x73/0xa0 [ext4]
> > >  [<ffffffffa0107158>] ? call_filldir+0x78/0xe0 [ext4]
> > >  [<ffffffffa010e2cc>] ext4_mark_inode_dirty+0x4c/0x1d0 [ext4]
> > >  [<ffffffffa010e5c0>] ext4_dirty_inode+0x40/0x60 [ext4]
> > >  [<ffffffff8119fceb>] __mark_inode_dirty+0x3b/0x160
> > >  [<ffffffff8119040d>] touch_atime+0x12d/0x170
> > >  [<ffffffff8118a290>] ? filldir+0x0/0xe0
> > >  [<ffffffff8118a526>] vfs_readdir+0xd6/0xe0
> > >  [<ffffffff8118a699>] sys_getdents+0x89/0xf0
> > >  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> > > [root@gluster01 ~]#
> > > 
> > > 
> > > [root@gluster01 ~]# mount
> > > /dev/sda3 on / type ext4 (rw)
> > > proc on /proc type proc (rw)
> > > sysfs on /sys type sysfs (rw)
> > > devpts on /dev/pts type devpts (rw,gid=5,mode=620)
> > > tmpfs on /dev/shm type tmpfs (rw)
> > > /dev/sda1 on /boot type ext4 (rw)
> > > /dev/sdb1 on /GLUSTER01 type ext4 (rw)
> > > none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
> > > sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
> > > 
> > > [root@gluster01 ~]# df -h
> > > Filesystem            Size  Used Avail Use% Mounted on
> > > /dev/sda3              18G  1.8G   15G  11% /
> > > tmpfs                 499M     0  499M   0% /dev/shm
> > > /dev/sda1             248M  103M  133M  44% /boot
> > > /dev/sdb1             1.4T  198M  1.4T   1% /GLUSTER01
> > > 
> > > [root@gluster01 ~]# gluster -V
> > > glusterfs 3.2.5 built on Dec  7 2011 18:41:39
> > > Repository revision: git://git.gluster.com/glusterfs.git
> > > Copyright (c) 2006-2011 Gluster Inc. <http://www.gluster.com>
> > > GlusterFS comes with ABSOLUTELY NO WARRANTY.
> > > You may redistribute copies of GlusterFS under the terms of the GNU General Public License.
> > > 
> > > [root@gluster01 ~]# uname -a
> > > Linux gluster01.prod 2.6.32-220.4.1.el6.x86_64 #1 SMP Tue Jan 24 02:13:44 GMT 2012 x86_64 x86_64 x86_64 GNU/Linux
> > > 
> > > 
> > > THE MACHINE RUNS CENTOS 6.2
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > > 
> > 
> > 
> 
> 

-- 
