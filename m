From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v7.1] block: Coordinate flush requests
Date: Fri, 14 Jan 2011 13:00:17 -0800
Message-ID: <20110114210017.GE27381@tux1.beaverton.ibm.com>
References: <20110113025646.GB27381@tux1.beaverton.ibm.com> <AANLkTi=hF8hwgtx+N-dBNRjoffX7nQmaehkE3PsFpSDq@mail.gmail.com> <20110113074603.GC27381@tux1.beaverton.ibm.com> <AANLkTi=pkM1-91cKULt=5L=cPpTUcR5qqFrbj7Bjtk36@mail.gmail.com>
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
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50558 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab1ANVAU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Jan 2011 16:00:20 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTi=pkM1-91cKULt=5L=cPpTUcR5qqFrbj7Bjtk36@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 14, 2011 at 09:00:22AM +0800, Shaohua Li wrote:
> 2011/1/13 Darrick J. Wong <djwong@us.ibm.com>:
> > On Thu, Jan 13, 2011 at 01:38:55PM +0800, Shaohua Li wrote:
> >> 2011/1/13 Darrick J. Wong <djwong@us.ibm.com>:
> >> > On certain types of storage hardware, flushing the write cache t=
akes a
> >> > considerable amount of time. =A0Typically, these are simple stor=
age systems with
> >> > write cache enabled and no battery to save that cache during a p=
ower failure.
> >> > When we encounter a system with many I/O threads that try to flu=
sh the cache,
> >> > performance is suboptimal because each of those threads issues i=
ts own flush
> >> > command to the drive instead of trying to coordinate the flushes=
, thereby
> >> > wasting execution time.
> >> >
> >> > Instead of each thread initiating its own flush, we now try to d=
etect the
> >> > situation where multiple threads are issuing flush requests. =A0=
The first thread
> >> > to enter blkdev_issue_flush becomes the owner of the flush, and =
all threads
> >> > that enter blkdev_issue_flush before the flush finishes are queu=
ed up to wait
> >> > for the next flush. =A0When that first flush finishes, one of th=
ose sleeping
> >> > threads is woken up to perform the next flush and then wake up t=
he other
> >> > threads which are asleep waiting for the second flush to finish.
> >> >
> >> > In the single-threaded case, the thread will simply issue the fl=
ush and exit.
> >> >
> >> > To test the performance of this latest patch, I created a spread=
sheet
> >> > reflecting the performance numbers I obtained with the same ffsb=
 fsync-happy
> >> > workload that I've been running all along: =A0http://tinyurl.com=
/6xqk5bs
> >> >
> >> > The second tab of the workbook provides easy comparisons of the =
performance
> >> > before and after adding flush coordination to the block layer. =A0=
Variations in
> >> > the runs were never more than about 5%, so the slight performanc=
e increases and
> >> > decreases are negligible. =A0It is expected that devices with lo=
w flush times
> >> > should not show much change, whether the low flush times are due=
 to the lack of
> >> > write cache or the controller having a battery and thereby ignor=
ing the flush
> >> > command.
> >> >
> >> > Notice that the elm3b231_ipr, elm3b231_bigfc, elm3b57, elm3c44_s=
sd,
> >> > elm3c44_sata_wc, and elm3c71_scsi profiles showed large performa=
nce increases
> >> > from flush coordination. =A0These 6 configurations all feature l=
arge write caches
> >> > without battery backups, and fairly high (or at least non-zero) =
average flush
> >> > times, as was discovered when I studied the v6 patch.
> >> >
> >> > Unfortunately, there is one very odd regression: elm3c44_sas. =A0=
This profile is
> >> > a couple of battery-backed RAID cabinets striped together with r=
aid0 on md. =A0I
> >> > suspect that there is some sort of problematic interaction with =
md, because
> >> > running ffsb on the individual hardware arrays produces numbers =
similar to
> >> > elm3c71_extsas. =A0elm3c71_extsas uses the same type of hardware=
 array as does
> >> > elm3c44_sas, in fact.
> >> >
> >> > FYI, the flush coordination patch shows performance improvements=
 both with and
> >> > without Christoph's patch that issues pure flushes directly. =A0=
The spreadsheet
> >> > only captures the performance numbers collected without Christop=
h's patch.
> >> Hi,
> >> can you explain why there is improvement with your patch? If there=
 are
> >> multiple flush, blk_do_flush already has queue for them (the
> >> ->pending_flushes list).
> >
> > With the current code, if we have n threads trying to issue flushes=
, the block
> > layer will issue n flushes one after the other. =A0I think the poin=
t of
> > Christoph's pure-flush patch is to skip the serialization step and =
allow
> > issuing of the n pure flushes in parallel. =A0The point of this pat=
ch is optimize
> > even more aggressively, such that as soon as the system becomes fre=
e to process
> > a pure flush (at time t), all the requests for a pure flush that we=
re created
> > since the last time a pure flush was actually issued can be covered=
 with a
> > single flush issued at time t. =A0In other words, this patch tries =
to reduce the
> > number of pure flushes issued.
> Thanks, but why just doing merge for pure flush? we can merge normal
> flush requests
> with a pure flush request too.
>=20
> +               complete_all(&new_flush->ready);
> +               spin_unlock(&disk->flush_flag_lock);
>=20
> -       bio_put(bio);
> +               complete_all(&flush->finish);
> this seems can't guarantee the second waiter runs after the first
> waiter, am I missing anything?

The first complete_all wakes up the thread that starts the next flush. =
 The
second complete_all wakes up the threads that were waiting to hear the =
results
of the flush issued by the current thread.  The second set of wakeups c=
an
happen in parallel with that first wakeup since they're tied to differe=
nt flush
contexts.

Maybe a simpler way to express that is that first waiter is the thread =
that is
woken up by the first complete_all.  That first waiter then executes th=
e flush
and then executes the second complete_all, thereby waking up the second=
 waiter.
That's how the second waiter only runs after the first waiter has finis=
hed the
flush.  After the point where either waiter can be running, the only ta=
sks left
to do are to collect the flush return code and to clean up, and that pa=
rt can
happen in any order.

> it appears we can easily implement this in blk_do_flush, I had
> something at my hand too, passed test but no data yet.

> Task1: ...FS.....C
> Task2: ....F......S...C
> Task3: ......F.........S..C
> F means a flush is queued, S means a flush is dispatched, C means the=
 flush
> is completed. In above, when Task2's flush is completed, we actually =
can
> make Task3 flush complete, as Task2's flush is dispatched after Task3=
's flush
> is queued. With the same reason, we can't merge Task2 and Task3's flu=
sh with
> Task1's.

Conceptually this seems to make sense.  I gave your patch a spin with
fsync-happy ffsb.  It ran ok for about 15 minutes but then the machine =
locked
hard when I ran mkfs on a different device.  I'll try to reproduce it a=
nd
capture the machine state, and when I do I'll report back.

--D
> ---
>  block/blk-core.c       |    1 +
>  block/blk-flush.c      |   24 ++++++++++++++++++++++++
>  include/linux/blkdev.h |    2 ++
>  3 files changed, 27 insertions(+)
>=20
> Index: linux/block/blk-core.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/block/blk-core.c	2011-01-13 21:02:24.000000000 +0800
> +++ linux/block/blk-core.c	2011-01-13 21:43:03.000000000 +0800
> @@ -128,6 +128,7 @@ void blk_rq_init(struct request_queue *q
>  	rq->ref_count =3D 1;
>  	rq->start_time =3D jiffies;
>  	set_start_time_ns(rq);
> +	rq->next_batched_flush =3D NULL;
>  }
>  EXPORT_SYMBOL(blk_rq_init);
> =20
> Index: linux/block/blk-flush.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/block/blk-flush.c	2011-01-13 21:02:24.000000000 +0800
> +++ linux/block/blk-flush.c	2011-01-14 08:22:56.000000000 +0800
> @@ -42,8 +42,18 @@ static struct request *blk_flush_complet
>  		/* not complete yet, queue the next flush sequence */
>  		next_rq =3D queue_next_fseq(q);
>  	} else {
> +		struct request *tmp_rq =3D q->orig_flush_rq->next_batched_flush;
> +		struct request *tmp_rq2;
> +		sector_t error_sector =3D q->orig_flush_rq->bio->bi_sector;
> +
>  		/* complete this flush request */
>  		__blk_end_request_all(q->orig_flush_rq, q->flush_err);
> +		while (tmp_rq) {
> +			tmp_rq2 =3D tmp_rq->next_batched_flush;
> +			tmp_rq->bio->bi_sector =3D error_sector;
> +			__blk_end_request_all(tmp_rq, q->flush_err);
> +			tmp_rq =3D tmp_rq2;
> +		}
>  		q->orig_flush_rq =3D NULL;
>  		q->flush_seq =3D 0;
> =20
> @@ -164,6 +174,20 @@ struct request *blk_do_flush(struct requ
>  	 * processing.
>  	 */
>  	if (q->flush_seq) {
> +		struct request *tmp_rq;
> +
> +		if ((rq->cmd_flags & REQ_FUA) || blk_rq_sectors(rq))
> +			goto add_list;
> +		list_for_each_entry(tmp_rq, &q->pending_flushes, queuelist) {
> +			if (tmp_rq->cmd_flags & REQ_FLUSH) {
> +				rq->next_batched_flush =3D
> +					tmp_rq->next_batched_flush;
> +				tmp_rq->next_batched_flush =3D rq;
> +				list_del_init(&rq->queuelist);
> +				return NULL;
> +			}
> +		}
> +add_list:
>  		list_move_tail(&rq->queuelist, &q->pending_flushes);
>  		return NULL;
>  	}
> Index: linux/include/linux/blkdev.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/include/linux/blkdev.h	2011-01-13 21:02:24.000000000 +=
0800
> +++ linux/include/linux/blkdev.h	2011-01-13 21:43:03.000000000 +0800
> @@ -163,6 +163,8 @@ struct request {
> =20
>  	/* for bidi */
>  	struct request *next_rq;
> +
> +	struct request *next_batched_flush;
>  };
> =20
>  static inline unsigned short req_get_ioprio(struct request *req)

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
