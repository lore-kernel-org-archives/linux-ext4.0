From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix xattr block allocation/release with bigalloc
Date: Mon, 18 Feb 2013 12:25:45 -0500
Message-ID: <20130218172545.GA10843@thunk.org>
References: <1361175262-16205-1-git-send-email-lczerner@redhat.com>
 <5122480F.9030100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48809 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246Ab3BRRZt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Feb 2013 12:25:49 -0500
Content-Disposition: inline
In-Reply-To: <5122480F.9030100@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 18, 2013 at 09:26:07AM -0600, Eric Sandeen wrote:
> On 2/18/13 2:14 AM, Lukas Czerner wrote:
> > Currently when new xattr block is created or released we we would call
> > dquot_free_block() or dquot_alloc_block() respectively, among the else
> > decrementing or incrementing the number of blocks assigned to the inode
> > by one block.
> > 
> > This however does not work for bigalloc file system because we always
> > allocate/free the whole cluster so we have to count with that in
> > dquot_free_block() and dquot_alloc_block() as well.
> > 
> > Use the clusters-to-blocks conversion EXT4_C2B() when passing number of
> > blocks to the dquot_alloc/free functions to fix the problem.
> > 
> > The problem has been revealed by xfstests #117 (and possibly others).
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks, indeed.  Applied.

						- Ted
