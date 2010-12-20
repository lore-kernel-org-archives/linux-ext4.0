From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fs/ext4/super.c: Use printf extension %pV
Date: Sun, 19 Dec 2010 22:44:47 -0500
Message-ID: <20101220034447.GG23626@thunk.org>
References: <1289325676.1823.78.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60984 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab0LTDov (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Dec 2010 22:44:51 -0500
Content-Disposition: inline
In-Reply-To: <1289325676.1823.78.camel@Joe-Laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 09, 2010 at 10:01:16AM -0800, Joe Perches wrote:
> Using %pV reduces the number of printk calls and
> eliminates any possible message interleaving from
> other printk calls.
> 
> In function __ext4_grp_locked_error also added
> KERN_CONT to some printks.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Thanks, added to the ext4 tree.

					- Ted
