From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/12] ext4: Fix ext4_writepage() to achieve data=ordered
 guarantees
Date: Mon, 28 Jan 2013 21:08:10 -0500
Message-ID: <20130129020810.GC7003@thunk.org>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-13-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45951 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab3A2CIQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2013 21:08:16 -0500
Content-Disposition: inline
In-Reply-To: <1358510446-19174-13-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 18, 2013 at 01:00:46PM +0100, Jan Kara wrote:
> So far ext4_writepage() skipped writing pages that had any delayed or
> unwritten buffers attached. When blocksize < pagesize this breaks
> data=ordered mode guarantees as we can have a page with one freshly
> allocated buffer whose allocation is part of the committing transaction
> and another buffer in the page which is delayed or unwritten. So fix this
> problem by calling ext4_bio_writepage() anyway. It will submit mapped
> buffers and leave others alone.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
