From: "Theodore Ts'o" <tytso@mit.edu>
Subject: What am I doing wrong?  submit_bio() suddenly stops working...
Date: Wed, 20 Oct 2010 22:00:30 -0400
Message-ID: <E1P8kSE-0001DW-8C@tytso-glaptop>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:45674 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695Ab0JUCAf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Oct 2010 22:00:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hey Jens,

I've been trying to figure out what I'm doing wrong.  I've been trying
to convert the data writeback bath to use the bio layer.  It mostly
works --- until all of sudden all calls to block_bio_queue(), either via
submit_bh() or via submit_bio(), start turning into no-ops.

I'm sure I'm doing something wrong, but the bio layer isn't terribly
well documented, so I'm not sure what it might be.  The patch which
causes the problem can be found be found here:

http://userweb.kernel.org/~tytso/ext4-bio-patches/0006-Ext4-Use-bio-layer-instead-of-buffer-layer-in-mpage_.patch

Here is an except from an ftrace I've been taking to get to the bottom
of it.  It's a combination of some trace_printk's, blktrace, and the
block_bio_queue tracepoint.   The full log can be found at:

http://userweb.kernel.org/~tytso/ext4-bio-patches/kvm-console

It shows all of the blktrace events that shows up after block_bio_queue
tracepoint, but at some point, after jbd2 or ext4 calls submit_bh() or
submit_bio(), after the block_bio_queue tracepoint, we stop seeing the
blktrace events, and it looks like the block I/O layer stops answering
the phone.  No complaints in dmesg, no BUG_ON's, no errors....

If I back out the ext4 bio patches, things work correctly, and as I
said, I'm pretty sure the bug is in my code.  But the failure is
happening deep in the block I/O stack, and I can't figure out why it's
failing.

I'm hoping this rings a bell, and perhaps we should consider some of the
debugging trace_printk's as possible new tracepoints?

Any help you could give me would be greatly appreciated.  Ideally, you
or someone can tell me what stupid thing I'm doing.  :-)

Thanks,

					- Ted

[  215.663499] jbd2/sdb-2126    0..... 6976406us : submit_bh: <5>dev sdb blk 131072, ret_pc c0211ecb (__sync_dirty_buffer) pid 2126
[  215.663499] jbd2/sdb-2126    0d.... 6976415us :   8,16   Q  WS 1048576 + 8 [jbd2/sdb-8]
[  215.663499] jbd2/sdb-2126    0..... 6976419us : block_bio_queue: 8,16 WS 1048576 + 8 [jbd2/sdb-8]
[  215.663499] jbd2/sdb-2126    0d.... 6976439us :   8,16   m   N cfq2126 alloced
[  215.663499] jbd2/sdb-2126    0d.... 6976440us :   8,16   G  WS 1048576 + 8 [jbd2/sdb-8]
[  215.663499] jbd2/sdb-2126    0d.... 6976445us :   8,16   I   W 1048576 + 8 [jbd2/sdb-8]
[  215.663499] jbd2/sdb-2126    0d.... 6976446us :   8,16   m   N cfq2126 insert_request
[  215.663499] jbd2/sdb-2126    0d.... 6976448us :   8,16   m   N cfq2126 add_to_rr
[  215.663499] jbd2/sdb-2126    0d.... 6976451us :   8,16   m   N cfq2126 preempt
[  215.663499] jbd2/sdb-2126    0d.... 6976452us :   8,16   m   N cfq2993 slice expired t=1
[  215.663499] jbd2/sdb-2126    0d.... 6976453us :   8,16   m   N cfq2993 resid=-331
[  215.663499] jbd2/sdb-2126    0d.... 6976456us :   8,16   m   N cfq2993 sl_used=12 disp=2 charge=12 iops=0 sect=296
[  215.663499] jbd2/sdb-2126    0d.... 6976788us :   8,16   m   N cfq workload slice:45
[  215.663499] jbd2/sdb-2126    0d.... 6976791us :   8,16   m   N cfq2126 set_active wl_prio:0 wl_type:2
[  215.663499] jbd2/sdb-2126    0..... 6976797us : __wait_on_buffer: <5>dev sdb blk 131072, ret_pc c0210e83 (wait_on_buffer) pid 2126
[  215.663499] jbd2/sdb-2126    0d.... 6976801us :   8,16   U   N [jbd2/sdb-8] 10
[  215.663499] jbd2/sda-1439    0..... 10966709us : submit_bh: <5>dev sda blk 128401, ret_pc c02128fb (__block_write_full_page) pid 1439
[  215.663499] jbd2/sda-1439    0..... 10966719us : block_bio_queue: 8,0 WS 1027208 + 8 [jbd2/sda-8]
[  215.663499] jbd2/sda-1439    0..... 10966750us : submit_bh: <5>dev sda blk 128402, ret_pc c02128fb (__block_write_full_page) pid 1439
...
