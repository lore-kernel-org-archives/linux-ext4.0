From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: add sanity checks in __ext4_check_dir_entry
Date: Mon, 3 Jun 2013 11:40:48 -0400
Message-ID: <20130603154048.GC20009@thunk.org>
References: <1370253616-8173-1-git-send-email-ruslan.bilovol@ti.com>
 <1370253616-8173-3-git-send-email-ruslan.bilovol@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54438 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756694Ab3FCPkx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Jun 2013 11:40:53 -0400
Content-Disposition: inline
In-Reply-To: <1370253616-8173-3-git-send-email-ruslan.bilovol@ti.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 03, 2013 at 01:00:16PM +0300, Ruslan Bilovol wrote:
> Added checks for NULL before dereferencing some pointers
> 
> +	if (!de || !bh || !dir)
> +		return 1;

Do you know which one of these pointers was NULL?

I want't make sure we're fixing the root issue as opposed to papering
over it.  I'm not seeing how any of these pointers could have been
NULL (at least in my upstream kernel), and while I believe that this
helped for your kernel, I want to make sure we understand exactly what
was going on.

Thanks,

					- Ted
