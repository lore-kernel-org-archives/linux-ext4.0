From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: use kmem_cache_zalloc instead of
 kmem_cache_alloc/memset
Date: Fri, 19 Apr 2013 17:50:43 -0400
Message-ID: <20130419215043.GA4879@thunk.org>
References: <1365769463-22071-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42981 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933294Ab3DSVvF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Apr 2013 17:51:05 -0400
Content-Disposition: inline
In-Reply-To: <1365769463-22071-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 12, 2013 at 08:24:23PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Now jbd2_alloc_handle is only called by new_handle.  So this commit
> uses kmem_cache_zalloc instead of kmem_cache_alloc/memset.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks, applied.

					- Ted
