From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 08/12] ext4: Remove __ext4_journalled_writepage() from
 mpage_da_submit_io()
Date: Mon, 28 Jan 2013 09:40:08 -0500
Message-ID: <20130128144008.GE22711@thunk.org>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-9-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45862 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756969Ab3A1OkK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2013 09:40:10 -0500
Content-Disposition: inline
In-Reply-To: <1358510446-19174-9-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 18, 2013 at 01:00:42PM +0100, Jan Kara wrote:
> We don't support delayed allocation in data=journal mode. So checking for it in
> mpage_da_submit_io() doesn't make really sence. If we ever decide to extend
> delayed allocation support to data=journal mode, adding
> __ext4_journalled_writepage() call will be the least of problems we have to
> solve. Most likely we'd have to implement separate writepages call anyways
> because we don't have transaction credits for writing more than a single page
> so mapping of page buffers would have to be done differently.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
