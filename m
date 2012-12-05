From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [ext4:dev 40/60] fs/ext4/inode.c:1953
 __ext4_journalled_writepage() error: potential NULL dereference 'page_bufs'.
Date: Wed, 5 Dec 2012 11:25:10 -0500
Message-ID: <20121205162510.GF18885@thunk.org>
References: <20121204111011.GD22569@mwanda>
 <1354627545-2792-1-git-send-email-tm@tao.ma>
 <20121204135602.GE22569@mwanda>
 <20121205054125.GC18885@thunk.org>
 <20121205083141.GJ22569@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36951 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568Ab2LEQZP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Dec 2012 11:25:15 -0500
Content-Disposition: inline
In-Reply-To: <20121205083141.GJ22569@mwanda>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 05, 2012 at 11:31:41AM +0300, Dan Carpenter wrote:
> 
> Yeah, moving the check for (inode_bh == NULL) forward is nice.
> Thanks.

Not that I really care about optimizing the error path that much, but
getting a starting a handle only to immediately stop it again if
inode_bh == NULL was just silly.  :-)

							- Ted
