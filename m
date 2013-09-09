From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: fix a coding style for EXT2_NO_MTAB_FILE
Date: Mon, 9 Sep 2013 10:50:37 -0400
Message-ID: <20130909145037.GH6059@thunk.org>
References: <1375678963-7845-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57037 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab3IIOuj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Sep 2013 10:50:39 -0400
Content-Disposition: inline
In-Reply-To: <1375678963-7845-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 05, 2013 at 01:02:43PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> When we define an error in lib/ext2fs/ext2_err.et.in, we will always use
> EXT2_ET_* prefix for a new error.  But EXT2_NO_MTAB_FILE doesn't obey
> this rule.  So fix it.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Cc: Theodore Ts'o <tytso@mit.edu>

Thanks, applied.

					- Ted
