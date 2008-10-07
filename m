From: Andreas Dilger <adilger@sun.com>
Subject: Re: ext4 deadlocks
Date: Tue, 07 Oct 2008 15:46:37 -0600
Message-ID: <20081007214637.GA2009@webber.adilger.int>
References: <48EBB9E9.4030105@goop.org> <48EBC6B9.7000608@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kalpak Shah <Kalpak.Shah@sun.com>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58004 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbYJGVrA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Oct 2008 17:47:00 -0400
In-reply-to: <48EBC6B9.7000608@sandeen.net>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Oct 07, 2008  15:29 -0500, Eric Sandeen wrote:
> Jeremy Fitzhardinge wrote:
> > I tried giving ext4 a spin on my rawhide system, and it appears to 
> > deadlock pretty quickly: lots of processed blocked in either ext4 or jbd2.
> > 
> >  From the look of the sysrq-t dumps I captured, I think beagled is 
> > what's triggering it by doing something with EAs. I haven't had any 
> > lockups since I killed it off.
> > 
> > beagled       D 0000000000000000     0  3477      1
> >  ffff880125809778 0000000000000082 0000000000000000 ffff88013b078150
> >  ffffffff8187a780 ffffffff8187a780 ffff88010f8445c0 ffff88013badc5c0
> >  ffff88010f844970 0000000100000001 0000000000000000 ffff88010f844970
> > Call Trace:
> >  [<ffffffff812170d8>] ? scsi_sg_alloc+0x48/0x4a
> >  [<ffffffff8136d4ae>] __down_write_nested+0xa3/0xbd
> >  [<ffffffff8136d4d3>] __down_write+0xb/0xd
> >  [<ffffffff8136c813>] down_write+0x2f/0x33
> >  [<ffffffffa04b30a8>] ext4_expand_extra_isize_ea+0x67/0x6f2 [ext4dev]
> 
> At first glance it seems that we're trying a down_write on the xattr_sem
> here...
> 
> >  [<ffffffffa04762ed>] ? jbd2_journal_add_journal_head+0x113/0x1b0 [jbd2]
> >  [<ffffffffa0476173>] ? jbd2_journal_put_journal_head+0x1a/0x56 [jbd2]
> >  [<ffffffffa0471669>] ? jbd2_journal_get_write_access+0x31/0x38 [jbd2]
> >  [<ffffffffa0471a6c>] ? jbd2_journal_extend+0x1af/0x1ca [jbd2]
> >  [<ffffffffa0497f5c>] ext4_mark_inode_dirty+0x119/0x18b [ext4dev]
> >  [<ffffffffa0498156>] ext4_dirty_inode+0xab/0xc3 [ext4dev]
> >  [<ffffffff810e7310>] __mark_inode_dirty+0x38/0x194
> >  [<ffffffffa04b0574>] ext4_mb_new_blocks+0x700/0x70f [ext4dev]
> >  [<ffffffff8109f395>] ? mark_page_accessed+0x5f/0x6b
> >  [<ffffffff810eb5ba>] ? __find_get_block+0x1af/0x1c1
> >  [<ffffffff8136c3af>] ? __wait_on_bit+0x6f/0x7e
> >  [<ffffffff810ec154>] ? sync_buffer+0x0/0x44
> >  [<ffffffffa0493e50>] do_blk_alloc+0x9d/0xb3 [ext4dev]
> >  [<ffffffffa0493eb5>] ext4_new_meta_blocks+0x34/0x76 [ext4dev]
> >  [<ffffffffa0493f1b>] ext4_new_meta_block+0x24/0x26 [ext4dev]
> >  [<ffffffffa04b2e79>] ext4_xattr_block_set+0x50e/0x6d6 [ext4dev]
> >  [<ffffffffa04b39b4>] ext4_xattr_set_handle+0x281/0x3f0 [ext4dev]
> 
> Having already downed it here?
> 
> I'll look into it, not 100% sure what path gets us here (between
> in-inode EAs and external block EAs) but I'll see.

This looks suspiciously like a similar bug fixed in the past by Kalpak,
related to trying to grow large-inode space in ext4_expand_extra_isize_ea().

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

