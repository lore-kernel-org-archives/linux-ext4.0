From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
Date: Fri, 27 Apr 2007 01:33:50 -0700
Message-ID: <20070427013350.d0d7ac38.akpm@linux-foundation.org>
References: <1177660767.6567.41.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Mike Galbraith <efault@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754140AbXD0Id7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Apr 2007 04:33:59 -0400
In-Reply-To: <1177660767.6567.41.camel@Homer.simpson.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 27 Apr 2007 09:59:27 +0200 Mike Galbraith <efault@gmx.de> wrote:

> Greetings,
> 
> As subject states, my GUI is going away for extended periods of time
> when my very full and likely highly fragmented (how to find out)
> filesystem is under heavy write load.  While write is under way, if
> amarok (mp3 player) is running, no song change will occur until write is
> finished, and the GUI can go _entirely_ comatose for very long periods.
> Usually, it will come back to life after write is finished, but
> occasionally, a complete GUI restart is necessary.

I'd be suspecting a GUI bug if a restart is necessary.  Perhaps it went to
lunch for so long in the kernel that some time-based thing went bad.

> The longest comatose period to date was ~20 minutes with 2.6.20.7 a few
> days ago.  I was letting SuSE's software update programs update my SuSE
> 10.2 system, and started a bonnie while it was running (because I had
> been seeing this on recent kernels, and wanted to see if it was in
> stable as well), WHAM, instant dead GUI.  When this happens, kbd and
> mouse events work fine, so I hot-keyed to a VT via CTRL+ALT+F1, and
> killed the bonnie.  No joy, GUI stayed utterly comatose until the
> updater finished roughly 20 minutes later, at which time the shells I'd
> tried to start popped up, and all worked as if nothing bad had ever
> happened.  During the time in between, no window could be brought into
> focus, nada.
> 
> While a bonnie is writing, if I poke KDE's menu button, that will
> instantly trigger nastiness, and a trace (this one was with a cfs
> kernel, but I just did same with virgin 2.6.21) shows that "kicker",
> KDE's launcher proggy does an fdatasync for some reason, and that's the
> end of it's world for ages.  When clicking on amarok's icon, it does an
> fsync, and that's the last thing that will happen in it's world until
> write is done as well.  I've repeated this with CFQ and AS IO
> schedulers.

Well that all sucks.

> I have a couple of old kernels lying around that I can test with, but I
> think it's going to be the same.  Seems to be ext3's journal that is
> causing my woes.  Below this trace of kicker is one of amarok during
> it's dead to the world time.
> 
> Box is 3GHz P4 intel ICH5, SMP/UP doesn't matter.  .config is latest
> kernel tested attached.  Mount options are
> noatime,nodiratime,acl,user_xattr.
> 
> 
> [  308.046646] kicker        D 00000044     0  5897      1 (NOTLB)
> [  308.052611]        f32abe4c 00200082 83398b5a 00000044 c01c251e f32ab000 f32ab000 c01169b6 
> [  308.060926]        f772fbcc cdc7e694 00000039 8339857a 00000044 83398b5a 00000044 00000000 
> [  308.069422]        c1b5ab00 c1b5aac0 00353928 f32abe80 c01c7ab8 00000000 f32ab000 c1b5ab10 
> [  308.077927] Call Trace:
> [  308.080568]  [<c01c7ab8>] log_wait_commit+0x9d/0x11f
> [  308.085549]  [<c01c250f>] journal_stop+0x1a1/0x22a
> [  308.090364]  [<c01c2fce>] journal_force_commit+0x1d/0x20
> [  308.095699]  [<c01bac1e>] ext3_force_commit+0x24/0x26
> [  308.100774]  [<c01b50ea>] ext3_write_inode+0x2d/0x3b
> [  308.105771]  [<c0186cf0>] __writeback_single_inode+0x2df/0x3a9
> [  308.111633]  [<c0187641>] sync_inode+0x15/0x38
> [  308.116093]  [<c01b1695>] ext3_sync_file+0xbd/0xc8
> [  308.120900]  [<c0189a09>] do_fsync+0x58/0x8b
> [  308.125188]  [<c0189a5c>] __do_fsync+0x20/0x2f
> [  308.129656]  [<c0189a7b>] sys_fdatasync+0x10/0x12
> [  308.134384]  [<c0103eec>] sysenter_past_esp+0x5d/0x81
> [  308.139441]  =======================

Right.  One possibility here is that bonnie is stuffing new dirty blocks
onto the committing transaction's ordered-data list and JBD commit is
livelocking.  Only we're not supposed to be putting those blocks on that
list.

Another livelock possibility is that bonnie is redirtying pages faster than
commit can write them out, so commit got livelocked:

When I was doing the original port-from-2.2 I found that an application
which does

	for ( ; ; )
		pwrite(fd, "", 1, 0);

would permanently livelock the fs.  I fixed that, but it was six years ago,
and perhaps we later unfixed it.

It would be most interesting to try data=writeback.

> [  311.755953] bonnie        D 00000046     0  6146   5929 (NOTLB)
> [  311.761929]        e7622a60 00200082 04d7e5fe 00000046 03332bd5 00000000 e7622000 c02c0c54 
> [  311.770244]        d8eaabcc e7622a64 f7d0c3ec 04d7e521 00000046 04d7e5fe 00000046 00000000 
> [  311.778758]        e7622aa4 f4f94400 e7622aac e7622a68 c04a2f06 e7622a70 c018b105 e7622a8c 
> [  311.787261] Call Trace:
> [  311.789904]  [<c04a2f06>] io_schedule+0xe/0x16
> [  311.794373]  [<c018b105>] sync_buffer+0x2e/0x32
> [  311.798927]  [<c04a3756>] __wait_on_bit_lock+0x3f/0x62
> [  311.804089]  [<c04a37d8>] out_of_line_wait_on_bit_lock+0x5f/0x67
> [  311.810115]  [<c018b248>] __lock_buffer+0x2b/0x31
> [  311.814846]  [<c018bb56>] sync_dirty_buffer+0x88/0xc3
> [  311.819921]  [<c01c3ce4>] journal_dirty_data+0x1dd/0x205
> [  311.825256]  [<c01b3300>] ext3_journal_dirty_data+0x12/0x37
> [  311.830858]  [<c01b333a>] journal_dirty_data_fn+0x15/0x1c
> [  311.836280]  [<c01b277d>] walk_page_buffers+0x36/0x68
> [  311.841347]  [<c01b552f>] ext3_ordered_writepage+0x11a/0x191
> [  311.847027]  [<c0152133>] generic_writepages+0x1f3/0x305
> [  311.852344]  [<c015227c>] do_writepages+0x37/0x39
> [  311.857064]  [<c0186aa7>] __writeback_single_inode+0x96/0x3a9
> [  311.862842]  [<c0187037>] sync_sb_inodes+0x1bc/0x27f
> [  311.867830]  [<c01875e3>] writeback_inodes+0x98/0xe1
> [  311.872819]  [<c015240a>] balance_dirty_pages_ratelimited_nr+0xc4/0x1bf
> [  311.879461]  [<c014df55>] generic_file_buffered_write+0x32e/0x677
> [  311.885576]  [<c014e580>] __generic_file_aio_write_nolock+0x2e2/0x57f
> [  311.892044]  [<c014e87d>] generic_file_aio_write+0x60/0xd4
> [  311.897553]  [<c01b14f7>] ext3_file_write+0x27/0xa5
> [  311.902455]  [<c016ab7b>] do_sync_write+0xcd/0x103
> [  311.907270]  [<c016b37a>] vfs_write+0xa8/0x128
> [  311.911738]  [<c016b873>] sys_write+0x3d/0x64
> [  311.916111]  [<c0103eec>] sysenter_past_esp+0x5d/0x81

That's normal.  But bonnie _is_ blocking here, so it obviously cannot be
dirtying buffers while it's doing that.


> [  311.921185]  =======================
> [  311.924763] pdflush       D 00000046     0  6147      5 (L-TLB)
> [  311.930739]        ec7e2ef0 00000046 03f2b0ea 00000046 ec7e2f0c c0186b45 ec7e2000 c01169b6 
> [  311.939052]        ea14069c ec7e2f00 ec7e2f00 03f2afc9 00000046 03f2b0ea 00000046 00000282 
> [  311.947557]        ec7e2f00 ffffab4c ec7e2f30 ec7e2f20 c04a3689 00000400 00000840 c0681648 
> [  311.956062] Call Trace:
> [  311.958703]  [<c04a3689>] schedule_timeout+0x44/0xa4
> [  311.963683]  [<c04a2eda>] io_schedule_timeout+0xe/0x16
> [  311.968827]  [<c01568c7>] congestion_wait+0x4c/0x61
> [  311.973721]  [<c0152603>] background_writeout+0x2f/0x8f
> [  311.978969]  [<c0152b68>] pdflush+0xe7/0x1d6
> [  311.983255]  [<c012e8fb>] kthread+0xc5/0xc9
> [  311.987465]  [<c0104aab>] kernel_thread_helper+0x7/0x1c

OK, that's normal.

> [ 1421.790647] amarokapp     D 00000148     0  6428      1 (NOTLB)
> [ 1421.796620]        e303ce4c 00000082 823c9fd2 00000148 00000148 ee1a3030 e303c000 00000001 
> [ 1421.804944]        ee1a316c dfef91d0 00000000 823c9f15 00000148 823c9fd2 00000148 00000246 
> [ 1421.813447]        dfef91c0 dfef9180 0035465c e303ce80 c01c7ab8 00000000 e303c000 dfef91d0 
> [ 1421.821962] Call Trace:
> [ 1421.824603]  [<c01c7ab8>] log_wait_commit+0x9d/0x11f
> [ 1421.829582]  [<c01c250f>] journal_stop+0x1a1/0x22a
> [ 1421.834397]  [<c01c2fce>] journal_force_commit+0x1d/0x20
> [ 1421.839732]  [<c01bac1e>] ext3_force_commit+0x24/0x26
> [ 1421.844790]  [<c01b50ea>] ext3_write_inode+0x2d/0x3b
> [ 1421.849771]  [<c0186cf0>] __writeback_single_inode+0x2df/0x3a9
> [ 1421.855633]  [<c0187641>] sync_inode+0x15/0x38
> [ 1421.860103]  [<c01b1695>] ext3_sync_file+0xbd/0xc8
> [ 1421.864918]  [<c0189a09>] do_fsync+0x58/0x8b
> [ 1421.869213]  [<c0189a5c>] __do_fsync+0x20/0x2f
> [ 1421.873673]  [<c0189a8a>] sys_fsync+0xd/0xf
> [ 1421.877874]  [<c0103eec>] sysenter_past_esp+0x5d/0x81
> 

hm, fsync.

Aside: why the heck do applications think that their data is so important
that they need to fsync it all the time.  I used to run a kernel on my
laptop which had "return 0;" at the top of fsync() and fdatasync().  Most
pleasurable.

But wedging for 20 minutes is probably excessive punishment.

Bottom line: no idea.  Please see if data=writeback changes things, maybe
try the pwrite() loop.
