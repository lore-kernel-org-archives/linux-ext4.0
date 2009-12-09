From: tytso@mit.edu
Subject: Re: [PATCH] Ext4: wait for log to commit when putting super V2.
Date: Tue, 8 Dec 2009 22:10:54 -0500
Message-ID: <20091209031054.GY27692@thunk.org>
References: <20091207210044.GD8558@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40323 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755834AbZLIDKu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Dec 2009 22:10:50 -0500
Content-Disposition: inline
In-Reply-To: <20091207210044.GD8558@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 07, 2009 at 04:00:44PM -0500, Josef Bacik wrote:
> Update:
> -Instead of adding new logic to wait for the journal to commit, just move the
> cleanup code below the journal destruction which does the same thing.  Thanks to
> Eric Sandeen for the suggestion.
> 
> There is a problem where a transaction will be committing while we're unmounting
> the filesystem and you will get a panic because EXT4_SB(sb)->s_group_info has
> been kfree'ed in ext4_put_super.  The commit code does the callback for the
> mballoc stuff to release free'ed blocks in the transaction and panic's trying to
> access s_group_info.  The fix is to wait for the transaction to finish
> committing before we start cleaning up the mballoc stuff.  This patch hasn't
> been tested yet, but its an obvious fix.

Added to the ext4 patch queue, thanks.

						- Ted
