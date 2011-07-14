From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] jbd/2[stable only]: Use WRITE_SYNC_PLUG in journal_commit_transaction.
Date: Thu, 14 Jul 2011 12:30:32 -0400
Message-ID: <x4962n4g6zb.fsf@segfault.boston.devel.redhat.com>
References: <1310467431-23108-1-git-send-email-tm@tao.ma>
	<20110712123041.GC1293@redhat.com> <4E1C65EA.5060009@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-ext4@vger.kernel.org,
	stable@kernel.org, Jan Kara <jack@suse.cz>,
	Corrado Zoccolo <czoccolo@gmail.com>,
	Jens Axboe <jaxboe@fusionio.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076Ab1GNQb1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Jul 2011 12:31:27 -0400
In-Reply-To: <4E1C65EA.5060009@tao.ma> (Tao Ma's message of "Tue, 12 Jul 2011
	23:19:06 +0800")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Tao Ma <tm@tao.ma> writes:

> On 07/12/2011 08:30 PM, Vivek Goyal wrote:
>> On Tue, Jul 12, 2011 at 06:43:51PM +0800, Tao Ma wrote:
>>> From: Tao Ma <boyu.mt@taobao.com>
>>>
>>> In commit 749ef9f8423, we use WRITE_SYNC instead of WRITE in
>>> journal_commit_transaction. It causes a much heavy burden for
>>> the disk as now the seqenctial write can't be merged(see the blktrace below).
>> 
>> Tao Ma,
>> 
>> Few queries.
>> 
>> - What's the workload you are using for this test.
> A very simple one.
> mkfs.ext4 -b 2048 /dev/sdx 10000000
> sync
> mount -t ext4 -o delalloc /dev/sdx /mnt/ext4
> dd if=/dev/zero of=/mnt/ext4/a bs=1024K count=1
> and run blktrace immediately after the 'dd'. When jbd2 begins to work,
> you will get the blktrace output you want.
>> 
>> - Do you see any performance improvement by switching to WRITE_SYNC_PLUG.
> I haven't done much tests yet. But I guess if there are many heavy sync
> workload, we should suffer from some latency if we dispatch these
> sequential write one by one. As I have said, Jens added plug/unplug in
> 39, and now these sequential write are dispatched in a one request. Run
> the same test cases with 3.0-rcX, you will get the same result.
>> 
>> - Why writes are not being merged? Because request got dispatched
>>   immediately? Do you have logs for insertion of requests also.
> You can get it from the above test case.

Writes aren't being merged because BIO_RW_UNPLUG is set, so
__make_request unplugs the device immediately after submitting the
request.

>> - WRITE_SYNC_PLUG will plug the queue and expects explicity unplug. Who
>>   is doing unplug in this case?
> See the comments I removed, "we rely on sync_buffer() doing the unplug
> for us". I removed them cause we all use pluged write now.

Your logic is upside-down.  The code currently only uses the _PLUG
variant when t_synchronous_commit is set, meaning somebody *will* call
sync_buffer.  Simply setting WRITE_SYNC_PLUG doens't mean the upper
layer is going to issue the unplug.  Of course, I'm not 100% sure of the
journaling process, so it may very well be that there always is an
unplug.  Can Jan or someone comment on that?  Anyway, you could test
this theory by seeing if your kernel generates any timer unplugs in the
blktrace output.

>> - I am not sure in how many cases we are expecting to submit multiple
>>   sequential write here.
> All the journal write will cause a sequential write to be split to many
> requests here. So it would mean too much for metadata heavy test I think.

If there is a lot of I/O going to the device, then I think we can expect
some amount of merging.  Your test case is a single process doing a
single buffered write which is written back in the background (so not
really high priority).

Cheers,
Jeff
