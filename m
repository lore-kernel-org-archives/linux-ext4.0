From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/3] block_write_full_page: Use synchronous writes for
	WBC_SYNC_ALL writebacks
Date: Wed, 8 Apr 2009 07:58:54 +0200
Message-ID: <20090408055853.GJ5178@kernel.dk>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu> <1238185471-31152-2-git-send-email-tytso@mit.edu> <20090406232141.ebdb426a.akpm@linux-foundation.org> <20090406235052.1ea47513.akpm@linux-foundation.org> <20090407070835.GM5178@kernel.dk> <20090407002313.fcdd1da0.akpm@linux-foundation.org> <20090407075732.GO5178@kernel.dk> <20090407190913.GA31723@mit.edu> <20090407193239.GE5178@kernel.dk> <20090407214421.GA7031@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jack@suse.cz
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:58522 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194AbZDHF6z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Apr 2009 01:58:55 -0400
Content-Disposition: inline
In-Reply-To: <20090407214421.GA7031@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 07 2009, Theodore Tso wrote:
> On Tue, Apr 07, 2009 at 09:32:39PM +0200, Jens Axboe wrote:
> > 
> > This should be all you need, forget the below. The manual unplugging
> > only really makes sense for very select situations, since it'll be done
> > when someone waits on the buffer anyway.
> 
> Thanks, ok; I missed the "sync_buffer" in the call to wait_on_bit() in
> __wait_on_buffer().  It also wasn't obvious to me that
> wait_on_writeback_range() ultimately ends up calling aops->sync_page
> which for filemap.c will call blk_run_backing_dev() --- and that
> blk_run_*() results in the right device queue getting unplugged.  So
> this would be a nice thing to get documented in
> Documentation/biodoc.txt.

I'm not even sure what is documented about this sort of thing in biodoc,
but it's actually somewhat outside the realm of block layer
documentation. The block layer should document that you need to call
unplug if you are going to be waiting for that IO. How the vm code does
it is implementation detail mostly, the important thing is that it gets
done :-)

-- 
Jens Axboe

