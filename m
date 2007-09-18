From: "Stephen C. Tweedie" <sct@redhat.com>
Subject: Re: [PATCH] ext34: ensure do_split leaves enough free space in
	both blocks
Date: Tue, 18 Sep 2007 18:41:11 +0100
Message-ID: <1190137272.27889.19.camel@sisko.scot.redhat.com>
References: <46EEA5F4.3030806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	hooanon05@yahoo.co.jp, Andrew Morton <akpm@osdl.org>,
	Stephen Tweedie <sct@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760211AbXIRRl2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Sep 2007 13:41:28 -0400
In-Reply-To: <46EEA5F4.3030806@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

On Mon, 2007-09-17 at 11:06 -0500, Eric Sandeen wrote:
> The do_split() function for htree dir blocks is intended to split a
> leaf block to make room for a new entry.  It sorts the entries in the
> original block by hash value, then moves the last half of the entries to 
> the new block - without accounting for how much space this actually moves.  

Nasty.

> Also add a few comments to the functions involved.

A big improvement.  :)

> +	/* Split the existing block in the middle, size-wise */
> +	size = 0;
> +	move = 0;
> +	for (i = count-1; i >= 0; i--) {
> +		/* is more than half of this entry in 2nd half of the block? */
> +		if (size + map[i].size/2 > blocksize/2)
> +			break;
> +		size += map[i].size;
> +		move++;
> +	}
> +	/* map index at which we will split */
> +	split = count - move;

This is the guts of it, and I spent a while looking just to convince
myself it was getting things right in the corner case and was splitting
at _exactly_ the right point.  If we have large dirents and 1k
blocksize, even getting the split point off-by-one will still leave us
vulnerable to the bug.

But it all looks fine.  My only other comment would be that "move" is
redundant, you could lose it completely and just do

	split = i+1;

but I think the logic's easier to understand the way it is. 

Nice catch.

--Stephen
