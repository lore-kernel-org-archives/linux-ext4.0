From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: filefrag: Fix segfault on virtual fs
Date: Sat, 28 Jul 2012 17:43:12 -0400
Message-ID: <20120728214312.GA8073@thunk.org>
References: <4FE9C02C.8040703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>, maxnet@onlinehome.de
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41846 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab2G1VnQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Jul 2012 17:43:16 -0400
Content-Disposition: inline
In-Reply-To: <4FE9C02C.8040703@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 26, 2012 at 03:59:08AM -0000, Eric Sandeen wrote:
> filefrag on a virtual fs like proc segfaults:
> 
> # filefrag /proc/filesystems 
> Floating point exception
> 
> because stat.f_blocks is 0, so the calculation of cylgroups is 0,
> which leads to a divide by 0 when calculating expected extents.
> 
> Since it's only used for ext2 filesystems anyway, just move
> the calculation of expected under "if (is_ext2)" to fix this.
> 
> Reported-by: Max Beikirch <maxnet@onlinehome.de>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
