From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: use kmem_cache_zalloc for allocating journal head
Date: Tue, 28 May 2013 07:28:11 -0400
Message-ID: <20130528112811.GB11839@thunk.org>
References: <1367226507-2990-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52507 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932685Ab3E1L2Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 May 2013 07:28:16 -0400
Content-Disposition: inline
In-Reply-To: <1367226507-2990-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 29, 2013 at 05:08:27PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> This commit tries to use kmem_cache_zalloc instead of kmem_cache_alloc/
> memset when a new journal head is alloctated.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>

Thanks, added to the ext4 patch queue.

						- Ted
