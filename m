From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 3/6] ext4: cache extent hole in extent status tree for
 ext4_da_map_blocks()
Date: Mon, 1 Sep 2014 22:43:50 -0400
Message-ID: <20140902024350.GS8974@thunk.org>
References: <1407382553-24256-1-git-send-email-wenqing.lz@taobao.com>
 <1407382553-24256-4-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60029 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbaIBCn6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Sep 2014 22:43:58 -0400
Content-Disposition: inline
In-Reply-To: <1407382553-24256-4-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 07, 2014 at 11:35:50AM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Currently extent status tree doesn't cache extent hole when a write
> looks up in extent tree to make sure whether a block has been allocated
> or not.  In this case, we don't put extent hole in extent cache because
> later this extent might be removed and a new delayed extent might be
> added back.  But it will cause a defect when we do a lot of writes.
> If we don't put extent hole in extent cache, the following writes also
> need to access extent tree to look at whether or not a block has been
> allocated.  It brings a cache miss.  This commit fixes this defect.
> Meanwhile, if an inode has no any extent, this extent hole also will
> be cached.

Hi Zheng,

I thought the reason why we have the EXT4_GET_BLOCKS_NO_PUT_HOLE flag
is because in ext4_da_map_blocks(), if there is a hole, we will be
immediately following it up with a call to ext4_es_insert_extent() to
fill in the hole with the EXTENT_STATUS_DELAYED flag.  The only time
we don't is if we run into an ENOSPC error.

Am I missing something?

						- Ted
