From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: Fix fsync error handling after filesystem
 abort.
Date: Wed, 12 Jun 2013 22:39:11 -0400
Message-ID: <20130613023911.GB16959@thunk.org>
References: <1370882461-12786-1-git-send-email-dmonakhov@openvz.org>
 <1370882461-12786-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57461 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758256Ab3FMCjR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Jun 2013 22:39:17 -0400
Content-Disposition: inline
In-Reply-To: <1370882461-12786-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 10, 2013 at 08:41:01PM +0400, Dmitry Monakhov wrote:
> If filesystem was aborted after inode's write back is complete
> but before its metadata was updated we may return success
> results in data loss.
> In order to handle fs abort correctly we have to check
> fs state once we discover that it is in MS_RDONLY state
> 
> Test case: http://patchwork.ozlabs.org/patch/244297
> 
> Changes from V2:
>  - more spelling fixes
> 
> Changes from V1:
>  - fix spelling
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Thanks, applied with Darrick's further suggested spelling fixes.

		     	       	       		 - Ted
