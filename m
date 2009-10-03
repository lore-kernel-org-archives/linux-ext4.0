From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: retry failed direct IO allocations
Date: Fri, 2 Oct 2009 22:04:36 -0400
Message-ID: <20091003020436.GC11365@mit.edu>
References: <4AC6810F.9020600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51588 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359AbZJCCEe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Oct 2009 22:04:34 -0400
Content-Disposition: inline
In-Reply-To: <4AC6810F.9020600@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 02, 2009 at 05:39:11PM -0500, Eric Sandeen wrote:
> On a 256M filesystem, doing this in a loop:
>
>        xfs_io -F -f -d -c 'pwrite 0 64m' test
>        rm -f test
>
> eventually leads to ENOSPC.  (the xfs_io command does a
> 64m direct IO write to the file "test")
>
> As with other block allocation callers, it looks like we need to
> potentially retry the allocations on the initial ENOSPC.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, added to the ext4 patch queue.

						- Ted
