From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH] ensure do_split leaves enough free space in both blocks
Date: Sun, 16 Sep 2007 23:48:18 -0600
Message-ID: <20070917054817.GG2990@schatzie.adilger.int>
References: <46ECA71C.9020100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	hooanon05@yahoo.co.jp
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:53175 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbXIQFrx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Sep 2007 01:47:53 -0400
Content-Disposition: inline
In-Reply-To: <46ECA71C.9020100@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 15, 2007  22:46 -0500, Eric Sandeen wrote:
> * calculate the minimum rec_len when generating the map, vs.
>   just storing the current rec_len.

Well, we already do this when moving the entries, so in theory we
should do it when checking how many entries to move.  That said,
we know we can't _increase_ the amount of space used (so no chance
of introducing a problem) but we might still end up with some imbalance.

> @@ -141,6 +141,7 @@ struct dx_map_entry
>  {
>  	u32 hash;
>  	u32 offs;
> +	u32 size;
>  };

Hmm, there was something about the size of the dx_map_entry, because
it is actually built at the end of the target block, that we don't
want to make it too large.

Now, I'm not sure if adding an extra 32-bit field per entry would make
it too large or not, since I haven't looked at that code in ages.  The
critical factor is whether max_entries = blocksize / min_rec_len would
consume more than the worst-case amount of space in the target block.

So, because thinking is hard, you might consider just changing the above
code to use "u16 offs; u16 size;" since we know those are big enough
variables, and won't increase the size of the map...

> +	for (i = count-1; i >= 0; i--) {
> +		/* is more than half of this entry in last half of the block? */
> +		if (size + map[i].size/2 > blocksize/2)
> +			break;
> +		size += map[i].size;
> +		move++;
> +	}
> +	/* map index at which we will split */
> +	split = count - move;

The rest of this looks fine - I think the "1/2 of median entry" decision
is the right one as we discussed.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
