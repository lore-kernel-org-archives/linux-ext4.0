From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC] extent status tree (step2)
Date: Tue, 20 Nov 2012 15:19:08 +0800
Message-ID: <20121120071908.GA6078@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:38166 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab2KTHG0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Nov 2012 02:06:26 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so1112631dak.19
        for <linux-ext4@vger.kernel.org>; Mon, 19 Nov 2012 23:06:25 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Extent status tree has been applied into linux-next.  So I have begun to try to
implement the second step of extent status tree [1].  In this step the following
improvements will be added:
 - track all extent status for an inode
 - improve delay allocation space reservation
 - reduce the race contention of i_data_sem w/ delalloc
 - big extent tree (accelerate looking up in extent tree)


* Track all extent status for an inode

Now extent status tree only records the status of delay extents.  In this step,
it will be improved to track all extent status for an inode.  The extent status
includes DELAY, WRITTEN, UNWRITTEN.  When an application opens a file, there
will be an empty extent status tree.  While calling get_block_t function, the
extent status will be inserted into this tree.  So after some time this tree can
track most of extent entries.

* Improve delay allocation space reservation

Currently we will meet a warning in some specific pressure test w/ bigalloc and
delalloc.  The reason is that we need to reserve some spaces for delay
allocation.  As bigalloc is enabled this work is complicated.  So we can use
extent status tree to track how much space we need to reserve.

* Reduce the race contention of i_data_sem w/ delalloc

When delalloc is enabled, filesystem will accumulate more blocks that are
waiting to be written out.  That brings us more continuous file layout and
higher throughput.  In a specific case, however, it causes a huge latency for
application.  When an app does some append writes, it only needs to wait just
a moment if flusher is sleep and doesn't write any dirty pages out.  But when
flusher tries to write these dirty pages, i_data_sem will be taken for a long
time with delalloc because filesystem needs to allocate lots of blocks for these
pages.  At the same time, if the app goes on doing a append write, filesystem
will try to take i_data_sem too because it needs to determine whether or not
some blocks has been allocated.  So the app must need to wait a long time to
finish this write.  It is unacceptable for some applications that are
latency-sensitive.

In this step, we can modify get_block_t function to look up extent status tree.
When filesystem needs to find a block mapping, it will look up extent status
tree firstly.  We only needs to take a rwlock and can avoid waiting for a long
time.

* Big extent tree

This year at ext4 developer workshop, Ted and other folks discussed about big
extent cache [2].  The idea is that multiple extent entries are collapsed into
a single in memory.  It looks like a cache for extent tree, and can reduce the
cost of memory and accelerate looking up an extent entry.  It seems that extent
status tree also can do this thing.

Ted, If you have some updates for big extent cache or I misunderstand something,
please let me know. Thanks!

Any comments or feedbacks are appreciated.

Thanks!
						- Zheng

---
1. http://pl.digipedia.org/usenet/thread/11916/30410/
2. http://www.spinics.net/lists/linux-ext4/msg31742.html
