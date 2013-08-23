From: Sage Weil <sage@inktank.com>
Subject: Re: crash in __jbd2_journal_file_buffer
Date: Fri, 23 Aug 2013 08:02:45 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1308230759110.2967@cobra.newdream.net>
References: <alpine.DEB.2.00.1307301540110.12830@cobra.newdream.net> <20130731190245.GC28018@quack.suse.cz> <alpine.DEB.2.00.1308091031450.17790@cobra.newdream.net> <20130809212425.GB1050@quack.suse.cz> <alpine.DEB.2.00.1308091504320.14125@cobra.newdream.net>
 <20130812125256.GB4596@quack.suse.cz> <alpine.DEB.2.00.1308121106320.29150@cobra.newdream.net> <20130813103416.GA12197@quack.suse.cz> <alpine.DEB.2.00.1308221633080.475@cobra.newdream.net> <20130823095405.GA3568@quack.suse.cz>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="557981400-183634980-1377270165=:2967"
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:38151 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab3HWPCp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Aug 2013 11:02:45 -0400
In-Reply-To: <20130823095405.GA3568@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--557981400-183634980-1377270165=:2967
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Fri, 23 Aug 2013, Jan Kara wrote:
> On Thu 22-08-13 16:35:15, Sage Weil wrote:
> > On Tue, 13 Aug 2013, Jan Kara wrote:
> > > On Mon 12-08-13 11:13:06, Sage Weil wrote:
> > > > Full dmesg is attached.
> > >   Hum, nothing interesting in there...
> > > 
> > > > Our QA seems to hit this with some regularity.  Let me know if there's 
> > > > some combination of patches that would help shed more light!
> > >   If they can run with attached debug patch it could maybe sched some more
> > > light. Please send also your System.map file together with the dmesg of the
> > > kernel when the crash happens so that I can map addresses to function
> > > names... Thanks!
> > 
> > Okay, finally hit it again:
> > 
> > <6>[75193.192249] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,user_xattr,user_xattr
> > <3>[77877.426658] Dirtying buffer without jh at 4302720297: state 218c029,jh added from 0xffffffff8127ab1d at 4302720297, removed from 0xffffffff8127b5b0 at 4302720296
>   Great! Can you please send me /proc/kallsyms from the machine?

Attached!

sage

> 
> 								Honza
> 
> > <4>[77877.441200] ------------[ cut here ]------------
> > <4>[77877.445845] WARNING: CPU: 7 PID: 26045 at /srv/autobuild-ceph/gitbuilder.git/build/fs/jbd2/transaction.c:1380 jbd2_journal_dirty_metadata+0x1f1/0x2e0()
> > 
> > <4>[77877.497349] CPU: 7 PID: 26045 Comm: ceph-osd Not tainted 3.11.0-rc5-ceph-00061-g546140d #1
> > <4>[77877.505649] Hardware name: Dell Inc. PowerEdge R410/01V648, BIOS 1.6.3 02/07/2011
> > <4>[77877.513213]  0000000000000564 ffff880131ca1938 ffffffff81642d85 ffff8802272ef290
> > <4>[77877.520694]  0000000000000000 ffff880131ca1978 ffffffff8104985c ffff880131ca19a0
> > <4>[77877.528218]  ffff88020f695aa0 0000000000000000 ffff880214c48b40 ffff88020be55000
> > <4>[77877.535756] Call Trace:
> > <4>[77877.538279]  [<ffffffff81642d85>] dump_stack+0x46/0x58
> > <4>[77877.543439]  [<ffffffff8104985c>] warn_slowpath_common+0x8c/0xc0
> > <4>[77877.549548]  [<ffffffff810498aa>] warn_slowpath_null+0x1a/0x20
> > <4>[77877.555413]  [<ffffffff8127adb1>] jbd2_journal_dirty_metadata+0x1f1/0x2e0
> > <4>[77877.562288]  [<ffffffff812578c3>] __ext4_handle_dirty_metadata+0xa3/0x140
> > <4>[77877.569155]  [<ffffffff81268e23>] ext4_xattr_release_block+0x103/0x1f0
> > <4>[77877.575723]  [<ffffffff812692b0>] ext4_xattr_block_set+0x1e0/0x910
> > <4>[77877.581990]  [<ffffffff8126a58b>] ext4_xattr_set_handle+0x38b/0x4a0
> > <4>[77877.588335]  [<ffffffff810af7cd>] ? trace_hardirqs_on+0xd/0x10
> > <4>[77877.594188]  [<ffffffff8126a765>] ext4_xattr_set+0xc5/0x140
> > <4>[77877.599837]  [<ffffffff8126b177>] ext4_xattr_user_set+0x47/0x50
> > <4>[77877.605779]  [<ffffffff811a3fee>] generic_setxattr+0x6e/0x90
> > <4>[77877.611514]  [<ffffffff811a48eb>] __vfs_setxattr_noperm+0x7b/0x1c0
> > <4>[77877.617773]  [<ffffffff811a4af4>] vfs_setxattr+0xc4/0xd0
> > <4>[77877.623103]  [<ffffffff811a4c3e>] setxattr+0x13e/0x1e0
> > <4>[77877.628317]  [<ffffffff81181ec7>] ? __sb_start_write+0xe7/0x1b0
> > <4>[77877.634260]  [<ffffffff8119fb98>] ? mnt_want_write_file+0x28/0x60
> > <4>[77877.640428]  [<ffffffff8119cf0c>] ? fget_light+0x3c/0x130
> > <4>[77877.645847]  [<ffffffff8119fb98>] ? mnt_want_write_file+0x28/0x60
> > <4>[77877.652015]  [<ffffffff8119e902>] ? mnt_clone_write+0x12/0x30
> > <4>[77877.657897]  [<ffffffff811a50de>] SyS_fsetxattr+0xbe/0x100
> > <4>[77877.663405]  [<ffffffff81653782>] system_call_fastpath+0x16/0x1b
> > <4>[77877.669488] ---[ end trace bb7933908cd5a32a ]---
> > <2>[77877.674126] EXT4-fs error (device sda1) in ext4_handle_dirty_xattr_block:167: error 117
> > <3>[77877.692983] Aborting journal on device sda1-8.
> > <2>[77877.721561] EXT4-fs (sda1): Remounting filesystem read-only
> > <0>[77877.721657] journal commit I/O error
> > <0>[77877.721706] journal commit I/O error
> > <0>[77877.721707] journal commit I/O error
> > <2>[77877.727300] EXT4-fs error (device sda1): ext4_journal_check_start:56: Detected aborted journal
> > <2>[77877.727338] EXT4-fs (sda1): Remounting filesystem read-only
> > <2>[77877.727613] EXT4-fs error (device sda1): ext4_journal_check_start:56: Detected aborted journal
> > <2>[77877.727618] EXT4-fs error (device sda1): ext4_journal_check_start:56: Detected aborted journal
> > <2>[77877.727625] EXT4-fs error (device sda1): ext4_journal_check_start:56: Detected aborted journal
> > <2>[77877.778239] EXT4-fs error (device sda1) in ext4_xattr_release_block:558: error 117
> > <3>[77877.786051] Dirtying buffer without jh at 4302720332: state 10c029,jh added from 0xffffffff8127eb88 at 4302720326, removed from 0xffffffff8127b5b0 at 4302720274
> > <4>[77877.800516] ------------[ cut here ]------------
> > <4>[77877.805156] WARNING: CPU: 7 PID: 26045 at /srv/autobuild-ceph/gitbuilder.git/build/fs/jbd2/transaction.c:1380 jbd2_journal_dirty_metadata+0x1f1/0x2e0()
> > 
> > <4>[77877.856583] CPU: 7 PID: 26045 Comm: ceph-osd Tainted: G        W    3.11.0-rc5-ceph-00061-g546140d #1
> > <4>[77877.865896] Hardware name: Dell Inc. PowerEdge R410/01V648, BIOS 1.6.3 02/07/2011
> > <4>[77877.873475]  0000000000000564 ffff880131ca19b8 ffffffff81642d85 ffff8802272ef290
> > <4>[77877.880954]  0000000000000000 ffff880131ca19f8 ffffffff8104985c ffff880131ca1a20
> > <4>[77877.888488]  ffff8801c499be58 0000000000000000 ffff880029010000 ffff880029010c30
> > <4>[77877.895962] Call Trace:
> > <4>[77877.898484]  [<ffffffff81642d85>] dump_stack+0x46/0x58
> > <4>[77877.903643]  [<ffffffff8104985c>] warn_slowpath_common+0x8c/0xc0
> > <4>[77877.909724]  [<ffffffff810498aa>] warn_slowpath_null+0x1a/0x20
> > <4>[77877.915577]  [<ffffffff8127adb1>] jbd2_journal_dirty_metadata+0x1f1/0x2e0
> > <4>[77877.922443]  [<ffffffff810af7cd>] ? trace_hardirqs_on+0xd/0x10
> > <4>[77877.928353]  [<ffffffff812578c3>] __ext4_handle_dirty_metadata+0xa3/0x140
> > <4>[77877.935165]  [<ffffffff8122ca3e>] ext4_mark_iloc_dirty+0x40e/0x660
> > <4>[77877.941421]  [<ffffffff8126a465>] ext4_xattr_set_handle+0x265/0x4a0
> > <4>[77877.947766]  [<ffffffff8126a765>] ext4_xattr_set+0xc5/0x140
> > <4>[77877.953358]  [<ffffffff8126b177>] ext4_xattr_user_set+0x47/0x50
> > <4>[77877.959354]  [<ffffffff811a3fee>] generic_setxattr+0x6e/0x90
> > <4>[77877.965034]  [<ffffffff811a48eb>] __vfs_setxattr_noperm+0x7b/0x1c0
> > <4>[77877.971289]  [<ffffffff811a4af4>] vfs_setxattr+0xc4/0xd0
> > <4>[77877.976621]  [<ffffffff811a4c3e>] setxattr+0x13e/0x1e0
> > <4>[77877.981837]  [<ffffffff81181ec7>] ? __sb_start_write+0xe7/0x1b0
> > <4>[77877.987830]  [<ffffffff8119fb98>] ? mnt_want_write_file+0x28/0x60
> > <4>[77877.993944]  [<ffffffff8119cf0c>] ? fget_light+0x3c/0x130
> > <4>[77877.999417]  [<ffffffff8119fb98>] ? mnt_want_write_file+0x28/0x60
> > <4>[77878.005530]  [<ffffffff8119e902>] ? mnt_clone_write+0x12/0x30
> > <4>[77878.011349]  [<ffffffff811a50de>] SyS_fsetxattr+0xbe/0x100
> > <4>[77878.016856]  [<ffffffff81653782>] system_call_fastpath+0x16/0x1b
> > <4>[77878.022941] ---[ end trace bb7933908cd5a32b ]---
> > [7]kdb> rd
> > ax: ffff88020aadbf20  bx: ffff8800290100a0  cx: 0000000000000000
> > dx: ffff8800290100a0  si: ffff8800290100a0  di: ffff8800290100a0
> > bp: ffff880131ca1a28  sp: ffff880131ca1978  r8: 0000000000000002
> > r9: 0000000000000000  r10: 0000000000000001  r11: 0000000000000000
> > r12: ffff880029010000  r13: 0000000000000000  r14: ffff880029010c30
> > r15: 00000000ffffff8b  ip: ffffffff81279f84  flags: 00010286  cs: 00000010
> > ss: 00000018  ds: 00000018  es: 00000018  fs: 00000018  gs: 00000018
> > [7]kdb> bt
> > Stack traceback for pid 26045
> > 0xffff88020aadbf20    26045    25958  1    7   R  0xffff88020aadc3a8 *ceph-osd
> >  ffff880131ca1978 0000000000000018 ffff880131ca1978 ffff880131ca1998
> >  bb7933908cd5a32b 0000000000000000 0000000000000001 0000000000000002
> >  0000000000000000 ffff880131ca19b8 0000000000000000 ffff880131ca19f8
> > Call Trace:
> >  [<ffffffff8104986f>] ? warn_slowpath_common+0x9f/0xc0
> >  [<ffffffff81257308>] ? __ext4_journal_stop+0x78/0xa0
> >  [<ffffffff812578dc>] ? __ext4_handle_dirty_metadata+0xbc/0x140
> >  [<ffffffff8122ca3e>] ? ext4_mark_iloc_dirty+0x40e/0x660
> >  [<ffffffff8126a465>] ? ext4_xattr_set_handle+0x265/0x4a0
> >  [<ffffffff8126a765>] ? ext4_xattr_set+0xc5/0x140
> >  [<ffffffff8126b177>] ? ext4_xattr_user_set+0x47/0x50
> >  [<ffffffff811a3fee>] ? generic_setxattr+0x6e/0x90
> >  [<ffffffff811a48eb>] ? __vfs_setxattr_noperm+0x7b/0x1c0
> >  [<ffffffff811a4af4>] ? vfs_setxattr+0xc4/0xd0
> >  [<ffffffff811a4c3e>] ? setxattr+0x13e/0x1e0
> >  [<ffffffff81181ec7>] ? __sb_start_write+0xe7/0x1b0
> >  [<ffffffff8119fb98>] ? mnt_want_write_file+0x28/0x60
> >  [<ffffffff8119cf0c>] ? fget_light+0x3c/0x130
> >  [<ffffffff8119fb98>] ? mnt_want_write_file+0x28/0x60
> >  [<ffffffff8119e902>] ? mnt_clone_write+0x12/0x30
> >  [<ffffffff811a50de>] ? SyS_fsetxattr+0xbe/0x100
> >  [<ffffffff81653782>] ? system_call_fastpath+0x16/0x1b
> > 
> > Let me know if there is anything else I can gather from this machine that 
> > will help!
> > 
> > sage
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> 
> 
--557981400-183634980-1377270165=:2967
Content-Type: APPLICATION/octet-stream; name=k
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.00.1308230802450.2967@cobra.newdream.net>
Content-Description: 
Content-Disposition: attachment; filename=k


--557981400-183634980-1377270165=:2967--
