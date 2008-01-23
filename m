From: Jan Kara <jack@suse.cz>
Subject: Re: Confused by journaling code in ext3_new_blocks()
Date: Wed, 23 Jan 2008 21:20:45 +0100
Message-ID: <20080123202045.GF23304@atrey.karlin.mff.cuni.cz>
References: <d9885f0f0801230107h6994847fg96d07198011b2065@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Abhishek Rai <abhishekrai@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:59415 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbYAWUUq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jan 2008 15:20:46 -0500
Content-Disposition: inline
In-Reply-To: <d9885f0f0801230107h6994847fg96d07198011b2065@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

> I have the following question related to the journaling code in
> ext3_new_blocks() function of fs/ext3/balloc.c, any help in this
> regard will be greatly appreciated. The code snippet below is taken
> from 2.6.24-rc8-mm1 but this code has changed little for a long time
> so it's likely that any other recent kernel will also have very
> similar code.
> 
> ext3_new_blocks()
> -> ext3_try_to_allocate_with_rsv()
>     -> ext3_journal_dirty_metadata(handle, bitmap_bh)
> ...
> allocated:
> if ( /*sanity checking of newly allocated block numbers*/) {
>     ext3_error(...);
>     goto out;
> }
> 
> out:
>     ...
>     brelse(bitmap_bh);
>     return 0;
> 
> 
> In the above code snippet, ext3_try_to_allocate_with_rsv() is marking
> bitmap_bh as dirty metadata _before_ the sanity checks. I'm not
> worried about the sanity checks as such, but it seems to me that if
> the checks were to fail, we'd be committing the bitmap_bh updates to
> disk even though it violates metadata sanity, or am I missing
> something here ?
  Actually, it depends. Because if sanity checks fail, we call
ext3_error() which remounts fs R/O or panics in most cases. Only if
errors=continue is set, we really get to committing the wrong bitmap
data. But I don't think this really is a problem - fsck has to be run
anyway and it rebuilds the bitmaps from scratch.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
