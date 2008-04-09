From: Jan Kara <jack@suse.cz>
Subject: Re: Ordered mode rewrite patch
Date: Wed, 9 Apr 2008 16:48:31 +0200
Message-ID: <20080409144831.GB7789@duck.suse.cz>
References: <20080408121149.GB6901@duck.suse.cz> <20080408121937.GA26650@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nathan Grennan <jack@cygnusx-1.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:56991 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750732AbYDIOsc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Apr 2008 10:48:32 -0400
Content-Disposition: inline
In-Reply-To: <20080408121937.GA26650@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 08-04-08 08:19:37, Christoph Hellwig wrote:
> On Tue, Apr 08, 2008 at 02:11:49PM +0200, Jan Kara wrote:
> > -		} else if (!buffer_mapped(bh) && buffer_dirty(bh)) {
> > +		} else if (!buffer_mapped(bh) && buffer_dirty(bh)
> > +			   && !wbc->skip_unmapped) {
> 
> As mentioned last time unmapped buffer shouldn't happen anymore with
> filesystem updated to have a ->page_mkwrite operations.  As you've
> included the ext3 patch in yours the above condition shoujldn't git
> anymore.
  True. I've used wbc->skip_unmapped to detect inside
ext3_ordered_writepage() that we are committing a transaction and therefore
we should not add inode into the running transaction's list. But later
I've realized that we never need to add inode into transaction's list
from ext3_ordered_writepage() once we have ext3_page_mkwrite(). So now I
don't need wbc->skip_unmapped at all and I've compeletely removed it.
Thanks for pointing this out.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
