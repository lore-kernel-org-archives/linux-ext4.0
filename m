From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] block_write_full_page: switch synchronous writes to
	use  WRITE_SYNC_PLUG
Date: Wed, 8 Apr 2009 11:26:37 -0400
Message-ID: <20090408152637.GB14895@mit.edu>
References: <20090406232141.ebdb426a.akpm@linux-foundation.org> <20090406235052.1ea47513.akpm@linux-foundation.org> <20090407070835.GM5178@kernel.dk> <20090407002313.fcdd1da0.akpm@linux-foundation.org> <20090407075732.GO5178@kernel.dk> <20090407190913.GA31723@mit.edu> <20090407193239.GE5178@kernel.dk> <20090407214421.GA7031@mit.edu> <20090407221933.GB7031@mit.edu> <20090408060033.GK5178@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jack@suse.cz
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47150 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933855AbZDHP0v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Apr 2009 11:26:51 -0400
Content-Disposition: inline
In-Reply-To: <20090408060033.GK5178@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 08, 2009 at 08:00:33AM +0200, Jens Axboe wrote:
> 
> I think you should comment on why we don't need to do the actual unplug.
> See what I added in fs/jbd/commit.c:journal_commit_transaction():
> 
>         /*
>          * Use plugged writes here, since we want to submit several
>          * before we unplug the device. We don't do explicit
>          * unplugging in here, instead we rely on sync_buffer() doing
>          * the unplug for us.
>          */

OK, agreed.  I'll add a comment explaining what is going on in the
patch; better there than in the commit log.

					- Ted
