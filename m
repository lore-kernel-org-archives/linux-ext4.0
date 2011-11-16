From: Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [PATCH v2 0/8] Filesystem io types statistic
Date: Wed, 16 Nov 2011 10:14:19 +0000
Message-ID: <1321438459.2713.22.camel@menhir>
References: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
	 <1321008926.2710.39.camel@menhir> <20111111153246.GA6826@gmail.com>
	 <1321266181.2731.8.camel@menhir> <20111114133536.GA4437@gmail.com>
	 <CAGr1F2E-pdHqVam27fWXRtWZ0K7=e2GPxOu5HsbhQPrnr=aoLw@mail.gmail.com>
	 <20111116084311.GA21356@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Aditya Kali <adityakali@google.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394Ab1KPKM4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Nov 2011 05:12:56 -0500
In-Reply-To: <20111116084311.GA21356@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Wed, 2011-11-16 at 16:43 +0800, Zheng Liu wrote:
> On Tue, Nov 15, 2011 at 10:34:20AM -0800, Aditya Kali wrote:
> > On Mon, Nov 14, 2011 at 5:35 AM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> > > On Mon, Nov 14, 2011 at 10:23:01AM +0000, Steven Whitehouse wrote:
> > >> Hi,
> > >>
> > >> On Fri, 2011-11-11 at 23:32 +0800, Zheng Liu wrote:
> > >> > On Fri, Nov 11, 2011 at 10:55:26AM +0000, Steven Whitehouse wrote:
> > >> > > Hi,
> > >> > >
> > >> > > On Thu, 2011-11-10 at 18:34 +0800, Zheng Liu wrote:
> > >> > > > Hi all,
> > >> > > >
> > >> > > > v1->v2: totally redesign this mechanism
> > >> > > >
> > >> > > > This patchset implements an io types statistic mechanism for filesystem
> > >> > > > and it has been added into ext4 to let us know how the ext4 is used by
> > >> > > > applications. It is useful for us to analyze how to improve the filesystem
> > >> > > > and applications. Nowadays, I have added it into ext4, but other filesytems
> > >> > > > also can use it to count the io types by themselves.
> > >> > > >
> > >> > > > A 'Issue' flag is added into buffer_head and will be set in submit_bh().
> > >> > > > Thus, we can check this flag in filesystem to know that a request is issued
> > >> > > > to the disk when this flag is set. Filesystems just need to check it in
> > >> > > > read operation because filesystem should know whehter a write request hits
> > >> > > > cache or not, at least in ext4. In filesystem, buffer needs to be locked in
> > >> > > > checking and clearing this flag, but it doesn't cost much overhead.
> > >> > > >
> > >> >
> > >> > Hi Steve,
> > >> >
> > >> > Thank you for your attention.
> > >> >
> > >> > > There is already a REQ_META flag available which allows distinction
> > >> > > between data and metadata I/O (at least when they are not contained
> > >> > > within the same block). If that was to be extended to allow some
> > >> > > filesystem specific bits that would solve the problem that you appear to
> > >> > > be addressing with these patches in a fs independent way.
> > >> >
> > >> > You are right. REQ_META flag quite can distinguish between metadata and
> > >> > data. But it is difficulty to check this flag in filesystem because
> > >> > buffer_head doesn't use it and most of filesystems still use buffer_head
> > >> > to submit a IO request. This is the reason why I added a new flag into
> > >> > buffer_head.
> > >> >
> > >> I don't understand what you mean here.... submit_bh() takes a bh and a
> > >> set of REQ flags, so there is no reason to not use REQ_META. Using a bh
> > >> doesn't prevent setting those flags. The issue is only that few bits
> > >> remain unused in those flags and solving the problem in a "nice" way, by
> > >> adding a few more flags, may be tricky.
> > >
> > > Hi,
> > >
> > > Please let me explain why a new flag is needed in buffer_head.
> > >
> > > The goal of this patchset wants to provide a mechanism to let
> > > filesystems can inspect how much different types of IOs are issued to
> > > the disk. The types not only are divided into metadata and data. The
> > > detailed types are needed, such as super_block, inode, EA and so on.
> > > So filesystem needs to define some counters to save the result and
> > > increase these counters when it makes a request. But filesystems couldn't
> > > know whether or not this request is issued to the disk because the data
> > > might be in page cache, at least read operation is like that. So we need
> > > a solution to let filesystems know that. Meanwhile filesystems can free
> > > choose whether or not providing the statistic result.
> > >
> > > A new flag can be added into buffer_head and is set when the request is
> > > really issued to the disk to let filesystem know that. But it seems that
> > > REQ_META flag could not fit for us because REQ flags are used in bio.
> > > Buffer_head couldn't use these flags. So filesystem cannot check this
> > > flag that has been set or not. Further, AFAIK, some filesystems (e.g.
> > > ext4) call sb_bread() and sb_breadahead() to do a read operation besides
> > > submit_bh() and ll_rw_block(). It seems that there is no way to check
> > > REQ_META flag from buffer_head too.
> > >
> > 
> > As part of some other work, I had added ext4's own submit_bh functions
> > and replaced all the calls to submit_bh() and ll_rw_block() with
> > these:
> > 
> > ------ x ------
> > 
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > +void ext4_submit_bh_read_nowait(int rw, struct buffer_head *bh)
> > +{
> > +       BUG_ON(rw & WRITE);
> > +       BUG_ON(!buffer_locked(bh));
> > +       get_bh(bh);
> > +       bh->b_end_io = end_buffer_read_sync;
> > +       submit_bh(rw, bh);
> > +}
> > +
> > +int ext4_submit_bh_read(int rw, struct buffer_head *bh)
> > +{
> > +       BUG_ON(rw & WRITE);
> > +       BUG_ON(!buffer_locked(bh));
> > +
> > +       if (buffer_uptodate(bh)) {
> > +               unlock_buffer(bh);
> > +               return 0;
> > +       }
> > +
> > +       ext4_submit_bh_read_nowait(rw, bh);
> > +       wait_on_buffer(bh);
> > +       if (buffer_uptodate(bh))
> > +               return 0;
> > +       return -EIO;
> > +}
> > +
> >  struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
> >                                ext4_lblk_t block, int create, int *err)
> >  {
> > @@ -1572,11 +1598,9 @@ struct buffer_head *ext4_bread(handle_t
> > *handle, struct inode *inode,
> >         bh = ext4_getblk(handle, inode, block, create, err);
> >         if (!bh)
> >                 return bh;
> > -       if (buffer_uptodate(bh))
> > +       if (bh_uptodate_or_lock(bh))
> >                 return bh;
> > -       ll_rw_block(READ_META, 1, &bh);
> > -       wait_on_buffer(bh);
> > -       if (buffer_uptodate(bh))
> > +       if (!ext4_submit_bh_read(READ_META, bh))
> >                 return bh;
> >         put_bh(bh);
> >         *err = -EIO;
> > 
> > ------ x ------
> > 
> > I had made the change only for reads, but it should be easy to make it
> > do writes to. Also, this function can take ext4 specific flags and you
> > can do your accounting at a single place in ext4. So, you wont need
> > any more flags for buffer head.
> > Will this approach help in what you are trying to do?
> > 
> > Thanks,
> 
> Hi Aditya,
> 
> Thank you for your patch. It quite can help me to solve my problem. We
> can define some wrapper functions to do our accounting in ext4. But it
> seems that this approach is just suitable for ext4. I prefer to
> provide a fs independent solution. Steven and I are talking about how to
> implement it to let other filesystems can use this mechanism directly to
> do their accouting. If you have some suggestions, feel free to tell me.
> 
> Regards,
> Zheng
> 

Hi,

I think Aditya's patch is a reasonable solution to part of the problem.
Having said that, I'm much more worried about how the info gets passed
via the block layer to blktrace. One possible solution is that a number
of the REQ flags are used only in certain places, so it might be
possible to split those into a separate field or something like that, in
order to avoid changing the submit_bh() interface. Resolving this issue
is really the tricky problem here, once thats done, the rest should be
relatively simple.

Looking at blk_types.h, a large number of those flags are listed as:

        /* request only flags */
        __REQ_SORTED,           /* elevator knows about this request */
        __REQ_SOFTBARRIER,      /* may not be passed by ioscheduler */
etc.

which I suspect are used only at lower layers of the block layer, so
they would potentially be available for use at submit_bh time, even if
they were then split out to a separate variable in the bio/request.

There is also the issue of what happens when requests containing
different fs objects get merged. I'd be tempted to just OR the info
together. A more tricky problem is if such requests/bios then got split
again. I think we'd just have to take the hit on accuracy and copy the
same info to both parts of the split request/bio, otherwise it would
become too complicated.

It should then be possible, given a few spare flags to use, to add some
generic flags, perhaps:

REQ_SB
REQ_INODE
REQ_INDIRECT
REQ_XATTR
REQ_JOURNAL

would be a minimum set, plus say:

REQ_FSPRIV1
REQ_FSPRIV2

for fs specific use. I've copied in Jens to see if he has some
suggestions on a good way forward here,

Steve.


