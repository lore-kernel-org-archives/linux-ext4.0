From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/5] jbd2: Speedup jbd2_journal_get_[write|undo]_access()
Date: Mon, 8 Jun 2015 12:47:26 -0400
Message-ID: <20150608164726.GM19168@thunk.org>
References: <1427983100-29889-1-git-send-email-jack@suse.cz>
 <1427983100-29889-5-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53292 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbbFHQr2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jun 2015 12:47:28 -0400
Content-Disposition: inline
In-Reply-To: <1427983100-29889-5-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 02, 2015 at 03:58:19PM +0200, Jan Kara wrote:
> jbd2_journal_get_write_access() and jbd2_journal_get_create_access() are
> frequently called for buffers that are already part of the running
> transaction - most frequently it is the case for bitmaps, inode table
> blocks, and superblock. Since in such cases we have nothing to do, it is
> unfortunate we still grab reference to journal head, lock the bh, lock
> bh_state only to find out there's nothing to do.
> 
> Improving this is a bit subtle though since until we find out journal
> head is attached to the running transaction, it can disappear from under
> us because checkpointing / commit decided it's no longer needed. We deal
> with this by protecting journal_head slab with RCU. We still have to be
> careful about journal head being freed & reallocated within slab and
> about exposing journal head in consistent state (in particular
> b_modified and b_frozen_data must be in correct state before we allow
> user to touch the buffer).
> 
> FIXME: Performance data.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, so we can start getting some testing on this patch.  Did you
ever get performance data?

Thanks,

						- Ted
