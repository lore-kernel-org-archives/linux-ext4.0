From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH next/mmotm] ext4: fix cache_es after merge_left
Date: Thu, 27 Sep 2012 16:39:20 -0400
Message-ID: <20120927203920.GB9585@thunk.org>
References: <alpine.LSU.2.00.1209271324060.2184@eggly.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <wenqing.lz@taobao.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Hugh Dickins <hughd@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52761 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815Ab2I0Uj1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Sep 2012 16:39:27 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1209271324060.2184@eggly.anvils>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 27, 2012 at 01:31:28PM -0700, Hugh Dickins wrote:
> Kernel build with CONFIG_DEBUG_SLAB or CONFIG_SLUB_DEBUG slub_debug=FPZ
> gives me kernel BUG at fs/ext4/extents_status.c:142!  That's the
> BUG_ON(es->start + es->len < es->start) in extent_status_end() called
> from ext4_es_insert_extent().  tree->cache_es has been freed and poisoned.
> 
> This comes from when ext4_es_try_to_merge_left() merges es into leftward
> es1, but ext4_es_insert_extent()'s out then updates cache_es to the freed
> extent_status.  ext4_es_try_to_merge_right() does not pose a problem.
> 
> Change ext4_es_try_to_merge_left() to return whichever extent_status
> should be recorded in tree->cache_es.  Remove cache_es update from
> both of them, leaving that to ext4_es_insert_extent()'s out label.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Hugh, thanks for finding this bug!

Zheng, you were going to send me an updated patch series; can you take
care of merging this patch into your patch series (and crediting Hugh
with a Signed-off-by as appropriate)?

Thanks!!

					- Ted
