From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: optimize ext4 direct I/O locking for reading
Date: Wed, 21 Sep 2016 10:37:48 -0400
Message-ID: <20160921143748.xswkovbjrtcgs3bq@thunk.org>
References: <20160921052744.5223-1-tytso@mit.edu>
 <20160921132609.GA30232@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46342 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934002AbcIUPOR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 21 Sep 2016 11:14:17 -0400
Content-Disposition: inline
In-Reply-To: <20160921132609.GA30232@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 21, 2016 at 06:26:09AM -0700, Christoph Hellwig wrote:
> Is there any chance you could look into simplifying the locking instead
> of making it even more complicated?  Since Al replaced i_mutex with
> i_rwsem you can now easily take that in shared mode.  E.g. if you'd
> move to a direct I/O model closer to XFS, ocfs2 and NFS where you always
> take i_rwsem in shared mode you'll get the scalibility of the
> dioread_nolock case while no having to do these crazy dances, and you
> can also massively simplify the codebase.  Similarly you can demote it
> from exclusive to shared after allocating blocks in the write path,
> and you'll end up with something way easier to understand.

Unfortunately, in order to do this we need to extend the
dioread_nolock handling for sub-page block sizes.  (This is where we
insert the allocated blocks into the extent maps marked uninitialized,
and only converting the extent from uninitialized to initialized ---
which today only works when the page size == block size.)

This is on my todo list, but half of the problem is the mess caused by
needing to iterate over the circularly linked buffer heads when there
are multiple buffer heads covering the page.  I was originally
assuming that it would be easier to fix this after doing the bh ->
iomap conversion, but it's in a while before I looked into this
particular change.  I can try to take a closer look again....

The main reason why I looked into this hack --- and I will be the
first to agree it was a hack, is because I had a request to support
the dioread_nolock scalability on a Little Endian PowerPC system which
has 64k page sizes.

> Sorry for the rant, but I just had to dig into this code when looking
> at converting ext4 to the new DAX path, and my eyes still bleed..

Yeah, I know, and I'm sorry.  There's quite a bit of technical debt
there, which I do want to clean up.

							- Ted
