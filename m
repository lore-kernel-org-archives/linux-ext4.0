From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove explicit WARN_ON when ext4_map_blocks()
 fails
Date: Mon, 28 Jan 2013 21:22:21 -0500
Message-ID: <20130129022221.GE7003@thunk.org>
References: <1359364447-4699-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45958 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab3A2CWY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2013 21:22:24 -0500
Content-Disposition: inline
In-Reply-To: <1359364447-4699-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 28, 2013 at 10:14:07AM +0100, Lukas Czerner wrote:
> In two places we call WARN_ON() before we print out the debug message,
> however we agreed that the WARN_ON() is unnecessary at those places so
> remove them.
> 
> Also use ext4_warning() instead of ext4_msg() and printk().
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

						- Ted
