From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: Forbid journal_async_commit in data=ordered mode
Date: Tue, 25 Nov 2014 20:20:02 -0500
Message-ID: <20141126012002.GA28130@thunk.org>
References: <1416930975-13676-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51995 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbaKZBUJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Nov 2014 20:20:09 -0500
Content-Disposition: inline
In-Reply-To: <1416930975-13676-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 25, 2014 at 04:56:15PM +0100, Jan Kara wrote:
> Option journal_async_commit breaks gurantees of data=ordered mode as it
> sends only a single cache flush after writing a transaction commit
> block. Thus even though the transaction including the commit block is
> fully stored on persistent storage, file data may still linger in drives
> caches and will be lost on power failure. Since all checksums match on
> journal recovery, we replay the transaction thus possibly exposing stale
> user data.
> 
> To fix this data exposure issue, remove the possibility to use
> journal_async_commit in data=ordered mode.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

						- Ted
