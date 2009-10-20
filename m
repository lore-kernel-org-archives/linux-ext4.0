From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: ext4 DIO read performance issue on SSD
Date: Mon, 19 Oct 2009 18:26:38 -0700
Message-ID: <5df78e1d0910191826k516cc410h88e26371d4a11edc@mail.gmail.com>
References: <1255546117.4377.62.camel@mingming-laptop>
	 <5df78e1d0910141248h1f537863n97991585e6147ca7@mail.gmail.com>
	 <1255553852.4377.63.camel@mingming-laptop>
	 <5df78e1d0910141442g680edac9m6bce0f9eb21f8ea6@mail.gmail.com>
	 <1255627645.4377.1109.camel@mingming-laptop>
	 <5df78e1d0910151827r7b6a9359mac6541833884c3d2@mail.gmail.com>
	 <5df78e1d0910091634q22e6a372g3738b0d9e9d0e6c9@mail.gmail.com>
	 <20091016191553.GA8013@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@google.com>,
	Michael Rubin <mrubin@google.com>,
	Manuel Benitez <rickyb@google.com>, Mingming <cmm@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:27445 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572AbZJTB0j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Oct 2009 21:26:39 -0400
Received: from zps37.corp.google.com (zps37.corp.google.com [172.25.146.37])
	by smtp-out.google.com with ESMTP id n9K1Qfra010760
	for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2009 18:26:42 -0700
Received: from pxi35 (pxi35.prod.google.com [10.243.27.35])
	by zps37.corp.google.com with ESMTP id n9K1QJVK024649
	for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2009 18:26:39 -0700
Received: by pxi35 with SMTP id 35so4125615pxi.2
        for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2009 18:26:38 -0700 (PDT)
In-Reply-To: <20091016191553.GA8013@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted,

Thanks a lot for your reply!

On Fri, Oct 16, 2009 at 12:15 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Fri, Oct 09, 2009 at 04:34:08PM -0700, Jiaying Zhang wrote:
>> Recently, we are evaluating the ext4 performance on a high speed SSD.
>> One problem we found is that ext4 performance doesn't scale well with
>> multiple threads or multiple AIOs reading a single file with O_DIRECT.
>> E.g., with 4k block size, multiple-thread DIO AIO random read on ext4
>> can lose up to 50% throughput compared to the results we get via RAW IO.
>>
>> After some initial analysis, we think the ext4 performance problem is caused
>> by the use of i_mutex lock during DIO read. I.e., during DIO read, we grab
>> the i_mutex lock in __blockdev_direct_IO because ext4 uses the default
>> DIO_LOCKING from the generic fs code. I did a quick test by calling
>> blockdev_direct_IO_no_locking() in ext4_direct_IO() and I saw ext4 DIO read
>> got 99% performance as raw IO.
>
> Your diagnosis makes sense, and the test of using
> blockdev_direct_IO_nol_locking() tends to confirm things, but before
> we start surgery, there's a very easy way of confirming that i_mutex
> is under contention.  Enable CONFIG_LOCK_STAT, do "echo 0> >
> /proc/lock_stat" before running your benchmark, and then capture the
> contents of /proc/lock_stat after running your benchmark.  For more
> information see Documentation/lockstat.txt in the kernel sources.
> It's always nice to grab before and after snapshots, and it's a handy
> way of finding other contention points.
>
I tried lock_stat as you suggested. I did see a lot of contentions
with multiple threads reading a single file via DIO AIO and a large
amount of time was spent on waiting for the i_mutex. I think this
confirms our theory that the use of i_mutex lock during DIO caused
most of the overhead we saw on the ext4 SSD.

>> That uninitialized extent will be marked as initialized at the
>> end_io callback. We are wondering whether we can extend this idea to
>> buffer write as well. I.e., we always allocate an uninitialized
>> extent first during any write and convert it as initialized at the
>> time of end_io callback. This will eliminate the need to hold
>> i_mutex lock during direct read because a DIO read should never get
>> a block marked initialized before the block has been written with
>> new data.
>
> Obviously this will only work for extent-mapped inodes.  So it means
> complicating the callback code somewhat, but in theory, this should
> work.
>
> On Thu, Oct 15, 2009 at 06:27:12PM -0700, Jiaying Zhang wrote:
>> Thinking about this again, I think there is another benefit to always
>> allocate uninitialized blocks first in all kinds of write, including
>> size-extending write.
>>
>> Currently, we avoid exposing stale data during size-extending
>> write by adding the inode to the orphan list before changing the
>> file size. This helps us with journaled ext4 because the journal
>> guarantees that the on-disk orphan list will be updated first before
>> data is written to disk and i_size is updated. But with non-journal ext4,
>> we don't update orphan list during size-extending write because
>> without a journal, there is no guarantee on the ordering of writes to disk.
>> So if the system crashes after the on-disk i_size is updated but before
>> data hits to disk (this is rare but can happen during fsync), we may
>> end up exposing stale data with non-journal ext4.
>
> Actually, that's not quite correct.  That's the plan for how works in
> ext3's guarded mode (which hasn't been merged into mainline nor ported
> to ext4), but in ext3 and ext4's ordered mode the way we avoid
> exposing stale data is by forcing data blocks to disk before the
> commit is allowed to complete.  You're right that either way, it doesn't
> help you if you're not using a journal.  (This is also going to be a
> problem in supporting TRIM/DISCARD, since we are depending on the
> commit mechanism to determine when it's safe to send the TRIM command
> to the block device --- but that's an separate issue.)
>
>> I think allocating uninitialized extend first during such size-extending
>> write and then converting the extend into initialized during end_io
>> time can help close this security hole with non-journal ext4.
>
> Well..... strictly speaking, using end_io won't guarantee that no
> stale data will be avoided, since the end_io callback is called when
> the data has been transfered to the disk controller, and not when data
> has actually be written to iron oxide.  In other words, since there's
> no barrier operation, there are no guarantees on a power drop.  Still,
> it's certainly better than nothing, and it will make things much
> better than they were previously.
>
I agree. It will be hard to eliminate the exposing stale data problem
in the non-journal case with disk buffer cache, but I think it can
help us with SSD, or battery-backed disks.

>
> By the way, something which would be worth testing is making sure that
> direct I/O read racing with a buffered write with delayed allocation
> works correctly today.  What should happen (although it may not be
> what application programmers expect) is that direct I/O read from part
> of a file which has just been written via buffered write with delayed
> allocation enabled and the block has been't been allocated yet, the
> direct I/O read should behave a read from a hole.  (XFS behaves the
> same way; we don't gurantee cache coherence when direct I/O and
> non-direct I/O is mixed.)
>
Hmm, do you mean that if a DIO read happens right after a buffered
write with delayed allocation, it should return zero instead of the data
written by the buffered write?

Jiaying

>                                                        - Ted
>
