From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Split off ext4_journalled_invalidatepage()
Date: Fri, 21 Dec 2012 14:48:10 -0500
Message-ID: <20121221194810.GE31731@thunk.org>
References: <1355345416-13565-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39801 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab2LUTsT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Dec 2012 14:48:19 -0500
Content-Disposition: inline
In-Reply-To: <1355345416-13565-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 12, 2012 at 09:50:15PM +0100, Jan Kara wrote:
> In data=journal mode we don't need delalloc or DIO handling in invalidatepage
> and similarly in other modes we don't need the journal handling. So split
> invalidatepage implementations.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
