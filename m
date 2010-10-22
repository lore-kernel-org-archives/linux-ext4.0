From: Jens Axboe <axboe@kernel.dk>
Subject: Re: What am I doing wrong?  submit_bio() suddenly stops working...
Date: Fri, 22 Oct 2010 16:08:10 +0200
Message-ID: <4CC19ACA.6060600@kernel.dk>
References: <E1P8kSE-0001DW-8C@tytso-glaptop> <4CBFE4E2.7050001@kernel.dk>	 <20101021165525.GB3127@thunk.org> <4CC07B62.9070000@panasas.com>	 <4CC0817F.1020403@kernel.dk> <1287752660.15336.37.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Boaz Harrosh <bharrosh@panasas.com>, Ted Ts'o <tytso@mit.edu>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49702 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853Ab0JVOHx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Oct 2010 10:07:53 -0400
In-Reply-To: <1287752660.15336.37.camel@twins>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-10-22 15:04, Peter Zijlstra wrote:
> On Thu, 2010-10-21 at 20:07 +0200, Jens Axboe wrote:
>>
>>>> +    do {
>>>> +            bio = bio_alloc(GFP_NOIO, nvecs);
>>>> +            nvecs >>= 1;
>>>> +    } while (bio == NULL);
>>>
>>> This is surly bad. bio_alloc must be allowed to fail
>>> (Specially with GFP_NOIO). You should only loop down to
>>> 1 and then prepare to return -ENOMEM from this function
>>> and handle it properly in callers. (Or schedule and wait
>>> like below)
>>
>> Since __GFP_WAIT is set, it'll never return NULL. And as long as you
>> don't allocate more than 1 before doing you submit_bio(), it should be
>> OK in this case. 
> 
> __GFP_WAIT can return NULL, on OOM and when the size is over a magic
> threshold.

The memory allocator, yes, but a mempool backed allocation with
__GFP_WAIT cannot. That's the difference.

> I find it bad form to rely on any allocation not failing.

On that we can agree, but it's not always easily doable. I bet you would
not like the block layer tossing IOs if it can't get a bio or request
structure :-)

-- 
Jens Axboe

