From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/3] ext4 : Pass GFP_KERNEL for transaction allocation
 if caller can handler failures
Date: Wed, 26 Jan 2011 08:55:38 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1101260848050.2728@dhcp-lab-213.englab.brq.redhat.com>
References: <AANLkTinVBicZyTthnp5SjOoHUWHcKc1Css46RjpfEEnh@mail.gmail.com> <20110125161745.GC4088@quack.suse.cz> <AANLkTiniUaD8SN53BKFC2ayku-4m=4EATKxBc148d51G@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571140353-262626377-1296028541=:2728"
Cc: Jan Kara <jack@suse.cz>, ext4 <linux-ext4@vger.kernel.org>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab1AZHzs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Jan 2011 02:55:48 -0500
In-Reply-To: <AANLkTiniUaD8SN53BKFC2ayku-4m=4EATKxBc148d51G@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571140353-262626377-1296028541=:2728
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

Hi Manish,

I might be very helpful to also improve commit description, because as
it is it's very confusing and shallow, at least for me.

Thanks!
-Lukas

On Tue, 25 Jan 2011, Manish Katiyar wrote:

> Thanks a lot Jan, I will have a look at the functions you mentioned
> and send an updated version.
> 
> On Tue, Jan 25, 2011 at 8:17 AM, Jan Kara <jack@suse.cz> wrote:
> >  Hi,
> >
> > On Sat 22-01-11 19:34:55, Manish Katiyar wrote:
> >> Pass GFP_KERNEL for transaction allocation for ext4 routines if caller
> >> can handler failures
> >  Some error recovery paths will need cleaning up before you actually start
> > using them - see below:
> >
> >> diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
> >> index e0270d1..1a4a944 100644
> >> --- a/fs/ext4/acl.c
> >> +++ b/fs/ext4/acl.c
> >> @@ -351,7 +351,7 @@ ext4_acl_chmod(struct inode *inode)
> >>
> >>       retry:
> >>               handle = ext4_journal_start(inode,
> >> -                             EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
> >> +                             EXT4_DATA_TRANS_BLOCKS(inode->i_sb), true);
> >>               if (IS_ERR(handle)) {
> >>                       error = PTR_ERR(handle);
> >>                       ext4_std_error(inode->i_sb, error);
> >  We shouldn't call ext4_std_error() (that possibly logs the message in
> > the kernel log and remounts the fs read-only, panics the kernel or so) in
> > case of ENOMEM...
> >
> >> @@ -449,7 +449,8 @@ ext4_xattr_set_acl(struct dentry *dentry, const
> >> char *name, const void *value,
> >>               acl = NULL;
> >>
> >>  retry:
> >> -     handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
> >> +     handle = ext4_journal_start(inode,
> >> +                                 EXT4_DATA_TRANS_BLOCKS(inode->i_sb), true);
> >>       if (IS_ERR(handle))
> >>               return PTR_ERR(handle);
> >  It's actually not your bug, but the above should be:
> >  error = PTR_ERR(handle);
> >  goto release_and_out;
> >
> >>       error = ext4_set_acl(handle, inode, type, acl);
> >> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> >> index eb9097a..e0e27a3 100644
> >> --- a/fs/ext4/ialloc.c
> >> +++ b/fs/ext4/ialloc.c
> >> @@ -1257,7 +1257,7 @@ extern int ext4_init_inode_table(struct
> >> super_block *sb, ext4_group_t group,
> >>       if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_ZEROED))
> >>               goto out;
> >>
> >> -     handle = ext4_journal_start_sb(sb, 1);
> >> +     handle = ext4_journal_start_sb(sb, 1, true);
> >>       if (IS_ERR(handle)) {
> >>               ret = PTR_ERR(handle);
> >>               goto out;
> >  Well, this might be disputable. This function is used to lazily
> > initialize inode table.  If the initialization fails, thread removes the
> > request for initialization from the queue. But in case of ENOMEM, it might
> > be more suitable to just postpone the initialization work to a more
> > suitable time...
> >
> >> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> >> index 9f7f9e4..76c20b8 100644
> >> --- a/fs/ext4/inode.c
> >> +++ b/fs/ext4/inode.c
> > ...
> >> @@ -1398,7 +1398,7 @@ static int _ext4_get_block(struct inode *inode,
> >> sector_t iblock,
> >>               if (map.m_len > DIO_MAX_BLOCKS)
> >>                       map.m_len = DIO_MAX_BLOCKS;
> >>               dio_credits = ext4_chunk_trans_blocks(inode, map.m_len);
> >> -             handle = ext4_journal_start(inode, dio_credits);
> >> +             handle = ext4_journal_start(inode, dio_credits, false);
> >>               if (IS_ERR(handle)) {
> >>                       ret = PTR_ERR(handle);
> >>                       return ret;
> >  Hmm, this would be actually another useful prerequisite cleanup of this
> > series. _ext4_get_block() should need to start a transaction only when
> > called from direct IO path (otherwise transaction should be already started
> > when creating blocks). But this is only implicit so it would be good to
> > create ext4_get_block_directIO() which would start a transaction, use it
> > as a callback of __blockdev_direct_IO(), and remove the code from standard
> > _ext4_get_block() function. Then you can also make ext4_journal_start()
> > possibly fail and still it will be clear you do not introduce any potential
> > problems.
> >
> >> @@ -1621,7 +1621,7 @@ static int ext4_write_begin(struct file *file,
> >> struct address_space *mapping,
> >>       to = from + len;
> >>
> >>  retry:
> >> -     handle = ext4_journal_start(inode, needed_blocks);
> >> +     handle = ext4_journal_start(inode, needed_blocks, false);
> >>       if (IS_ERR(handle)) {
> >>               ret = PTR_ERR(handle);
> >>               goto out;
> >  Failing this with ENOMEM is OK. Note that grab_cache_page_write_begin()
> > called just below can fail with ENOMEM as well.
> >
> >> @@ -3553,7 +3554,7 @@ static ssize_t ext4_ind_direct_IO(int rw, struct
> >> kiocb *iocb,
> >>
> >>               if (final_size > inode->i_size) {
> >>                       /* Credits for sb + inode write */
> >> -                     handle = ext4_journal_start(inode, 2);
> >> +                     handle = ext4_journal_start(inode, 2, false);
> >>                       if (IS_ERR(handle)) {
> >>                               ret = PTR_ERR(handle);
> >>                               goto out;
> >  This can fail without introducing problems. It's standard directIO write
> > path.
> >
> >> @@ -3596,7 +3597,7 @@ retry:
> >>               int err;
> >>
> >>               /* Credits for sb + inode write */
> >> -             handle = ext4_journal_start(inode, 2);
> >> +             handle = ext4_journal_start(inode, 2, false);
> >>               if (IS_ERR(handle)) {
> >>                       /* This is really bad luck. We've written the data
> >>                        * but cannot extend i_size. Bail out and pretend
> >  This one can fail just fine as well.
> >
> >> @@ -5329,8 +5330,10 @@ int ext4_setattr(struct dentry *dentry, struct
> >> iattr *attr)
> >>
> >>               /* (user+group)*(old+new) structure, inode write (sb,
> >>                * inode block, ? - but truncate inode update has it) */
> >> -             handle = ext4_journal_start(inode, (EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)+
> >> -                                     EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb))+3);
> >> +             handle = ext4_journal_start(inode,
> >> +                                         (EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)+
> >> +                                         EXT4_MAXQUOTAS_DEL_BLOCKS(inode->i_sb))+3,
> >> +                                         true);
> >>               if (IS_ERR(handle)) {
> >>                       error = PTR_ERR(handle);
> >>                       goto err_out;
> >> @@ -5365,7 +5368,7 @@ int ext4_setattr(struct dentry *dentry, struct
> >> iattr *attr)
> >>            (ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS)))) {
> >>               handle_t *handle;
> >>
> >> -             handle = ext4_journal_start(inode, 3);
> >> +             handle = ext4_journal_start(inode, 3, true);
> >>               if (IS_ERR(handle)) {
> >>                       error = PTR_ERR(handle);
> >>                       goto err_out;
> >  The above two sites are fine but note that err_out calls ext4_std_error()
> > which we don't want to happen in case of ENOMEM.
> >
> >> @@ -5822,7 +5825,7 @@ int ext4_change_inode_journal_flag(struct inode
> >> *inode, int val)
> >>
> >>       /* Finally we can mark the inode as dirty. */
> >>
> >> -     handle = ext4_journal_start(inode, 1);
> >> +     handle = ext4_journal_start(inode, 1, true);
> >>       if (IS_ERR(handle))
> >>               return PTR_ERR(handle);
> >  This can fail OK, but you should undo inode flag and aops change before
> > returning error (that would be probably better as a separate preparatory
> > patch because it won't be completely trivial - you need to lock the updates
> > again etc. possibly create a helper function for that so that you don't
> > duplicate the code).
> >
> >> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> >> index eb3bc2f..3e7977b 100644
> >> --- a/fs/ext4/ioctl.c
> >> +++ b/fs/ext4/ioctl.c
> >> @@ -101,7 +101,7 @@ long ext4_ioctl(struct file *filp, unsigned int
> >> cmd, unsigned long arg)
> >>               } else if (oldflags & EXT4_EOFBLOCKS_FL)
> >>                       ext4_truncate(inode);
> >>
> >> -             handle = ext4_journal_start(inode, 1);
> >> +             handle = ext4_journal_start(inode, 1, false);
> >>               if (IS_ERR(handle)) {
> >>                       err = PTR_ERR(handle);
> >>                       goto flags_out;
> >  This can handle failure just fine...
> 
> I wasn't sure about this since this was calling ext4_truncate if the
> old_flags had EXT4_EOFBLOCKS_FL. And then in ext4_truncate() had
> start_transaction which was passing false.
> 
> 
> >
> >> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> >> index cb10a06..7714a15 100644
> >> --- a/fs/ext4/super.c
> >> +++ b/fs/ext4/super.c
> >> @@ -4487,7 +4488,7 @@ static int ext4_acquire_dquot(struct dquot *dquot)
> >>       handle_t *handle;
> >>
> >>       handle = ext4_journal_start(dquot_to_inode(dquot),
> >> -                                 EXT4_QUOTA_INIT_BLOCKS(dquot->dq_sb));
> >> +                                 EXT4_QUOTA_INIT_BLOCKS(dquot->dq_sb), true);
> >>       if (IS_ERR(handle))
> >>               return PTR_ERR(handle);
> >>       ret = dquot_acquire(dquot);
> >> @@ -4503,7 +4504,7 @@ static int ext4_release_dquot(struct dquot *dquot)
> >>       handle_t *handle;
> >>
> >>       handle = ext4_journal_start(dquot_to_inode(dquot),
> >> -                                 EXT4_QUOTA_DEL_BLOCKS(dquot->dq_sb));
> >> +                                 EXT4_QUOTA_DEL_BLOCKS(dquot->dq_sb), true);
> >>       if (IS_ERR(handle)) {
> >>               /* Release dquot anyway to avoid endless cycle in dqput() */
> >>               dquot_release(dquot);
> >  For now put 'false' in these quota functions. Because failure here
> > results in a failure of dquot_initialize() which is not tested in most
> > places and thus results in quota miscomputations... Properly handling this
> > would require another set of cleanups.
> >
> >                                                                Honza
> > --
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
> >
> 
> 
> 
> 

-- 
--571140353-262626377-1296028541=:2728--
