From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ext4: silence array overflow warning
Date: Tue, 18 Jul 2017 14:00:21 +0300
Message-ID: <CAOQ4uxi+H4AQW=twF8pL1G-rOYcpFLw5T+nktZG9jQkjimkiZA@mail.gmail.com>
References: <20170718092702.bpk2k5qjg4cz2mqk@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Ext4 <linux-ext4@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170718092702.bpk2k5qjg4cz2mqk@mwanda>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

CC fsdevel, because this bug is duplicated at least in 6 other filesystems:
ext2, exofs, ocfs2, f2fs, nilfs2, btrfs

On Tue, Jul 18, 2017 at 12:27 PM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> I get a static checker warning:
>
>     fs/ext4/ext4.h:3091 ext4_set_de_type()
>     error: buffer overflow 'ext4_type_by_mode' 15 <= 15
>
> It seems unlikely that we would hit this read overflow in real life, but
> it's also simple enough to make the array 16 bytes instead of 15.

FYI, I posted a series to fix this in 10 different filesystems, all have
the same hypothetical bug:
https://marc.info/?l=linux-fsdevel&m=148217829301701&w=2
There were objections about using common code for filesystem
specific on-disk format, so my initial approach was dropped.

My manual code audit of ext4 concluded that this specific bug cannot
hit current ext4 code, which sanitizes the value of i_mode when reading
it from disk:
https://marc.info/?l=linux-fsdevel&m=148243866204444&w=2

The only maintainer that followed up on fixing the array overflow was
Darrick and a fix was merged to xfs:
1fc4d33fed12 xfs: replace xfs_mode_to_ftype table with switch statement

So there are 6 more fix patches you can send.

Cheers,
Amir.

>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 9ebde0cd632e..fbaeb441bed3 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3074,7 +3074,7 @@ extern int ext4_handle_dirty_dirent_node(handle_t *handle,
>                                          struct inode *inode,
>                                          struct buffer_head *bh);
>  #define S_SHIFT 12
> -static const unsigned char ext4_type_by_mode[S_IFMT >> S_SHIFT] = {
> +static const unsigned char ext4_type_by_mode[(S_IFMT >> S_SHIFT) + 1] = {
>         [S_IFREG >> S_SHIFT]    = EXT4_FT_REG_FILE,
>         [S_IFDIR >> S_SHIFT]    = EXT4_FT_DIR,
>         [S_IFCHR >> S_SHIFT]    = EXT4_FT_CHRDEV,

I still think it makes more sense to use common DT_* macros here,
even if not using common conversion helpers, i.e.:
https://marc.info/?l=linux-fsdevel&m=148221950110233&w=2

If for nothing else, then for not redefining S_SHIFT 7 times
in the code:
fs/btrfs/inode.c:#define S_SHIFT 12
fs/exofs/dir.c:#define S_SHIFT 12
fs/ext2/dir.c:#define S_SHIFT 12
fs/ext4/ext4.h:#define S_SHIFT 12
fs/nilfs2/dir.c:#define S_SHIFT 12
fs/ocfs2/ocfs2_fs.h:#define S_SHIFT 12
include/linux/f2fs_fs.h:#define S_SHIFT 12
