From: Jan Kara <jack@suse.cz>
Subject: Re: A proposal for making ext4's journal more SMR (and flash)
 friendly
Date: Wed, 8 Jan 2014 23:14:30 +0100
Message-ID: <20140108221430.GB21663@quack.suse.cz>
References: <nsxfvozavl2.fsf@lambda.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41349 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932192AbaAHWOd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Jan 2014 17:14:33 -0500
Content-Disposition: inline
In-Reply-To: <nsxfvozavl2.fsf@lambda.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 08-01-14 00:31:05, Ted Tso wrote:
> The simplest implementation of this design does not require making any
> on-disk format changes.  We simply suppress the writeback of the dirty
> metadata block to the file system.  Instead we keep a journal map in
> memory, which maps metadata block numbers (or data block numbers if data
> journalling is enabled) to a block number in the journal.
> 
> The journal is not truncated when the file system is unmounted, and so
> there is no difference between mounting a file system which has been
> cleanly unmounted or after a system crash.  In both case, the ext4 file
> system will scan the journal, and create an in-memory data structure
> which maps metadata block locations to their location in the journal.
> When a metadata block (or a data block, if data journalling is enabled)
> needs to be read, if the block number is found in the journal map, the
> block is read from the journal instead of from its "real" location on
> disk.
  So when I was thinking about this (already couple of years ago) the thing
which stopped me was the question at which layer we should do the
translation. Ideally we would need something at submit_bh() level but just
wrapping submit_bh() calls inside ext4 isn't enough for stuff like symlinks
or journalled data... Do you have any thoughts on that?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
