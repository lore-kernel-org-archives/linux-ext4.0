From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: What am I doing wrong?  submit_bio() suddenly stops working...
Date: Fri, 22 Oct 2010 15:04:20 +0200
Message-ID: <1287752660.15336.37.camel@twins>
References: <E1P8kSE-0001DW-8C@tytso-glaptop> <4CBFE4E2.7050001@kernel.dk>
	 <20101021165525.GB3127@thunk.org> <4CC07B62.9070000@panasas.com>
	 <4CC0817F.1020403@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: Boaz Harrosh <bharrosh@panasas.com>, Ted Ts'o <tytso@mit.edu>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4CC0817F.1020403@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2010-10-21 at 20:07 +0200, Jens Axboe wrote:
> 
> >> +    do {
> >> +            bio = bio_alloc(GFP_NOIO, nvecs);
> >> +            nvecs >>= 1;
> >> +    } while (bio == NULL);
> > 
> > This is surly bad. bio_alloc must be allowed to fail
> > (Specially with GFP_NOIO). You should only loop down to
> > 1 and then prepare to return -ENOMEM from this function
> > and handle it properly in callers. (Or schedule and wait
> > like below)
> 
> Since __GFP_WAIT is set, it'll never return NULL. And as long as you
> don't allocate more than 1 before doing you submit_bio(), it should be
> OK in this case. 

__GFP_WAIT can return NULL, on OOM and when the size is over a magic
threshold.

I find it bad form to rely on any allocation not failing.
