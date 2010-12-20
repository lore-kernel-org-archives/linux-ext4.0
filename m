From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: zero out nanosecond timestamps for small inodes
Date: Sun, 19 Dec 2010 22:11:30 -0500
Message-ID: <20101220031130.GE23626@thunk.org>
References: <4CE76938.8050304@quo.to>
 <4CEAAC4C.3070406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jordan Russell <jr-list-2010@quo.to>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:53921 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab0LTDLg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Dec 2010 22:11:36 -0500
Content-Disposition: inline
In-Reply-To: <4CEAAC4C.3070406@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 22, 2010 at 11:45:48AM -0600, Eric Sandeen wrote:
> As reported by Jordan Russell:
> 
> When nanosecond timestamp resolution isn't supported on an ext4
> partition (inode size = 128), stat() appears to be returning
> uninitialized garbage in the nanosecond component of timestamps.
> 
> EXT4_INODE_GET_XTIME should zero out tv_nsec when EXT4_FITS_IN_INODE
> evaluates to false.
> 
> Reported-by: Jordan Russell <jr-list-2010@quo.to>
> Signed-of-by: Eric Sandeen <sandeen@redhat.com>

Thanks, added to the ext4 patch queue.

						- Ted
