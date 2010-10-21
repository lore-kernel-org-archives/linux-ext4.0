From: Jens Axboe <axboe@kernel.dk>
Subject: Re: What am I doing wrong?  submit_bio() suddenly stops working...
Date: Thu, 21 Oct 2010 20:21:52 +0200
Message-ID: <4CC084C0.9020000@kernel.dk>
References: <E1P8kSE-0001DW-8C@tytso-glaptop> <4CBFE4E2.7050001@kernel.dk> <20101021165525.GB3127@thunk.org> <4CC07B62.9070000@panasas.com> <20101021181432.GE3127@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>, Boaz Harrosh <bharrosh@panasas.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49739 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab0JUSVy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Oct 2010 14:21:54 -0400
In-Reply-To: <20101021181432.GE3127@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-10-21 20:14, Ted Ts'o wrote:
> On Thu, Oct 21, 2010 at 07:41:54PM +0200, Boaz Harrosh wrote:
>>> +#ifdef PDEBUG
>>> +	trace_printk("%s: io submitted io_end %p\n", 
>>> +		     io->io_end->inode->i_sb->s_id, io->io_end);
>>> +#endif
>>> +	submit_bio(io->io_op, io->io_bio);
>>> +	ASSERT(!bio_flagged(bio, BIO_EOPNOTSUPP));
>>> +	bio_put(io->io_bio);
>>
>> The extra get/put is only done for the duration of the ASSERT above, right?
>> I'd put a comment. And why don't you just call the _get here just before
>> submit_bio instead of down at io_submit_init.
> 
> The bio layer isn't well documented, so a lot of this was written by
> cargo cult programming.  In this case, I was following what XFS did
> when I originally wrote it.  It's only in the past week when I've been
> diving deep into the source and was able to conclude that yes, it's
> only needed for the ASSERT.

Come on Ted, you are laying it on pretty thick now. It's ordinary
reference counting, and the use case you have here is exactly the one
that is described in the comment for bio_get(). You allocate the bio, it
has a single reference. The end_io function you define drops the
reference you had to this bio. Since IO can complete before submit_bio()
has returned, you need to grab an extra reference if you depend on
dereferencing the bio after submission.

> One of the frustrating things about the bio layer is that all of the
> different file systems use very different patterns about how they
> access the bio layer --- which is perhaps caused by the lack of
> documentation.  But I finally did notice that the JFS code dodn't do a
> bio_get() after calling bio_alloc(), and it was only when I did a lot
> of source code tracing that I realized that it strictly speaking the
> ASSERT isn't really even all that necessary, since we're not calling
> using a discard or barrier op, which is the only thing that could
> possibly set the EOPNOTSUPP flag anyway....
> 
>>> +	do {
>>> +		bio = bio_alloc(GFP_NOIO, nvecs);
>>> +		nvecs >>= 1;
>>> +	} while (bio == NULL);
>>
>> This is surly bad. bio_alloc must be allowed to fail
>> (Specially with GFP_NOIO). You should only loop down to
>> 1 and then prepare to return -ENOMEM from this function
>> and handle it properly in callers. (Or schedule and wait
>> like below)
> 
> Copied exactly from the XFS code.  I was under the (possibly mistaken)
> assumption that the XFS code was a good place to copy from, since
> everyone sings the praises of XFS.....

And it'll work.

> I do agree that bio_alloc() should be allowed to fail, although life
> gets really tough deep in the writeback stack to throw a failure all
> the way back out.  This was on my todo list to fix, after I got things
> basically working.

So don't use __GFP_WAIT, then it returns NULL.

-- 
Jens Axboe

