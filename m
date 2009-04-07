From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/3] block_write_full_page: Use synchronous writes for
	WBC_SYNC_ALL writebacks
Date: Tue, 7 Apr 2009 10:19:04 -0400
Message-ID: <20090407141904.GD31725@mit.edu>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu> <1238185471-31152-2-git-send-email-tytso@mit.edu> <20090406232141.ebdb426a.akpm@linux-foundation.org> <20090406235052.1ea47513.akpm@linux-foundation.org> <20090407070835.GM5178@kernel.dk> <20090407002313.fcdd1da0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jack@suse.cz
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44884 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbZDGOTW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Apr 2009 10:19:22 -0400
Content-Disposition: inline
In-Reply-To: <20090407002313.fcdd1da0.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 07, 2009 at 12:23:13AM -0700, Andrew Morton wrote:
> 
> I think the number of different greps which was needed to find all the
> above was excessive.  Too many levels of wrappers and helpers.

This is true not only for the block I/O code, it's true also for the
page writeback code --- have you ever tried creating a call tree that
traces all of the descendents of sync_inode()?

One of these days when I have a spare week (hah!), I'd love to create
a huge chart of all of the callers into the various wrapper functions
of the page writeback paths, figure out who needs what, and then
collapse the rest.

> > It looks like a good candidate for WRITE_SYNC_PLUG instead,

Yeah, what we'll need to do now that we have the difference between
WRITE_SYNC and WRITE_SYNC_PLUG is to have a way of signalling
(probably via yet another wbc flag) that we want WRITE_SYNC_PLUG and
not WRITE_SYNC, and that the top-level caller of this whole mess will
be responsible for issuing the unplug.  I'll try to get something
whipped up.

						- Ted

