From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH 0/5] Ext4 quota fixes for 2.6.32 -stable kernel
Date: Mon, 4 Jan 2010 15:01:05 -0800
Message-ID: <20100104230105.GF20708@kroah.com>
References: <1261589108-17588-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:45237 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111Ab0ADXQH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Jan 2010 18:16:07 -0500
Content-Disposition: inline
In-Reply-To: <1261589108-17588-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 23, 2009 at 06:25:03PM +0100, Jan Kara wrote:
> The following five patches fix deadlocks, miscomputations, and similar
> problems in ext4 implementation of quota.

All now queued up.

Next time, if you could provide the git commit id of the patches as they
are in Linus's tree, that would make things easier.

thanks,

greg k-h
