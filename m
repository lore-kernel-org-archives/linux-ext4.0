From: tytso@mit.edu
Subject: Re: [PATCH] ext4: initialize multi-block allocator before checking
 block descriptors
Date: Sat, 15 Mar 2014 17:40:29 -0400
Message-ID: <20140315214029.GA18873@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41927 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756190AbaCOVke (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Mar 2014 17:40:34 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>With EXT4FS_DEBUG ext4_count_free_clusters() will call
>ext4_read_block_bitmap() without s_group_info initialized, so we need to
>initialize multi-block allocator before.
>
>And we can't initialize multi-block allocator without group descriptors,
>since it use them.
>Also we need to install s_op before initializing multi-block allocator,
>because in ext4_mb_init_backend() new inode is created.

I've had to drop this patch because it's causing a series of bigalloc
failures.  I'll take a closer look at this later, but I wantd to give
you a heads up.

   	      	    			- Ted



