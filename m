From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 16/25] e2fsck: remove extraneous memset
Date: Fri, 16 Sep 2011 18:56:55 -0400
Message-ID: <20110916225655.GS16246@thunk.org>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
 <1316206180-6375-17-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56182 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600Ab1IPW45 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 18:56:57 -0400
Content-Disposition: inline
In-Reply-To: <1316206180-6375-17-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 03:49:31PM -0500, Eric Sandeen wrote:
> e2fsck_allocate_memory() already sets allocated memory to 0,
> so remove the explicit memset.
> 
> Especially since it was setting the wrong size (iter not *iter)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
