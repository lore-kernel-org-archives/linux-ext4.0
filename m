From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix return value of ext4_do_update_inode
Date: Wed, 1 Oct 2014 22:22:07 -0400
Message-ID: <20141002022207.GC16766@thunk.org>
References: <1411955914-550-1-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca, jack@suse.cz
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60051 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbaJBCWP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Oct 2014 22:22:15 -0400
Content-Disposition: inline
In-Reply-To: <1411955914-550-1-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 29, 2014 at 09:58:34AM +0800, Li Xi wrote:
> When ext4_do_update_inode() gets error from ext4_inode_blocks_set(),
> error number should be returned.
> 
> Signed-off-by: Li Xi <lixi@ddn.com>

Applied, thanks.

					- Ted
