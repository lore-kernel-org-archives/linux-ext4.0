From: djwong <djwong@us.ibm.com>
Subject: Re: Determining if an ext4 fs uses the whole partition
Date: Mon, 30 Apr 2012 10:33:04 -0700
Message-ID: <20120430173304.GF6938@tux1.beaverton.ibm.com>
References: <CAMLZHHSi=1U=-V+qMOOunPnuSWDcTm81aSjXdnc51kvYk=n_vA@mail.gmail.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Daniel Drake <dsd@laptop.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:37902 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab2D3Rda (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Apr 2012 13:33:30 -0400
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 30 Apr 2012 11:33:29 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id C0E6D1FF0054
	for <linux-ext4@vger.kernel.org>; Mon, 30 Apr 2012 11:33:20 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q3UHX9GP051478
	for <linux-ext4@vger.kernel.org>; Mon, 30 Apr 2012 11:33:12 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q3UHX8jB010014
	for <linux-ext4@vger.kernel.org>; Mon, 30 Apr 2012 11:33:08 -0600
Content-Disposition: inline
In-Reply-To: <CAMLZHHSi=1U=-V+qMOOunPnuSWDcTm81aSjXdnc51kvYk=n_vA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 30, 2012 at 11:19:31AM -0600, Daniel Drake wrote:
> Hi,
> 
> OLPC has started using ext4 online resizing to grow our filesystems to
> use the whole SD card on first boot - something we never did before.
> Working very nicely, thanks!
> 
> I'm trying to simplify/improve the scripts involved in doing this.
> 
> How can I programatically check if an ext4 fs already fills its
> partition, or if it has room to grow?

Is it not the case that there's room to grow if:

(ext4_block_count * ext4_block_size) - (bdev_size * 512) >= ext4_block_size

> The numbers produced by dumpe2fs (e.g. block count) or "df" don't seem
> to exactly line up with the sizes produced by fdisk.

How far off are the counts?  A small number of sectors, or many?

--D

> One easy solution, if possible, would be to find out the number of the
> last sector used by the filesystem. I could then very easily compare
> this to the "end" information found in sysfs for the partition. Then I
> can make the decision on whether to grow or not.
> 
> Thanks
> Daniel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

