From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: isolate ext4_extents.h file
Date: Wed, 28 Aug 2013 14:49:56 -0400
Message-ID: <20130828184956.GF27079@thunk.org>
References: <1377005893-4394-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50789 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab3H1St7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Aug 2013 14:49:59 -0400
Content-Disposition: inline
In-Reply-To: <1377005893-4394-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 20, 2013 at 09:38:13PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> After applied the commit (4a092d73), we have reduced the number of
> source files that need to #include ext4_extents.h.  But we can do
> better.
> 
> This commit defines ext4_zeroout_es() in extents.c and move
> EXT_MAX_BLOCKS into ext4.h in order not to include ext4_extents.h in
> indirect.c and ioctl.c.  Meanwhile we just need to include this file in
> extent_status.c when ES_AGGRESSIVE_TEST is defined.  Otherwise, this
> commit removes a duplicated declaration in trace/events/ext4.h.
> 
> After applied this patch, we just need to include ext4_extents.h file
> in {super,migrate,move_extents,extents}.c, and it is easy for us to
> define a new extent disk layout.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Applied, thanks.

						- Ted
