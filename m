From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Atomic non-durable file write API
Date: Sun, 26 Dec 2010 21:53:16 -0500
Message-ID: <20101227025316.GH2595@thunk.org>
References: <AANLkTikHMZDyNkaOux5VWUHvC5D1cXHEFKxhvzfVjN+Q@mail.gmail.com>
 <AANLkTinjtoF0gOdi6TV+RPjMkeqA8fcrkJBYRBd5WQ==@mail.gmail.com>
 <AANLkTi=g4zvxdQdnS7crg015sexk3NSJ3CaODi_c=6Fv@mail.gmail.com>
 <AANLkTinHa1wLB6hKi_xwiQNwMb1xZs-pa1sLB=ebtjiX@mail.gmail.com>
 <AANLkTinXd8Zf=13HSYTxsAUc02jbCgV=17UqXQyFxNUG@mail.gmail.com>
 <AANLkTi=ihgiJAsJ+hSeRjhcOTUhY5YC-xPDRPT0ws+oB@mail.gmail.com>
 <20101226221016.GF2595@thunk.org>
 <4D17DE0D.2070504@ontolinux.com>
 <20101227010434.GG2595@thunk.org>
 <4D17EC27.4050808@ontolinux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Olaf van der Spek <olafvdspek@gmail.com>,
	Nick Piggin <npiggin@gmail.com>
To: Christian Stroetmann <stroetmann@ontolinux.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D17EC27.4050808@ontolinux.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Dec 27, 2010 at 02:30:15AM +0100, Christian Stroetmann wrote:
> I'm sorry, because I was really thinking that you do know that R4 is
> used as the short term for the file system Reiser4.
> And no,  I'm not fooling, because I don't think that BTRFS is a
> database. I only said that Oracle took technical parts of Reiser4
> like a b-tree datastructure and some other parts as a show stopper.

The fact that Reiser4 and BTRFS use a B-tree doesn't mean that they
have the double intent/rollback logs that a traditional database uses.
So mentioning them is irrelevant to the argument.

> And if you read above again, then you will see that I already said
> that Oracle has started once again the promotion of its concept with
> an FS in a DB in an FS (this thing that you described as a
> performance disaster even running on a raw block device). Do you
> claim that Oracle doesn't do this?

I haven't personally seen evidence of Oracle trying to make the claim
that it's sane to implement a file system, a web server and/or an IMAP
server using a Oracle DB as a backend since their last attempt at the
end of the dot COM error was greeted with near-universal ridicule and
amusement.  

Even if they did are trying to convince people to do this, I'm pretty
sure the response (and resulting performance) would be the same.  It
would be like sending an Armored Hummer H1 Hummvee to try to do the
job of a Audi Convertible.  Sure, the Hummer may be more durable, and
maybe it can go everywhere an Audi can go --- but it's going to have
awful gas mileage compared to the convertible.  Can I imagine a
Hummmer dealership saying, "yes, you should use an H1 for your daily
15 minute commute from your suburb to the city?"  Sure, but I don't
think many sane people will believe them.

> I'm sorry, but I do believe Oracle, Microsoft and Apple more than you.

You mean how Microsoft attempted to create a hybrid file system and
database solution called WinFS, which helped delay MS Vista by seven
years, and ultimately was abandoned by Microsoft?

And I'm not aware of any attempt by Apple to try to go down this
insane architectural direction.

But sure, if you're so smart, maybe you're smarter than me.  Go ahead
and implement it, and send us the patches.  I'll be happy to look them
over and benchmark them on common Linux workloads when you're done.

							- Ted
