From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix the deadlock in mpage_da_map_and_submit()
Date: Thu, 20 Oct 2011 19:47:12 -0400
Message-ID: <20111020234712.GJ17210@thunk.org>
References: <4E968F8E.5070802@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44662 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab1JUBMp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Oct 2011 21:12:45 -0400
Content-Disposition: inline
In-Reply-To: <4E968F8E.5070802@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 13, 2011 at 04:13:18PM +0900, Kazuya Mio wrote:
> If ext4_jbd2_file_inode() in mpage_da_map_and_submit() fails due to journal
> abort, this function returns to caller without unlocking the page.
> It leads to the deadlock, and the patch fixes this issue by calling
> mpage_da_submit_io().
> 
> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>

Applied, thanks.

This is an area where we should really clean things up next merge
window, though.  I'm a little uneasy that we will potentially write
back some blocks even though the journal has been aborted (we do this
in other error paths, so this isn't a criticism of this patch, just of
the current state of affairs).

The problem mpage_da_submit_io() is the only way we have to unlock the
pages.  In the future we should probably have a separate path to
unlock the pages in case of an error.  We might also want to merge
mpage_da_submit_io() and mpage_da_map_and_submit(), and to also clean
up a number of comments which are out of date.  (For example,
mpage_da_submit_io() no longer uses ext4_writepage().)

						- Ted
