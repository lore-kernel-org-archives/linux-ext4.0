From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix incorrect n_blocks_count result when resizing
 file system to size larger than 2^32 blocks
Date: Sun, 6 Aug 2017 01:18:56 -0400
Message-ID: <20170806051856.k4ftzkslzciujxnv@thunk.org>
References: <CAA1ppbjN3LdNdixNWb_OdA36UtZy1VDZHKySLpyt_O2rj-a35w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jerry Lee <jerrylee@qnap.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41506 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751179AbdHFFS6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 6 Aug 2017 01:18:58 -0400
Content-Disposition: inline
In-Reply-To: <CAA1ppbjN3LdNdixNWb_OdA36UtZy1VDZHKySLpyt_O2rj-a35w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 28, 2017 at 02:23:55PM +0800, Jerry Lee wrote:
> On 32-bit platform, the value of n_blcoks_count may be wrong during the
> file system is resized to size larger than 2^32 blocks.  This may caused
> the superblock being corrupted with zero blocks count.
> 
> Signed-off-by: Jerry Lee <jerrylee@qnap.com>

Thanks, applied.

				- Ted
