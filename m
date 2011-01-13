From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v7.1] block: Coordinate flush requests
Date: Wed, 12 Jan 2011 23:46:03 -0800
Message-ID: <20110113074603.GC27381@tux1.beaverton.ibm.com>
References: <20110113025646.GB27381@tux1.beaverton.ibm.com> <AANLkTi=hF8hwgtx+N-dBNRjoffX7nQmaehkE3PsFpSDq@mail.gmail.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
	Neil Brown <neilb@suse.de>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>, Tejun Heo <tj@kernel.org>,
	linux-ext4@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@redhat.com>
To: Shaohua Li <shli@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41482 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab1AMHqN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Jan 2011 02:46:13 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTi=hF8hwgtx+N-dBNRjoffX7nQmaehkE3PsFpSDq@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 13, 2011 at 01:38:55PM +0800, Shaohua Li wrote:
> 2011/1/13 Darrick J. Wong <djwong@us.ibm.com>:
> > On certain types of storage hardware, flushing the write cache take=
s a
> > considerable amount of time. =A0Typically, these are simple storage=
 systems with
> > write cache enabled and no battery to save that cache during a powe=
r failure.
> > When we encounter a system with many I/O threads that try to flush =
the cache,
> > performance is suboptimal because each of those threads issues its =
own flush
> > command to the drive instead of trying to coordinate the flushes, t=
hereby
> > wasting execution time.
> >
> > Instead of each thread initiating its own flush, we now try to dete=
ct the
> > situation where multiple threads are issuing flush requests. =A0The=
 first thread
> > to enter blkdev_issue_flush becomes the owner of the flush, and all=
 threads
> > that enter blkdev_issue_flush before the flush finishes are queued =
up to wait
> > for the next flush. =A0When that first flush finishes, one of those=
 sleeping
> > threads is woken up to perform the next flush and then wake up the =
other
> > threads which are asleep waiting for the second flush to finish.
> >
> > In the single-threaded case, the thread will simply issue the flush=
 and exit.
> >
> > To test the performance of this latest patch, I created a spreadshe=
et
> > reflecting the performance numbers I obtained with the same ffsb fs=
ync-happy
> > workload that I've been running all along: =A0http://tinyurl.com/6x=
qk5bs
> >
> > The second tab of the workbook provides easy comparisons of the per=
formance
> > before and after adding flush coordination to the block layer. =A0V=
ariations in
> > the runs were never more than about 5%, so the slight performance i=
ncreases and
> > decreases are negligible. =A0It is expected that devices with low f=
lush times
> > should not show much change, whether the low flush times are due to=
 the lack of
> > write cache or the controller having a battery and thereby ignoring=
 the flush
> > command.
> >
> > Notice that the elm3b231_ipr, elm3b231_bigfc, elm3b57, elm3c44_ssd,
> > elm3c44_sata_wc, and elm3c71_scsi profiles showed large performance=
 increases
> > from flush coordination. =A0These 6 configurations all feature larg=
e write caches
> > without battery backups, and fairly high (or at least non-zero) ave=
rage flush
> > times, as was discovered when I studied the v6 patch.
> >
> > Unfortunately, there is one very odd regression: elm3c44_sas. =A0Th=
is profile is
> > a couple of battery-backed RAID cabinets striped together with raid=
0 on md. =A0I
> > suspect that there is some sort of problematic interaction with md,=
 because
> > running ffsb on the individual hardware arrays produces numbers sim=
ilar to
> > elm3c71_extsas. =A0elm3c71_extsas uses the same type of hardware ar=
ray as does
> > elm3c44_sas, in fact.
> >
> > FYI, the flush coordination patch shows performance improvements bo=
th with and
> > without Christoph's patch that issues pure flushes directly. =A0The=
 spreadsheet
> > only captures the performance numbers collected without Christoph's=
 patch.
> Hi,
> can you explain why there is improvement with your patch? If there ar=
e
> multiple flush, blk_do_flush already has queue for them (the
> ->pending_flushes list).

With the current code, if we have n threads trying to issue flushes, th=
e block
layer will issue n flushes one after the other.  I think the point of
Christoph's pure-flush patch is to skip the serialization step and allo=
w
issuing of the n pure flushes in parallel.  The point of this patch is =
optimize
even more aggressively, such that as soon as the system becomes free to=
 process
a pure flush (at time t), all the requests for a pure flush that were c=
reated
since the last time a pure flush was actually issued can be covered wit=
h a
single flush issued at time t.  In other words, this patch tries to red=
uce the
number of pure flushes issued.

--D
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
