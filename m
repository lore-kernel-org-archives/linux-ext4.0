From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Remove code duplication in
 ext4_get_block_write_nolock()
Date: Thu, 8 Nov 2012 15:08:00 -0500
Message-ID: <20121108200800.GK19977@thunk.org>
References: <1350328009-22740-1-git-send-email-anatol.pomozov@gmail.com>
 <1350328009-22740-2-git-send-email-anatol.pomozov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: wenqing.lz@taobao.com, linux-ext4@vger.kernel.org
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60047 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756661Ab2KHV7t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2012 16:59:49 -0500
Content-Disposition: inline
In-Reply-To: <1350328009-22740-2-git-send-email-anatol.pomozov@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 15, 2012 at 12:06:49PM -0700, Anatol Pomozov wrote:
> 729f52c6be51013 introduced function ext4_get_block_write_nolock() that
> is very similar to _ext4_get_block(). Eliminate code duplication
> by passing different flags to _ext4_get_block()
> 
> Tested: xfs tests
> 
> Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>

Applied, thanks.

					- Ted
