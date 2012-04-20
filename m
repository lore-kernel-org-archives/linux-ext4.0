From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH, RFC 0/3] Introduce new O_HOT and O_COLD flags
Date: Fri, 20 Apr 2012 12:31:52 +0300
Message-ID: <4F912D08.9020907@panasas.com>
References: <1334863211-19504-1-git-send-email-tytso@mit.edu> <4F90AD29.9030501@dreamhost.com> <20120420024511.GB24486@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Alex Elder <elder@dreamhost.com>, <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120420024511.GB24486@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 04/20/2012 05:45 AM, Ted Ts'o wrote:

> The other approach is to leave things roughly undefined, and accept
> the fact that applications which use this will probably be specialized
> applications that are very much aware of what file system they are
> using, 


If that is the case then I prefer an FS specific IOCTL. Since the app
already has FS specific code built in.

> and just need to pass minimal hints to the application in a
> general way, and that's the approach I went with in this O_HOT/O_COLD proposal.
> 


You are contradicting yourself. Above you say specific FS (read ext4)
and here you say "general way".

Please show me how your proposal is not ext4 outer-rim specific, in devices
that are single rotational disks.

What does the "general way" mean?

> I suspect that HOT/COLD is enough to go quite far even for tiered
> storage; maybe at some point we will want some other, more
> fine-grained interface where an application program can very precisely
> dial in their requirements in a T10-like fashion.  Perhaps.  But I
> don't think having a simple O_HOT/O_COLD interface precludes the
> other, or vice versa.  In fact, one advantage with sticking with
> HOT/COLD is that there's much less chance of bike-shedding, with
> people arguing over what a more fine-grained interface might look like.
> 


But bike-shedding is exactly what you propose. (well not that you actually
stated what you propose)

Your patch says "beginning of the disk" but the flag is called O_HOT,
That's bike-shedding. You hope there will be new meaning for it in the
future.

> So why not start with this, and if we need to use something more
> complex later, we can cross that bridge if and when we get to it?  In
> the meantime, I think there are valid uses of this simple, minimal
> interface in the case of a local disk file system supporting a cluster
> file system such as Hadoopfs or TFS.  One of the useful things that
> came out of the ext4 workshop where we got to talk to developers from
> Taobao was finding out how much their interests matched with some of
> the things we've talked about doing at Google to support our internal
> customers.
> 


This all reads, ext4 specific / app specific. Why a general API? and
why must it be at create?

> 	       	      	    	 	   - Ted


Thanks
Boaz

