From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 performance falloff
Date: Mon, 7 Apr 2014 22:08:30 +0200
Message-ID: <20140407200830.GC23670@quack.suse.cz>
References: <533EE547.3030504@numascale.com>
 <20140404205604.GC10275@thunk.org>
 <533F7851.30803@numascale.com>
 <20140407141935.GA22171@quack.suse.cz>
 <87bnwdjdoj.fsf@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Daniel J Blueman <daniel@numascale.com>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Steffen Persvold <sp@numascale.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87bnwdjdoj.fsf@tassilo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 07-04-14 09:40:28, Andi Kleen wrote:
> Jan Kara <jack@suse.cz> writes:
> >
> > What we really need is a counter where we can better estimate counts
> > accumulated in the percpu part of it. As the counter approaches zero, it's
> > CPU overhead will have to become that of a single locked variable but when
> > the value of counter is relatively high, we want it to be fast as the
> > percpu one. Possibly, each CPU could "reserve" part of the value in the
> > counter (by just decrementing the total value; how large that part should
> > be really needs to depend to the total value of the counter and number of
> > CPUs - in this regard we really differ from classical percpu couters) and
> > allocate/free using that part. If CPU cannot reserve what it is asked for
> > anymore, it would go and steal from parts other CPUs have accumulated,
> > returning them to global pool until it can satisfy the allocation.
> 
> That's a percpu_counter() isn't it? (or cookie jar)
  Not quite. We could use __percpu_counter_add() to set batch size for each
operation depending on the current counter value. But still we don't want
any cpu-local count to go negative (as then we cannot rely on global
counter to give us a lower bound on number of free blocks). Also stealing
from different cpu needs to be implemented...

> The MM uses similar techniques.
  Where exactly? I'd be happy to be inspired :).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
