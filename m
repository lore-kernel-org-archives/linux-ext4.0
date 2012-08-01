From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: "Unknown code" error when enabling metadata_csum on ext4 raid1
 device
Date: Wed, 1 Aug 2012 15:19:35 +0800
Message-ID: <20120801071935.GA12929@gmail.com>
References: <CAFepXZhPc0Vw-m0h_U9SnS6=CutOsGbiApe=-PEbKb3dxWOEvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, semenko@alum.mit.edu, mangoo@wpkg.org,
	tytso@mit.edu, djwong@us.ibm.com
To: semenko@syndetics.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57134 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab2HAHKx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Aug 2012 03:10:53 -0400
Received: by yenl2 with SMTP id l2so6977743yen.19
        for <linux-ext4@vger.kernel.org>; Wed, 01 Aug 2012 00:10:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAFepXZhPc0Vw-m0h_U9SnS6=CutOsGbiApe=-PEbKb3dxWOEvw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 30, 2012 at 09:53:15PM -0500, Nick Semenkovich wrote:
> I'm trying to enable metadata_csum on an ext4 raid1 device, but end up
> with a semi-cryptic error.
> 
> (This is probably the same thing Tomasz Chmielewski reported in
> http://www.spinics.net/lists/linux-ext4/msg33139.html )
> 
> Is this issue being tracked someplace?
> 
> $ uname -ar
> Linux dev 3.5.0-6-generic #6-Ubuntu SMP Mon Jul 23 19:52:14 UTC 2012
> x86_64 x86_64 x86_64 GNU/Linux
> 
> $ git clone git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
> $ ./configure
> [snip]
> $ make progs
> [snip]
> $ sudo misc/tune2fs -O metadata_csum /dev/md1
> tune2fs 1.42.3 (14-May-2012)
> rewrite_directory: Unknown code Ijv 64 while rewriting directories
> 
> The error code changes when I re-run tune2fs (to [a-zA-Z]*3 64).
> 
> 
> I've tried this on the master, "next", & "pu" git branches, all with errors.
> 
> 
> $ debugfs -R 'stats' /dev/md1 >
> http://web.mit.edu/semenko/Public/debugfs-md1.txt

[CC to Tomasz, Ted, and Darrick]

Hi Nick and Tomasz,

Could you please try this patch?  It seems that the problem is because
error code doesn't be clear.

Regards,
Zheng

Subject: [PATCH] tune2fs: clear error code before rewriting directory when metadata_csum enabled

From: Zheng Liu <wenqing.lz@taobao.com>

When we enable metadata_csum feature in tune2fs, all inodes need to be rewrited
to calculate checksum.  In this process, the inode that has been removed also
needs to calculate checksum, but the extent tree in these inodes has been clear.
Thus, we cannot read any extents, and an 'EXT2_ET_EXTENT_NO_NEXT' error is
returned back.  But in this condition error code in rewrite_dir_context doesn't
be initialized, and it causes an unknown error.

we can use this script to reproduce this bug:

#!/bin/sh

dev='/dev/sda1'
mnt='/mnt/sda1'

mkfs.ext4 $dev
mount -t ext4 $dev $mnt # without metadata_csum feature

mkdir -p $mnt/test/1
mkdir $mnt/test/2
echo "hello" > $mnt/test/1/hello
rm -rf $mnt/*
umount $mnt
tune2fs -O metadata_csum $dev

CC: Nick Semenkovich <semenko@alum.mit.edu>
CC: Tomasz Chmielewski <mangoo@wpkg.org>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 misc/tune2fs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 6a48009..41a5529 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -592,6 +592,7 @@ errcode_t rewrite_directory(ext2_filsys fs, ext2_ino_t dir,
 
 	ctx.is_htree = (inode->i_flags & EXT2_INDEX_FL);
 	ctx.dir = dir;
+	ctx.errcode = 0;
 	retval = ext2fs_block_iterate3(fs, dir, BLOCK_FLAG_READ_ONLY |
 						BLOCK_FLAG_DATA_ONLY,
 				       0, rewrite_dir_block, &ctx);
-- 
1.7.4.1

