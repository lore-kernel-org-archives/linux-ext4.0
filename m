Return-Path: <SRS0=Qv/7=NE=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:40623 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbeJXQX4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2018 12:23:56 -0400
MIME-Version: 1.0
References: <20181023201957.GA15708@pathfinder> <CAOQ4uxhitRXu+qjg-0hWVe4VJLEu0Th+ExFr=MSeBdP+y2C6vw@mail.gmail.com>
In-Reply-To: <CAOQ4uxhitRXu+qjg-0hWVe4VJLEu0Th+ExFr=MSeBdP+y2C6vw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 24 Oct 2018 10:56:43 +0300
Message-ID: <CAOQ4uxjAh9wbdKT5TAAY9mgahfqCdKghdAFxkuxwkx_+0+dXhA@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 04/10] ext2: use common file type conversion
To: Phillip Potter <phil@philpotter.co.uk>
Cc: Jan Kara <jack@suse.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 24, 2018 at 9:50 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Oct 23, 2018 at 11:19 PM Phillip Potter <phil@philpotter.co.uk> wrote:
> >
> > Deduplicate the ext2 file type conversion implementation.
> >
> > Original patch by Amir Goldstein.
> >
> > v2:
> > - Rebased against Linux 4.19 by Phillip Potter
> > - This version does not remove EXT2_FT_x enum from fs/ext2/ext2.h,
> >   as these values are now used in compile-time checks added by
> >   Phillip Potter to make sure they remain the same as FT_x values
> >
> > v1:
> > - Initial implementation
> >
>
> Same comments as how to apply a patch and about changelog as patch 1.
> Won't repeat for other patches.
>
> I think it would be also good to mention there is a lurking bug if code
> ever tries to access ext2_type_by_mode[S_IFMT] because on-disk
> data is corrupted.

So my old notes on the alleged ext2 bug:
https://marc.info/?l=linux-fsdevel&m=148243866204444&w=2

>
> > Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> > ---
> >  fs/ext2/dir.c | 51 ++++++++++++++++++++++-----------------------------
> >  1 file changed, 22 insertions(+), 29 deletions(-)
> >
> > diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
> > index 3b8114def693..420d4b9e8980 100644
> > --- a/fs/ext2/dir.c
> > +++ b/fs/ext2/dir.c
> > @@ -252,33 +252,10 @@ ext2_validate_entry(char *base, unsigned offset, unsigned mask)
> >         return (char *)p - base;
> >  }
> >
> > -static unsigned char ext2_filetype_table[EXT2_FT_MAX] = {
> > -       [EXT2_FT_UNKNOWN]       = DT_UNKNOWN,
> > -       [EXT2_FT_REG_FILE]      = DT_REG,
> > -       [EXT2_FT_DIR]           = DT_DIR,
> > -       [EXT2_FT_CHRDEV]        = DT_CHR,
> > -       [EXT2_FT_BLKDEV]        = DT_BLK,
> > -       [EXT2_FT_FIFO]          = DT_FIFO,
> > -       [EXT2_FT_SOCK]          = DT_SOCK,
> > -       [EXT2_FT_SYMLINK]       = DT_LNK,
> > -};
> > -
> > -#define S_SHIFT 12
> > -static unsigned char ext2_type_by_mode[S_IFMT >> S_SHIFT] = {
> > -       [S_IFREG >> S_SHIFT]    = EXT2_FT_REG_FILE,
> > -       [S_IFDIR >> S_SHIFT]    = EXT2_FT_DIR,
> > -       [S_IFCHR >> S_SHIFT]    = EXT2_FT_CHRDEV,
> > -       [S_IFBLK >> S_SHIFT]    = EXT2_FT_BLKDEV,
> > -       [S_IFIFO >> S_SHIFT]    = EXT2_FT_FIFO,
> > -       [S_IFSOCK >> S_SHIFT]   = EXT2_FT_SOCK,
> > -       [S_IFLNK >> S_SHIFT]    = EXT2_FT_SYMLINK,
> > -};
> > -
> >  static inline void ext2_set_de_type(ext2_dirent *de, struct inode *inode)
> >  {
> > -       umode_t mode = inode->i_mode;
> >         if (EXT2_HAS_INCOMPAT_FEATURE(inode->i_sb, EXT2_FEATURE_INCOMPAT_FILETYPE))
> > -               de->file_type = ext2_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
> > +               de->file_type = fs_umode_to_ftype(inode->i_mode);
> >         else
> >                 de->file_type = 0;
> >  }
> > @@ -293,14 +270,14 @@ ext2_readdir(struct file *file, struct dir_context *ctx)
> >         unsigned long n = pos >> PAGE_SHIFT;
> >         unsigned long npages = dir_pages(inode);
> >         unsigned chunk_mask = ~(ext2_chunk_size(inode)-1);
> > -       unsigned char *types = NULL;
> >         bool need_revalidate = !inode_eq_iversion(inode, file->f_version);
> > +       bool has_filetype;
> >
> >         if (pos > inode->i_size - EXT2_DIR_REC_LEN(1))
> >                 return 0;
> >
> > -       if (EXT2_HAS_INCOMPAT_FEATURE(sb, EXT2_FEATURE_INCOMPAT_FILETYPE))
> > -               types = ext2_filetype_table;
> > +       has_filetype =
> > +               EXT2_HAS_INCOMPAT_FEATURE(sb, EXT2_FEATURE_INCOMPAT_FILETYPE);
> >
> >         for ( ; n < npages; n++, offset = 0) {
> >                 char *kaddr, *limit;
> > @@ -335,8 +312,24 @@ ext2_readdir(struct file *file, struct dir_context *ctx)
> >                         if (de->inode) {
> >                                 unsigned char d_type = DT_UNKNOWN;
> >
> > -                               if (types && de->file_type < EXT2_FT_MAX)
> > -                                       d_type = types[de->file_type];
> > +                               /*
> > +                                * compile-time asserts that generic FT_x types
> > +                                * still match EXT2_FT_x types - no need to list
> > +                                * for other functions as well as build will
> > +                                * fail either way

Please remove the part about "no need to list for other functions..."
Imagine how kernel code would look like if every call to BUILD_BUG_ON()
would have a comment explaining how BUILD_BUG_ON() works...

Thanks,
Amir.
