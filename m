From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Remove code duplication in
 ext4_get_block_write_nolock()
Date: Fri, 9 Nov 2012 12:29:57 -0500
Message-ID: <20121109172957.GA19041@thunk.org>
References: <1350328009-22740-1-git-send-email-anatol.pomozov@gmail.com>
 <1350328009-22740-2-git-send-email-anatol.pomozov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: wenqing.lz@taobao.com, linux-ext4@vger.kernel.org
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60258 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755382Ab2KIRaC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Nov 2012 12:30:02 -0500
Content-Disposition: inline
In-Reply-To: <1350328009-22740-2-git-send-email-anatol.pomozov@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There's a really serious bug in this patch which I didn't notice at
first:

> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -683,7 +683,7 @@ static int _ext4_get_block(struct inode *inode, sector_t iblock,
>  	map.m_lblk = iblock;
>  	map.m_len = bh->b_size >> inode->i_blkbits;
>  
> -	if (flags && !handle) {
> +	if (flags && !(flags | EXT4_GET_BLOCKS_NO_LOCK) && !handle) {
                            ^^^

This should obviously read:

	if (flags && !(flags & EXT4_GET_BLOCKS_NO_LOCK) && !handle) {

Otherwise xfstests #91 will blow out with a circular lockdep warning.

As a reminder, please do make sure you compile with lockdep enabled
when you run your tests; it's found more than one bug for me!

     	     	  	      	    	      - Ted
