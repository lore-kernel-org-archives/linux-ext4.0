From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: be more strict when migrating to non-extent
 based file
Date: Sat, 4 Jul 2015 00:04:50 -0400
Message-ID: <20150704040450.GR9456@thunk.org>
References: <1435942311-2337-1-git-send-email-guaneryu@gmail.com>
 <1435942311-2337-2-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39527 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbbGDEEu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Jul 2015 00:04:50 -0400
Content-Disposition: inline
In-Reply-To: <1435942311-2337-2-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 04, 2015 at 12:51:50AM +0800, Eryu Guan wrote:
> Currently the check in ext4_ind_migrate() is not enough before doing the
> real conversion:
> 
> a) delayed allocated extents could bypass the check on eh->eh_entries
>    and eh->eh_depth
> 
> This can be demonstrated by this script
> 
>   xfs_io -fc "pwrite 0 4k" -c "pwrite 8k 4k" /mnt/ext4/testfile
>   chattr -e /mnt/ext4/testfile
> 
> where testfile has two extents but still be converted to non-extent
> based file format.
> 
> b) only extent length is checked but not the offset, which would result
>    in data lose (delalloc) or fs corruption (nodelalloc), because
>    non-extent based file only supports at most (12 + 2^10 + 2^20 + 2^30)
>    blocks
>
> ...

Thanks for the really great commit description!  I've applied this to
the ext4 git tree.

					- Ted
