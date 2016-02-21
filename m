From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: iterate over buffer heads correctly in
 move_extent_per_page()
Date: Sun, 21 Feb 2016 18:39:46 -0500
Message-ID: <20160221233946.GB23122@thunk.org>
References: <1456070249-29945-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33614 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbcBUXjs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Feb 2016 18:39:48 -0500
Content-Disposition: inline
In-Reply-To: <1456070249-29945-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 21, 2016 at 11:57:29PM +0800, Eryu Guan wrote:
> In commit bcff24887d00 ("ext4: don't read blocks from disk after extents
> being swapped") bh is not updated correctly in the for loop and wrong
> data has been written to disk. generic/324 catches this on sub-page
> block size ext4.
> 
> Fixes: bcff24887d00 ("ext4: don't read blocks from disk after extentsbeing swapped")
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>

Thanks, applied.

						- Ted
