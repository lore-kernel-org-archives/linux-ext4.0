From: Jan Kara <jack@suse.cz>
Subject: Re: nobh mount option in ext3/4?
Date: Mon, 31 May 2010 19:55:58 +0200
Message-ID: <20100531175557.GC5334@quack.suse.cz>
References: <20100531124051.GA17262@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:54320 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630Ab0EaR4L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 May 2010 13:56:11 -0400
Content-Disposition: inline
In-Reply-To: <20100531124051.GA17262@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 31-05-10 14:40:51, Christoph Hellwig wrote:
> ext3 and ext4 heave inherited the nobh option from ext2, but the
> implementation is rather interesting.  Except for the usual
> option parsing / display it's only respected in
> ext3_writeback_writepage/ext4_writepage and the truncate_page
> implementation.  Given that we don't take any more than usual
> care to not create buffers heads during read this is not going
> to effect a whole lot.
> 
> Is there a good reason to keep these options and the associated
> code complexity?  I'd be rather surprised if it gets any sufficient
> testing..
  IMHO nobh can go away from ext3/ext4. I would be also in favor of
removing all the nobh logic from VFS and ext2 but for ext2 it saves some
low memory so some people might actually use it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
