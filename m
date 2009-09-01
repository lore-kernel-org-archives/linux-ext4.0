From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads v15
Date: Tue, 1 Sep 2009 00:01:14 -0400
Message-ID: <20090901040114.GI23535@mit.edu>
References: <1251747693-32354-1-git-send-email-jens.axboe@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
	akpm@linux-foundation.org, jack@suse.cz, linux-ext4@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49717 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbZIAEBg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Sep 2009 00:01:36 -0400
Content-Disposition: inline
In-Reply-To: <1251747693-32354-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 31, 2009 at 09:41:26PM +0200, Jens Axboe wrote:
> 
> Here's the 15th version of the writeback patches.

The test-bdi branch of ext4.git tree is a combination of the patches I
plan to push once the merge window opens, plus v15 per-bdi patches.
On the ext4 call I've recruited some ext4 developers to do some
testing and benchmarking *before* the merge window opens.

I've found something potentially wrong with the writeback.  It was
careful to sync the disk before shutting down the system, and I got
the following error.   

[  660.499155] ext4_da_writepages: jbd2_start: 32768 pages, ino 41; err -30
[  660.505664] Pid: 1848, comm: flush-8:0 Not tainted 2.6.31-rc8-01474-geef6bd0 #362
[  660.512402] Call Trace:
[  660.514982]  [<c064412f>] ? printk+0x14/0x16
[  660.518851]  [<c023ac4a>] ext4_da_writepages+0x213/0x40e
[  660.523356]  [<c023aa37>] ? ext4_da_writepages+0x0/0x40e
[  660.528383]  [<c01b65a8>] do_writepages+0x28/0x39
[  660.533534]  [<c01f1e07>] writeback_single_inode+0x15c/0x346
[  660.538401]  [<c0165b23>] ? down_read_trylock+0x3e/0x48
[  660.542921]  [<c01f2892>] generic_sync_wb_inodes+0x2ab/0x37b
[  660.547805]  [<c01f2a2a>] wb_writeback+0xc8/0xfa
[  660.551975]  [<c01f2abb>] wb_do_writeback+0x5f/0x118
[  660.556333]  [<c01f2b95>] bdi_writeback_task+0x21/0x92
[  660.560838]  [<c01c0f5d>] bdi_start_fn+0x63/0xb2
[  660.565647]  [<c01c0efa>] ? bdi_start_fn+0x0/0xb2
[  660.569710]  [<c0162363>] kthread+0x73/0x78
[  660.573528]  [<c01622f0>] ? kthread+0x0/0x78
[  660.577355]  [<c011e6f3>] kernel_thread_helper+0x7/0x10

... and a very similar failure for inode 354

[  660.582215] ext4_da_writepages: jbd2_start: 32768 pages, ino 354; err -30

Inode 41 is /var/lib/urandom/random-seed, and inode 354 is
/var/run/syslogd.pid.

The failure occurs if I build w/o the ext4 "next" patches, and the
failure does not happen if I take build v2.6.31-rc8 without per-bdi
patches (with or without the ext4 patches).  At a guess it looks like
the bdi threads are trying to write out the dirty files that were
written in the shutdown scripts, *after* the file system has been made
read-only in preparation for unmounting the file system in question.

	     		     		    	 - Ted
