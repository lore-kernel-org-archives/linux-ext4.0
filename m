From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 09/12] ext4: Dirty page has always buffers attached
Date: Mon, 28 Jan 2013 12:55:37 -0500
Message-ID: <20130128175537.GI22711@thunk.org>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-10-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45891 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757670Ab3A1Rzj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2013 12:55:39 -0500
Content-Disposition: inline
In-Reply-To: <1358510446-19174-10-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 18, 2013 at 01:00:43PM +0100, Jan Kara wrote:
> ext4_writepage(), write_cache_pages_da(), and mpage_da_submit_io() doesn't
> have to deal with the case when page doesn't have buffers. We attach buffers
> to a page in ->write_begin() and ->page_mkwrite() which covers all places
> where a page can become dirty.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
