From: Jens Axboe <axboe@kernel.dk>
Subject: Re: What am I doing wrong?  submit_bio() suddenly stops working...
Date: Thu, 21 Oct 2010 20:07:59 +0200
Message-ID: <4CC0817F.1020403@kernel.dk>
References: <E1P8kSE-0001DW-8C@tytso-glaptop> <4CBFE4E2.7050001@kernel.dk> <20101021165525.GB3127@thunk.org> <4CC07B62.9070000@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:42894 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756292Ab0JUSIB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Oct 2010 14:08:01 -0400
In-Reply-To: <4CC07B62.9070000@panasas.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-10-21 19:41, Boaz Harrosh wrote:
>> +void ext4_io_submit(struct ext4_io_submit *io)
>> +{
>> +	if (!io->io_bio)
>> +		return;
>> +#ifdef PDEBUG
>> +	trace_printk("%s: io submitted io_end %p\n", 
>> +		     io->io_end->inode->i_sb->s_id, io->io_end);
>> +#endif
>> +	submit_bio(io->io_op, io->io_bio);
>> +	ASSERT(!bio_flagged(bio, BIO_EOPNOTSUPP));
>> +	bio_put(io->io_bio);
> 
> The extra get/put is only done for the duration of the ASSERT above, right?
> I'd put a comment. And why don't you just call the _get here just before
> submit_bio instead of down at io_submit_init.

Ted is using it to signal the reference from io:

>> +	io->io_bio = 0;

which makes sense (even if you don't need it, as long as you don't deref
bio after calling submit_bio()).

>> +	do {
>> +		bio = bio_alloc(GFP_NOIO, nvecs);
>> +		nvecs >>= 1;
>> +	} while (bio == NULL);
> 
> This is surly bad. bio_alloc must be allowed to fail
> (Specially with GFP_NOIO). You should only loop down to
> 1 and then prepare to return -ENOMEM from this function
> and handle it properly in callers. (Or schedule and wait
> like below)

Since __GFP_WAIT is set, it'll never return NULL. And as long as you
don't allocate more than 1 before doing you submit_bio(), it should be
OK in this case.

-- 
Jens Axboe

