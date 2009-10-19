From: Mingming <cmm@us.ibm.com>
Subject: Re: ext4 DIO read performance issue on SSD
Date: Mon, 19 Oct 2009 12:04:51 -0700
Message-ID: <1255979091.4257.3.camel@mingming-laptop>
References: <5df78e1d0910091634q22e6a372g3738b0d9e9d0e6c9@mail.gmail.com>
	 <1255546117.4377.62.camel@mingming-laptop>
	 <5df78e1d0910141248h1f537863n97991585e6147ca7@mail.gmail.com>
	 <1255553852.4377.63.camel@mingming-laptop>
	 <5df78e1d0910141442g680edac9m6bce0f9eb21f8ea6@mail.gmail.com>
	 <1255627645.4377.1109.camel@mingming-laptop>
	 <5df78e1d0910151827r7b6a9359mac6541833884c3d2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Michael Rubin <mrubin@google.com>,
	Manuel Benitez <rickyb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:43018 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132AbZJUWsD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Oct 2009 18:48:03 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e38.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n9LMhjYF011938
	for <linux-ext4@vger.kernel.org>; Wed, 21 Oct 2009 16:43:45 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9LMm3M2148568
	for <linux-ext4@vger.kernel.org>; Wed, 21 Oct 2009 16:48:03 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n9LMm0Lw009783
	for <linux-ext4@vger.kernel.org>; Wed, 21 Oct 2009 16:48:01 -0600
In-Reply-To: <5df78e1d0910151827r7b6a9359mac6541833884c3d2@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2009-10-15 at 18:27 -0700, Jiaying Zhang wrote:
> Thinking about this again, I think there is another benefit to always
> allocate uninitialized blocks first in all kinds of write, including
> size-extending write.
> 
> Currently, we avoid exposing stale data during size-extending
> write by adding the inode to the orphan list before changing the
> file size. 

Jan kara corrected me on this misunderstanding before. The orphan list
in the direct IO code is there to trim the inode to the original size if
the system/fs crash in the middle of expanding a file. The file won't
get size updated until all the IO is completed.

The ordeded journal mode is there to avoid exposing stale data during
the size extending write.

> This helps us with journaled ext4 because the journal
> guarantees that the on-disk orphan list will be updated first before
> data is written to disk and i_size is updated. But with non-journal ext4,
> we don't update orphan list during size-extending write because
> without a journal, there is no guarantee on the ordering of writes to disk.
> So if the system crashes after the on-disk i_size is updated but before
> data hits to disk (this is rare but can happen during fsync), we may
> end up exposing stale data with non-journal ext4.
> 
> I think allocating uninitialized extend first during such size-extending
> write and then converting the extend into initialized during end_io
> time can help close this security hole with non-journal ext4.
> 
> Any thoughts on this?
> 

Probably true, something similar to data=guarded mode.
> Jiaying
> On Thu, Oct 15, 2009 at 10:27 AM, Mingming <cmm@us.ibm.com> wrote:
> > On Wed, 2009-10-14 at 14:42 -0700, Jiaying Zhang wrote:
> >> On Wed, Oct 14, 2009 at 1:57 PM, Mingming <cmm@us.ibm.com> wrote:
> >> > On Wed, 2009-10-14 at 12:48 -0700, Jiaying Zhang wrote:
> >> >> On Wed, Oct 14, 2009 at 11:48 AM, Mingming <cmm@us.ibm.com> wrote:
> >> >> > On Fri, 2009-10-09 at 16:34 -0700, Jiaying Zhang wrote:
> >> >> >> Hello,
> >> >> >>
> >> >> >> Recently, we are evaluating the ext4 performance on a high speed SSD.
> >> >> >> One problem we found is that ext4 performance doesn't scale well with
> >> >> >> multiple threads or multiple AIOs reading a single file with O_DIRECT.
> >> >> >> E.g., with 4k block size, multiple-thread DIO AIO random read on ext4
> >> >> >> can lose up to 50% throughput compared to the results we get via RAW IO.
> >> >> >>
> >> >> >> After some initial analysis, we think the ext4 performance problem is caused
> >> >> >> by the use of i_mutex lock during DIO read. I.e., during DIO read, we grab
> >> >> >> the i_mutex lock in __blockdev_direct_IO because ext4 uses the default
> >> >> >> DIO_LOCKING from the generic fs code. I did a quick test by calling
> >> >> >> blockdev_direct_IO_no_locking() in ext4_direct_IO() and I saw ext4 DIO read
> >> >> >> got 99% performance as raw IO.
> >> >> >>
> >> >> >
> >> >> > This is very interesting...and impressive number.
> >> >> >
> >> >> > I tried to change ext4 to call blockdev_direct_IO_no_locking() directly,
> >> >> > but then realize that we can't do this all the time, as ext4 support
> >> >> > ext3 non-extent based files, and uninitialized extent is not support on
> >> >> > ext3 format file.
> >> >> >
> >> >> >> As we understand, the reason why we want to take i_mutex lock during DIO
> >> >> >> read is to prevent it from accessing stale data that may be exposed by a
> >> >> >> simultaneous write. We saw that Mingming Cao has implemented a patch set
> >> >> >> with which when a get_block request comes from direct write, ext4 only
> >> >> >> allocates or splits an uninitialized extent. That uninitialized extent
> >> >> >> will be marked as initialized at the end_io callback.
> >> >> >
> >> >> > Though I need to clarify that with all the patches in mainline, we only
> >> >> > treat new allocated blocks form direct io write to holes, not to writes
> >> >> > to the end of file. I actually have proposed to treat the write to the
> >> >> > end of file also as unintialized extents, but there is some concerns
> >> >> > that this getting tricky with updating inode size when it is async IO
> >> >> > direct IO. So it didn't getting done yet.
> >> >> >
> >> >> >>  We are wondering
> >> >> >> whether we can extend this idea to buffer write as well. I.e., we always
> >> >> >> allocate an uninitialized extent first during any write and convert it
> >> >> >> as initialized at the time of end_io callback. This will eliminate the need
> >> >> >> to hold i_mutex lock during direct read because a DIO read should never get
> >> >> >> a block marked initialized before the block has been written with new data.
> >> >> >>
> >> >> >
> >> >> > Oh I don't think so. For buffered IO, the data is being copied to
> >> >> > buffer, direct IO read would first flush what's in page cache to disk,
> >> >>
> >> >> Hmm, do you mean the filemap_write_and_wait_range() in
> >> >> __blockdev_direct_IO?
> >> >
> >> > yes, that's the one to flush the page cache before direct read.
> >> >
> >> I don't think that function is called with DIO_NO_LOCKING.
> >
> > Oh, I mean the filemap_write_and_wait_range() in generic_file_aio_read()
> >
> >> Also, if we no longer hold i_mutex lock during dio read, I think
> >> there is a time window that a buffer write can allocate an
> >> initialize block after dio read flushes page cache but
> >> before it calls get_block. Then that dio read can get that
> >> initialized block with stale data.
> >>
> >
> > ah, I think it over, the key is prevent get_block() expose initialized
> > extent to direct read. concurrent buffered write to hole could result in
> > get_block() allocate blocks before direct IO read. That could be
> > addressed in a similar way we did for async direct IO write to hole...
> >> Jiaying
> >>
> >> >> Or do we flush page cache after calling
> >> >> get_block in dio read?
> >> >>
> >> >> Jiaying
> >> >>
> >> >> > then read from disk. So if there is concurrent buffered write and direct
> >> >> > read, removing the i_mutex locks from the direct IO path should still
> >> >> > gurantee the right order, without having to treat buffered allocation
> >> >> > with uninitialized extent/end_io.
> >> >> >
> >> >> > The i_mutex lock, from my understanding, is there to protect direct IO
> >> >> > write to hole and concurrent direct IO read, we should able to remove
> >> >> > this lock for extent based ext4 file.
> >> >> >
> >> >>
> >> >>
> >> >> >> We haven't implemented anything yet because we want to ask here first to
> >> >> >> see whether this proposal makes sense to you.
> >> >> >>
> >> >> >
> >> >> > It does make sense to me.
> >> >> >
> >> >> > Mingming
> >> >> >> Regards,
> >> >> >>
> >> >> >> Jiaying
> >> >> >> --
> >> >> >> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >> >> >> the body of a message to majordomo@vger.kernel.org
> >> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
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
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> >


