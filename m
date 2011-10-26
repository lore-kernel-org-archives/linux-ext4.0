From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: use ext4_reserve_inode_write in
 ext4_xattr_set_handle
Date: Wed, 26 Oct 2011 03:40:36 -0400
Message-ID: <20111026074036.GN31921@thunk.org>
References: <4EA6F749.3000308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38414 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab1JZHkj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Oct 2011 03:40:39 -0400
Content-Disposition: inline
In-Reply-To: <4EA6F749.3000308@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 25, 2011 at 12:52:09PM -0500, Eric Sandeen wrote:
> ext4_mark_iloc_dirty() says:
> 
>  * The caller must have previously called ext4_reserve_inode_write().
>  * Give this, we know that the caller already has write access to iloc->bh.
> 
> ext4_xattr_set_handle, however, just open-codes it.  May as well use
> the helper function for consistency.
> 
> No bug here, just tidiness.
> 
> (Note: on cleanup path, ext4_reserve_inode_write sets
> the bh to NULL if it returns an error, and brelse() of 
> a null bh is handled gracefully).
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
