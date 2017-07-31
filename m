From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove unused metadata accounting variables
Date: Sun, 30 Jul 2017 22:34:51 -0400
Message-ID: <20170731023451.pm75sx7isl3oscf4@thunk.org>
References: <20170713145708.GA6159@localhost.localdomain>
 <20170713155832.GA15524@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47218 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751585AbdGaCey (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 30 Jul 2017 22:34:54 -0400
Content-Disposition: inline
In-Reply-To: <20170713155832.GA15524@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 13, 2017 at 05:58:32PM +0200, Jan Kara wrote:
> On Thu 13-07-17 10:57:08, Eric Whitney wrote:
> > Two variables in ext4_inode_info, i_reserved_meta_blocks and
> > i_allocated_meta_blocks, are unused.  Removing them saves a little
> > memory per in-memory inode and cleans up clutter in several tracepoints.
> > Adjust tracepoint output from ext4_alloc_da_blocks() for consistency
> > and fix a typo and whitespace near these changes.
> > 
> > Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> 
> Looks good. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
