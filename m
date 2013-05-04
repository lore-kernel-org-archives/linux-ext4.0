From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: fix return value
Date: Sat, 4 May 2013 19:55:03 -0400
Message-ID: <20130504235503.GC5948@thunk.org>
References: <1367643954-31340-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46349 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705Ab3EDXzK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 May 2013 19:55:10 -0400
Content-Disposition: inline
In-Reply-To: <1367643954-31340-1-git-send-email-vapier@gentoo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 04, 2013 at 01:05:54AM -0400, Mike Frysinger wrote:
> The ext2fs_test_block_bitmap_range2 func is not a void, so make sure we
> return a value.  I picked EINVAL as it looks like what other things in
> this func use.
> 
> URL: http://bugs.gentoo.org/467986
> Reported-by: Vicente Olivert Riera <vincent@gentoo.org>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

This is already fixed in e2fsprogs's git repository, in commit
0d89e5acea9.

Cheers,

					- Ted
