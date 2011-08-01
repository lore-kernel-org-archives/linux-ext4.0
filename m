From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: fix message in ext3_remount for rw-remount case
Date: Mon, 1 Aug 2011 11:57:31 +0200
Message-ID: <20110801095731.GI6522@quack.suse.cz>
References: <20110801135451.cb73c981.toshi.okajima@jp.fujitsu.com>
 <20110801084526.GB6522@quack.suse.cz>
 <4E3675D6.3010201@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, akpm@linux-foundation.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50476 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab1HAJ5d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Aug 2011 05:57:33 -0400
Content-Disposition: inline
In-Reply-To: <4E3675D6.3010201@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 01-08-11 18:45:58, Toshiyuki Okajima wrote:
> (2011/08/01 17:45), Jan Kara wrote:
> >On Mon 01-08-11 13:54:51, Toshiyuki Okajima wrote:
> >>If there are some inodes in orphan list while a filesystem is being
> >>read-only mounted, we should recommend that pepole umount and then
> >>mount it when they try to remount with read-write. But the current
> >>message/comment recommends that they umount and then remount it.
> >>
> >>ext3_remount:
> >>	/*
> >>	 * If we have an unprocessed orphan list hanging
> >>	 * around from a previously readonly bdev mount,
> >>	 * require a full umount/remount for now.
> >>                           ^^^^^^^^^^^^^^
> >>	 */
> >>	if (es->s_last_orphan) {
> >>		printk(KERN_WARNING "EXT3-fs: %s: couldn't "
> >>			"remount RDWR because of unprocessed "
> >>			"orphan inode list.  Please "
> >>			"umount/remount instead.\n",
> >>                          ^^^^^^^^^^^^^^
> >>			sb->s_id);
> 
> >   OK, so how about using "umount&  mount"? The '/' is what would confuse me
> OK. I modify it like your comment.
> 
>  umount/mount => umount & mount
  Thanks.

> >the most... BTW, I guess you didn't really see this message in practice, did
> >you?
> No.
> I have seen this message in practice while quotacheck command was repeatedly
> executed per an hour.
  Interesting. Are you able to reproduce this? Quotacheck does remount
read-only + remount read-write but you cannot really remount the filesystem
read-only when it has orphan inodes and so you should not see those when
you remount read-write again. Possibly there's race between remounting and
unlinking...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
