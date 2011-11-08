From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH V3 0/15] ext4: add new online resize interface
Date: Tue, 8 Nov 2011 00:06:45 -0700
Message-ID: <B6C5796D-0A41-4131-A947-9BF554B8CEFD@dilger.ca>
References: <1320707608-14246-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:35063 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab1KHHFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Nov 2011 02:05:43 -0500
In-Reply-To: <1320707608-14246-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-11-07, at 4:13 PM, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:

> Hi all,
> 
> V2->V3:
>   initialize block bitmap of last group.
>   remove code initalizing inode bitmap and inode tables.

Thanks for the great work. I haven't looked through the patches yet, but just a high level question...

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

Does this also support META_BG filesystems?  One major limitation of the current resize implementation is that mke2fs does not prepare filesystems over 16TB for resizing.  With METABG it would be possible to online resize without any preparation. One drawback of METABG is that there is no backup group descriptor for the last group if it is the only one in the METABG. I recall Ted had a suggestion to add a GDT backup for the last group in the superblock (maybe at the end), since it is only 64 bytes big, and this could be done compatibly under the METABG flag, since an all-zero backup for an old fs (if there are any) is no worse that no backup at all. 

It is also not currently possible to resize from a sub-16TB filesystem to above 16TB.  Did you test with a 64-byte group descriptor for filesystemsbelow 16TB?

These aren't at all reasons to reject this patch series, but since you are in the middle of working on this code it might be easier for you to implement this functionality if it isn't already in the patches. 

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
> [PATCH V3 01/15] ext4: add a function which extends a group without
> [PATCH V3 02/15] ext4: add a function which adds a new desc to a fs
> [PATCH V3 03/15] ext4: add a function which sets up a new group desc
> [PATCH V3 04/15] ext4: add a function which updates super block
> [PATCH V3 05/15] ext4: add a structure which will be used by
> [PATCH V3 06/15] ext4: add a function which sets up group blocks of
> [PATCH V3 07/15] ext4: add a function which adds several group
> [PATCH V3 08/15] ext4: add a function which sets up a flex groups
> [PATCH V3 09/15] ext4: enable ext4_update_super() to handle a flex
> [PATCH V3 10/15] ext4: pass verify_reserved_gdb() the number of
> [PATCH V3 11/15] ext4: add a new function which allocates bitmaps
> [PATCH V3 12/15] ext4: add a new function which adds a flex group to
> [PATCH V3 13/15] ext4: add new online resize interface
> [PATCH V3 14/15] ext4: let ext4_group_extend() use common code
> [PATCH V3 15/15] ext4: let ext4_group_add() use common code
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
