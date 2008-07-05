From: Christoph Hellwig <hch@infradead.org>
Subject: Re: New ext4 patchset 2.6.26-rc8-ext4-1
Date: Sat, 5 Jul 2008 13:50:47 -0400
Message-ID: <20080705175047.GA11243@infradead.org>
References: <E1KFBPc-0006yI-Gx@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52070 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759885AbYGERur (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2008 13:50:47 -0400
Content-Disposition: inline
In-Reply-To: <E1KFBPc-0006yI-Gx@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 05, 2008 at 01:19:04PM -0400, Theodore Ts'o wrote:
> Alex Tomas (2):
>     * vfs: add basic delayed allocation support
>     * ext4: Add basic delayed allocation support

Strong NACK.  For one thing the code added to mpage.c doesn't belong
there.  It's far inferior to the existing delalloc code we already have
and that could be made generic easily, or the next generation code
developed by Chris mason.  It's an ext4-specific hack and doesn't belong
into common code.  I'm pretty sure we agreed on not having it in
common code long ago.

Also the code still deals with the !buffer_mapped and no buffers on page
cases all over which isn't needed anymore with ->page_mkwrite implemented.
Similarly the !get_block case in mpage_da_writepages doesn't make any
sense - it's never used and if people would want to use
generic_writepages they could trivially just call it directly.

And please fix up the indentation of the new buffer_delay checks in
fs/buffer.c, the && belongs on the end of the previous line, and the
second line of the conditional should not be indented the same amount
as the code inside the conditional block.
