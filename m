From: tytso@mit.edu
Subject: Re: [PATCH] ext4: remove unnecessary operation in
 ext4_mb_regular_allocator()
Date: Mon, 22 Mar 2010 14:26:45 -0400
Message-ID: <20100322182645.GI11560@thunk.org>
References: <ac8f92701003220735h76b4a51dib1a9b311f9cf6d99@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48368 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab0CVS07 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Mar 2010 14:26:59 -0400
Content-Disposition: inline
In-Reply-To: <ac8f92701003220735h76b4a51dib1a9b311f9cf6d99@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 22, 2010 at 10:35:54PM +0800, jing zhang wrote:
> From: Jing Zhang <zj.barak@gmail.com>
> 
> Date: Mon Mar 22 22:20:38     2010
> 
> 1, In one of the hot functions in mballoc.c, unnecessary operation on
>        struct ext4_group_desc *desc;
>     is removed.
> 
> 2, Unlike spin_lock() and spin_unlock(), ext4_mb_load_buddy() is
> companied by ext4_mb_release_desc. And it is hard, at least for me, to
> get sure that ext4_mb_release_desc has little to do with struct
> ext4_group_desc, and for those readers as well, whose native language
> is not English. It seems the choice includes
>      ext4_mb_release_buddy
>      ext4_mb_put_buddy
>      ext4_mb_unload_buddy
> and I like the last one.

Please separate things like this into two separate patches; it makes
them much easier to review.

Thanks,

					- Ted
