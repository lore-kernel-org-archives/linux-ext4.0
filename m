From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 11/25] libe2p: reach unreachable code
Date: Fri, 16 Sep 2011 18:54:40 -0400
Message-ID: <20110916225440.GN16246@thunk.org>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
 <1316206180-6375-12-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56167 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621Ab1IPWyl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 18:54:41 -0400
Content-Disposition: inline
In-Reply-To: <1316206180-6375-12-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 03:49:26PM -0500, Eric Sandeen wrote:
> The EOPNOTSUPP case is unreachable, being outside a set of:
>  #if
> 	...
> 	return;
>  #else
> 	...
> 	return;
>  #endif
> 
> Fix this up so that if neither HAVE_CHFLAGS nor
> HAVE_EXT2_IOCTLS applies, we set EOPNOTSUPP.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
