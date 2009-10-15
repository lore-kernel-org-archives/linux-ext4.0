From: Mingming <cmm@us.ibm.com>
Subject: Re: ext4 DIO read performance issue on SSD
Date: Thu, 15 Oct 2009 10:31:08 -0700
Message-ID: <1255627868.4377.1113.camel@mingming-laptop>
References: <5df78e1d0910091634q22e6a372g3738b0d9e9d0e6c9@mail.gmail.com>
	 <1255546117.4377.62.camel@mingming-laptop>
	 <5df78e1d0910142214s51a4db0and358fc432225338b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@google.com>,
	Michael Rubin <mrubin@google.com>,
	Manuel Benitez <rickyb@google.com>
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:42782 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758592AbZJORcJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Oct 2009 13:32:09 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e39.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n9FHPixE002164
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2009 11:25:44 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9FHVInD087788
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2009 11:31:20 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n9FHVHFf022954
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2009 11:31:18 -0600
In-Reply-To: <5df78e1d0910142214s51a4db0and358fc432225338b@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2009-10-14 at 22:14 -0700, Jiaying Zhang wrote:
> Mingming,
> 

Hi Jiaying,

> On Wed, Oct 14, 2009 at 11:48 AM, Mingming <cmm@us.ibm.com> wrote:
> > On Fri, 2009-10-09 at 16:34 -0700, Jiaying Zhang wrote:
> >> Hello,
> >>
> >> Recently, we are evaluating the ext4 performance on a high speed SSD.
> >> One problem we found is that ext4 performance doesn't scale well with
> >> multiple threads or multiple AIOs reading a single file with O_DIRECT.
> >> E.g., with 4k block size, multiple-thread DIO AIO random read on ext4
> >> can lose up to 50% throughput compared to the results we get via RAW IO.
> >>
> >> After some initial analysis, we think the ext4 performance problem is caused
> >> by the use of i_mutex lock during DIO read. I.e., during DIO read, we grab
> >> the i_mutex lock in __blockdev_direct_IO because ext4 uses the default
> >> DIO_LOCKING from the generic fs code. I did a quick test by calling
> >> blockdev_direct_IO_no_locking() in ext4_direct_IO() and I saw ext4 DIO read
> >> got 99% performance as raw IO.
> >>
> >
> > This is very interesting...and impressive number.
> >
> > I tried to change ext4 to call blockdev_direct_IO_no_locking() directly,
> > but then realize that we can't do this all the time, as ext4 support
> > ext3 non-extent based files, and uninitialized extent is not support on
> > ext3 format file.
> >
> >> As we understand, the reason why we want to take i_mutex lock during DIO
> >> read is to prevent it from accessing stale data that may be exposed by a
> >> simultaneous write. We saw that Mingming Cao has implemented a patch set
> >> with which when a get_block request comes from direct write, ext4 only
> >> allocates or splits an uninitialized extent. That uninitialized extent
> >> will be marked as initialized at the end_io callback.
> >
> > Though I need to clarify that with all the patches in mainline, we only
> > treat new allocated blocks form direct io write to holes, not to writes
> > to the end of file. I actually have proposed to treat the write to the
> > end of file also as unintialized extents, but there is some concerns
> > that this getting tricky with updating inode size when it is async IO
> > direct IO. So it didn't getting done yet.
> 
> I read you previous email thread again. As I understand, the main
> concern for allocating uninitialized blocks in i_size extending write
> is that we may end up having uninitialized blocks beyond i_size
> if the system crashes during write. Can we protect this case by
> adding the inode into the orphan list in ext4_ext_direct_IO,
> i.e., same as we have done in ext4_ind_direct_IO?
> 

Sure we could do that, though initially I hoped we could get rid of
that:)

The tricky part is async direct write to the end of file. By the time
the IO is completed, the inode may be truncated or extended larger.
Updating the most "safe" size is the part I haven't thought through yet.



> Jiaying
> 
> >
> >>  We are wondering
> >> whether we can extend this idea to buffer write as well. I.e., we always
> >> allocate an uninitialized extent first during any write and convert it
> >> as initialized at the time of end_io callback. This will eliminate the need
> >> to hold i_mutex lock during direct read because a DIO read should never get
> >> a block marked initialized before the block has been written with new data.
> >>
> >
> > Oh I don't think so. For buffered IO, the data is being copied to
> > buffer, direct IO read would first flush what's in page cache to disk,
> > then read from disk. So if there is concurrent buffered write and direct
> > read, removing the i_mutex locks from the direct IO path should still
> > gurantee the right order, without having to treat buffered allocation
> > with uninitialized extent/end_io.
> >
> > The i_mutex lock, from my understanding, is there to protect direct IO
> > write to hole and concurrent direct IO read, we should able to remove
> > this lock for extent based ext4 file.
> >
> >> We haven't implemented anything yet because we want to ask here first to
> >> see whether this proposal makes sense to you.
> >>
> >
> > It does make sense to me.
> >
> > Mingming
> >> Regards,
> >>
> >> Jiaying
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> >


