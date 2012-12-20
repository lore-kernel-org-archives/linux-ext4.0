From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Check dioread_nolock on remount
Date: Thu, 20 Dec 2012 00:07:56 -0500
Message-ID: <20121220050756.GA22145@thunk.org>
References: <1355434842-13478-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39438 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab2LTFIB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Dec 2012 00:08:01 -0500
Content-Disposition: inline
In-Reply-To: <1355434842-13478-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 13, 2012 at 10:40:42PM +0100, Jan Kara wrote:
> Currently we allow enabling dioread_nolock mount option on remount for
> filesystems where blocksize < PAGE_CACHE_SIZE. This isn't really supported so
> fix the bug by moving the check for blocksize != PAGE_CACHE_SIZE into
> parse_options(). Change the original PAGE_SIZE to PAGE_CACHE_SIZE along the way
> because that's what we are really interested in.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
