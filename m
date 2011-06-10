From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: 64bit filesystem questions
Date: Thu, 9 Jun 2011 18:08:24 -0600
Message-ID: <692307AB-41C8-4BC7-9D01-E5798CAB3548@dilger.ca>
References: <4DF0DA54.1080005@cfl.rr.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:20741 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab1FJAI1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Jun 2011 20:08:27 -0400
In-Reply-To: <4DF0DA54.1080005@cfl.rr.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-09, at 8:36 AM, Phillip Susi wrote:
> I was checking up on the support for 64bit ( > 16 TB ) fs support in the next branch last night and have a few questions:
> 
> 1)  Why is blocks_per_group limited to 32k ( more specifically, 8 x blocksize )

There is only a single block pointer for each bitmap per group.  That said,
with flex_bg this is mostly meaningless, since the bitmaps do not have to
be located in the group, and a flex group is the same as a virtual group
that is {flex_bg_factor} times as large.

> 2)  Why can't 64bit be enabled explicitly ( with -O or -E? ) instead of automatically when needed and the enable automatic 64bit setting is in mke2fs.conf?

I thought it could be enabled with "-O 64bit", but I admit I've never tried.

> 3)  Why does 64bit disable the resize inode?

Because the on-disk format of the resize inode is only suitable for 32-bit
filesystems (it is an indirect-block mapped file and cannot reserve blocks
beyond 2^32).  The "future" way to resize filesystems is using the META_BG
feature, but the ability to use it has not been integrated into the kernel
or e2fsprogs yet.


Cheers, Andreas





