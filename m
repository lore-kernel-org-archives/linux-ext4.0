From: Jan Kara <jack@suse.cz>
Subject: Re: New ext4 patchset 2.6.26-rc8-ext4-1
Date: Tue, 8 Jul 2008 21:53:53 +0200
Message-ID: <20080708195353.GB22477@atrey.karlin.mff.cuni.cz>
References: <E1KFBPc-0006yI-Gx@closure.thunk.org> <20080705175047.GA11243@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36905 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbYGHTxy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jul 2008 15:53:54 -0400
Content-Disposition: inline
In-Reply-To: <20080705175047.GA11243@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Sat, Jul 05, 2008 at 01:19:04PM -0400, Theodore Ts'o wrote:
> > Alex Tomas (2):
> >     * vfs: add basic delayed allocation support
> >     * ext4: Add basic delayed allocation support
> 
> Strong NACK.  For one thing the code added to mpage.c doesn't belong
> there.  It's far inferior to the existing delalloc code we already have
> and that could be made generic easily, or the next generation code
> developed by Chris mason.  It's an ext4-specific hack and doesn't belong
> into common code.  I'm pretty sure we agreed on not having it in
> common code long ago.
> 
> Also the code still deals with the !buffer_mapped and no buffers on page
> cases all over which isn't needed anymore with ->page_mkwrite implemented.
  I'd just comment on this: We've experimentally found out that page
without buffers *can* happen even with page_mkwrite() implementation.
  One path I remember we identified as possible cause is do_wp_page()
where buffers can be removed again from the page before it is marked
dirty. So if filesystem wants to be sure that buffers are really
attached to the page, I think it must mark the page (and through it buffers)
dirty before unlocking it...

> Similarly the !get_block case in mpage_da_writepages doesn't make any
> sense - it's never used and if people would want to use
> generic_writepages they could trivially just call it directly.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
