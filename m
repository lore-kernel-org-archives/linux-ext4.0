From: Neil Brown <neilb@suse.de>
Subject: Re: Atomic non-durable file write API
Date: Wed, 29 Dec 2010 07:59:28 +1100
Message-ID: <20101229075928.6bdafb08@notabene.brown>
References: <20101224095105.GG12763@thunk.org>
	<AANLkTimPZ_Hq2Ye4mc60WKTWZNU4Zz3yZaPzfARYa6jh@mail.gmail.com>
	<20101225031529.GA2595@thunk.org>
	<AANLkTi=TWjKMfLG0nGGjxvGR87PwNm5NkKYPnsFsLgfZ@mail.gmail.com>
	<AANLkTikHMZDyNkaOux5VWUHvC5D1cXHEFKxhvzfVjN+Q@mail.gmail.com>
	<AANLkTinjtoF0gOdi6TV+RPjMkeqA8fcrkJBYRBd5WQ==@mail.gmail.com>
	<AANLkTi=g4zvxdQdnS7crg015sexk3NSJ3CaODi_c=6Fv@mail.gmail.com>
	<AANLkTinHa1wLB6hKi_xwiQNwMb1xZs-pa1sLB=ebtjiX@mail.gmail.com>
	<AANLkTinXd8Zf=13HSYTxsAUc02jbCgV=17UqXQyFxNUG@mail.gmail.com>
	<AANLkTi=ihgiJAsJ+hSeRjhcOTUhY5YC-xPDRPT0ws+oB@mail.gmail.com>
	<20101226221016.GF2595@thunk.org>
	<AANLkTikS8hJtqxRrc3CqQs591bSkynQT1hg=vR4QBo0J@mail.gmail.com>
	<4D18B106.4010308@ontolinux.com>
	<AANLkTimMSxGTEcTbsx8MUYVTLhYRxrdDFQsi6Toer_h9@mail.gmail.com>
	<4D18E94C.3080908@ontolinux.com>
	<AANLkTikW8K4VFLJuYngU64m2vAL1yhA3R=jRt7U6-RRp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Christian Stroetmann <stroetmann@ontolinux.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, "Ted Ts'o" <tytso@mit.edu>,
	Nick Piggin <npiggin@gmail.com>
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <AANLkTikW8K4VFLJuYngU64m2vAL1yhA3R=jRt7U6-RRp@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 28 Dec 2010 18:22:42 +0100 Olaf van der Spek <olafvdspek@gmail.com>
wrote:

> On Mon, Dec 27, 2010 at 8:30 PM, Christian Stroetmann
> <stroetmann@ontolinux.com> wrote:
> > Btw.: There is even no analogy: "The concepts are the same".
> 
> So? Doesn't mean you implement full ACID DB-like transactions.
> 
> >>>> Still waiting on any hint for why that performance loss would happen.
> >>>
> >>> > From my point of view, the loss of performance depends on what is
> >>> benchmarked in which way.
> >>
> >> Maybe, but still no indication of why.
> >
> > If you have a solution, then you really should show other persons the
> > working source code.
> 
> I don't have source code.
> Are you not capable of reasoning about something without having
> concrete source code?
> 
> > For me speaking: I like such technologies and I'm also interested in your
> > attempts.
> 
> Writing code is a lot of work and one should have the design clear
> before writing code, IMO.

Yes and no.

Having some design is obviously important before starting to code.
However it is a common experience that once you start writing code, you start
to see all the holes in your design - all the corner cases that you didn't
think about.  So sometimes writing some proof-of-concept code is a very
valuable step in the design process.
Then of course you need to do some testing to see if in the code actually
performs as hoped or expected.  That testing may cause the design to be
revised.
So asking for code early is not necessarily a bad thing.

I think the real disconnect here is that you haven't really established or
justified a need.

You seem to be asking for the ability to atomically change the data in a file
without changing the metadata.  I cannot see why you would want this.  Maybe
you could give an explicit use-case??

Another significant issue here is "how much atomicity can we justify".
One possibility is for the file system not to provide any atomicity, and so
require lots of repair after a crash:  fsck for the filesystem, "make clean"
for your compile tree, removal of stray temp files etc for other subsystems.

On the other extreme we could allow full transactions encompassing
multiple changes to multiple files which a guarantee to be either committed
completely or not at all after a crash.

We gave up on the first extreme about a decade ago when journalling
filesystems became available for Linux.  There seems to be little desire to
pay the cost of ever implementing the other extreme in general purpose
filesystems.

So the important question is "Where on that spectrum of options should we be?"
The answer has to be based on cost/benefit.  The cost of adding journalling
was quite high, but the benefit of not having to fsck an enormous filesystem
after a crash is enormous, so it is a cost we have chosen to pay.

If you want some extra level of atomicity, you need to demonstrate either a
high benefit or a low cost.  There seems to be some scepticism as to whether
you can.  A convincing use-case might demonstrate the high benefit.  Working
code might demonstrate low cost.  But you really need to provide at least one 
(ideally both) or people are unlikely to take you seriously.

NeilBrown

