From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v2 0/8] Filesystem io types statistic
Date: Fri, 18 Nov 2011 10:48:39 +0800
Message-ID: <20111118024839.GA19583@gmail.com>
References: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
 <1321008926.2710.39.camel@menhir>
 <20111111153246.GA6826@gmail.com>
 <1321266181.2731.8.camel@menhir>
 <20111114133536.GA4437@gmail.com>
 <CAGr1F2E-pdHqVam27fWXRtWZ0K7=e2GPxOu5HsbhQPrnr=aoLw@mail.gmail.com>
 <20111116084311.GA21356@gmail.com>
 <1321438459.2713.22.camel@menhir>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Aditya Kali <adityakali@google.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
To: Steven Whitehouse <swhiteho@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59664 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab1KRCq4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Nov 2011 21:46:56 -0500
Content-Disposition: inline
In-Reply-To: <1321438459.2713.22.camel@menhir>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Sorry for the delay reply.

On Wed, Nov 16, 2011 at 10:14:19AM +0000, Steven Whitehouse wrote:
[snip]
> > > 
> > > As part of some other work, I had added ext4's own submit_bh functions
> > > and replaced all the calls to submit_bh() and ll_rw_block() with
> > > these:
> > > 
> > > ------ x ------
> > > 
> > > --- a/fs/ext4/inode.c
> > > +++ b/fs/ext4/inode.c
> > > +void ext4_submit_bh_read_nowait(int rw, struct buffer_head *bh)
> > > +{
> > > +       BUG_ON(rw & WRITE);
> > > +       BUG_ON(!buffer_locked(bh));
> > > +       get_bh(bh);
> > > +       bh->b_end_io = end_buffer_read_sync;
> > > +       submit_bh(rw, bh);
> > > +}
> > > +
> > > +int ext4_submit_bh_read(int rw, struct buffer_head *bh)
> > > +{
> > > +       BUG_ON(rw & WRITE);
> > > +       BUG_ON(!buffer_locked(bh));
> > > +
> > > +       if (buffer_uptodate(bh)) {
> > > +               unlock_buffer(bh);
> > > +               return 0;
> > > +       }
> > > +
> > > +       ext4_submit_bh_read_nowait(rw, bh);
> > > +       wait_on_buffer(bh);
> > > +       if (buffer_uptodate(bh))
> > > +               return 0;
> > > +       return -EIO;
> > > +}
> > > +
> > >  struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
> > >                                ext4_lblk_t block, int create, int *err)
> > >  {
> > > @@ -1572,11 +1598,9 @@ struct buffer_head *ext4_bread(handle_t
> > > *handle, struct inode *inode,
> > >         bh = ext4_getblk(handle, inode, block, create, err);
> > >         if (!bh)
> > >                 return bh;
> > > -       if (buffer_uptodate(bh))
> > > +       if (bh_uptodate_or_lock(bh))
> > >                 return bh;
> > > -       ll_rw_block(READ_META, 1, &bh);
> > > -       wait_on_buffer(bh);
> > > -       if (buffer_uptodate(bh))
> > > +       if (!ext4_submit_bh_read(READ_META, bh))
> > >                 return bh;
> > >         put_bh(bh);
> > >         *err = -EIO;
> > > 
> > > ------ x ------
> > > 
> > > I had made the change only for reads, but it should be easy to make it
> > > do writes to. Also, this function can take ext4 specific flags and you
> > > can do your accounting at a single place in ext4. So, you wont need
> > > any more flags for buffer head.
> > > Will this approach help in what you are trying to do?
> > > 
> > > Thanks,
> > 
> > Hi Aditya,
> > 
> > Thank you for your patch. It quite can help me to solve my problem. We
> > can define some wrapper functions to do our accounting in ext4. But it
> > seems that this approach is just suitable for ext4. I prefer to
> > provide a fs independent solution. Steven and I are talking about how to
> > implement it to let other filesystems can use this mechanism directly to
> > do their accouting. If you have some suggestions, feel free to tell me.
> > 
> > Regards,
> > Zheng
> > 
> 
> Hi,
> 
> I think Aditya's patch is a reasonable solution to part of the problem.
> Having said that, I'm much more worried about how the info gets passed
> via the block layer to blktrace. One possible solution is that a number
> of the REQ flags are used only in certain places, so it might be
> possible to split those into a separate field or something like that, in
> order to avoid changing the submit_bh() interface. Resolving this issue
> is really the tricky problem here, once thats done, the rest should be
> relatively simple.

I think this information should be provided by filesystem rather than
block layer because it depends on specific filesystem. Block layer only
needs to notify filesystem that the request is issued to the disk. Then
filesystem can do something according to this notification, such as
increasing different counters by the IO types. So I don't think blktrace
shoud handle these flags.

> 
> Looking at blk_types.h, a large number of those flags are listed as:
> 
>         /* request only flags */
>         __REQ_SORTED,           /* elevator knows about this request */
>         __REQ_SOFTBARRIER,      /* may not be passed by ioscheduler */
> etc.
> 
> which I suspect are used only at lower layers of the block layer, so
> they would potentially be available for use at submit_bh time, even if
> they were then split out to a separate variable in the bio/request.
> 
> There is also the issue of what happens when requests containing
> different fs objects get merged. I'd be tempted to just OR the info
> together. A more tricky problem is if such requests/bios then got split
> again. I think we'd just have to take the hit on accuracy and copy the
> same info to both parts of the split request/bio, otherwise it would
> become too complicated.
> 
> It should then be possible, given a few spare flags to use, to add some
> generic flags, perhaps:
> 
> REQ_SB
> REQ_INODE
> REQ_INDIRECT
> REQ_XATTR
> REQ_JOURNAL
> 
> would be a minimum set, plus say:
> 
> REQ_FSPRIV1
> REQ_FSPRIV2
> 
> for fs specific use. I've copied in Jens to see if he has some
> suggestions on a good way forward here,

This is an optional approach. We can define some REQ_* flags into block
layer and build some wrapper functions in filesystem like Aditya's
suggestion to handle these flags. But it has a defect that this
implementation is not a fs independent solution, even though we don't
need to modify block layer.

I will try to implement a new version by this approach.

Regards,
Zheng
