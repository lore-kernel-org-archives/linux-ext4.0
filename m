From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] ext4: simple cleanup in fiemap codepath
Date: Wed, 21 Nov 2012 15:12:09 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1211211511440.28163@dhcp-1-104.brq.redhat.com>
References: <1353423460-12178-1-git-send-email-lczerner@redhat.com> <1353423460-12178-3-git-send-email-lczerner@redhat.com> <CA+a=Yy6U4Md9_LU3e9Hy0QJ_LyEQPbg7xxOtGWrUuddH7=r2gQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	gnehzuil.liu@gmail.com, tytso@mit.edu, dmonakhov@openvz.org
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab2KUOMR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Nov 2012 09:12:17 -0500
In-Reply-To: <CA+a=Yy6U4Md9_LU3e9Hy0QJ_LyEQPbg7xxOtGWrUuddH7=r2gQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 21 Nov 2012, Peng Tao wrote:

> Date: Wed, 21 Nov 2012 18:48:34 +0800
> From: Peng Tao <bergwolf@gmail.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, gnehzuil.liu@gmail.com, tytso@mit.edu,
>     dmonakhov@openvz.org
> Subject: Re: [PATCH 2/2] ext4: simple cleanup in fiemap codepath
> 
> On Tue, Nov 20, 2012 at 10:57 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> > This commit is simple cleanup of fiemap codepath which has not been
> > included in previous commit to make the changes clearer. In this commit
> > we rename cbex variable to newex in ext4_fill_fiemap_extents() and more
> > importantly remove unnecessary condition in ext4_find_delayed_extent().
>                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> missing some code or commit message needs updating?

Yeah, the message needs some updating after porting to the extent
status tree.

Thanks!
-Lukas

> 
> Thanks,
> Tao
> 
> >
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  fs/ext4/extents.c |   28 ++++++++++++++--------------
> >  1 files changed, 14 insertions(+), 14 deletions(-)
> >
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index c7e3b58..ec34a0c 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -1967,7 +1967,7 @@ static int ext4_fill_fiemap_extents(struct inode *inode,
> >                                     struct fiemap_extent_info *fieinfo)
> >  {
> >         struct ext4_ext_path *path = NULL;
> > -       struct ext4_ext_cache cbex;
> > +       struct ext4_ext_cache newex;
> >         struct ext4_extent *ex;
> >         ext4_lblk_t next, next_del, start = 0, end = 0;
> >         ext4_lblk_t last = block + num;
> > @@ -2044,26 +2044,26 @@ static int ext4_fill_fiemap_extents(struct inode *inode,
> >                 BUG_ON(end <= start);
> >
> >                 if (!exists) {
> > -                       cbex.ec_block = start;
> > -                       cbex.ec_len = end - start;
> > -                       cbex.ec_start = 0;
> > +                       newex.ec_block = start;
> > +                       newex.ec_len = end - start;
> > +                       newex.ec_start = 0;
> >                 } else {
> > -                       cbex.ec_block = le32_to_cpu(ex->ee_block);
> > -                       cbex.ec_len = ext4_ext_get_actual_len(ex);
> > -                       cbex.ec_start = ext4_ext_pblock(ex);
> > +                       newex.ec_block = le32_to_cpu(ex->ee_block);
> > +                       newex.ec_len = ext4_ext_get_actual_len(ex);
> > +                       newex.ec_start = ext4_ext_pblock(ex);
> >                         if (ext4_ext_is_uninitialized(ex))
> >                                 flags |= FIEMAP_EXTENT_UNWRITTEN;
> >                 }
> >
> > -               next_del = ext4_find_delayed_extent(inode, &cbex);
> > +               next_del = ext4_find_delayed_extent(inode, &newex);
> >                 if (next_del) {
> >                         exists = 1;
> >                         flags |= FIEMAP_EXTENT_DELALLOC;
> >                 }
> >                 up_read(&EXT4_I(inode)->i_data_sem);
> >
> > -               if (unlikely(cbex.ec_len == 0)) {
> > -                       EXT4_ERROR_INODE(inode, "cbex.ec_len == 0");
> > +               if (unlikely(newex.ec_len == 0)) {
> > +                       EXT4_ERROR_INODE(inode, "newex.ec_len == 0");
> >                         err = -EIO;
> >                         break;
> >                 }
> > @@ -2084,9 +2084,9 @@ static int ext4_fill_fiemap_extents(struct inode *inode,
> >
> >                 if (exists) {
> >                         err = fiemap_fill_next_extent(fieinfo,
> > -                               (__u64)cbex.ec_block << blksize_bits,
> > -                               (__u64)cbex.ec_start << blksize_bits,
> > -                               (__u64)cbex.ec_len << blksize_bits,
> > +                               (__u64)newex.ec_block << blksize_bits,
> > +                               (__u64)newex.ec_start << blksize_bits,
> > +                               (__u64)newex.ec_len << blksize_bits,
> >                                 flags);
> >                         if (err < 0)
> >                                 break;
> > @@ -2096,7 +2096,7 @@ static int ext4_fill_fiemap_extents(struct inode *inode,
> >                         }
> >                 }
> >
> > -               block = cbex.ec_block + cbex.ec_len;
> > +               block = newex.ec_block + newex.ec_len;
> >         }
> >
> >         if (path) {
> > --
> > 1.7.7.6
> >
> 
