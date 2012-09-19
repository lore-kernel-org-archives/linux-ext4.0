From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: convert file system to meta_bg if needed during resizing
Date: Tue, 18 Sep 2012 23:51:32 -0400
Message-ID: <20120919035132.GB18707@thunk.org>
References: <20120918114634.GA12383@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Fengguang Wu <fengguang.wu@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51429 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab2ISDvg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Sep 2012 23:51:36 -0400
Content-Disposition: inline
In-Reply-To: <20120918114634.GA12383@elgon.mountain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 18, 2012 at 02:46:35PM +0300, Dan Carpenter wrote:
>   1775          struct ext4_inode_info *ei = 0;
>                                         ^^^^^^
> Sparse is going to complain.  Not sure why Fengguang hasn't emailed you.

>   1791                  ei = EXT4_I(inode);
>                         ^^^^^^^^^^^^^^^^^^
> We only set "ei" if EXT4_FEATURE_COMPAT_RESIZE_INODE.
> ...

>   1829                  nr = le32_to_cpu(ei->i_data[EXT4_DIND_BLOCK]);
>                                          ^^^^^^^^^^
> Null deref.  Perhaps inode implies EXT4_FEATURE_COMPAT_RESIZE_INODE?

Inode does imply EXT4_FEATURE_COMPAT_RESIZE_INODE, but I should make
the code cleaner.

Thanks for pointing this out.

							- Ted
