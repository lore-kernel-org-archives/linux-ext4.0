From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: avoid setting directory i_nlink to zero
Date: Wed, 26 Oct 2011 03:30:40 -0400
Message-ID: <20111026073040.GM31921@thunk.org>
References: <1319556785-34754-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34313 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214Ab1JZHap (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Oct 2011 03:30:45 -0400
Content-Disposition: inline
In-Reply-To: <1319556785-34754-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 25, 2011 at 09:33:05AM -0600, Andreas Dilger wrote:
> If a directory with more than EXT4_LINK_MAX subdirectories, the nlink
> count is set to 1.  Subsequently, if any subdirectories are deleted,
> ext4_dec_count() decrements the i_nlink count, which may go to 0
> temporarily before being incremented back to 1.
> 
> While this is done under i_mutex, which prevents races for directory
> and inode operations that check i_nlink, the temporary i_nlink == 0
> case is exposed to userspace via stat() and similar calls that do not
> hold i_mutex.
> 
> Instead, change the code to not decrement i_nlink count for any
> directories that do not already have i_nlink larger than 2.
> 
> Reported-by: Cliff White <cliffw@whamcloud.com>
> Reviewed-by: Johann Lombardi <johann@whamcloud.com>
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>


Applied, thanks.

				- Ted
