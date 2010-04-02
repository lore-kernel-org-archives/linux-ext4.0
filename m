From: tytso@mit.edu
Subject: Re: [PATCH] ext4: allow defrag (EXT4_IOC_MOVE_EXT) in 32bit compat
 mode
Date: Fri, 2 Apr 2010 17:48:31 -0400
Message-ID: <20100402214831.GN8298@thunk.org>
References: <201003072132.10579.borntraeger@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56581 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811Ab0DBVsg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Apr 2010 17:48:36 -0400
Content-Disposition: inline
In-Reply-To: <201003072132.10579.borntraeger@de.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 07, 2010 at 09:32:10PM +0100, Christian Borntraeger wrote:
> I have an x86_64 kernel with i386 userspace. e4defrag fails on the
> EXT4_IOC_MOVE_EXT ioctl because it is not wired up for the compat
> case. It seems that struct move_extent is compat save, only types
> with fixed widths are used:
> {
>         __u32 reserved;         /* should be zero */
>         __u32 donor_fd;         /* donor file descriptor */
>         __u64 orig_start;       /* logical start offset in block for orig */
>         __u64 donor_start;      /* logical start offset in block for donor */
>         __u64 len;              /* block length to be moved */
>         __u64 moved_len;        /* moved block length */
> };
> 
> Lets just wire up EXT4_IOC_MOVE_EXT for the compat case.

Thanks, added to the ext4 patch queue.

							- Ted
