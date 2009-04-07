From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/3] block_write_full_page: Use synchronous writes for
	WBC_SYNC_ALL writebacks
Date: Tue, 7 Apr 2009 17:44:21 -0400
Message-ID: <20090407214421.GA7031@mit.edu>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu> <1238185471-31152-2-git-send-email-tytso@mit.edu> <20090406232141.ebdb426a.akpm@linux-foundation.org> <20090406235052.1ea47513.akpm@linux-foundation.org> <20090407070835.GM5178@kernel.dk> <20090407002313.fcdd1da0.akpm@linux-foundation.org> <20090407075732.GO5178@kernel.dk> <20090407190913.GA31723@mit.edu> <20090407193239.GE5178@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jack@suse.cz
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:49595 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161AbZDGVoe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Apr 2009 17:44:34 -0400
Content-Disposition: inline
In-Reply-To: <20090407193239.GE5178@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 07, 2009 at 09:32:39PM +0200, Jens Axboe wrote:
> 
> This should be all you need, forget the below. The manual unplugging
> only really makes sense for very select situations, since it'll be done
> when someone waits on the buffer anyway.

Thanks, ok; I missed the "sync_buffer" in the call to wait_on_bit() in
__wait_on_buffer().  It also wasn't obvious to me that
wait_on_writeback_range() ultimately ends up calling aops->sync_page
which for filemap.c will call blk_run_backing_dev() --- and that
blk_run_*() results in the right device queue getting unplugged.  So
this would be a nice thing to get documented in
Documentation/biodoc.txt.

						- Ted
