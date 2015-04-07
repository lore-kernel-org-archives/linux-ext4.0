From: Davide Italiano <dccitaliano@gmail.com>
Subject: Re: [PATCH] ext4: Remove redundant check under lock scope
Date: Tue, 7 Apr 2015 11:15:19 -0700
Message-ID: <CADob98Ri7RJR7u-ivzwZ6z+LvyNKsgbej4T8eg-ipCAFvZzwiw@mail.gmail.com>
References: <1428384901-2304-1-git-send-email-dccitaliano@gmail.com>
	<1428384901-2304-2-git-send-email-dccitaliano@gmail.com>
	<87mw2ki6ur.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonlist@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:34648 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbbDGSPU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Apr 2015 14:15:20 -0400
Received: by wgbdm7 with SMTP id dm7so64798049wgb.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Apr 2015 11:15:19 -0700 (PDT)
In-Reply-To: <87mw2ki6ur.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 7, 2015 at 3:13 AM, Dmitry Monakhov <dmonlist@gmail.com> wrote:
>
> Davide Italiano <dccitaliano@gmail.com> writes:
>
> > ext4_zero_range() and ext4_collapse_range() duplicate
> > the check in ext4_fallocate(). The checks are made with
> > inode lock held when there's no need for that. Remove them,
> > reducing the scope of the lock.
> NAK. Other task can convert indirect<=>extent via
> ioctl(, EXT4_IOC_SETFLAGS, flags)
>   ->ext4_ext_migrate()
>   ->ext4_int_migrate()
> So we _must_ recheck EXT4_INODE_EXTENTS after we grab i_mutex.
> >
> > Signed-off-by: Davide Italiano <dccitaliano@gmail.com>
> > ---
> >  fs/ext4/extents.c | 16 ----------------
> >  1 file changed, 16 deletions(-)
> >
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index bed4308..9e6fa09 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -4810,15 +4810,6 @@ static long ext4_zero_range(struct file *file, loff_t offset,
> >               flags |= EXT4_GET_BLOCKS_KEEP_SIZE;
> >
> >       mutex_lock(&inode->i_mutex);
> > -
> > -     /*
> > -      * Indirect files do not support unwritten extnets
> > -      */
> > -     if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
> > -             ret = -EOPNOTSUPP;
> > -             goto out_mutex;
> > -     }
> > -
> >       if (!(mode & FALLOC_FL_KEEP_SIZE) &&
> >            offset + len > i_size_read(inode)) {
> >               new_size = offset + len;
> > @@ -5445,13 +5436,6 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
> >               ret = -EINVAL;
> >               goto out_mutex;
> >       }
> > -
> > -     /* Currently just for extent based files */
> > -     if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
> > -             ret = -EOPNOTSUPP;
> > -             goto out_mutex;
> > -     }
> > -
> >       truncate_pagecache(inode, ioffset);
> >
> >       /* Wait for existing dio to complete */
> > --
> > 2.3.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


Thanks, this explains it. Do you think it's worth adding a comment
explaining this behaviour?

--
Davide
