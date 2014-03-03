From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] mke2fs: disable resize_inode feature if 64bit feature
 is enabled
Date: Mon, 3 Mar 2014 16:40:21 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1403031640020.2258@localhost.localdomain>
References: <1372928710-10461-1-git-send-email-guaneryu@gmail.com> <20130705012128.GA11793@gmail.com> <20130707154140.GA11993@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eryu Guan <guaneryu@gmail.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbaCCPk2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Mar 2014 10:40:28 -0500
In-Reply-To: <20130707154140.GA11993@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 7 Jul 2013, Theodore Ts'o wrote:

> Date: Sun, 7 Jul 2013 11:41:40 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Eryu Guan <guaneryu@gmail.com>, linux-ext4@vger.kernel.org
> Subject: Re: [PATCH] mke2fs: disable resize_inode feature if 64bit feature is
>     enabled

Hi Ted,

are you going to take this in ?

Thanks!
-Lukas

> 
> On Fri, Jul 05, 2013 at 09:21:28AM +0800, Zheng Liu wrote:
> > Do we really need to check it?  My point is that we just clear
> > RESIZE_INODE flag if 64BIT flag is enabled.
> 
> It's better to use the resize_inode for file systems that are smaller
> than 16TB, even if the 64-bit flag is enabled, since using the meta_bg
> style resizing spreads out the block group descriptors, which
> increases the time to mount the file system.  Using the resize_inode
> will defer the need to go to the meta_bg-style resizing until we cross
> the 16TB boundary.
> 
> Cheers,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
