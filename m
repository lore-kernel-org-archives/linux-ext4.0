From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix cache flish in ext4_sync_file
Date: Sat, 5 Sep 2009 21:43:16 -0400
Message-ID: <20090906014316.GE2287@mit.edu>
References: <20090831193553.GA2672@lst.de> <4A9D669F.1040508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41650 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbZIFBnX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Sep 2009 21:43:23 -0400
Content-Disposition: inline
In-Reply-To: <4A9D669F.1040508@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 01, 2009 at 01:23:27PM -0500, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > We need to flush the write cache unconditionally in ->fsync, otherwise
> > writes into already allocated blocks can get lost.  Writes into fully
> > allocated files are very common when using disk images for
> > virtualization, and without this fix can easily lose data after
> > an fdatasync, which is the typical implementation for a cache flush on
> > the virtual drive.
> > 
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Fixing my old commit, I guess ;)

Added to the ext4 patch queue (with the "flish" corrected to "flush")

      	     	  	      	    - Ted
