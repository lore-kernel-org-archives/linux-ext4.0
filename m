From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 18/25] e2initrd_helper: Fix memory leak on error
Date: Fri, 16 Sep 2011 18:58:23 -0400
Message-ID: <20110916225823.GV16246@thunk.org>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
 <1316206180-6375-19-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49483 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454Ab1IPW6Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 18:58:24 -0400
Content-Disposition: inline
In-Reply-To: <1316206180-6375-19-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 03:49:33PM -0500, Eric Sandeen wrote:
> Some error paths did not properly free "buf"
> 
> And the normal exit seemed to close e2_file twice (?)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
