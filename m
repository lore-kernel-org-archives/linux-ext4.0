From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: check bh in ext4_read_block_bitmap()
Date: Sat, 12 Jan 2013 16:34:11 -0500
Message-ID: <20130112213411.GB19503@thunk.org>
References: <1357985111-11937-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42962 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab3ALVeN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Jan 2013 16:34:13 -0500
Content-Disposition: inline
In-Reply-To: <1357985111-11937-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 12, 2013 at 06:05:11PM +0800, Eryu Guan wrote:
> bh returned by ext4_read_block_bitmap_nowait() might be NULL, validate
> the bh pointer before using it...
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>

Applied, thanks.

					- Ted
