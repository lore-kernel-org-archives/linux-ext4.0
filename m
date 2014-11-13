From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH,RFC] ext4: add lazytime mount option
Date: Thu, 13 Nov 2014 11:07:10 -0500
Message-ID: <20141113160710.GE5235@thunk.org>
References: <1415765227-9561-1-git-send-email-tytso@mit.edu>
 <87vbmkpm2p.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonlist@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56633 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933AbaKMQHO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Nov 2014 11:07:14 -0500
Content-Disposition: inline
In-Reply-To: <87vbmkpm2p.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 12, 2014 at 04:47:42PM +0300, Dmitry Monakhov wrote:
> Also sync mtime updates is a great pain for AIO submitter
> because AIO submission may be blocked for a seconds (up to 5 second in my case)
> if inode is part of current committing transaction see: do_get_write_access

5 seconds?!?  So you're seeing cases where the jbd2 layer is taking
that long to close a commit?  It might be worth looking at that so we
can understand why that is happening, and to see if there's anything
we might do to improve things on that front.  Even if we can get rid
of most of the mtime updates, there will be other cases where a commit
that takes a long time to complete will cause all sorts of other very
nasty latencies on the entire system.

> Yeah we also has ticket for that :)
> https://jira.sw.ru/browse/PSBM-20411

Is this supposed to be a URL to publically visible web page?

	Host jira.sw.ru not found: 3(NXDOMAIN)

> > +	if (flags & S_VERSION)
> > +		inode_inc_iversion(inode);
	  ....
> Since we want update all in-memory data we also have to explicitly update inode->i_version
> Which was previously updated implicitly here:
> mark_inode_dirty_sync()
> ->__mark_inode_dirty
>   ->ext4_dirty_inode
>     ->ext4_mark_inode_dirty
>       ->ext4_mark_iloc_dirty
>         ->inode_inc_iversion(inode);

It's not necessary to add a anothre call to inode_inc_version() since
we already incremented the i_version if S_VERSION is set, and
S_VERSIOn gets set when it's necessary to handle incrementing
i_Version.

The inode_inc_iversion() in mark4_ext4_iloc_dirty() is probably not
necessary, since we already should be incrementing i_version whenever
ctime and mtime gets updated.  The inode_inc_iversion() there is more
of a "belt and suspenders" safety thing, on the theory that the extra
bump in i_version won't hurt anything.

Cheers,

					- Ted
