From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 4/4] Support discard if at least one underlying device supports it
Date: Mon, 05 Jul 2010 11:03:58 +0400
Message-ID: <87tyoe76ld.fsf@dmon-lap.sw.ru>
References: <Pine.LNX.4.64.1007021107420.7296@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1007021112340.7296@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1007021117580.7296@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1007021118340.7296@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1007021119070.7296@hs20-bc2-1.build.redhat.com>
	<20100702181430.GD26916@redhat.com>
	<Pine.LNX.4.64.1007021540150.6197@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1007021554550.11102@hs20-bc2-1.build.redhat.com>
	<20100702204709.GB21915@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com,
	Alasdair G Kergon <agk@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	axboe@kernel.dk
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35680 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab0GEHES (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Jul 2010 03:04:18 -0400
In-Reply-To: <20100702204709.GB21915@redhat.com> (Mike Snitzer's message of
	"Fri, 2 Jul 2010 16:47:09 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mike Snitzer <snitzer@redhat.com> writes:

> On Fri, Jul 02 2010 at  4:00pm -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>> 
>> 
>> On Fri, 2 Jul 2010, Mikulas Patocka wrote:
>> 
>> > > As we discussed, we have a challenge where we need DM to avoid issuing
>> > > a barrier before the discard IFF a target doesn't support the discard
>> > > (which the barrier is paired with).
>> > > 
>> > > My understanding is that blkdev_issue_discard() only cares if the
>> > > discard was supported.  Barrier is used just to decorate the discard
>> > > (for correctness).  So by returning -EOPNOTSUPP we're saying the discard
>> > > isn't supported; we're not making any claims about the implict barrier,
>> > > so best to avoid the barrier entirely.
>> > > 
>> > > Otherwise we'll be issuing unnecessary barriers (and associated
>> > > performance loss).
>> > > 
>> > > So yet another TODO item... Anyway:
>> > > 
>> > > Acked-by: Mike Snitzer <snitzer@redhat.com>
>> > 
>> > Unnecessary barriers are issued anyway. With each freed extent.
>> > 
>> > The code must issue a "SYNCHRONIZE CACHE" to flush cache for previous 
>> > writes, then "UNMAP" and then another "SYNCHRONIZE CACHE" to commit that 
>> > unmap to disk. And this in loop for all extents in 
>> > "release_blocks_on_commit".
>> > 
>> > One idea behind "discard barriers" was to submit a discard request and not 
>> > wait for it. Then the request would need a barrier so that it doesn't get 
>> > reordered with further writes (that may potentially write to the same area 
>> > as the discarded area). But discard isn't used this way anyway, 
>> > sb_issue_discard waits for completion, so the barrier isn't needed.
>> > 
>> > Even if ext4 developers wanted asynchronous discard requests, they should 
>> > fire all the discards at once and then submit one zero-sized barrier. Not 
>> > barrier with each discard request.
>> > 
>> > This is up to ext4 developers to optimize and remove the barriers and we 
>> > can't do anything with it. Just send "SYNCHRONIZE 
>> > CACHE"+"UNMAP"+"SYNCHRONIZE CACHE" like the barrier specification wants...
>> > 
>> > Mikulas
>> 
>> BTW. I understand that the current dm implementation will send two useless 
>> consecutive "SYNCHRONIZE CACHE" commands discard is directed to the part 
>> of the device that doesn't support it.
>
> Issue 1 ^^^
>
>> But the problem is that when you use discard on a part of the device that 
>> supports discard, it also sends two useless "SYNCHRONIZE CACHE" commands 
>> --- they are useless for functionality, but mandated by the barrier 
>> specification.
>
> Issue 2 ^^^
>
> Those are 2 different issues.  Please don't join them as if they are one
> in the same.  DM should treat a discard as a first class request (which
> may or may not have a barrier).  If a region doesn't support the discard
> DM has no business processing anything related to the discard (barriers
> included).  It is as simple as that.
>
>> The fix is supposedly this:
>> 
>> ---
>>  include/linux/blkdev.h |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> Index: linux-2.6.35-rc3-fast/include/linux/blkdev.h
>> ===================================================================
>> --- linux-2.6.35-rc3-fast.orig/include/linux/blkdev.h	2010-07-02 21:59:21.000000000 +0200
>> +++ linux-2.6.35-rc3-fast/include/linux/blkdev.h	2010-07-02 21:59:37.000000000 +0200
>> @@ -1021,7 +1021,7 @@ static inline int sb_issue_discard(struc
>>  	block <<= (sb->s_blocksize_bits - 9);
>>  	nr_blocks <<= (sb->s_blocksize_bits - 9);
>>  	return blkdev_issue_discard(sb->s_bdev, block, nr_blocks, GFP_KERNEL,
>> -				   BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
>> +				   BLKDEV_IFL_WAIT);
>>  }
>>  
>>  extern int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm);
>
> Hmm, older kernels use DISCARD_FL_BARRIER which merely mapped to
> BLKDEV_IFL_BARRIER.
>
> Seems you've stumbled onto a bug in the conversion that commit
> "blkdev: generalize flags for blkdev_issue_fn functions"
> (fbd9b09a177a481eda) performed?
>
> That commit seems to have incorrectly replaced DISCARD_FL_BARRIER with
> both: BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER
>
> Dmitry and/or Jens was this intended?
Yes, before the path WAIT behavior was implicit, now caller is
responsible for exact behavior.
So, as it was mentioned earlier, it is reasonable to send
discard request only with BLKDEV_IFL_BARRIER flag from some places in
ext4. I have optimization patches for that in my queue, i hope they
will be ready soon.
>
> Mike
