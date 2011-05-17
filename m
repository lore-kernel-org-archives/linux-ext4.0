From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] ext4: Block mmapped writes while the fs is frozen
Date: Tue, 17 May 2011 11:11:08 -0400
Message-ID: <20110517151108.GB6653@infradead.org>
References: <1305066574-1573-1-git-send-email-jack@suse.cz>
 <1305066574-1573-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1305066574-1573-4-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 11, 2011 at 12:29:34AM +0200, Jan Kara wrote:
> We should not allow file modification via mmap while the filesystem is
> frozen. So block in ext4_page_mkwrite() while the filesystem is frozen.
> 
> We have to check for frozen filesystem with the page marked dirty and under
> page lock with which we then return from ext4_page_mkwrite(). Only that way we
> cannot race with writeback done by freezing code - either we mark the page
> dirty after the writeback has started, see freezing in progress and block, or
> writeback will wait for our page lock which is released only when the fault is
> done and then writeback will writeout and writeprotect the page again.

This really should be done in (__)block_page_mkwrite.  I'd also return
VM_FAULT_RETRY instead of retrying inside the block_mkwrite handler
in case you hit the race.

