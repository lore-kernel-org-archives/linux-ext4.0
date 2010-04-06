From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [patch/rft] jbd2: tag journal writes as metadata I/O
Date: Tue, 6 Apr 2010 14:25:27 -0400
Message-ID: <20100406182527.GF3029@redhat.com>
References: <x49iq8b9ep5.fsf@segfault.boston.devel.redhat.com> <20100401194822.GA8401@atrey.karlin.mff.cuni.cz> <x49tyrpkjmq.fsf@segfault.boston.devel.redhat.com> <20100405174603.GA24493@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: tytso@mit.edu, Jeff Moyer <jmoyer@redhat.com>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
	esandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757428Ab0DFS06 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Apr 2010 14:26:58 -0400
Content-Disposition: inline
In-Reply-To: <20100405174603.GA24493@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 05, 2010 at 01:46:03PM -0400, vivek.goyal2008@gmail.com wrote:
> On Mon, Apr 05, 2010 at 11:24:13AM -0400, Jeff Moyer wrote:
> > Jan Kara <jack@suse.cz> writes:
> > 
> > >   Hi,
> > >
> > >> In running iozone for writes to small files, we noticed a pretty big
> > >> discrepency between the performance of the deadline and cfq I/O
> > >> schedulers.  Investigation showed that I/O was being issued from 2
> > >> different contexts: the iozone process itself, and the jbd2/sdh-8 thread
> > >> (as expected).  Because of the way cfq performs slice idling, the delays
> > >> introduced between the metadata and data I/Os were significant.  For
> > >> example, cfq would see about 7MB/s versus deadline's 35 for the same
> > >> workload.  I also tested fs_mark with writing and fsyncing 1000 64k
> > >> files, and a similar 5x performance difference was observed.  Eric
> > >> Sandeen suggested that I flag the journal writes as metadata, and once I
> > >> did that, the performance difference went away completely (cfq has
> > >> special logic to prioritize metadata I/O).
> > >> 
> > >> So, I'm submitting this patch for comments and testing.  I have a
> > >> similar patch for jbd that I will submit if folks agree that this is a
> > >> good idea.
> > >   This looks like a good idea to me. I'd just be careful about data=journal
> > > mode where even data is written via journal and thus you'd incorrectly
> > > prioritize all the IO. I suppose that could have negative impact on performace
> > > of other filesystems on the same disk. So for data=journal mode, I'd leave
> > > write_op to be just WRITE / WRITE_SYNC_PLUG.
> > 
> > Hi, Jan, thanks for the review!  I'm trying to figure out the best way
> > to relay the journal mode from ext3 or ext4 to jbd or jbd2.  Would a new
> > journal flag, set in journal_init_inode, be appropriate?  This wouldn't
> > cover the case of data journalling set per inode, though.  It also puts
> > some ext3-specific code into the purportedly fs-agnostic jbd code
> > (specifically, testing the superblock for the data journal mount flag).
> > Do you have any suggestions?
> 
> I don't think it's necessary to worry about journal=data mode.  First
> of all, it's not true that all of the I/O would be prioritized as
> metadata.  In data=journal mode, data blocks are written twice; once
> to the journal, and once to the final location on disk.  And the
> journal writes do need to be prioritized because the commit can't go
> out until all of the preceeding journal blocks have been written.  So
> treating all of the journal writes as metadata for the the purposes of
> cfq's prioritization makes sense to me....
> 

CFQ currently seems to be preempting any thread doing IO if a request has
been marked as metadata. I think this is going to be bad for any other IO
going on.

I wrote a small fio script which is doing buffered writes with bs=32K and I
am doing fsync on file after every 20 IOs (fsync=20). I am assuming that this
something close to writting a small file and then doing fsync on that. 

With that fio script running I launched firefox and measured the time it
takes.

Without patch
=============
real    0m13.141s
user    0m0.588s
sys     0m0.164s

real    0m11.859s
user    0m0.580s
sys     0m0.163s

real    0m13.384s
user    0m0.587s
sys     0m0.163s

With patch
==========
real    0m25.986s
user    0m0.627s
sys     0m0.150s

real    0m29.582s
user    0m0.623s
sys     0m0.156s

real    0m25.898s
user    0m0.587s
sys     0m0.160s

So it looks like that firefox launching times have seems to just almost doubled.

My fio script looks like as follows.

*******************************************
[global]
directory=/root/fio/
ioscheduler=cfq
size=1G
group_reporting=1
bs=32K
exec_prerun='echo 3 > /proc/sys/vm/drop_caches'

[iostest]
numjobs=1
new_group=1
rw=write
fsync=20
**********************************************

Thanks
Vivek

> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
