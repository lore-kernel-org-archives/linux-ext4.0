From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: BUG_ON assertion repeated for inode1, not done for
 inode2
Date: Mon, 8 Jun 2015 11:59:37 -0400
Message-ID: <20150608155937.GH19168@thunk.org>
References: <5564B06E.6000604@gmail.com>
 <5564DB28.1050908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Moore <dmoorefo@gmail.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53151 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbbFHP7k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jun 2015 11:59:40 -0400
Content-Disposition: inline
In-Reply-To: <5564DB28.1050908@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 26, 2015 at 03:44:24PM -0500, Eric Sandeen wrote:
> On 5/26/15 12:42 PM, David Moore wrote:
> > During a source code review of fs/ext4/extents.c I noted identical
> > consecutive lines. An assertion is repeated for inode1 and never done
> > for inode2. This is not in keeping with the rest of the code in the
> > ext4_swap_extents function and appears to be a bug.
> > 
> > Assert that the inode2 mutex is not locked.
> 
> Yep, it's been that way since 
> 
> fcf6b1b ext4: refactor ext4_move_extents code base
> 
> and it's pretty obviously not right as it is, and
> if there's any doubt the comments make it clear:
> 
> + * Locking:
> + *             i_mutex is held for both inodes
> + *             i_data_sem is locked for write for both inodes
> 
> Thanks,
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

						- Ted
