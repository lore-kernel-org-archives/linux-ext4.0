From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v7.1] block: Coordinate flush requests
Date: Thu, 13 Jan 2011 13:38:55 +0800
Message-ID: <AANLkTi=hF8hwgtx+N-dBNRjoffX7nQmaehkE3PsFpSDq@mail.gmail.com>
References: <20110113025646.GB27381@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62590 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab1AMFi4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Jan 2011 00:38:56 -0500
In-Reply-To: <20110113025646.GB27381@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/1/13 Darrick J. Wong <djwong@us.ibm.com>:
> On certain types of storage hardware, flushing the write cache takes =
a
> considerable amount of time. =A0Typically, these are simple storage s=
ystems with
> write cache enabled and no battery to save that cache during a power =
failure.
> When we encounter a system with many I/O threads that try to flush th=
e cache,
> performance is suboptimal because each of those threads issues its ow=
n flush
> command to the drive instead of trying to coordinate the flushes, the=
reby
> wasting execution time.
>
> Instead of each thread initiating its own flush, we now try to detect=
 the
> situation where multiple threads are issuing flush requests. =A0The f=
irst thread
> to enter blkdev_issue_flush becomes the owner of the flush, and all t=
hreads
> that enter blkdev_issue_flush before the flush finishes are queued up=
 to wait
> for the next flush. =A0When that first flush finishes, one of those s=
leeping
> threads is woken up to perform the next flush and then wake up the ot=
her
> threads which are asleep waiting for the second flush to finish.
>
> In the single-threaded case, the thread will simply issue the flush a=
nd exit.
>
> To test the performance of this latest patch, I created a spreadsheet
> reflecting the performance numbers I obtained with the same ffsb fsyn=
c-happy
> workload that I've been running all along: =A0http://tinyurl.com/6xqk=
5bs
>
> The second tab of the workbook provides easy comparisons of the perfo=
rmance
> before and after adding flush coordination to the block layer. =A0Var=
iations in
> the runs were never more than about 5%, so the slight performance inc=
reases and
> decreases are negligible. =A0It is expected that devices with low flu=
sh times
> should not show much change, whether the low flush times are due to t=
he lack of
> write cache or the controller having a battery and thereby ignoring t=
he flush
> command.
>
> Notice that the elm3b231_ipr, elm3b231_bigfc, elm3b57, elm3c44_ssd,
> elm3c44_sata_wc, and elm3c71_scsi profiles showed large performance i=
ncreases
> from flush coordination. =A0These 6 configurations all feature large =
write caches
> without battery backups, and fairly high (or at least non-zero) avera=
ge flush
> times, as was discovered when I studied the v6 patch.
>
> Unfortunately, there is one very odd regression: elm3c44_sas. =A0This=
 profile is
> a couple of battery-backed RAID cabinets striped together with raid0 =
on md. =A0I
> suspect that there is some sort of problematic interaction with md, b=
ecause
> running ffsb on the individual hardware arrays produces numbers simil=
ar to
> elm3c71_extsas. =A0elm3c71_extsas uses the same type of hardware arra=
y as does
> elm3c44_sas, in fact.
>
> FYI, the flush coordination patch shows performance improvements both=
 with and
> without Christoph's patch that issues pure flushes directly. =A0The s=
preadsheet
> only captures the performance numbers collected without Christoph's p=
atch.
Hi,
can you explain why there is improvement with your patch? If there are
multiple flush, blk_do_flush already has queue for them (the
->pending_flushes list).

Thanks,
Shaohua
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
