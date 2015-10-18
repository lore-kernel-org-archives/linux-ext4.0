From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix xfstest generic/269 double revoked buffer bug
Date: Sat, 17 Oct 2015 22:30:24 -0400
Message-ID: <20151018023024.GI2678@thunk.org>
References: <1444868598-16188-1-git-send-email-daeho.jeong@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56643 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233AbbJRCa1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Oct 2015 22:30:27 -0400
Content-Disposition: inline
In-Reply-To: <1444868598-16188-1-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 15, 2015 at 09:23:18AM +0900, Daeho Jeong wrote:
> When you repeatly execute xfstest generic/269 with bigalloc_1k option
> enabled using the below command:
> 
> "./kvm-xfstests -c bigalloc_1k -m nodelalloc -C 1000 generic/269"
> 
> you can easily see the below bug message.
> 
> "JBD2 unexpected failure: jbd2_journal_revoke: !buffer_revoked(bh);"
> 
> This means that an already revoked buffer is erroneously revoked again
> and it is caused by doing revoke for the buffer at the wrong position
> in ext4_free_blocks(). We need to re-position the buffer revoke
> procedure for an unspecified buffer after checking the cluster boundary
> for bigalloc option. If not, some part of the cluster can be doubly
> revoked.
> 
> Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>

Thanks, applied.

						- Ted
