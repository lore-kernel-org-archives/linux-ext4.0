From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [v2] ext4: delete a no useful sentence
Date: Mon, 9 Jul 2012 10:25:28 -0400
Message-ID: <20120709142528.GA18072@thunk.org>
References: <1340303466-7967-1-git-send-email-HaiboLiu6@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Haibo Liu <HaiboLiu6@gmai.com>
To: Liu Haibo <haiboliu6@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38013 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab2GIOZb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jul 2012 10:25:31 -0400
Content-Disposition: inline
In-Reply-To: <1340303466-7967-1-git-send-email-HaiboLiu6@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 21, 2012 at 08:31:06AM -0000, Liu Haibo wrote:
> From: Haibo Liu <HaiboLiu6@gmai.com>
> 
> In this patch, the sentence "poff = block % blocks_per_page"
> in ext4_mb_get_buddy_page_lock has no effect.
> So we should delete it to save cpu.
> 
> v1->v2: update the patch subject and the patch comment.
> 
> Signed-off-by: Haibo Liu <HaiboLiu6@gmail.com>

Applied, thanks.  BTW, I modified the patch description a little to
note that the compiler would optimize out the statement, but it's
better to remove unused C statements.

       	  	 				- Ted
