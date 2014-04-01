From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: FIBMAP ioctl causes BUG_ON due to handle
 EXT_MAX_BLOCKS
Date: Tue, 1 Apr 2014 01:15:16 -0400
Message-ID: <20140401051516.GO4911@thunk.org>
References: <C26C67884C4B7A48980D574635594864E16DD8@BPXM20GP.gisp.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48162 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaDAFPf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Apr 2014 01:15:35 -0400
Content-Disposition: inline
In-Reply-To: <C26C67884C4B7A48980D574635594864E16DD8@BPXM20GP.gisp.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 26, 2014 at 05:20:54AM +0000, Kazuya Mio wrote:
> When we try to get 2^32-1 block of the file which has the extent
> (ee_block=2^32-2, ee_len=1) with FIBMAP ioctl, it causes BUG_ON
> in ext4_ext_put_gap_in_cache().

We should be returning an error when we pass in an lblk >=
EXT4_MAX_BLOCKS in ext4_map_blocks(), long before we even get to
ext4_ext_put_gap_in_cache().  And if we fix it there, we may catch
other cases which might lead to the BUG_ON() firing.

Also, how ext4_bmap() is currently being implemented is spectacularly
ugly; I have no idea why we are calling generic_block_bmap() instead
of calling ext4_map_blocks() directly.

Since FIBMAP requires root privs, I'd much rather fix this at our
leisure post merge-window.  If this same bug can be triggered by
FIEMAP, then we really do need to fix this right away, since FIEMAP
can be used by anybody.  (But then we should be fixing it in
ext4_map_blocks, not in ext4_bmap.)

Did you check whether the same bug can be triggered via FIEMAP?

Thanks,

					- Ted
