From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: [PATCH 1/3] Implement generic freeze feature
Date: Fri, 27 Jun 2008 20:33:27 +0900
Message-ID: <2B8295B5761847BCB9831DB3ADE96B49@nsl.ad.nec.co.jp>
References: <20080624155950t-sato@mail.jp.nec.com> <20080624144803.0135a84d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: <viro@ZenIV.linux.org.uk>, <linux-ext4@vger.kernel.org>,
	<xfs@oss.sgi.com>, <dm-devel@redhat.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<axboe@kernel.dk>, <mtk.manpages@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:52684 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbYF0Lem (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Jun 2008 07:34:42 -0400
In-Reply-To: <20080624144803.0135a84d.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

>> +/*
>> + * get_super_without_lock - Get super_block from block_device without lock.
>> + * @bdev: block device struct
>> + *
>> + * Scan the superblock list and finds the superblock of the file system
>> + * mounted on the block device given. This doesn't lock anyone.
>> + * %NULL is returned if no match is found.
>> + */
>
> This is not a terribly good comment.
>
> Which lock are we not taking?  I _assume_ that it's referring to
> s_umount?  If so, the text should describe that.
>
> It should also go to some lengths explaining why this dangerous-looking
> and rather nasty-looking function exists.
>
> Look at it this way: there is no way in which the reviewer of this
> patch (ie: me) can work out why this function exists.  Hence there will
> be no way in which future readers of this code will be able to work out
> why this function exists either.  This is bad.  These things should be
> described in code comments and in the changelog (whichever is most
> appropriate).

Thank you for your comment.  I will write comments appropriately.

I was wrong. I thought we didn't need to lock s_umount because
this ioctl required to open a regular file or a directory and we cannot
unmount a target filesystem.
So I created get_super_without_lock() used in freeze_bdev().

But, I have found that the ioctl (DM_DEV_SUSPEND_CMD in
drivers/md/dm-ioctl.c) requires to open  a logical volume
(not a file or a directory) and calls freeze_bdev(), so we can unmount
a filesystem.
So I will replace get_super_without_lock with get_super to get s_umount.

Cheers, Takashi
