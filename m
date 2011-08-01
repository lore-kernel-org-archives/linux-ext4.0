From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH] ext3: fix message in ext3_remount for rw-remount case
Date: Mon, 01 Aug 2011 18:45:58 +0900
Message-ID: <4E3675D6.3010201@jp.fujitsu.com>
References: <20110801135451.cb73c981.toshi.okajima@jp.fujitsu.com> <20110801084526.GB6522@quack.suse.cz>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47264 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab1HAJpU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Aug 2011 05:45:20 -0400
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 461973EE0B5
	for <linux-ext4@vger.kernel.org>; Mon,  1 Aug 2011 18:45:18 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 2CA2945DE4F
	for <linux-ext4@vger.kernel.org>; Mon,  1 Aug 2011 18:45:18 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 14BCC45DE4E
	for <linux-ext4@vger.kernel.org>; Mon,  1 Aug 2011 18:45:18 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 08B2A1DB8037
	for <linux-ext4@vger.kernel.org>; Mon,  1 Aug 2011 18:45:18 +0900 (JST)
Received: from m105.s.css.fujitsu.com (m105.s.css.fujitsu.com [10.240.81.145])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id C90471DB802F
	for <linux-ext4@vger.kernel.org>; Mon,  1 Aug 2011 18:45:17 +0900 (JST)
In-Reply-To: <20110801084526.GB6522@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi.

(2011/08/01 17:45), Jan Kara wrote:
> On Mon 01-08-11 13:54:51, Toshiyuki Okajima wrote:
>> If there are some inodes in orphan list while a filesystem is being
>> read-only mounted, we should recommend that pepole umount and then
>> mount it when they try to remount with read-write. But the current
>> message/comment recommends that they umount and then remount it.
>>
>> ext3_remount:
>> 	/*
>> 	 * If we have an unprocessed orphan list hanging
>> 	 * around from a previously readonly bdev mount,
>> 	 * require a full umount/remount for now.
>>                            ^^^^^^^^^^^^^^
>> 	 */
>> 	if (es->s_last_orphan) {
>> 		printk(KERN_WARNING "EXT3-fs: %s: couldn't "
>> 			"remount RDWR because of unprocessed "
>> 			"orphan inode list.  Please "
>> 			"umount/remount instead.\n",
>>                           ^^^^^^^^^^^^^^
>> 			sb->s_id);

>    OK, so how about using "umount&  mount"? The '/' is what would confuse me
OK. I modify it like your comment.

  umount/mount => umount & mount

> the most... BTW, I guess you didn't really see this message in practice, did
> you?
No.
I have seen this message in practice while quotacheck command was repeatedly
executed per an hour.

Thanks,
Toshiyuki Okajima

