From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Atomic non-durable file write API
Date: Sun, 26 Dec 2010 17:10:16 -0500
Message-ID: <20101226221016.GF2595@thunk.org>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nick Piggin <npiggin@gmail.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55705 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332Ab0LZWK2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 26 Dec 2010 17:10:28 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTi=ihgiJAsJ+hSeRjhcOTUhY5YC-xPDRPT0ws+oB@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 26, 2010 at 07:51:23PM +0100, Olaf van der Spek wrote:
> f = open(..., O_ATOMIC, O_CREAT, O_TRUNC);

Great, let's rename O_ATOMIC to O_PONIES.  :-)

> abort/rollback(...); // optional

As I said earlier, "file systems are not databases", and "databases
are not file systems".  Oracle tried to foist their database as a file
system during the dot.com boom, and everyone laughed at them; the
performance was a nightmare.  If Oracle wasn't able to make a
transaction engine that supports transactions and rollbacks
performant, you really expect that you'll be able to do it?

> > If it is a multi-file/dir archive, then you could equally well come back in
> > an inconsistent state after crashing with some files extracted and
> > some not, without atomic-write-multiple-files-and-directories API.
> 
> True, but at least each file will be valid by itself. So no broken
> executables, images or scripts.
> Transactions involving multiple files are outside the scope of this 
> discussion.

But what's the use case where this is useful and/or interesting?  It
certainly doesn't help in the case of dpkg, because you still have to
deal with shell scripts that depend on certain executables being
present, or executables depending on the new version of the shared
library being present.  If we're going to give up huge amounts of file
system performance for some use case, it's nice to know what the
real-world use case would actually be.  (And again, I believe the dpkg
folks are squared away at this point.)

If the use case is really one of replacing the data while maintaining
the metadata (i.e., ACL's, extended attributes, etc.), we've already
pointed out that in the case of a file editor, you had better have
durability.  Keep in mind that if you don't eventually call fsync(),
you'll never know if the file system is full or the user has hit their
quota, and the data can't be lazily written out later.  Or in the case
of a networked file system, what if the network connection disappears
before you have a chance to lazily update the data and do the rename?
So before the editor exits, and the last remaining copy of the new
data (in memory) disappears, you had better call fsync() and check to
make sure the write can and has succeeded.

So in the case of replacing the data, what's the use case if it's not
for a file editor?  And note that you've said that you want atomicity
because you want to make sure that after a crash you don't lose data.
What about the case where the system doesn't crash, but the wireless
connection goes away, or the user has exceeded his/her quota and they
were trying to replace 4k worth of data fork with 12k worth of data?
I can certainly think of scenarios where wireless connection drops and
quota overruns are far more likely than system crashes.  (i.e., when
you're not using proprietary video drivers.  :-P)

> Providing transaction semantics for multiple files is a far broader
> proposal and not necessary for implement this proposal.

But providing magic transaction semantics for a single file in the
rename is not at all clearly useful.  You need to justify all of this
hard effort, and performance loss.  (Well, or if you're so smart you
can implement your own file system that does all of this work, and we
can benchmark it against a file system that doesn't do all of this
work....)

> I'm not sure, but Ted appears to be saying temp file + rename (but no
> fsync) isn't guaranteed to work either.

It won't work if you get really unlucky and your system takes a power
cut right at the wrong moment during or after the rename().  It could
be made to work, but at a performance cost.  And the question is
whether the performance cost is worth it.  At the end of the day it's
all between the tradeoff between performance cost, implementation
cost, and value to the user and the application programmer.  Which is
why you need to articular the use case where this makes sense.

It's not dpkg, and it's not file editors.  What is it, specifically?
And why can it tolerate data loss in the case of quota overruns and
wireless connection hits, but not in the case of system crashes?

> It just seems quite suboptimal. There's no need for infinite storage
> (or an oracle) to avoid this.

If you're so smart, why don't you try implementing it?  Itt's going to
be hard for us to convince you why it's going to be non-trivial and
have huge implementation *and* performance costs, so why don't you
produce the patches that makes this all work?

						- Ted
