From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 21/29] ext4: Split extent conversion lists to reserved &
 unreserved parts
Date: Wed, 8 May 2013 19:49:32 +0800
Message-ID: <20130508114932.GA3437@gmail.com>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-22-git-send-email-jack@suse.cz>
 <20130508070335.GC20599@gmail.com>
 <20130508112355.GC30550@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41309 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab3EHLbv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 May 2013 07:31:51 -0400
Received: by mail-pa0-f47.google.com with SMTP id kl13so1268658pab.20
        for <linux-ext4@vger.kernel.org>; Wed, 08 May 2013 04:31:51 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130508112355.GC30550@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 08, 2013 at 01:23:55PM +0200, Jan Kara wrote:
> On Wed 08-05-13 15:03:35, Zheng Liu wrote:
> > On Mon, Apr 08, 2013 at 11:32:26PM +0200, Jan Kara wrote:
> > > Now that we have extent conversions with reserved transaction, we=
 have
> > > to prevent extent conversions without reserved transaction (from =
DIO
> > > code) to block these (as that would effectively void any transact=
ion
> > > reservation we did). So split lists, work items, and work queues =
to
> > > reserved and unreserved parts.
> > >=20
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> >=20
> > I got a build error that looks like this.
> >=20
> >  fs/ext4/page-io.c: In function =E2=80=98ext4_ioend_shutdown=E2=80=99=
:
> >  fs/ext4/page-io.c:60: error: =E2=80=98struct ext4_inode_info=E2=80=
=99 has no member
> >  named =E2=80=98i_unwritten_work=E2=80=99
> >=20
> > I guess the reason is that when this patch set is sent out,
> > ext4_io_end_shutdown() hasn't be added.  So please add the code
> > like this.  Otherwise the patch looks good to me.
> > Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
>   Yeah, I've already rebased the series on top of current Linus's tre=
e and
> I've notice this problem as well. It should be fixed by now. I didn't=
 post
> the rebased series yet because I'm looking into some xfstests failure=
s I
> hit when testing it...

Thanks for your excellent work.  Yes, I am running xfstests against you=
r
patch set and I got a failure that is #091 test case when dioread_noloc=
k
enables.  That is pretty easy to be triggered.  Just let you know.

Regards,
                                                - Zheng

> > diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> > index 3fea79e..f9ecc4f 100644
> > --- a/fs/ext4/page-io.c
> > +++ b/fs/ext4/page-io.c
> > @@ -57,8 +57,10 @@ void ext4_ioend_shutdown(struct inode *inode)
> >          * We need to make sure the work structure is finished bein=
g
> >          * used before we let the inode get destroyed.
> >          */
> > -       if (work_pending(&EXT4_I(inode)->i_unwritten_work))
> > -               cancel_work_sync(&EXT4_I(inode)->i_unwritten_work);
> > +       if (work_pending(&EXT4_I(inode)->i_rsv_conversion_work))
> > +               cancel_work_sync(&EXT4_I(inode)->i_rsv_conversion_w=
ork);
> > +       if (work_pending(&EXT4_I(inode)->i_unrsv_conversion_work))
> > + cancel_work_sync(&EXT4_I(inode)->i_unrsv_conversion_work);
> >  }
> > =20
> >  static void ext4_release_io_end(ext4_io_end_t *io_end)
> >=20
> > > ---
> > >  fs/ext4/ext4.h    |   25 +++++++++++++++++-----
> > >  fs/ext4/page-io.c |   59 ++++++++++++++++++++++++++++++++++-----=
-------------
> > >  fs/ext4/super.c   |   38 ++++++++++++++++++++++++---------
> > >  3 files changed, 84 insertions(+), 38 deletions(-)
> > >=20
> > > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > > index 65adf0d..a594a94 100644
> > > --- a/fs/ext4/ext4.h
> > > +++ b/fs/ext4/ext4.h
> > > @@ -889,12 +889,22 @@ struct ext4_inode_info {
> > >  	qsize_t i_reserved_quota;
> > >  #endif
> > > =20
> > > -	/* completed IOs that might need unwritten extents handling */
> > > -	struct list_head i_completed_io_list;
> > > +	/* Lock protecting lists below */
> > >  	spinlock_t i_completed_io_lock;
> > > +	/*
> > > +	 * Completed IOs that need unwritten extents handling and have
> > > +	 * transaction reserved
> > > +	 */
> > > +	struct list_head i_rsv_conversion_list;
> > > +	/*
> > > +	 * Completed IOs that need unwritten extents handling and don't=
 have
> > > +	 * transaction reserved
> > > +	 */
> > > +	struct list_head i_unrsv_conversion_list;
> > >  	atomic_t i_ioend_count;	/* Number of outstanding io_end structs=
 */
> > >  	atomic_t i_unwritten; /* Nr. of inflight conversions pending */
> > > -	struct work_struct i_unwritten_work;	/* deferred extent convers=
ion */
> > > +	struct work_struct i_rsv_conversion_work;
> > > +	struct work_struct i_unrsv_conversion_work;
> > > =20
> > >  	spinlock_t i_block_reservation_lock;
> > > =20
> > > @@ -1257,8 +1267,10 @@ struct ext4_sb_info {
> > >  	struct flex_groups *s_flex_groups;
> > >  	ext4_group_t s_flex_groups_allocated;
> > > =20
> > > -	/* workqueue for dio unwritten */
> > > -	struct workqueue_struct *dio_unwritten_wq;
> > > +	/* workqueue for unreserved extent convertions (dio) */
> > > +	struct workqueue_struct *unrsv_conversion_wq;
> > > +	/* workqueue for reserved extent conversions (buffered io) */
> > > +	struct workqueue_struct *rsv_conversion_wq;
> > > =20
> > >  	/* timer for periodic error stats printing */
> > >  	struct timer_list s_err_report;
> > > @@ -2599,7 +2611,8 @@ extern int ext4_put_io_end(ext4_io_end_t *i=
o_end);
> > >  extern void ext4_put_io_end_defer(ext4_io_end_t *io_end);
> > >  extern void ext4_io_submit_init(struct ext4_io_submit *io,
> > >  				struct writeback_control *wbc);
> > > -extern void ext4_end_io_work(struct work_struct *work);
> > > +extern void ext4_end_io_rsv_work(struct work_struct *work);
> > > +extern void ext4_end_io_unrsv_work(struct work_struct *work);
> > >  extern void ext4_io_submit(struct ext4_io_submit *io);
> > >  extern int ext4_bio_write_page(struct ext4_io_submit *io,
> > >  			       struct page *page,
> > > diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> > > index e8ee4da..8bff3b3 100644
> > > --- a/fs/ext4/page-io.c
> > > +++ b/fs/ext4/page-io.c
> > > @@ -103,20 +103,17 @@ static int ext4_end_io(ext4_io_end_t *io)
> > >  	return ret;
> > >  }
> > > =20
> > > -static void dump_completed_IO(struct inode *inode)
> > > +static void dump_completed_IO(struct inode *inode, struct list_h=
ead *head)
> > >  {
> > >  #ifdef	EXT4FS_DEBUG
> > >  	struct list_head *cur, *before, *after;
> > >  	ext4_io_end_t *io, *io0, *io1;
> > > =20
> > > -	if (list_empty(&EXT4_I(inode)->i_completed_io_list)) {
> > > -		ext4_debug("inode %lu completed_io list is empty\n",
> > > -			   inode->i_ino);
> > > +	if (list_empty(head))
> > >  		return;
> > > -	}
> > > =20
> > > -	ext4_debug("Dump inode %lu completed_io list\n", inode->i_ino);
> > > -	list_for_each_entry(io, &EXT4_I(inode)->i_completed_io_list, li=
st) {
> > > +	ext4_debug("Dump inode %lu completed io list\n", inode->i_ino);
> > > +	list_for_each_entry(io, head, list) {
> > >  		cur =3D &io->list;
> > >  		before =3D cur->prev;
> > >  		io0 =3D container_of(before, ext4_io_end_t, list);
> > > @@ -137,16 +134,23 @@ static void ext4_add_complete_io(ext4_io_en=
d_t *io_end)
> > >  	unsigned long flags;
> > > =20
> > >  	BUG_ON(!(io_end->flag & EXT4_IO_END_UNWRITTEN));
> > > -	wq =3D EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
> > > -
> > >  	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> > > -	if (list_empty(&ei->i_completed_io_list))
> > > -		queue_work(wq, &ei->i_unwritten_work);
> > > -	list_add_tail(&io_end->list, &ei->i_completed_io_list);
> > > +	if (io_end->handle) {
> > > +		wq =3D EXT4_SB(io_end->inode->i_sb)->rsv_conversion_wq;
> > > +		if (list_empty(&ei->i_rsv_conversion_list))
> > > +			queue_work(wq, &ei->i_rsv_conversion_work);
> > > +		list_add_tail(&io_end->list, &ei->i_rsv_conversion_list);
> > > +	} else {
> > > +		wq =3D EXT4_SB(io_end->inode->i_sb)->unrsv_conversion_wq;
> > > +		if (list_empty(&ei->i_unrsv_conversion_list))
> > > +			queue_work(wq, &ei->i_unrsv_conversion_work);
> > > +		list_add_tail(&io_end->list, &ei->i_unrsv_conversion_list);
> > > +	}
> > >  	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> > >  }
> > > =20
> > > -static int ext4_do_flush_completed_IO(struct inode *inode)
> > > +static int ext4_do_flush_completed_IO(struct inode *inode,
> > > +				      struct list_head *head)
> > >  {
> > >  	ext4_io_end_t *io;
> > >  	struct list_head unwritten;
> > > @@ -155,8 +159,8 @@ static int ext4_do_flush_completed_IO(struct =
inode *inode)
> > >  	int err, ret =3D 0;
> > > =20
> > >  	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> > > -	dump_completed_IO(inode);
> > > -	list_replace_init(&ei->i_completed_io_list, &unwritten);
> > > +	dump_completed_IO(inode, head);
> > > +	list_replace_init(head, &unwritten);
> > >  	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> > > =20
> > >  	while (!list_empty(&unwritten)) {
> > > @@ -172,21 +176,34 @@ static int ext4_do_flush_completed_IO(struc=
t inode *inode)
> > >  }
> > > =20
> > >  /*
> > > - * work on completed aio dio IO, to convert unwritten extents to=
 extents
> > > + * work on completed IO, to convert unwritten extents to extents
> > >   */
> > > -void ext4_end_io_work(struct work_struct *work)
> > > +void ext4_end_io_rsv_work(struct work_struct *work)
> > >  {
> > >  	struct ext4_inode_info *ei =3D container_of(work, struct ext4_i=
node_info,
> > > -						  i_unwritten_work);
> > > -	ext4_do_flush_completed_IO(&ei->vfs_inode);
> > > +						  i_rsv_conversion_work);
> > > +	ext4_do_flush_completed_IO(&ei->vfs_inode, &ei->i_rsv_conversio=
n_list);
> > > +}
> > > +
> > > +void ext4_end_io_unrsv_work(struct work_struct *work)
> > > +{
> > > +	struct ext4_inode_info *ei =3D container_of(work, struct ext4_i=
node_info,
> > > +						  i_unrsv_conversion_work);
> > > +	ext4_do_flush_completed_IO(&ei->vfs_inode, &ei->i_unrsv_convers=
ion_list);
> > >  }
> > > =20
> > >  int ext4_flush_unwritten_io(struct inode *inode)
> > >  {
> > > -	int ret;
> > > +	int ret, err;
> > > +
> > >  	WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex) &&
> > >  		     !(inode->i_state & I_FREEING));
> > > -	ret =3D ext4_do_flush_completed_IO(inode);
> > > +	ret =3D ext4_do_flush_completed_IO(inode,
> > > +					 &EXT4_I(inode)->i_rsv_conversion_list);
> > > +	err =3D ext4_do_flush_completed_IO(inode,
> > > +					 &EXT4_I(inode)->i_unrsv_conversion_list);
> > > +	if (!ret)
> > > +		ret =3D err;
> > >  	ext4_unwritten_wait(inode);
> > >  	return ret;
> > >  }
> > > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > > index 09ff724..916c4fb 100644
> > > --- a/fs/ext4/super.c
> > > +++ b/fs/ext4/super.c
> > > @@ -747,8 +747,10 @@ static void ext4_put_super(struct super_bloc=
k *sb)
> > >  	ext4_unregister_li_request(sb);
> > >  	dquot_disable(sb, -1, DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLE=
D);
> > > =20
> > > -	flush_workqueue(sbi->dio_unwritten_wq);
> > > -	destroy_workqueue(sbi->dio_unwritten_wq);
> > > +	flush_workqueue(sbi->unrsv_conversion_wq);
> > > +	flush_workqueue(sbi->rsv_conversion_wq);
> > > +	destroy_workqueue(sbi->unrsv_conversion_wq);
> > > +	destroy_workqueue(sbi->rsv_conversion_wq);
> > > =20
> > >  	if (sbi->s_journal) {
> > >  		err =3D jbd2_journal_destroy(sbi->s_journal);
> > > @@ -856,13 +858,15 @@ static struct inode *ext4_alloc_inode(struc=
t super_block *sb)
> > >  	ei->i_reserved_quota =3D 0;
> > >  #endif
> > >  	ei->jinode =3D NULL;
> > > -	INIT_LIST_HEAD(&ei->i_completed_io_list);
> > > +	INIT_LIST_HEAD(&ei->i_rsv_conversion_list);
> > > +	INIT_LIST_HEAD(&ei->i_unrsv_conversion_list);
> > >  	spin_lock_init(&ei->i_completed_io_lock);
> > >  	ei->i_sync_tid =3D 0;
> > >  	ei->i_datasync_tid =3D 0;
> > >  	atomic_set(&ei->i_ioend_count, 0);
> > >  	atomic_set(&ei->i_unwritten, 0);
> > > -	INIT_WORK(&ei->i_unwritten_work, ext4_end_io_work);
> > > +	INIT_WORK(&ei->i_rsv_conversion_work, ext4_end_io_rsv_work);
> > > +	INIT_WORK(&ei->i_unrsv_conversion_work, ext4_end_io_unrsv_work)=
;
> > > =20
> > >  	return &ei->vfs_inode;
> > >  }
> > > @@ -3867,12 +3871,20 @@ no_journal:
> > >  	 * The maximum number of concurrent works can be high and
> > >  	 * concurrency isn't really necessary.  Limit it to 1.
> > >  	 */
> > > -	EXT4_SB(sb)->dio_unwritten_wq =3D
> > > -		alloc_workqueue("ext4-dio-unwritten", WQ_MEM_RECLAIM | WQ_UNBO=
UND, 1);
> > > -	if (!EXT4_SB(sb)->dio_unwritten_wq) {
> > > -		printk(KERN_ERR "EXT4-fs: failed to create DIO workqueue\n");
> > > +	EXT4_SB(sb)->rsv_conversion_wq =3D
> > > +		alloc_workqueue("ext4-rsv-conversion", WQ_MEM_RECLAIM | WQ_UNB=
OUND, 1);
> > > +	if (!EXT4_SB(sb)->rsv_conversion_wq) {
> > > +		printk(KERN_ERR "EXT4-fs: failed to create workqueue\n");
> > >  		ret =3D -ENOMEM;
> > > -		goto failed_mount_wq;
> > > +		goto failed_mount4;
> > > +	}
> > > +
> > > +	EXT4_SB(sb)->unrsv_conversion_wq =3D
> > > +		alloc_workqueue("ext4-unrsv-conversion", WQ_MEM_RECLAIM | WQ_U=
NBOUND, 1);
> > > +	if (!EXT4_SB(sb)->unrsv_conversion_wq) {
> > > +		printk(KERN_ERR "EXT4-fs: failed to create workqueue\n");
> > > +		ret =3D -ENOMEM;
> > > +		goto failed_mount4;
> > >  	}
> > > =20
> > >  	/*
> > > @@ -4019,7 +4031,10 @@ failed_mount4a:
> > >  	sb->s_root =3D NULL;
> > >  failed_mount4:
> > >  	ext4_msg(sb, KERN_ERR, "mount failed");
> > > -	destroy_workqueue(EXT4_SB(sb)->dio_unwritten_wq);
> > > +	if (EXT4_SB(sb)->rsv_conversion_wq)
> > > +		destroy_workqueue(EXT4_SB(sb)->rsv_conversion_wq);
> > > +	if (EXT4_SB(sb)->unrsv_conversion_wq)
> > > +		destroy_workqueue(EXT4_SB(sb)->unrsv_conversion_wq);
> > >  failed_mount_wq:
> > >  	if (sbi->s_journal) {
> > >  		jbd2_journal_destroy(sbi->s_journal);
> > > @@ -4464,7 +4479,8 @@ static int ext4_sync_fs(struct super_block =
*sb, int wait)
> > >  	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
> > > =20
> > >  	trace_ext4_sync_fs(sb, wait);
> > > -	flush_workqueue(sbi->dio_unwritten_wq);
> > > +	flush_workqueue(sbi->rsv_conversion_wq);
> > > +	flush_workqueue(sbi->unrsv_conversion_wq);
> > >  	/*
> > >  	 * Writeback quota in non-journalled quota case - journalled qu=
ota has
> > >  	 * no dirty dquots
> > > --=20
> > > 1.7.1
> > >=20
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-e=
xt4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
> --=20
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
