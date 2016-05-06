From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove unnecessary bio get/put
Date: Thu, 5 May 2016 22:11:04 -0400
Message-ID: <20160506021104.GB31860@thunk.org>
References: <20160321161523.GA12438@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52456 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbcEFCLH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 May 2016 22:11:07 -0400
Content-Disposition: inline
In-Reply-To: <20160321161523.GA12438@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 21, 2016 at 10:15:23AM -0600, Jens Axboe wrote:
> 
> ext4_io_submit() use to check for EOPNOTSUPP after bio submission,
> which is why it had to get an extra reference to the bio before
> submitting it. But since we no longer touch the bio after submission,
> get rid of the redundant get/put of the bio. If we do get the extra
> reference, we enter the slower path of having to flag this bio as now
> having external references.
> 
> Signed-off-by: Jens Axboe <axboe@fb.com>

Jens, thanks for pointing this out.  I've applied this to the ext4.git
tree.

					- Ted
