From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] ext4: Block mmapped writes while the fs is frozen
Date: Wed, 18 May 2011 09:56:14 +0200
Message-ID: <20110518075614.GB25632@quack.suse.cz>
References: <1305066574-1573-1-git-send-email-jack@suse.cz>
 <1305066574-1573-4-git-send-email-jack@suse.cz>
 <20110517151108.GB6653@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725Ab1ERH4h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 03:56:37 -0400
Content-Disposition: inline
In-Reply-To: <20110517151108.GB6653@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 17-05-11 11:11:08, Christoph Hellwig wrote:
> On Wed, May 11, 2011 at 12:29:34AM +0200, Jan Kara wrote:
> > We should not allow file modification via mmap while the filesystem is
> > frozen. So block in ext4_page_mkwrite() while the filesystem is frozen.
> > 
> > We have to check for frozen filesystem with the page marked dirty and under
> > page lock with which we then return from ext4_page_mkwrite(). Only that way we
> > cannot race with writeback done by freezing code - either we mark the page
> > dirty after the writeback has started, see freezing in progress and block, or
> > writeback will wait for our page lock which is released only when the fault is
> > done and then writeback will writeout and writeprotect the page again.
> 
> This really should be done in (__)block_page_mkwrite.  I'd also return
> VM_FAULT_RETRY instead of retrying inside the block_mkwrite handler
> in case you hit the race.
  Well, we can do the non-blocking check at the end of
__block_page_mkwrite() and return some error value (EAGAIN translating to
VM_FAULT_RETRY would look logical, I just have to think off better error
value for VM_FAULT_NOPAGE). But vfs_check_frozen() cannot be in
__block_page_mkwrite() since ext4 needs to call that with a transaction
started so that would create a deadlock and we need to call
vfs_check_frozen() somewhere so that we don't busyloop.

I can call vfs_check_frozen() inside block_page_mkwrite() but it would be a
bit surprising difference from __block_page_mkwrite() to me. Not sure what
the cleanest solution would be here...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
