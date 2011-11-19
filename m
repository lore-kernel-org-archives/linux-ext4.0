From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [PATCH v4 0/15] ext4: add new online resize interface
Date: Sat, 19 Nov 2011 11:13:57 -0700
Message-ID: <E4904E52-7428-478D-AE2E-B29EA825CDB1@gmail.com>
References: <1321696641-14437-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"adilger@dilger.ca" <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52818 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab1KSSOF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Nov 2011 13:14:05 -0500
Received: by iage36 with SMTP id e36so5134859iag.19
        for <linux-ext4@vger.kernel.org>; Sat, 19 Nov 2011 10:14:03 -0800 (PST)
In-Reply-To: <1321696641-14437-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-11-19, at 2:57, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:
> This patch series adds new resize implementation to ext4.
> 
> -- What's new resize implementation?
>   It is a new online resize interface for ext4.  It can be used via
>   ioctl with EXT4_IOC_RESIZE_FS and a 64 bit integer indicating size
>   of the resized fs in block.
> 
> -- Difference between current resize and new resize.
>   New resize lets kernel do all work, like allocating bitmaps and
>   inode tables and can support flex_bg and BLOCK_UNINIT features.
>   Besides these, new resize is much faster than current resize.
> 
>   Below are benchmarks I made on my personal computer, fses with
>   flex_bg size = 16 were resized to 230GB evry time. The first
>   row shows the size of a fs from which the fs was resized to 230GB.
>   The datas were collected by 'time resize2fs'.
> 
>                      new resize
>                20GB          50GB      100GB
>      real    0m3.558s     0m2.891s    0m0.394s
>      user    0m0.004s     0m0.000s    0m0.394s
>      sys     0m0.048s     0m0.048s    0m0.028s
> 
>                      current resize
>                20GB          50GB      100GB
>      real    5m2.770s     4m43.757s  3m14.840s
>      user    0m0.040s     0m0.032s   0m0.024s
>      sys     0m0.464s     0m0.432s   0m0.324s

These stats must be backward, because resizing 20GB takes more time than resizing 100GB. 

>   According to data above, new resize is faster than current resize in both
>   user and sys time.  New resize performs well in sys time, because it
>   supports BLOCK_UNINIT and adds multi-groups each time.
> 
> -- About supporting new features.
>   YES! New resize can support new feature like bigalloc and exclude bitmap
>   easily.  Because it lets kernel do all work.
> 
> V3->V4:
>   rename __ext4_group_extend to ext4_group_extend_no_check.
> 
> V2->V3:
>   initialize block bitmap of last group.
>   remove code initalizing inode bitmap and inode tables.
> 
> Yongqiang.
> 
> git diff --stat
> 
> Documentation/filesystems/ext4.txt |    7 +
> fs/ext4/ext4.h                     |   10 +
> fs/ext4/ioctl.c                    |   39 ++
> fs/ext4/resize.c                   | 1167 +++++++++++++++++++++++++++---------
> 4 files changed, 942 insertions(+), 281 deletions(-)
> 
> 
