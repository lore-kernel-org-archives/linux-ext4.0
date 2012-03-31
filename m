From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v1 0/9] do not use s_dirt in ext4
Date: Sat, 31 Mar 2012 13:49:26 +0200
Message-ID: <20120331114926.GA4569@quack.suse.cz>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
 <20120322095342.GC14485@quack.suse.cz>
 <1332410747.18717.12.camel@sauron.fi.intel.com>
 <20120322103309.GA14484@quack.suse.cz>
 <1332854998.31549.40.camel@sauron.fi.intel.com>
 <20120327201401.GF5020@quack.suse.cz>
 <1333121035.5440.49.camel@sauron.fi.intel.com>
 <20120330153530.GH5587@quack.suse.cz>
 <1333122195.5440.60.camel@sauron.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1333122195.5440.60.camel@sauron.fi.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 30-03-12 18:43:15, Artem Bityutskiy wrote:
> On Fri, 2012-03-30 at 17:35 +0200, Jan Kara wrote:
> > > [23500.239442]  [<ffffffff811ab59d>] write_dirty_buffer+0x4d/0x80
> > > [23500.239442]  [<ffffffff8123be1d>] __flush_batch+0x4d/0xa0
> > > [23500.239442]  [<ffffffff8123c605>] jbd2_log_do_checkpoint+0xf5/0x4f0
> > > [23500.239442]  [<ffffffff8123ca89>] __jbd2_log_wait_for_space+0x89/0x190
> > > [23500.239442]  [<ffffffff81237a98>] start_this_handle+0x3a8/0x4e0
> > > [23500.239442]  [<ffffffff810799e0>] ? remove_wait_queue+0x50/0x50
> > > [23500.239442]  [<ffffffff81237c93>] jbd2__journal_start+0xc3/0x100
> > > [23500.239442]  [<ffffffff81237ce3>] jbd2_journal_start+0x13/0x20
> > > [23500.239442]  [<ffffffff8121743f>] ext4_journal_start_sb+0x7f/0x1d0
> > > [23500.239442]  [<ffffffff81224a24>] ? ext4_fallocate+0x1a4/0x530
> > > [23500.239442]  [<ffffffff811f64c5>] ? ext4_meta_trans_blocks+0xa5/0xb0
> > > [23500.239442]  [<ffffffff81224a24>] ext4_fallocate+0x1a4/0x530
> > > [23500.239442]  [<ffffffff8117a092>] do_fallocate+0xf2/0x160
> > > [23500.239442]  [<ffffffff8117a14b>] sys_fallocate+0x4b/0x70
> > > [23500.239442]  [<ffffffff815e6d69>] system_call_fastpath+0x16/0x1b
> > > [23500.239442] Code: ee 44 89 e7 e8 35 1f 0f 00 49 8b 5d 18 4c 89 ef e8 19 4e 00 00 48 83 c4 08 c1 e3 18 c1 fb 1f 83 e3 a1 89 d8 5b 41 5c 41 5d 5d c3 <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 66 0f 1f 84 00 00 00 00 00 55 48 
> > > [23500.239442] RIP  [<ffffffff811a9add>] submit_bh+0x10d/0x120
> > > [23500.239442]  RSP <ffff880273a41b58>
> > > [23500.261657] ---[ end trace 3db7a7a7ae953551 ]---
> >   Hmm, looks like we tried to checkpoint BH_Unwritten buffer. That looks
> > like a bug in fallocate() support. Not really related but definitely worth
> > reporting.
> 
> Well, I ran vanilla the tests in vanilla 3.3 overnight, they were fine.
> But may be I was lucky. I'll try to run the tests with vanilla kernel
> some more. I mean, it would make more sense to report something against
> vanilla 3.3, not a patched 3.3.
  That's true. Frankly I think you were lucky with hitting the bug with
patched kernel rather than not hitting it with vanilla :). What test did
you run exactly?

> Any hints how to properly report an ext4 bug?
  Hmm, like any other. Report what load did you run, what kernel, and the
oops... And send the report to linux-ext4@vger.kernel.org.
								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
