From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] ext4: basic bug shield for move_extent_per_page
Date: Wed, 26 Sep 2012 12:50:07 -0400
Message-ID: <20120926165007.GC18983@thunk.org>
References: <1348489434-22778-1-git-send-email-dmonakhov@openvz.org>
 <1348489434-22778-4-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, a-fujita@rs.jp.nec.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52521 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757333Ab2IZQuN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2012 12:50:13 -0400
Content-Disposition: inline
In-Reply-To: <1348489434-22778-4-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Applied, thanks.

I added one sanity check:

> +	for(bh = head, block_start = 0; bh != head || !block_start;
> +	    block++, block_start = block_end, bh = bh->b_this_page) {
  	    ...
		BUG_ON(nr >= MAX_BUF_PER_PAGE);
> +		arr[nr++] = bh;
> +	}

...just to make sure a corrupted link list on b_this_page can't cause
a on-stack array overrun.

						- Ted
