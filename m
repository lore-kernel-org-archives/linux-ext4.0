From: Mingming <cmm@us.ibm.com>
Subject: Re: ext4 DIO read performance issue on SSD
Date: Mon, 19 Oct 2009 13:23:09 -0700
Message-ID: <1255983789.4257.82.camel@mingming-laptop>
References: <5df78e1d0910091634q22e6a372g3738b0d9e9d0e6c9@mail.gmail.com>
	 <1255546117.4377.62.camel@mingming-laptop>
	 <5df78e1d0910142214s51a4db0and358fc432225338b@mail.gmail.com>
	 <1255627868.4377.1113.camel@mingming-laptop>
	 <5df78e1d0910151307p342a0c71x5413fad2202a1daa@mail.gmail.com>
	 <1255649304.4377.1155.camel@mingming-laptop>
	 <5df78e1d0910151633s54ef6bb5pe1957eb0cf33eff6@mail.gmail.com>
	 <1255719403.4377.1168.camel@mingming-laptop>
	 <5df78e1d0910161244s3f47fe02s1ede2093b8aeacbf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@google.com>,
	Michael Rubin <mrubin@google.com>,
	Manuel Benitez <rickyb@google.com>
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:49866 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141AbZJUWsF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Oct 2009 18:48:05 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e32.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n9LMh7OV000572
	for <linux-ext4@vger.kernel.org>; Wed, 21 Oct 2009 16:43:07 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9LMm5mg169440
	for <linux-ext4@vger.kernel.org>; Wed, 21 Oct 2009 16:48:05 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n9LMm2hC009847
	for <linux-ext4@vger.kernel.org>; Wed, 21 Oct 2009 16:48:02 -0600
In-Reply-To: <5df78e1d0910161244s3f47fe02s1ede2093b8aeacbf@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2009-10-16 at 12:44 -0700, Jiaying Zhang wrote:
> On Fri, Oct 16, 2009 at 11:56 AM, Mingming <cmm@us.ibm.com> wrote:
> > On Thu, 2009-10-15 at 16:33 -0700, Jiaying Zhang wrote:
> >> On Thu, Oct 15, 2009 at 4:28 PM, Mingming <cmm@us.ibm.com> wrote:
> >> > On Thu, 2009-10-15 at 13:07 -0700, Jiaying Zhang wrote:
> >> >> On Thu, Oct 15, 2009 at 10:31 AM, Mingming <cmm@us.ibm.com> wrote:
> >> >> > On Wed, 2009-10-14 at 22:14 -0700, Jiaying Zhang wrote:
> >> >> >> Mingming,
> >> >> >>
> >> >> >
> >> >> > Hi Jiaying,
> >> >> >
> >> >> >> On Wed, Oct 14, 2009 at 11:48 AM, Mingming <cmm@us.ibm.com> wrote:
> >> >> >> > On Fri, 2009-10-09 at 16:34 -0700, Jiaying Zhang wrote:
> >> >> >> >> Hello,
> >> >> >> >>
> >> >> >> >> Recently, we are evaluating the ext4 performance on a high speed SSD.
> >> >> >> >> One problem we found is that ext4 performance doesn't scale well with
> >> >> >> >> multiple threads or multiple AIOs reading a single file with O_DIRECT.
> >> >> >> >> E.g., with 4k block size, multiple-thread DIO AIO random read on ext4
> >> >> >> >> can lose up to 50% throughput compared to the results we get via RAW IO.
> >> >> >> >>
> >> >> >> >> After some initial analysis, we think the ext4 performance problem is caused
> >> >> >> >> by the use of i_mutex lock during DIO read. I.e., during DIO read, we grab
> >> >> >> >> the i_mutex lock in __blockdev_direct_IO because ext4 uses the default
> >> >> >> >> DIO_LOCKING from the generic fs code. I did a quick test by calling
> >> >> >> >> blockdev_direct_IO_no_locking() in ext4_direct_IO() and I saw ext4 DIO read
> >> >> >> >> got 99% performance as raw IO.
> >> >> >> >>
> >> >> >> >
> >> >> >> > This is very interesting...and impressive number.
> >> >> >> >
> >> >> >> > I tried to change ext4 to call blockdev_direct_IO_no_locking() directly,
> >> >> >> > but then realize that we can't do this all the time, as ext4 support
> >> >> >> > ext3 non-extent based files, and uninitialized extent is not support on
> >> >> >> > ext3 format file.
> >> >> >> >
> >> >> >> >> As we understand, the reason why we want to take i_mutex lock during DIO
> >> >> >> >> read is to prevent it from accessing stale data that may be exposed by a
> >> >> >> >> simultaneous write. We saw that Mingming Cao has implemented a patch set
> >> >> >> >> with which when a get_block request comes from direct write, ext4 only
> >> >> >> >> allocates or splits an uninitialized extent. That uninitialized extent
> >> >> >> >> will be marked as initialized at the end_io callback.
> >> >> >> >
> >> >> >> > Though I need to clarify that with all the patches in mainline, we only
> >> >> >> > treat new allocated blocks form direct io write to holes, not to writes
> >> >> >> > to the end of file. I actually have proposed to treat the write to the
> >> >> >> > end of file also as unintialized extents, but there is some concerns
> >> >> >> > that this getting tricky with updating inode size when it is async IO
> >> >> >> > direct IO. So it didn't getting done yet.
> >> >> >>
> >> >> >> I read you previous email thread again. As I understand, the main
> >> >> >> concern for allocating uninitialized blocks in i_size extending write
> >> >> >> is that we may end up having uninitialized blocks beyond i_size
> >> >> >> if the system crashes during write. Can we protect this case by
> >> >> >> adding the inode into the orphan list in ext4_ext_direct_IO,
> >> >> >> i.e., same as we have done in ext4_ind_direct_IO?
> >> >> >>
> >> >> >
> >> >> > Sure we could do that, though initially I hoped we could get rid of
> >> >> > that:)
> >> >> >
> >> >> > The tricky part is async direct write to the end of file. By the time
> >> >> > the IO is completed, the inode may be truncated or extended larger.
> >> >> > Updating the most "safe" size is the part I haven't thought through yet.
> >> >> >
> >> >>
> >> >> Ok. I think I understand the problem better now :).
> >> >>
> >> >> Looking at the __blockdev_direct_IO(), I saw it actually treats
> >> >> size-extending aio dio write as synchronous and expects the dio to
> >> >> complete before return (fs/direct-io.c line 1204 and line 1056-1061).
> >> >
> >> > Oh? It seems it will keep the write async as long as it's not a partial
> >> > write
> >> >        /*
> >> >         * The only time we want to leave bios in flight is when a successful
> >> >         * partial aio read or full aio write have been setup.  In that case
> >> >         * bio completion will call aio_complete.  The only time it's safe to
> >> >         * call aio_complete is when we return -EIOCBQUEUED, so we key on that.
> >> >         * This had *better* be the only place that raises -EIOCBQUEUED.
> >> >         */
> >> >        BUG_ON(ret == -EIOCBQUEUED);
> >> >        if (dio->is_async && ret == 0 && dio->result &&
> >> >            ((rw & READ) || (dio->result == dio->size)))
> >> >                ret = -EIOCBQUEUED;
> >> >
> >> >        if (ret != -EIOCBQUEUED)
> >> >                dio_await_completion(dio);
> >> >
> >>
> >> If I read the code correctly, dio->is_async is not set for file extending write:
> >>
> >>         /*
> >>          * For file extending writes updating i_size before data
> >>          * writeouts complete can expose uninitialized blocks. So
> >>          * even for AIO, we need to wait for i/o to complete before
> >>          * returning in this case.
> >>          */
> >>         dio->is_async = !is_sync_kiocb(iocb) && !((rw & WRITE) &&
> >>                 (end > i_size_read(inode)));
> >>
> >
> > Ah... that's a little surprise to know. Async write to the end of file
> > is actually synchonous. That explains why ext3 async direct IO could
> > always expand inode i_size safely without having to worry about expose
> > stale data out.
> >
> > It would be better to fix this with end_io callback, user expects get
> > higher performance via async mode.
> >
> > But, these are seperate from removing i_mutex lock from direct IO read,
> > IMHO. The dio write to end of file won't extend inode size until the IO
> > is completed (AIO or non AIO mode). So if we remove the i_mutex lock
> > from the dio read,  in the case of parallel dio/buffered write to end of
> > file and direct io read, it won't expose updated inode's block mapping
> > tree to parallel direct IO read, as the i_size hasn't been changed yet.
> >
> > The only concern to remove the the lock from dio read path, is the
> > buffered write to the hole. Isn't it?
> >
> 
> Hmm. Will we be safe between dio read and size-extending buffer
> write if we don't hold i_mutex lock during dio read but still allocating
> initialized blocks in size-extending buffer write? As I understand, we
> update file size in ext4_write_end. The buffer write have finished at
> this time but the changes are still in memory. Currently, we prevent
> dio read from reading stale data by calling filemap_write_and_wait_range()
> after holding the i_mutex lock in __blockdev_direct_IO(). If we no
> longer hold i_mutex during dio read, a buffer write can finish after
> a dio read calls filemap_write_and_wait_range() but before it calls
> get_block(). At the time that dio read calls get_block(), the i_size
> of the file has been updated, but the written data is still in memory,
> so it may read stale data.
> 

If the page was dirtied after the direct read calling
filemap_write_and_wait_range(), then yes, there is window that file gets
extended and direct read sees the blocks being allocated. This window is
very smaller with delayed allocation, as data write out and and
allocation happens at the same time. 

If the page was dirtied (ie. buffered write to that file) before the
direct IO read, filemap_write_and_wait_range() will write out that dirty
page and ensure block allocation/i_size happen all complete before get
back to direct IO read.

> I was thinking that we may change to call filemap_write_and_wait_range()
> after get_block() during dio read. This seems to eliminate the above
> problem. 
 That would impact the performance, I think.

> However, I am also worried about non-journal ext4. With the
> current code, I think there is a chance that we can expose stale data
> after reboot if the system crashed at a bad time. I think always
> converting uninitialized blocks to initialized during end_io time may
> help to close this security hole in non-journal ext4.
> 
> Jiaying
> 
> >> Jiaying
> >>
> >> >> Can we follow the same rule and check whether it is a size-extending
> >> >> aio write in ext4_end_io_dio()? In such cases, we can call
> >> >> ext4_end_aio_dio_nolock() synchronously instead of queuing
> >> >> the work. I think this will protect us from truncate because we
> >> >> are still holding i_mutex and i_alloc_sem.
> >> >>
> >> >> Jiaying
> >> >>
> >> >> >
> >> >> >
> >> >> >> Jiaying
> >> >> >>
> >> >> >> >
> >> >> >> >>  We are wondering
> >> >> >> >> whether we can extend this idea to buffer write as well. I.e., we always
> >> >> >> >> allocate an uninitialized extent first during any write and convert it
> >> >> >> >> as initialized at the time of end_io callback. This will eliminate the need
> >> >> >> >> to hold i_mutex lock during direct read because a DIO read should never get
> >> >> >> >> a block marked initialized before the block has been written with new data.
> >> >> >> >>
> >> >> >> >
> >> >> >> > Oh I don't think so. For buffered IO, the data is being copied to
> >> >> >> > buffer, direct IO read would first flush what's in page cache to disk,
> >> >> >> > then read from disk. So if there is concurrent buffered write and direct
> >> >> >> > read, removing the i_mutex locks from the direct IO path should still
> >> >> >> > gurantee the right order, without having to treat buffered allocation
> >> >> >> > with uninitialized extent/end_io.
> >> >> >> >
> >> >> >> > The i_mutex lock, from my understanding, is there to protect direct IO
> >> >> >> > write to hole and concurrent direct IO read, we should able to remove
> >> >> >> > this lock for extent based ext4 file.
> >> >> >> >
> >> >> >> >> We haven't implemented anything yet because we want to ask here first to
> >> >> >> >> see whether this proposal makes sense to you.
> >> >> >> >>
> >> >> >> >
> >> >> >> > It does make sense to me.
> >> >> >> >
> >> >> >> > Mingming
> >> >> >> >> Regards,
> >> >> >> >>
> >> >> >> >> Jiaying
> >> >> >> >> --
> >> >> >> >> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >> >> >> >> the body of a message to majordomo@vger.kernel.org
> >> >> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> >> >> >
> >> >> >> >
> >> >> >> >
> >> >> >
> >> >> >
> >> >> >
> >> >> --
> >> >> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >> >> the body of a message to majordomo@vger.kernel.org
> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> >
> >> >
> >> >
> >
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


