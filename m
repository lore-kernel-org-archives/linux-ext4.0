From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 4/6] ext4: Properly initialize the buffer_head state
Date: Wed, 13 May 2009 08:38:01 -0400
Message-ID: <20090513123801.GB6579@mit.edu>
References: <1242168327-31127-1-git-send-email-tytso@mit.edu> <1242168327-31127-2-git-send-email-tytso@mit.edu> <1242168327-31127-3-git-send-email-tytso@mit.edu> <1242168327-31127-4-git-send-email-tytso@mit.edu> <1242168327-31127-5-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:45272 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859AbZEMMiH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 May 2009 08:38:07 -0400
Content-Disposition: inline
In-Reply-To: <1242168327-31127-5-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 12, 2009 at 06:45:25PM -0400, Theodore Ts'o wrote:
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 8d0ff73..475c3dd 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2049,7 +2049,7 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
>  	if ((mpd->b_state  & (1 << BH_Mapped)) &&
>  	    !(mpd->b_state & (1 << BH_Delay)))
>  		return 0;
> -	new.b_state = mpd->b_state;
> +	new.b_state = 0;
>  	new.b_blocknr = 0;
>  	new.b_size = mpd->b_size;
>  	next = mpd->b_blocknr;

Aneesh,

Eric asked about this change, and it looks like this patch hunk is
responsible for a regression.  With this change, the delayed
allocation accounting gets screwed up.  It looks like if you delete a
file which has blocks that haven't been allocated yet, the delayed
allocation count doesn't get dropped, and so
sbi->s_dirtyblocks_counter is left higher than it should be.

You can replicate this by running "dbench 32" on an ext4 filesystem,
hitting ^C after about ten seconds, and then running "sync", and then
noting that "cat /sys/fs/ext4/<device>/delayed_allocation_blocks" is
non-zero.  The df command will show that the blocks in use is too
high; if you run the df command, then unmount and remount the
filesystem, and re-run the df command, you will see the blocks (in
kilobytes) in use will have dropped by the amount reported by
delayed_allocation_blocks times 4 (assuming a 4k blocksize).

When I reverted just that patch hunk above, the problem went away.

What was your reasonining behind changing how new.b_state was getting
initialized.  (And insert my standard worries that the buffer head
flags accounting is getting horrifically complicated --- I have *no*
idea why this should be making a difference, especially in the way
that the symptoms expressed themselves, but I am very concerned about
the fragility of this whole set up...)

						- Ted
