From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v1 0/9] do not use s_dirt in ext4
Date: Fri, 30 Mar 2012 17:35:30 +0200
Message-ID: <20120330153530.GH5587@quack.suse.cz>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
 <20120322095342.GC14485@quack.suse.cz>
 <1332410747.18717.12.camel@sauron.fi.intel.com>
 <20120322103309.GA14484@quack.suse.cz>
 <1332854998.31549.40.camel@sauron.fi.intel.com>
 <20120327201401.GF5020@quack.suse.cz>
 <1333121035.5440.49.camel@sauron.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1333121035.5440.49.camel@sauron.fi.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 30-03-12 18:23:55, Artem Bityutskiy wrote:
> On Tue, 2012-03-27 at 22:14 +0200, Jan Kara wrote:
> > On Tue 27-03-12 16:29:58, Artem Bityutskiy wrote:
> > > On Thu, 2012-03-22 at 11:33 +0100, Jan Kara wrote:
> > > >   Then we have ext4_mark_super_dirty() call from 4 places - I forgot about
> > > > these originally... I kind of miss their purpose. Originally they were used
> > > > so that we write total number of free blocks and inodes in the superblock
> > > > but when we do not maintain them in the journal mode I don't see a reason
> > > > to periodically sync them in no-journal mode. Ted, what is the purpose of
> > > > these calls?
> > > 
> > > I do not understand what's the fundamental difference between journal
> > > and non-journal mode. Why when we do have the journal we do not mark the
> > > super-block as dirty in many places (e.g., in 'ext4_file_open()' - if we
> > > do have the journal, when do we make sure we save the mount point path
> > > change?).
> >   We write it at least during ext4_put_super().
> > 
> > > May be it has something to do with behaving like the ext2 driver when
> > > mounting ext2-formatted media with the the ext4 driver?
> >   I'm not really sure about this...
> > 
> > > Jan, since Ted did not answer, may be you can figure out the reasons
> > > from this commit message, which actually introduced the
> > > 'ext4_mark_super_dirty()' function?
> >   Anyway, attached are two patches which you can include in your series
> > and which should make your cleanups simpler.
> 
> I amended the second patch:
> -                               ext4_journal_stop(sb);
> +                               ext4_journal_stop(sbi->s_sbh);
  It should have been:
	ext4_journal_stop(handle);

> Extensive testing with xfstests found a problem with these patches:
> 
> [23500.238579] ------------[ cut here ]------------
> [23500.238720] kernel BUG at fs/buffer.c:2871!
> [23500.238842] invalid opcode: 0000 [#1] SMP 
> [23500.239279] CPU 11 
> [23500.239338] Modules linked in: [last unloaded: scsi_wait_scan]
> [23500.239442] 
> [23500.239442] Pid: 15799, comm: fsstress Not tainted 3.3.0+ #43 Bochs Bochs
> [23500.239442] RIP: 0010:[<ffffffff811a9add>]  [<ffffffff811a9add>] submit_bh+0x10d/0x120
> [23500.239442] RSP: 0018:ffff880273a41b58  EFLAGS: 00010202
> [23500.239442] RAX: 000000000004d025 RBX: ffff8802469e5a90 RCX: 0000000000000000
> [23500.239442] RDX: ffff880273a41fd8 RSI: ffff8802469e5a90 RDI: 0000000000000211
> [23500.239442] RBP: ffff880273a41b78 R08: ffff880409645d80 R09: 0000000000000001
> [23500.239442] R10: 0000000000000001 R11: ffff880178439000 R12: 0000000000000211
> [23500.239442] R13: ffff880273a41c34 R14: ffff8804059b7000 R15: ffff880273a41fd8
> [23500.239442] FS:  00007fc8731e7700(0000) GS:ffff88041fd60000(0000) knlGS:0000000000000000
> [23500.239442] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [23500.239442] CR2: 00007fc873082008 CR3: 000000012456a000 CR4: 00000000000006e0
> [23500.239442] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [23500.239442] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [23500.239442] Process fsstress (pid: 15799, threadinfo ffff880273a40000, task ffff880150dd8000)
> [23500.239442] Stack:
> [23500.239442]  ffff8804059b7000 ffff8802469e5a90 0000000000000211 ffff880273a41c34
> [23500.239442]  ffff880273a41b98 ffffffff811ab59d 0000000000000002 ffff8804059b7128
> [23500.239442]  ffff880273a41bf8 ffffffff8123be1d 0000000091827364 ffff88010e9a7e30
> [23500.239442] Call Trace:
> [23500.239442]  [<ffffffff811ab59d>] write_dirty_buffer+0x4d/0x80
> [23500.239442]  [<ffffffff8123be1d>] __flush_batch+0x4d/0xa0
> [23500.239442]  [<ffffffff8123c605>] jbd2_log_do_checkpoint+0xf5/0x4f0
> [23500.239442]  [<ffffffff8123ca89>] __jbd2_log_wait_for_space+0x89/0x190
> [23500.239442]  [<ffffffff81237a98>] start_this_handle+0x3a8/0x4e0
> [23500.239442]  [<ffffffff810799e0>] ? remove_wait_queue+0x50/0x50
> [23500.239442]  [<ffffffff81237c93>] jbd2__journal_start+0xc3/0x100
> [23500.239442]  [<ffffffff81237ce3>] jbd2_journal_start+0x13/0x20
> [23500.239442]  [<ffffffff8121743f>] ext4_journal_start_sb+0x7f/0x1d0
> [23500.239442]  [<ffffffff81224a24>] ? ext4_fallocate+0x1a4/0x530
> [23500.239442]  [<ffffffff811f64c5>] ? ext4_meta_trans_blocks+0xa5/0xb0
> [23500.239442]  [<ffffffff81224a24>] ext4_fallocate+0x1a4/0x530
> [23500.239442]  [<ffffffff8117a092>] do_fallocate+0xf2/0x160
> [23500.239442]  [<ffffffff8117a14b>] sys_fallocate+0x4b/0x70
> [23500.239442]  [<ffffffff815e6d69>] system_call_fastpath+0x16/0x1b
> [23500.239442] Code: ee 44 89 e7 e8 35 1f 0f 00 49 8b 5d 18 4c 89 ef e8 19 4e 00 00 48 83 c4 08 c1 e3 18 c1 fb 1f 83 e3 a1 89 d8 5b 41 5c 41 5d 5d c3 <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 66 0f 1f 84 00 00 00 00 00 55 48 
> [23500.239442] RIP  [<ffffffff811a9add>] submit_bh+0x10d/0x120
> [23500.239442]  RSP <ffff880273a41b58>
> [23500.261657] ---[ end trace 3db7a7a7ae953551 ]---
  Hmm, looks like we tried to checkpoint BH_Unwritten buffer. That looks
like a bug in fallocate() support. Not really related but definitely worth
reporting.

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
