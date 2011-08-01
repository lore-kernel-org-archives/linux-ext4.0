From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: fix message in ext3_remount for rw-remount case
Date: Mon, 1 Aug 2011 10:45:26 +0200
Message-ID: <20110801084526.GB6522@quack.suse.cz>
References: <20110801135451.cb73c981.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab1HAIp2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Aug 2011 04:45:28 -0400
Content-Disposition: inline
In-Reply-To: <20110801135451.cb73c981.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 01-08-11 13:54:51, Toshiyuki Okajima wrote:
> If there are some inodes in orphan list while a filesystem is being 
> read-only mounted, we should recommend that pepole umount and then
> mount it when they try to remount with read-write. But the current
> message/comment recommends that they umount and then remount it.
> 
> ext3_remount:
> 	/*
> 	 * If we have an unprocessed orphan list hanging
> 	 * around from a previously readonly bdev mount,
> 	 * require a full umount/remount for now.
>                           ^^^^^^^^^^^^^^
> 	 */
> 	if (es->s_last_orphan) {
> 		printk(KERN_WARNING "EXT3-fs: %s: couldn't "
> 			"remount RDWR because of unprocessed "
> 			"orphan inode list.  Please "
> 			"umount/remount instead.\n",
>                          ^^^^^^^^^^^^^^
> 			sb->s_id);
  OK, so how about using "umount & mount"? The '/' is what would confuse me
the most... BTW, I guess you didn't really see this message in practice, did
you?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
