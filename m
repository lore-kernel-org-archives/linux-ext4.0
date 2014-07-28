From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] filefrag: fix -B option and extents calculation for
 FIBMAP
Date: Sun, 27 Jul 2014 20:01:52 -0400
Message-ID: <20140728000152.GF6725@thunk.org>
References: <20140724100539.GA8061@hercules.tuxera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Rakesh Pandit <rakesh@tuxera.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59641 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbaG1ABz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Jul 2014 20:01:55 -0400
Content-Disposition: inline
In-Reply-To: <20140724100539.GA8061@hercules.tuxera.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 24, 2014 at 01:05:40PM +0300, Rakesh Pandit wrote:
> 29758d2 broke -B option which is useful for filesystems not supporting
> FIEMAP. Also, fix extents calculation for -B which is broken since
> 2508eaa7.
> 
> Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>

Applied, thanks.

					- Ted
