From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: Transfer initialized block to right neighbor if
 possible
Date: Mon, 1 Apr 2013 11:12:16 -0400
Message-ID: <20130401151216.GC4731@thunk.org>
References: <1363698788-15665-1-git-send-email-lczerner@redhat.com>
 <1363791235-18707-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, darrick.wong@oracle.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57808 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758247Ab3DAPMU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Apr 2013 11:12:20 -0400
Content-Disposition: inline
In-Reply-To: <1363791235-18707-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 20, 2013 at 03:53:55PM +0100, Lukas Czerner wrote:
> Currently when converting extent to initialized we attempt to transfer
> initialized block to the left neighbour if possible when certain criteria
> are met. However we do not attempt to do the same for the right
> neighbor.
> 
> This commit adds the possibility to transfer initialized block to the
> right neighbour if:
> 
> 1. We're not converting the whole extent
> 2. Both extents are stored in the same extent tree node
> 3. Right neighbor is initialized
> 4. Right neighbor is logically abutting the current one
> 5. Right neighbor is physically abutting the current one
> 6. Right neighbor would not overflow the length limit
> 
> This is basically the same logic as with transferring to the left. This
> will gain us some performance benefits since it is faster than inserting
> extent and then merging it.
> 
> It would also prevent some situation in delalloc patch when we might run
> out of metadata reservation. This is due to the fact that we would
> attempt to split the extent first (possibly allocating new metadata
> block) even though we did not counted for that because it can (and will)
> be merged again. This commit fix that scenario, because we no longer
> need to split the extent in such case.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied to the dev branch for testing

					- Ted
