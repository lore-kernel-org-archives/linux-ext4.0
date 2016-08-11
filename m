From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 11/11] ext4: Factor out loop for freeing inode xattr space
Date: Thu, 11 Aug 2016 13:34:19 -0400
Message-ID: <20160811173419.GK10626@thunk.org>
References: <1470220795-17045-1-git-send-email-jack@suse.cz>
 <1470220795-17045-12-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45674 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbcHKReV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Aug 2016 13:34:21 -0400
Content-Disposition: inline
In-Reply-To: <1470220795-17045-12-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 03, 2016 at 12:39:55PM +0200, Jan Kara wrote:
> Move loop to make enough space in the inode from
> ext4_expand_extra_isize_ea() into a separate function to make that
> function smaller and better readable and also to avoid delaration of
> variables inside a loop block.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
