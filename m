From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] ext4: Block mmapped writes while the fs is frozen
Date: Wed, 18 May 2011 04:07:31 -0400
Message-ID: <20110518080731.GA2759@infradead.org>
References: <1305066574-1573-1-git-send-email-jack@suse.cz>
 <1305066574-1573-4-git-send-email-jack@suse.cz>
 <20110517151108.GB6653@infradead.org>
 <20110518075614.GB25632@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34449 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab1ERIHc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 May 2011 04:07:32 -0400
Content-Disposition: inline
In-Reply-To: <20110518075614.GB25632@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 18, 2011 at 09:56:14AM +0200, Jan Kara wrote:
> __block_page_mkwrite() and return some error value (EAGAIN translating to
> VM_FAULT_RETRY would look logical, I just have to think off better error
> value for VM_FAULT_NOPAGE). But vfs_check_frozen() cannot be in
> __block_page_mkwrite() since ext4 needs to call that with a transaction
> started so that would create a deadlock and we need to call
> vfs_check_frozen() somewhere so that we don't busyloop.
> 
> I can call vfs_check_frozen() inside block_page_mkwrite() but it would be a
> bit surprising difference from __block_page_mkwrite() to me. Not sure what
> the cleanest solution would be here...

block_page_mkwrite is supposed to be used directly by filesystems and
do all the right things.  IIRC Eric even mentioned he added
vfs_check_frozen to it for RHEL, but forgot to push it upstream.

