From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2freefrag: print 64bit free blocks count
Date: Mon, 4 Dec 2017 22:18:14 -0500
Message-ID: <20171205031814.ovzmjgw5bzgv6qnq@thunk.org>
References: <C26C67884C4B7A48980D574635594864033FC0E1@BPXM20GP.gisp.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33428 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751852AbdLEDSS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 4 Dec 2017 22:18:18 -0500
Content-Disposition: inline
In-Reply-To: <C26C67884C4B7A48980D574635594864033FC0E1@BPXM20GP.gisp.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 05, 2017 at 12:15:38AM +0000, Kazuya Mio wrote:
> e2freefrag prints incorrect free blocks count when the number of free blocks
> is larger than 2^32. 
> To fix this problem, e2freefrag uses ext2fs_free_blocks_count(),
> not fs->super->s_free_blocks_count.
> 
> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>

Thanks, applied.

					- Ted
