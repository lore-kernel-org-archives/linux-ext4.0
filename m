From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: fix printf conversion specs in ea_refcount.c
Date: Tue, 24 Dec 2013 02:00:44 -0500
Message-ID: <20131224070044.GC26944@thunk.org>
References: <20131217023639.GB2173@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42968 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab3LXHAr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Dec 2013 02:00:47 -0500
Content-Disposition: inline
In-Reply-To: <20131217023639.GB2173@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 16, 2013 at 09:36:39PM -0500, Eric Whitney wrote:
> Commit 130e961a6fb9d38997c83c6397cf9ddb5ed2491f changed the type
> used to represent block numbers in ea_refcount.c from blk_t to blk64_t
> to add support for 64 bit extended attribute refcounting.  We also
> need to adjust printf conversion specs that now don't match their new
> blk64_t arguments.  This will silence compiler warnings seen when
> "make check" is run and will avoid truncation of printed values.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

					- Ted
