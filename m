From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v3] ext4: Prevent race while waling extent tree
Date: Tue, 13 Nov 2012 13:07:03 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1211131304030.3577@localhost>
References: <1352732245-30132-1-git-send-email-lczerner@redhat.com> <1352794923-28555-1-git-send-email-lczerner@redhat.com> <CA+a=Yy6pi5rUv2GJtsvH1=O+WAawWg03S_ORpVfwnVzYa4tPqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, zab@redhat.com, dmonakhov@openvz.org
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab2KMMHL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Nov 2012 07:07:11 -0500
In-Reply-To: <CA+a=Yy6pi5rUv2GJtsvH1=O+WAawWg03S_ORpVfwnVzYa4tPqA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 13 Nov 2012, Peng Tao wrote:

> Date: Tue, 13 Nov 2012 19:34:41 +0800
> From: Peng Tao <bergwolf@gmail.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, zab@redhat.com,
>     dmonakhov@openvz.org
> Subject: Re: [PATCH v3] ext4: Prevent race while waling extent tree
> 
> On Tue, Nov 13, 2012 at 4:22 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> > Currently ext4_ext_walk_space() only takes i_data_sem for read when
> > searching for the extent at given block with ext4_ext_find_extent().
> > Then it drops the lock and the extent tree can be changed at will.
> > However later on we're searching for the 'next' extent, but the extent
> > tree might already have changed, so the information might not be
> > accurate.
> >
> > In fact we can hit BUG_ON(end <= start) if the extent got inserted into
> > the tree after the one we found and before the block we were searching
> > for. This has been reproduced by running xfstests 225 in loop on s390x
> > architecture, but theoretically we could hit this on any other
> > architecture as well, but probably not as often.
> >
> > Fix this by extending the critical section to include
> > ext4_ext_next_allocated_block() as well. It means that if there are any
> > operation going on on the particular inode, the fiemap will return
> > inaccurate data. However this will also fix the concerns about starving
> > writers to the extent tree, because we will put and reacquire the
> > semaphore with every iteration. This will not be particularly fast, but
> > fiemap is not critical operation.
> >
> > However we also need to limit the access to the extent structure to the
> > critical section, because outside of it the content can change. So we
> > remove extent and next block parameters from ext4_ext_fiemap_cb()
> > function and pass just flags instead.
> >
> > Also we have to move path reinitialization inside the critical section.
> >
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> > v3: reworked
> >
> >  fs/ext4/ext4_extents.h |    5 ++---
> >  fs/ext4/extents.c      |   40 +++++++++++++++++++++-------------------
> >  2 files changed, 23 insertions(+), 22 deletions(-)
> >
> > diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
> > index cb1b2c9..356ad9f 100644
> > --- a/fs/ext4/ext4_extents.h
> > +++ b/fs/ext4/ext4_extents.h
> > @@ -149,9 +149,8 @@ struct ext4_ext_path {
> >   * positive retcode - signal for ext4_ext_walk_space(), see below
> >   * callback must return valid extent (passed or newly created)
> >   */
> > -typedef int (*ext_prepare_callback)(struct inode *, ext4_lblk_t,
> > -                                       struct ext4_ext_cache *,
> > -                                       struct ext4_extent *, void *);
> > +typedef int (*ext_prepare_callback)(struct inode *, struct ext4_ext_cache *,
> > +                                   unsigned int, void *);
> >
> >  #define EXT_CONTINUE   0
> >  #define EXT_BREAK      1
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 7011ac9..c097acf 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -1968,7 +1968,8 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
> >         struct ext4_extent *ex;
> >         ext4_lblk_t next, start = 0, end = 0;
> >         ext4_lblk_t last = block + num;
> > -       int depth, exists, err = 0;
> > +       int exists, depth = 0, err = 0;
> > +       unsigned int flags = 0;
> >
> >         BUG_ON(func == NULL);
> >         BUG_ON(inode == NULL);
> > @@ -1977,9 +1978,16 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
> >                 num = last - block;
> >                 /* find extent for this block */
> >                 down_read(&EXT4_I(inode)->i_data_sem);
> > +
> > +               if (path && ext_depth(inode) != depth) {
> > +                       /* depth was changed. we have to realloc path */
> > +                       kfree(path);
> > +                       path = NULL;
> > +               }
> > +
> >                 path = ext4_ext_find_extent(inode, block, path);
> > -               up_read(&EXT4_I(inode)->i_data_sem);
> >                 if (IS_ERR(path)) {
> > +                       up_read(&EXT4_I(inode)->i_data_sem);
> >                         err = PTR_ERR(path);
> >                         path = NULL;
> >                         break;
> > @@ -1987,6 +1995,7 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
> >
> >                 depth = ext_depth(inode);
> >                 if (unlikely(path[depth].p_hdr == NULL)) {
> > +                       up_read(&EXT4_I(inode)->i_data_sem);
> >                         EXT4_ERROR_INODE(inode, "path[%d].p_hdr == NULL", depth);
> >                         err = -EIO;
> >                         break;
> > @@ -2037,14 +2046,21 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
> >                         cbex.ec_block = le32_to_cpu(ex->ee_block);
> >                         cbex.ec_len = ext4_ext_get_actual_len(ex);
> >                         cbex.ec_start = ext4_ext_pblock(ex);
> > +                       if (ext4_ext_is_uninitialized(ex))
> > +                               flags |= FIEMAP_EXTENT_UNWRITTEN;
> >                 }
> > +               up_read(&EXT4_I(inode)->i_data_sem);
> >
> >                 if (unlikely(cbex.ec_len == 0)) {
> >                         EXT4_ERROR_INODE(inode, "cbex.ec_len == 0");
> >                         err = -EIO;
> >                         break;
> >                 }
> > -               err = func(inode, next, &cbex, ex, cbdata);
> > +
> > +               if (next == EXT_MAX_BLOCKS)
> > +                       flags |= FIEMAP_EXTENT_LAST;
> > +
> > +               err = func(inode, &cbex, flags, cbdata);
> You may want to include func() in the critical section as well, to fix
> the cp data corruption reported by Roger Niva. It looks to be the same
> race.

That's not a good idea. As already mentioned by Zach Brown
ext4_ext_fiemap_cb() is doing all kinds of things including possibly
taking i_data_sem. Moreover even if we do that, after we drop the
semaphore and return data to the user it might no longer be valid
anyway in the case there is any IO going on on the file.

-Lukas
