From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [patch 003/152] jbd: fix commit of ordered data buffers
Date: Fri, 29 Sep 2006 09:11:46 -0700
Message-ID: <1159546306.8780.2.camel@dyn9047017100.beaverton.ibm.com>
References: <200609260630.k8Q6UrvQ011999@shell0.pdx.osdl.net>
	 <451C4DDE.60307@us.ibm.com>
	 <20060929090253.GA17124@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: akpm@osdl.org, torvalds@osdl.org, stable@kernel.org,
	ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:40645 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S1161106AbWI2QMN
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Sep 2006 12:12:13 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k8TGC9q3029239
	for <linux-ext4@vger.kernel.org>; Fri, 29 Sep 2006 12:12:09 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8TGC9wQ354640
	for <linux-ext4@vger.kernel.org>; Fri, 29 Sep 2006 10:12:09 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8TGC858006411
	for <linux-ext4@vger.kernel.org>; Fri, 29 Sep 2006 10:12:09 -0600
To: Jan Kara <jack@suse.cz>
In-Reply-To: <20060929090253.GA17124@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2006-09-29 at 11:02 +0200, Jan Kara wrote:
...
> > >+		}
> > >+		/* Someone already cleaned up the buffer? */
> > >+		if (!buffer_jbd(bh)
> > >+			|| jh->b_transaction != commit_transaction
> > >+			|| jh->b_jlist != BJ_SyncData) {
> > >+			jbd_unlock_bh_state(bh);
> > >+			if (locked)
> > >+				unlock_buffer(bh);
> > >+			BUFFER_TRACE(bh, "already cleaned up");
> > >+			put_bh(bh);
> > >+			continue;
>    ---> Here the buffer was refiled by someone else

I am little concerned about this particular code. We know that
some one else will do the unfile/remove - but we will keep
spinning on it till that happens. Isn't it ? Why don't we
skip it and move to next one ?

We are seeing few following message while running tests and
wondering if your patch is causing it ..

BUG: spinlock lockup on CPU#1, scp/30189, c00000000fb503d8 (Not tainted)
Call Trace:
[C000000018FDB320] [C0000000000102E0] .show_stack+0x68/0x1b0 (unreliable)
[C000000018FDB3C0] [C0000000001734F4] ._raw_spin_lock+0x138/0x184
[C000000018FDB460] [C00000000025AD24] ._spin_lock+0x10/0x24
[C000000018FDB4E0] [D000000000172E14] .journal_dirty_data+0xa4/0x2c0 [jbd]
[C000000018FDB580] [D000000000205BAC] .ext3_journal_dirty_data+0x28/0x70 [ext3]
[C000000018FDB610] [D0000000002048BC] .walk_page_buffers+0xb0/0x134 [ext3]
[C000000018FDB6D0] [D000000000208280] .ext3_ordered_commit_write+0x74/0x114 
[ext
3]
[C000000018FDB780] [C00000000007E710] .generic_file_buffered_write+0x51c/0x794
[C000000018FDB930] 
[C00000000007ECB8] .__generic_file_aio_write_nolock+0x330/0x3
bc
[C000000018FDBA20] [C00000000007EDBC] .generic_file_aio_write+0x78/0x104
[C000000018FDBAE0] [D000000000202EFC] .ext3_file_write+0x2c/0xd4 [ext3]
[C000000018FDBB70] [C0000000000A8090] .do_sync_write+0xd4/0x130
[C000000018FDBCF0] [C0000000000A8E14] .vfs_write+0x118/0x200
[C000000018FDBD90] [C0000000000A9584] .sys_write+0x4c/0x8c
[C000000018FDBE30] [C000000000008434] syscall_exit+0x0/0x40

Thanks,
Badari

