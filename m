From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 19/25] libext2: Fix leaks in write_bitmaps on error
 returns
Date: Fri, 16 Sep 2011 18:58:36 -0400
Message-ID: <20110916225836.GW16246@thunk.org>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
 <1316206180-6375-20-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49486 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454Ab1IPW6h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 18:58:37 -0400
Content-Disposition: inline
In-Reply-To: <1316206180-6375-20-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 03:49:34PM -0500, Eric Sandeen wrote:
> block_buf and/or inode_buf may not be properly freed on an error
> return.
> 
> Create a new errout: target to free them as needed in error conditions.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
