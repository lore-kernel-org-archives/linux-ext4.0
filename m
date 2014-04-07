From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V2] ext4: FIBMAP ioctl causes BUG_ON due to handle
 EXT_MAX_BLOCKS
Date: Mon, 7 Apr 2014 10:36:32 -0400
Message-ID: <20140407143632.GA25478@thunk.org>
References: <C26C67884C4B7A48980D574635594864E1B62A@BPXM20GP.gisp.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51099 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbaDGOgj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Apr 2014 10:36:39 -0400
Content-Disposition: inline
In-Reply-To: <C26C67884C4B7A48980D574635594864E1B62A@BPXM20GP.gisp.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 04, 2014 at 08:02:58AM +0000, Kazuya Mio wrote:
> When we try to get 2^32-1 block of the file which has the extent
> (ee_block=2^32-2, ee_len=1) with FIBMAP ioctl, it causes BUG_ON
> in ext4_ext_put_gap_in_cache().
> 
> To avoid the problem, ext4_map_blocks() needs to check the file logical block
> number. ext4_ext_put_gap_in_cache() called via ext4_map_blocks() cannot
> handle 2^32-1 because the maximum file logical block number is 2^32-2.
> 
> Note that ext4_ind_map_blocks() returns -EIO when the block number is invalid.
> So ext4_map_blocks() should also return the same errno.
> 
> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>

Thanks, applied.

					- Ted
