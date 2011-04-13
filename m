From: Ted Ts'o <tytso@mit.edu>
Subject: Re: CONFIG_EXT4_USE_FOR_EXT23:  rootfs shows as ext2 instead of
 ext4
Date: Tue, 12 Apr 2011 20:49:38 -0400
Message-ID: <20110413004938.GE3682@thunk.org>
References: <4DA48AF4.5080803@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Mark Lord <kernel@teksavvy.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42599 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756910Ab1DMAtm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Apr 2011 20:49:42 -0400
Content-Disposition: inline
In-Reply-To: <4DA48AF4.5080803@teksavvy.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 12, 2011 at 01:25:08PM -0400, Mark Lord wrote:
> Ted et al.
> 
> I've only just noticed this, so I have no idea how long it has been this way.
> 
> When I build a kernel with CONFIG_EXT4_USE_FOR_EXT23=y and boot from it,
> the ext4 root filesystem shows up as "ext2" mode, rather than "ext4".
> 
> This looks very wrong to me, and quite dangerous.

It's a cosemtic bug, I agree, but I'm not sure why you consider it
dangerous.

CONFIG_EXT4_USE_FOR_EXT23 means that ext4 registers itself as ext2
and/or ext3, if ext2 and/or ext3 are not configured into the kernel.
Since the kernel tries to mount the file system as ext2, ext3, and
then ext4, and uses whichever one works first.

						- Ted
