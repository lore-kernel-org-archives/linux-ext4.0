From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: do not clear resize inode for 0 resvd blocks
Date: Wed, 22 Dec 2010 13:55:01 -0500
Message-ID: <20101222185501.GA30115@thunk.org>
References: <4D111CD5.2040800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49296 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab0LVSzE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Dec 2010 13:55:04 -0500
Content-Disposition: inline
In-Reply-To: <4D111CD5.2040800@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 21, 2010 at 03:32:05PM -0600, Eric Sandeen wrote:
> I ran into odd behavior where mkfs.ext4 of a 16T filesystem would
> create a resize inode with 0 reserved blocks, and mark the resize_inode
> feature.
> 
> A subsequent slight downward resize of the filesystem would remove
> the resize inode, making any further offline resizing impossible.
> 
> This is especially odd in light of the fact that a large downward
> resize (say, to 8T) will actually add blocks to the resize inode -
> so a small resize removes it, a large resize expands it ...
> 
> commit 8ade268cf2fde8629b51bfd1c044a83db88234cd had added this:
> 
>   If the filesystem is grown to the point where the resize_inode is no
>   longer needed, clean it up properly so e2fsck doesn't have to.
> 
> but, it seems e2fsck does not care about this situation, either.
> 
> So, simply leave the resize_inode intact in this case, and everything
> seems to be happy.
> 
> Note, this is for the 1.41.xx branch.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

						- Ted


