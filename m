From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 crypto: enforce context consistency
Date: Thu, 16 Apr 2015 02:15:45 -0400
Message-ID: <20150416061545.GA7445@thunk.org>
References: <20150415191007.GA32654@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41839 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbbDPGPs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Apr 2015 02:15:48 -0400
Content-Disposition: inline
In-Reply-To: <20150415191007.GA32654@mwanda>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 15, 2015 at 10:10:07PM +0300, Dan Carpenter wrote:
> Hello Theodore Ts'o,
> 
> The patch faac02be2843: "ext4 crypto: enforce context consistency"
> from Apr 12, 2015, leads to the following static checker warning:
> 
> 	fs/ext4/namei.c:1646 ext4_lookup()
> 	error: 'inode' dereferencing possible ERR_PTR()
> 
> fs/ext4/namei.c
>   1638                  inode = ext4_iget_normal(dir->i_sb, ino);
>   1639                  if (inode == ERR_PTR(-ESTALE)) {
> 
> We normally check ext4_iget() against -ESTALE, but then we changed this
> to ext4_iget_normal() which returns several error values.

Thanks for pointing that out.  That's not quite what had happened.  We
were using ext4_iget_normal() before (and both ext4_iget() and
ext4_iget_normal() can return multiple error values), but before we
fell out to the bottof of the function where we called
d_splice_alias() which would take care of ERR_PTR versions of inode.

We added some additional code between the ext4_iget_normal() and the
d_splice_alias() lines, which is what introduced the problem.

I'll take care of fixing it.

Cheers,

						- Ted
