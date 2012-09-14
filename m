From: Kevin Liao <kevinlia@gmail.com>
Subject: Re: [PATCH 2/2] resize2fs: fix overhead calculation for meta_bg file systems
Date: Fri, 14 Sep 2012 11:24:20 +0800
Message-ID: <CAF_MivFO9mqKsTL+e3LmQ-2+=YX-1MLfhnRoMNVTXVuoEjGQxA@mail.gmail.com>
References: <20120903164525.GD5066@thunk.org>
	<1346690758-21072-1-git-send-email-tytso@mit.edu>
	<1346690758-21072-2-git-send-email-tytso@mit.edu>
	<CAGBYx2a8J1ZvWDjgv3snTCE59nqurF_sGYJ0pxSy2anXjzfBRg@mail.gmail.com>
	<20120904021412.GG5066@thunk.org>
	<CAF_MivFMtFvTN9Gwdjk+imenuUHOcO3vbeha6nt+eqovRK3VXw@mail.gmail.com>
	<20120913232157.GA14184@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Anssi Hannula <anssi.hannula@iki.fi>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59211 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758971Ab2INDYV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Sep 2012 23:24:21 -0400
Received: by yenm15 with SMTP id m15so91631yen.19
        for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2012 20:24:20 -0700 (PDT)
In-Reply-To: <20120913232157.GA14184@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/9/14 Theodore Ts'o <tytso@mit.edu>:
>
> The reason for this is how meta_bg changes how the block group
> descriptors are laid out.  Originally, the block group descriptors
> were located contiguously.  From a 12T filesystem without meta_bg,
> you'll see this from dumpe2fs:
>
> Group 0: (Blocks 0-32767)
>   Primary superblock at 0, Group descriptors at 1-768
>
> If the file system is created with meta_bg, then group descriptors
> that have to be read when the file system is opened by libext2fs or
> when the file system is mounted look like this:
>
> Group 0: (Blocks 0-32767)
>   Primary superblock at 0, Group descriptor at 1
> Group 128: (Blocks 4194304-4227071) [INODE_UNINIT]
>   Group descriptor at 4194304
> Group 256: (Blocks 8388608-8421375) [INODE_UNINIT]
>   Group descriptor at 8388608
> Group 384: (Blocks 12582912-12615679) [INODE_UNINIT]
>   Group descriptor at 12582912
>   ...
>
> In the set of kernel and e2fsprogs patches that I just released, we
> can partially work around this problem by starting with the
> resize_inode, and only switch over to the meta_bg once we have
> exhausted the resize_inode scheme.  So now we can do this:
>
>     mke2fs -t ext4 -q -O 64bit /dev/vdc 12T
>     mount /dev/vdc
>     resize2fs /dev/vdc 18T
>
> After the resize2fs, the block group descriptors for the first 16TB
> will be contiguous:
>
> Group 0: (Blocks 0-32767) [ITABLE_ZEROED]
>   Primary superblock at 0, Group descriptors at 1-2048
>
> after that, there will be singleton block group descriptor blocks, i.e.:
>
> Group 131136: (Blocks 4297064448-4297097215) [INODE_UNINIT]
>   Group descriptor at 4297064448
>
> The other thing we can do to speed up the mount times is change how
> the kernel to lazily read the block group descriptors, instead of
> trying to read them all at mount time, at least once they are no
> longer contiguous.  I'll look into seeing what we can do to improve
> things on that front.
>
> Regards,
>
>                                         - Ted

Ted, thanks a lot for the detailed explanation. It is very clear. I
will find time to test your new patches..

Regards,
Kevin Liao
