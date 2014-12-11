From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext2fs: fix integer overflow in rb_get_bmap_range
Date: Thu, 11 Dec 2014 17:58:28 -0500
Message-ID: <20141211225828.GH31008@thunk.org>
References: <1418153416-17750-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51935 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967342AbaLKW6a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Dec 2014 17:58:30 -0500
Content-Disposition: inline
In-Reply-To: <1418153416-17750-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 09, 2014 at 11:30:16PM +0400, Dmitry Monakhov wrote:
> bmap_rb_extent is defined as __u64:blk __u64:count. So count can exceed INT_MAX on
> populated filesystems
> 
> TESTCASE: xfstest ext4/004
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Applied, thanks.

					- Ted
