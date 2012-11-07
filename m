From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v4+ hot_track 00/19] vfs: hot data tracking
Date: Wed, 7 Nov 2012 16:51:11 +0800
Message-ID: <CAEH94LiD4-_Ao7=x0TEtwJ3d+V+w3bOQjhTRCosTwe6vrpzBpw@mail.gmail.com>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, tytso@mit.edu,
	cmm@us.ibm.com, wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41398 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab2KGIvN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Nov 2012 03:51:13 -0500
In-Reply-To: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 29, 2012 at 12:30 PM,  <zwu.kernel@gmail.com> wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>
> NOTE:
>
>   The patchset can be obtained via my kernel dev git on github:
> git@github.com:wuzhy/kernel.git hot_tracking
>   If you're interested, you can also can review them via
> https://github.com/wuzhy/kernel/commits/hot_tracking
hi, guys,

The latest code change has been pushed into my above dev git tree. If
no further comments are done, i will post next version soon.

>
>   For more info, please check hot_tracking.txt in Documentation
>
> TODO List:
>
>  1.) Need to do scalability or performance tests.
>  2.) Need one simpler but effective temp calc'ing function
>  3.) How to save the file temperature among the umount to be able to
>      preserve the file tempreture after reboot
>
> Ben Chociej, Matt Lupfer and Conor Scott originally wrote this code to
>  be very btrfs-specific.  I've taken their code and attempted to
> make it more generic and integrate it at the VFS level.
>
> Changelog from v3:
>  1.) Rewritten debugfs support based seq_file operation. [Dave Chinner]
>  2.) Refactored workqueue support. [Dave Chinner]
>  3.) Turn some Micro into be tunable   [Zhiyong, Zheng Liu]
>        TIME_TO_KICK, and HEAT_UPDATE_DELAY
>  4.) Introduce hot func registering framework [Zhiyong]
>  5.) Remove global variable for hot tracking [Zhiyong]
>  6.) Add xfs hot tracking support [Dave Chinner]
>  7.) Add ext4 hot tracking support [Zheng Liu]
>  8.) Cleanedup a lot of other issues [Dave Chinner]
>
> v3:
>  1.) Converted to Radix trees, not RB-tree [Zhiyong, Dave Chinner]
>  2.) Added memory shrinker [Dave Chinner]
>
> v2:
>  1.) Converted to one workqueue to update map info periodically [Dave Chinner]
>  2.) Cleanedup a lot of other issues [Dave Chinner]
>
> v1:
>  1.) Reduce new files and put all in fs/hot_tracking.[ch] [Dave Chinner]
>  2.) Add btrfs hot tracking support [Zhiyong]
>  3.) The first three patches can probably just be flattened into one.
>                                         [Marco Stornelli , Dave Chinner]
>
> Dave Chinner (1):
>   xfs: add hot tracking support
>
> Zheng Liu (1):
>   ext4: add hot tracking support
>
> Zhi Yong Wu (17):
>   vfs: introduce private radix tree structures
>   vfs: initialize and free data structures
>   vfs: add I/O frequency update function
>   vfs: add two map arrays
>   vfs: add hooks to enable hot tracking
>   vfs: add temp calculation function
>   vfs: add map info update function
>   vfs: add aging function
>   vfs: add one work queue
>   vfs: introduce hot func register framework
>   vfs: register one shrinker
>   vfs: add one ioctl interface
>   debugfs: introduce one function
>   vfs: add debugfs support
>   sysfs: add two hot_track proc files
>   btrfs: add hot tracking support
>   vfs: add documentation
>
>  Documentation/filesystems/00-INDEX         |    2 +
>  Documentation/filesystems/hot_tracking.txt |  262 ++++++
>  fs/Makefile                                |    2 +-
>  fs/btrfs/ctree.h                           |    1 +
>  fs/btrfs/super.c                           |   22 +-
>  fs/compat_ioctl.c                          |    5 +
>  fs/dcache.c                                |    2 +
>  fs/debugfs/inode.c                         |   26 +
>  fs/direct-io.c                             |    6 +
>  fs/ext4/ext4.h                             |    3 +
>  fs/ext4/super.c                            |   13 +-
>  fs/hot_tracking.c                          | 1367 ++++++++++++++++++++++++++++
>  fs/hot_tracking.h                          |   58 ++
>  fs/ioctl.c                                 |   78 ++
>  fs/xfs/xfs_mount.h                         |    1 +
>  fs/xfs/xfs_super.c                         |   16 +
>  include/linux/debugfs.h                    |    9 +
>  include/linux/fs.h                         |    4 +
>  include/linux/hot_tracking.h               |  149 +++
>  kernel/sysctl.c                            |   14 +
>  mm/filemap.c                               |    6 +
>  mm/page-writeback.c                        |   12 +
>  mm/readahead.c                             |    6 +
>  23 files changed, 2061 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/filesystems/hot_tracking.txt
>  create mode 100644 fs/hot_tracking.c
>  create mode 100644 fs/hot_tracking.h
>  create mode 100644 include/linux/hot_tracking.h
>
> --
> 1.7.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards,

Zhi Yong Wu
