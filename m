From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 13/25] e2fsprogs: Fix some error cleanup path bugs
Date: Fri, 16 Sep 2011 18:55:55 -0400
Message-ID: <20110916225555.GP16246@thunk.org>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
 <1316206180-6375-14-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56173 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755636Ab1IPWz4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 18:55:56 -0400
Content-Disposition: inline
In-Reply-To: <1316206180-6375-14-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 03:49:28PM -0500, Eric Sandeen wrote:
> In inode_open(), if the allocation of &io fails, we go to cleanup
> and dereference io to test io->name, which is a bug.
> 
> Similarly in undo_open()  if allocation of &data fails, we
> go to cleanup and dereference data to test data->real.
> 
> In the test_open() case we explicitly set retval to the only
> possible error return from ext2fs_get_mem(), so remove that
> for tidiness.
> 
> The other changes just make make earlier returns go through
> the error goto for consistency.
> 
> In many cases we returned directly from the first error, but
> "goto cleanup" etc for every subsequent error.  In some
> cases this leads to "impossible" tests such as:
> 
> 	if (ptr)
> 		ext2fs_free_mem(&ptr)
> 
> on paths where ptr cannot be null because we would have
> returned directly earlier, and Coverity flags this.
> 
> This isn't really indicative of an error in most cases, but
> I think it can be clearer to always exit through the error goto
> if it's used later in the function.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
