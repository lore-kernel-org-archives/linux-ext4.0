From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: take i_mutex in ext4_symlink to eliminate a
 warning from ext4_truncate
Date: Wed, 27 Mar 2013 09:41:10 -0400
Message-ID: <20130327134110.GI5861@thunk.org>
References: <1364390347-4360-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56324 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab3C0NlO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Mar 2013 09:41:14 -0400
Content-Disposition: inline
In-Reply-To: <1364390347-4360-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 27, 2013 at 09:19:07PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> After applied this commit (8e4061cb), we will get a warning from
> ext4_truncate when i_mutex isn't taken.  Here the assumption is that
> i_mutex should be taken when we do a truncation.  In ext4_symlink we
> could need to call ext4_truncate to trim some blocks beyond i_size, but
> the i_mutex isn't taken.

Hmm, and this is why I added the warning.  Even after looking your
patch, I'm having trouble finding the codepath that results in
ext4_truncate() getting called from __page_symlink().  Can you send
the stack trace from the WARN_ON, just so I can see what I missed?

Thanks,

						- Ted
