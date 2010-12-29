From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Wed, 29 Dec 2010 16:41:45 +0100
Message-ID: <AANLkTimpsDAUt6KnE=qmcbRLdZdaSaqxvJFh0Ki3iV7B@mail.gmail.com>
References: <20101224095105.GG12763@thunk.org>
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
	<20101229075928.6bdafb08@notabene.brown>
	<AANLkTikZ5wFf0KHiLFNxUO=0EGTqb5Ce-GDTVnGCCUaD@mail.gmail.com>
	<20101229093158.2bfed8ca@notabene.brown>
	<AANLkTinkHQ2tqAzqo77Bg_iyyYWUE72V85rTQqsEH4Nc@mail.gmail.com>
	<4D1B542B.9030400@ontolinux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	"Ted Ts'o" <tytso@mit.edu>, Neil Brown <neilb@suse.de>,
	Nick Piggin <npiggin@gmail.com>
To: Christian Stroetmann <stroetmann@ontolinux.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4D1B542B.9030400@ontolinux.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 29, 2010 at 4:30 PM, Christian Stroetmann
<stroetmann@ontolinux.com> wrote:
>> True, I don't understand why people say it will cause a performance
>> hit but then don't want to tell why.
>
> We are talking about atomicity. And it is a simple fact in the field of
> information processing/informatics/computer science that if someone wants to
> give/have the guarantee of atomicity, then she/he has to do several
> additional steps often by using an additional data structure. In the end

Additional steps compared to what? The temp file, fsync, rename case?

> this all costs more time and/or space than doing it without atomicity. At

Of course. But this should not affect the non-atomic usage.

> this point there is no discussion anymore, because this is fully discussed
> to the maximum in subjects like Efficient Algorithms, Special Problem Fields
> of Operating System Design and Fundamentals of DBMS Design (eg. AtomicityCID
> principle).
> And such fundamental points are not (needed to be) discussed here.
>
> Furthermore, due to the competence it is possible for FS gurus like Ted to
> estimate that the additional steps have to be done by several functions of
> an FS, which implies performance loss. And because elementary FS functions
> are involved the performance loss could be and in the past have been
> significant, though in nearly all cases I have seen the reason was a very
> bad implementation. The only exception so far is the Reiser4 FS: All of its
> file operations are atomic, but still to a little cost of performance in the
> most cases and the need of a repacker in some few cases which show a
> significant loss of performance.

So making all ops atomic can be done at a little performance hit, but
implementing one specific op costs a huge performance hit? That
doesn't make sense and seems to indicate those that say otherwise
aren't right.

> And the advice to use a well-known DBMS is simply based on the knowledge
> that it has all the needed functionality already implemented in a highly
> performant way, and on the knowledge that such a solution is used oftenly
> for comparable use cases due to the cost vs. benefit ratio.
> To take a look at the Reiser4 FS could also help.

I don't think storing all my conf files, executables, libraries etc in
a DBMS is a good idea...

Olaf
