From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext3: Avoid creating new file in append-only dir when
 open(2) return error
Date: Tue, 1 Nov 2011 19:27:25 -0400
Message-ID: <20111101232725.GO32161@thunk.org>
References: <1319824987-5621-1-git-send-email-guaneryu@gmail.com>
 <20111101231034.GI18701@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eryu Guan <guaneryu@gmail.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47840 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400Ab1KAX12 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Nov 2011 19:27:28 -0400
Content-Disposition: inline
In-Reply-To: <20111101231034.GI18701@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 02, 2011 at 12:10:34AM +0100, Jan Kara wrote:
> > 
> > To avoid this, check EXT3_APPEND_FL flag first in ext3_create before
> > really allocating new inode.
>   Yes, it is nicer to not create any file when open(2) fails in the end.
> BTW, how have you spotted this? I've taken your ext2 and ext3 patches into
> my tree.

Note: I have a fix in my tree which removes EXTx_APPEND_FL from the
set of flags that can be inherited from the containing directory in
ext2, ext3, and ext4.  That addresses this issue without needing to
make the change in this patch.

				- Ted
