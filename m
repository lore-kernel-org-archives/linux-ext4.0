From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate
Date: Mon, 15 Jun 2015 00:29:20 -0400
Message-ID: <20150615042920.GI15793@thunk.org>
References: <02e401d09475$f5cd47a0$e167d6e0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35218 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbbFOE3X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Jun 2015 00:29:23 -0400
Content-Disposition: inline
In-Reply-To: <02e401d09475$f5cd47a0$e167d6e0$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 22, 2015 at 06:59:14PM +0900, Namjae Jeon wrote:
> This patch implements fallocate's FALLOC_FL_INSERT_RANGE for Ext4.
> 
> 1) Make sure that both offset and len are block size aligned.
> 2) Update the i_size of inode by len bytes.
> 3) Compute the file's logical block number against offset. If the computed
>    block number is not the starting block of the extent, split the extent
>    such that the block number is the starting block of the extent.
> 4) Shift all the extents which are lying between [offset, last allocated extent]
>    towards right by len bytes. This step will make a hole of len bytes
>    at offset.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>

Thanks, applied.

						- Ted
