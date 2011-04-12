From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Does ext4 send FUA to flush disk cache
Date: Tue, 12 Apr 2011 00:40:18 -0400
Message-ID: <20110412044018.GA4245@infradead.org>
References: <BANLkTikmryaO5r012VwsNzhcaaVQ_4QfzA@mail.gmail.com>
 <DE099CBA-6478-4651-B3E5-F406D0C11C3D@mit.edu>
 <20110411231606.GA9406@infradead.org>
 <20110412021423.GC3682@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Mark Busheman <markbusheman@gmail.com>,
	linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36322 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab1DLEkU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Apr 2011 00:40:20 -0400
Content-Disposition: inline
In-Reply-To: <20110412021423.GC3682@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 11, 2011 at 10:14:23PM -0400, Ted Ts'o wrote:
> Ah, Jens pushed a patch that I hadn't noticed that appears to
> optionally use FUA for the commit block.  Thanks for pointing that
> out.

The commits actually are from Tejun:

commit 797e7dbbee0a91fa1349192f18ad5c454997d876
Author: Tejun Heo <htejun@gmail.com>
Date:   Fri Jan 6 09:51:03 2006 +0100

    [BLOCK] reimplement handling of barrier request

    Reimplement handling of barrier requests.
	        
     * Flexible handling to deal with various capabilities of
       target devices.
     * Retry support for falling back.
     * Tagged queues which don't support ordered tag can do ordered.
				      
    Signed-off-by: Tejun Heo <htejun@gmail.com>
    Signed-off-by: Jens Axboe <axboe@suse.de>

commit 007365ad60387df30f02f01fdc2b6e6432f6c265
Author: Tejun Heo <htejun@gmail.com>
Date:   Fri Jan 6 09:53:52 2006 +0100

    [BLOCK] scsi: add FUA support to sd

    Add FUA support for barriers to SCSI disk.

    Signed-off-by: Tejun Heo <htejun@gmail.com>
    Signed-off-by: Jens Axboe <axboe@suse.de>

