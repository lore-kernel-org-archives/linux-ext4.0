From: Sage Weil <sage@inktank.com>
Subject: Re: crash in __jbd2_journal_file_buffer
Date: Sat, 5 Apr 2014 12:20:06 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1404051212480.21861@cobra.newdream.net>
References: <alpine.DEB.2.00.1307301540110.12830@cobra.newdream.net> <20130731190245.GC28018@quack.suse.cz> <alpine.DEB.2.00.1308091031450.17790@cobra.newdream.net> <20130809212425.GB1050@quack.suse.cz> <alpine.DEB.2.00.1308091504320.14125@cobra.newdream.net>
 <20130812125256.GB4596@quack.suse.cz> <alpine.DEB.2.00.1308121106320.29150@cobra.newdream.net> <20130813103416.GA12197@quack.suse.cz> <alpine.DEB.2.00.1308221633080.475@cobra.newdream.net> <20130823204810.GB12980@quack.suse.cz>
 <20130910221900.GA9805@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, ceph-devel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:54051 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbaDETUH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Apr 2014 15:20:07 -0400
In-Reply-To: <20130910221900.GA9805@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

Thanks for reminding me about this at LSF.  Both your debug patch and this 
fix were dropped from our testing branch a while ago, but we just hit the 
crash again yesterday on 3.14-rc5.  The fix was in our tree for quite some 
time, though, and did not cause any problems; I think it got dropped when 
we rebased for the 3.14 cycle.  I'll add it back now.

Unfortunately this triggers pretty infrequently so I'm not sure I can give 
a definitive "this fixes it," but it feels that way, and we haven't seen 
any fallout as a result.

Let me know if there's anything else we can put into the test kernel that 
might help out.

Thanks!
sage


On Wed, 11 Sep 2013, Jan Kara wrote:

> On Fri 23-08-13 22:48:10, Jan Kara wrote:
> > On Thu 22-08-13 16:35:15, Sage Weil wrote:
> > > On Tue, 13 Aug 2013, Jan Kara wrote:
> > > > On Mon 12-08-13 11:13:06, Sage Weil wrote:
> > > > > Full dmesg is attached.
> > > >   Hum, nothing interesting in there...
> > > > 
> > > > > Our QA seems to hit this with some regularity.  Let me know if there's 
> > > > > some combination of patches that would help shed more light!
> > > >   If they can run with attached debug patch it could maybe sched some more
> > > > light. Please send also your System.map file together with the dmesg of the
> > > > kernel when the crash happens so that I can map addresses to function
> > > > names... Thanks!
> > > 
> > > Okay, finally hit it again:
> > > 
> > > <6>[75193.192249] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,user_xattr,user_xattr
> > > <3>[77877.426658] Dirtying buffer without jh at 4302720297: state 218c029,jh added from 0xffffffff8127ab1d at 4302720297, removed from 0xffffffff8127b5b0 at 4302720296
> > > <4>[77877.441200] ------------[ cut here ]------------
> > > <4>[77877.445845] WARNING: CPU: 7 PID: 26045 at /srv/autobuild-ceph/gitbuilder.git/build/fs/jbd2/transaction.c:1380 jbd2_journal_dirty_metadata+0x1f1/0x2e0()
> > > 
> > > <4>[77877.497349] CPU: 7 PID: 26045 Comm: ceph-osd Not tainted 3.11.0-rc5-ceph-00061-g546140d #1
> > > <4>[77877.505649] Hardware name: Dell Inc. PowerEdge R410/01V648, BIOS 1.6.3 02/07/2011
> > > <4>[77877.513213]  0000000000000564 ffff880131ca1938 ffffffff81642d85 ffff8802272ef290
> > > <4>[77877.520694]  0000000000000000 ffff880131ca1978 ffffffff8104985c ffff880131ca19a0
> > > <4>[77877.528218]  ffff88020f695aa0 0000000000000000 ffff880214c48b40 ffff88020be55000
> > > <4>[77877.535756] Call Trace:
> > > <4>[77877.538279]  [<ffffffff81642d85>] dump_stack+0x46/0x58
> > > <4>[77877.543439]  [<ffffffff8104985c>] warn_slowpath_common+0x8c/0xc0
> > > <4>[77877.549548]  [<ffffffff810498aa>] warn_slowpath_null+0x1a/0x20
> > > <4>[77877.555413]  [<ffffffff8127adb1>] jbd2_journal_dirty_metadata+0x1f1/0x2e0
> > > <4>[77877.562288]  [<ffffffff812578c3>] __ext4_handle_dirty_metadata+0xa3/0x140
> > > <4>[77877.569155]  [<ffffffff81268e23>] ext4_xattr_release_block+0x103/0x1f0
> > > <4>[77877.575723]  [<ffffffff812692b0>] ext4_xattr_block_set+0x1e0/0x910
> > > <4>[77877.581990]  [<ffffffff8126a58b>] ext4_xattr_set_handle+0x38b/0x4a0
> > > <4>[77877.588335]  [<ffffffff810af7cd>] ? trace_hardirqs_on+0xd/0x10
> > > <4>[77877.594188]  [<ffffffff8126a765>] ext4_xattr_set+0xc5/0x140
> > > <4>[77877.599837]  [<ffffffff8126b177>] ext4_xattr_user_set+0x47/0x50
> > > <4>[77877.605779]  [<ffffffff811a3fee>] generic_setxattr+0x6e/0x90
> > > <4>[77877.611514]  [<ffffffff811a48eb>] __vfs_setxattr_noperm+0x7b/0x1c0
> > > <4>[77877.617773]  [<ffffffff811a4af4>] vfs_setxattr+0xc4/0xd0
> > > <4>[77877.623103]  [<ffffffff811a4c3e>] setxattr+0x13e/0x1e0
> > > <4>[77877.628317]  [<ffffffff81181ec7>] ? __sb_start_write+0xe7/0x1b0
> > > <4>[77877.634260]  [<ffffffff8119fb98>] ? mnt_want_write_file+0x28/0x60
> > > <4>[77877.640428]  [<ffffffff8119cf0c>] ? fget_light+0x3c/0x130
> > > <4>[77877.645847]  [<ffffffff8119fb98>] ? mnt_want_write_file+0x28/0x60
> > > <4>[77877.652015]  [<ffffffff8119e902>] ? mnt_clone_write+0x12/0x30
> > > <4>[77877.657897]  [<ffffffff811a50de>] SyS_fsetxattr+0xbe/0x100
> > > <4>[77877.663405]  [<ffffffff81653782>] system_call_fastpath+0x16/0x1b
> > > <4>[77877.669488] ---[ end trace bb7933908cd5a32a ]---
> >   I was scratching my head for a while how this could happen but I think I
> > see the race now. Think we have two inodes A and B which share the same
> > xattr block (so &BHDR(bh)->h_refcount == 2). Now we are changing xattrs for
> > both inodes in parallel - that can easily happen because xattr locking is
> > generally per inode (EXT4_I(inode)->xattr_sem). The following race then
> > happens:
> > CPU1					CPU2
> > ext4_xattr_release_block()		ext4_xattr_release_block()
> > lock_buffer(bh);
> > /* False */
> > if (BHDR(bh)->h_refcount == cpu_to_le32(1))
> > } else {
> > 	le32_add_cpu(&BHDR(bh)->h_refcount, -1);
> > 	unlock_buffer(bh);
> > 					lock_buffer(bh);
> > 					/* True */
> > 					if (BHDR(bh)->h_refcount == cpu_to_le32(1))
> > 						get_bh(bh);
> > 						ext4_free_blocks()
> > 							...
> > 							jbd2_journal_forget()
> > 								jbd2_journal_unfile_buffer()
> > 								-> JH is gone
> > 	error = ext4_handle_dirty_xattr_block(handle, inode, bh);
> > 	-> triggers warning
> > 
> > Now easy fix would be to move ext4_handle_dirty_xattr_block() before
> > unlock_buffer() but I don't really like that because of locking
> > constraints. I'll think about it...
>   So finally I've got back to this. Attached is a somewhat ugly patch that
> should fix this issue. Can you please test it? Thanks!
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> 
