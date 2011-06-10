From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: 64bit filesystem questions
Date: Fri, 10 Jun 2011 11:19:45 -0400
Message-ID: <4DF23611.7000307@cfl.rr.com>
References: <4DF0DA54.1080005@cfl.rr.com> <692307AB-41C8-4BC7-9D01-E5798CAB3548@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:58988 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588Ab1FJPTr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jun 2011 11:19:47 -0400
In-Reply-To: <692307AB-41C8-4BC7-9D01-E5798CAB3548@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/9/2011 8:08 PM, Andreas Dilger wrote:
> There is only a single block pointer for each bitmap per group.  That said,
> with flex_bg this is mostly meaningless, since the bitmaps do not have to
> be located in the group, and a flex group is the same as a virtual group
> that is {flex_bg_factor} times as large.

Of course there is only a single pointer because there is only a single 
bitmap.  What does this have to do with limiting the block count to 8 * 
blocksize?

>> 3)  Why does 64bit disable the resize inode?
>
> Because the on-disk format of the resize inode is only suitable for 32-bit
> filesystems (it is an indirect-block mapped file and cannot reserve blocks
> beyond 2^32).  The "future" way to resize filesystems is using the META_BG
> feature, but the ability to use it has not been integrated into the kernel
> or e2fsprogs yet.

Ahh, right... no indirect blocks.  Couldn't and shouldn't the resize 
inode just use extents instead?  Also I thought that META_BG was an idea 
that eventually become FLEX_BG and has been dropped?

