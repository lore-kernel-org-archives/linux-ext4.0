From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/3] block_write_full_page: Use synchronous writes for
	WBC_SYNC_ALL writebacks
Date: Wed, 8 Apr 2009 11:25:41 -0400
Message-ID: <20090408152541.GA14895@mit.edu>
References: <1238185471-31152-2-git-send-email-tytso@mit.edu> <20090406232141.ebdb426a.akpm@linux-foundation.org> <20090406235052.1ea47513.akpm@linux-foundation.org> <20090407070835.GM5178@kernel.dk> <20090407002313.fcdd1da0.akpm@linux-foundation.org> <20090407075732.GO5178@kernel.dk> <20090407190913.GA31723@mit.edu> <20090407193239.GE5178@kernel.dk> <20090407214421.GA7031@mit.edu> <20090408055853.GJ5178@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jack@suse.cz
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47143 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750AbZDHPZy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Apr 2009 11:25:54 -0400
Content-Disposition: inline
In-Reply-To: <20090408055853.GJ5178@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 08, 2009 at 07:58:54AM +0200, Jens Axboe wrote:
> 
> I'm not even sure what is documented about this sort of thing in biodoc,
> but it's actually somewhat outside the realm of block layer
> documentation. The block layer should document that you need to call
> unplug if you are going to be waiting for that IO. How the vm code does
> it is implementation detail mostly, the important thing is that it gets
> done :-)

Fair enough; I agree a lot of the problem is the page writeback
subsystem isn't well documented at all, and is crying out for a review
for possible refactorization and cleanup....

						- Ted
