From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix error handling on inode bitmap corruption
Date: Sun, 18 Dec 2011 16:28:24 -0500
Message-ID: <20111218212824.GB7226@thunk.org>
References: <1323376115-23881-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34177 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab1LRV22 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Dec 2011 16:28:28 -0500
Content-Disposition: inline
In-Reply-To: <1323376115-23881-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 08, 2011 at 09:28:34PM +0100, Jan Kara wrote:
> When insert_inode_locked() fails in ext4_new_inode() it most likely means inode
> bitmap got corrupted and we allocated again inode which is already in use. Also
> doing unlock_new_inode() during error recovery is wrong since the inode does
> not have I_NEW set. Fix the problem by jumping to fail: (instead of fail_drop:)
> which declares filesystem error and does not call unlock_new_inode().
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
