From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 0/4 v. 9] Ext3/Ext4 Batched discard support
Date: Mon, 11 Oct 2010 19:02:48 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1010111858330.2954@dhcp-lab-213.englab.brq.redhat.com>
References: <1285596600-28358-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, rwheeler@redhat.com,
	sandeen@redhat.com, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755483Ab0JKRCz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Oct 2010 13:02:55 -0400
In-Reply-To: <1285596600-28358-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 27 Sep 2010, Lukas Czerner wrote:

> Hi,
> 
> just some minor changes here. As Andreas pointed out it is better to
> have special structure to pass FITRIM arguments into ioctl, instead
> os just an array of "noname" elements. So I have introduced this
> structure:
> 
> struct fstrim_range {
> 	uint64_t start;
> 	uint64_t len;
> 	uint64_t minlen;
> };
> 
> Also the tool which uses FSTRIM ioctl gets updated.
> 
> 
> SHORT DESCRIPTION:
> ==================
> 
> Batched discard adds ability to discard free space on mounded filesystem,
> in order to avoid using current discard implementation which discards
> recently freed blocks. This approach may on some devices (it depends on
> how efficient is the device wear-leveling algorithm) result in huge
> performance loss.
> 
> Batched discard can be invoked from user-space through FITRIM ioctl on
> the whole, or just a part, of file system. With this approach we are
> searching for continuous free blocks bigger than defined through ioctl
> to discard them. So, since we are searching for big continuous extents
> it is much more efficient than current approach and it gives user fine
> grained control over how much disk space will be reclaimed for
> wear-leveling and what impact will it have on performance.
> 
> 
> I have attached source code for example application which uses FITRIM
> to discard just a part or whole filesystem. Since FITRIM is filesystem
> independent ioctl it can be used by any filesystem which supports it.
> 
> Usage: fstrim [-s start] [-l length] [-m minimum-extent] [-v] {mountpoint}
>         -s Starting Byte to discard from
>         -l Number of Bytes to discard from the start
>         -m Minimum extent length to discard
>         -v Verbose - number of discarded bytes
> 
> ---
> bd6a5a3 ext3: Add batched discard support for ext3
> 9dcabb2 ext4: Add batched discard support for ext4
> 9c8c3a5 Add ioctl FITRIM.
> 787dbea ext4: Use return value from sb_issue_discard()
> 
>  fs/ext3/balloc.c        |  256 +++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ext3/super.c         |    1 +
>  fs/ext4/ext4.h          |    2 +
>  fs/ext4/mballoc.c       |  194 +++++++++++++++++++++++++++++++++++-
>  fs/ext4/super.c         |    1 +
>  fs/ioctl.c              |   39 +++++++
>  include/linux/ext3_fs.h |    1 +
>  include/linux/fs.h      |    8 ++
>  8 files changed, 501 insertions(+), 1 deletions(-)
> 
Hi Ted,

I was wondering, is there still anything holding this patch-set from
being merged in ?

Thanks!

-Lukas

