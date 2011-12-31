From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH V6 RESEND] ext4: add new online resize
Date: Sat, 31 Dec 2011 10:40:24 -0700
Message-ID: <9CB90BD7-CB4D-42D5-9254-A0455ADB0E15@whamcloud.com>
References: <1325242812-27005-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44223 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab1LaUEC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 31 Dec 2011 15:04:02 -0500
Received: by iaeh11 with SMTP id h11so27189268iae.19
        for <linux-ext4@vger.kernel.org>; Sat, 31 Dec 2011 12:04:02 -0800 (PST)
In-Reply-To: <1325242812-27005-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The main issue I have with this patch is that the series starts by adding a bunch of unused functions, and only wires them I to the existing resize code at the very end. 

A better approach would be to have the early patches refactor the existing functions so that they are used by the current resize code, and the new resize functionality is enabled at the end. 

That allows verifying that the existing code continues to work through the entire series, and that the functions being added actually work properly even before the new ioctl is added. 

Cheers, Andreas

On 2011-12-30, at 3:59, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:

> Hi all,
> 
> Here is the 6th veriosn of patch series adding new resize implementation
> to ext4.
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
> 
>   According to data above, new resize is faster than current resize in both
>   user and sys time.  New resize performs well in sys time, because it
>   supports BLOCK_UNINIT and adds multi-groups each time.
> 
> -- About supporting new features.
>   YES! New resize can support new feature like bigalloc and exclude bitmap
>   easily.  Because it lets kernel do all work.
> 
> V5->V6:
>   add code initializing inode bitmap and inode tables back.
> 
> V4->V5:
>   release resizing error lock in error case of IOC_RESIZEFS
>   Thanks Djalal <tixxdz@opendz.org> for pointing it out and his
>   patch for IOC_GROUP_EXTEND and IOC_GROUP_ADD.
> 
> V3->V4:
>   rename __ext4_group_extend to ext4_group_extend_no_check
> 
> V2->V3:
>   initialize block bitmap of last group.
>   remove code initializing inode bitmap and inode tables.
> 
> Yongqiang.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
