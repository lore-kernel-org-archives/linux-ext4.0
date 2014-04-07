From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v4] ext4: initialize multi-block allocator before
 checking block descriptors
Date: Mon, 7 Apr 2014 10:37:15 -0400
Message-ID: <20140407143715.GB25478@thunk.org>
References: <1396712916-6296-1-git-send-email-a3at.mail@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	open list <linux-kernel@vger.kernel.org>
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51104 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbaDGOhS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Apr 2014 10:37:18 -0400
Content-Disposition: inline
In-Reply-To: <1396712916-6296-1-git-send-email-a3at.mail@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 05, 2014 at 07:48:36PM +0400, Azat Khuzhin wrote:
> With EXT4FS_DEBUG ext4_count_free_clusters() will call
> ext4_read_block_bitmap() without s_group_info initialized, so we need to
> initialize multi-block allocator before.
> 
> And dependencies that must be solved, to allow this:
> - multi-block allocator needs in group descriptors
> - need to install s_op before initializing multi-block allocator,
>   because in ext4_mb_init_backend() new inode is created.
> - initialize number of group desc blocks (s_gdb_count) otherwise
>   number of clusters returned by ext4_free_clusters_after_init() is not correct.
>   (see ext4_bg_num_gdb_nometa())

Thanks, applied.

					- Ted
