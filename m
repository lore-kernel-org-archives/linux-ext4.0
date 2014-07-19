From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 02/24] debugfs: Only print the first 60 bytes from i_block on a fast symlink
Date: Sat, 19 Jul 2014 10:49:35 -0600
Message-ID: <B72871BE-3D5E-4A07-8EDE-9B4032119174@dilger.ca>
References: <20140718225200.31374.85411.stgit@birch.djwong.org> <20140718225224.31374.15186.stgit@birch.djwong.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:47698 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbaGSQtm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Jul 2014 12:49:42 -0400
Received: by mail-pa0-f50.google.com with SMTP id et14so7167294pad.23
        for <linux-ext4@vger.kernel.org>; Sat, 19 Jul 2014 09:49:41 -0700 (PDT)
In-Reply-To: <20140718225224.31374.15186.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Wouldn't it be better to decode and print the whole symlink from the inline data?  Depending on the use of debugfs, printing only the first 60 bytes may cause people/scripts to think the link is corrupted. 

Cheers, Andreas

> On Jul 18, 2014, at 16:52, "Darrick J. Wong" <darrick.wong@oracle.com> wrote:
> 
> If we have an inline_data fast symlink, i_size can be larger than the
> size of i_block.  In this case, debugfs prints off the end of the
> buffer, so fix that.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> debugfs/debugfs.c            |   15 ++++++++++-----
> tests/d_special_files/expect |    2 +-
> 2 files changed, 11 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
> index 51f386b..5eecabe 100644
> --- a/debugfs/debugfs.c
> +++ b/debugfs/debugfs.c
> @@ -783,11 +783,16 @@ void internal_dump_inode(FILE *out, const char *prefix,
>    }
> 
>    if (LINUX_S_ISLNK(inode->i_mode) &&
> -        ext2fs_inode_data_blocks(current_fs,inode) == 0 &&
> -        !(inode->i_flags & EXT4_INLINE_DATA_FL))
> -        fprintf(out, "%sFast_link_dest: %.*s\n", prefix,
> -            (int) inode->i_size, (char *)inode->i_block);
> -    else if (LINUX_S_ISBLK(inode->i_mode) || LINUX_S_ISCHR(inode->i_mode)) {
> +        ext2fs_inode_data_blocks(current_fs, inode) == 0 &&
> +        !(inode->i_flags & EXT4_INLINE_DATA_FL)) {
> +        int sz = EXT2_I_SIZE(inode);
> +
> +        if (sz > sizeof(inode->i_block))
> +            sz = sizeof(inode->i_block);
> +        fprintf(out, "%sFast link dest: \"%.*s\"\n", prefix, sz,
> +            (char *)inode->i_block);
> +    } else if (LINUX_S_ISBLK(inode->i_mode) ||
> +           LINUX_S_ISCHR(inode->i_mode)) {
>        int major, minor;
>        const char *devnote;
> 
> diff --git a/tests/d_special_files/expect b/tests/d_special_files/expect
> index 2b2dbfa..f729b0f 100644
> --- a/tests/d_special_files/expect
> +++ b/tests/d_special_files/expect
> @@ -11,7 +11,7 @@ Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
> atime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
> mtime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
> -Fast_link_dest: bar
> +Fast link dest: "bar"
> Exit status is 0
> debugfs -R ''stat foo2'' -w test.img
> Inode: 13   Type: symlink    Mode:  0777   Flags: 0x0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
