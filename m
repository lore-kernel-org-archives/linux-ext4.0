From: Christian Stroetmann <stroetmann@ontolinux.com>
Subject: Re: Atomic non-durable file write API
Date: Mon, 27 Dec 2010 01:30:05 +0100
Message-ID: <4D17DE0D.2070504@ontolinux.com>
References: <20101224095105.GG12763@thunk.org> <AANLkTimPZ_Hq2Ye4mc60WKTWZNU4Zz3yZaPzfARYa6jh@mail.gmail.com> <20101225031529.GA2595@thunk.org> <AANLkTi=TWjKMfLG0nGGjxvGR87PwNm5NkKYPnsFsLgfZ@mail.gmail.com> <AANLkTikHMZDyNkaOux5VWUHvC5D1cXHEFKxhvzfVjN+Q@mail.gmail.com> <AANLkTinjtoF0gOdi6TV+RPjMkeqA8fcrkJBYRBd5WQ==@mail.gmail.com> <AANLkTi=g4zvxdQdnS7crg015sexk3NSJ3CaODi_c=6Fv@mail.gmail.com> <AANLkTinHa1wLB6hKi_xwiQNwMb1xZs-pa1sLB=ebtjiX@mail.gmail.com> <AANLkTinXd8Zf=13HSYTxsAUc02jbCgV=17UqXQyFxNUG@mail.gmail.com> <AANLkTi=ihgiJAsJ+hSeRjhcOTUhY5YC-xPDRPT0ws+oB@mail.gmail.com> <20101226221016.GF2595@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Olaf van der Spek <olafvdspek@gmail.com>,
	Nick Piggin <npiggin@gmail.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:53968 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab0L0A3s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 26 Dec 2010 19:29:48 -0500
In-Reply-To: <20101226221016.GF2595@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On the 26.12.2010 23:10, Ted Ts'o wrote:
> On Sun, Dec 26, 2010 at 07:51:23PM +0100, Olaf van der Spek wrote:
>
<snip>
> As I said earlier, "file systems are not databases", and "databases
> are not file systems".  Oracle tried to foist their database as a file
> system during the dot.com boom, and everyone laughed at them; the
> performance was a nightmare.  If Oracle wasn't able to make a
> transaction engine that supports transactions and rollbacks
> performant, you really expect that you'll be able to do it?

An FS could easily have the rest of the functions of a database 
management system (DBMS) as an FSDB, a hybrid if you wish. An example 
for such a hybrid is the ext2/3-sqlite FS and there are two little 
architectural problems only: One is related with the structure and 
naming scheme of the api and the other is related with the handling of 
the FS caching by the programmer and the user due to the many different 
options available.

Furthermore, the performance of Oracle's solutions was and still is so 
low, because they have a file system as a database that is managed by a 
DBMS as a file that again is stored in an FS. Can you see now what does 
the loss of performance?
And Oracle fears FSs like R4 that have database(-like) functionalities, 
so it took those technical features of R4 for the BTRFS, which they 
thought could stop its show.
And also, Oracle has started some months ago again to promote its FS in 
a DB in an FS concept.

So, there must be something that is highly interesting with the idea to 
use an FS as DBMS, not only for Oracle, but at least for the four 
largest software companies.

<snip>
>
>> Providing transaction semantics for multiple files is a far broader
>> proposal and not necessary for implement this proposal.
> But providing magic transaction semantics for a single file in the
> rename is not at all clearly useful.  You need to justify all of this
> hard effort, and performance loss.  (Well, or if you're so smart you
> can implement your own file system that does all of this work, and we
> can benchmark it against a file system that doesn't do all of this
> work....)

But then the benchmark must be done correctly, which means that the FS 
without transaction must be used with a transaction mechanism by an 
additional software component. Otherwise the benchmarking would be worth 
nothing.

>> I'm not sure, but Ted appears to be saying temp file + rename (but no
>> fsync) isn't guaranteed to work either.
> It won't work if you get really unlucky and your system takes a power
> cut right at the wrong moment during or after the rename().  It could
> be made to work, but at a performance cost.  And the question is
> whether the performance cost is worth it.  At the end of the day it's
> all between the tradeoff between performance cost, implementation
> cost, and value to the user and the application programmer.  Which is
> why you need to articular the use case where this makes sense.

see above

> It's not dpkg, and it's not file editors.  What is it, specifically?
> And why can it tolerate data loss in the case of quota overruns and
> wireless connection hits, but not in the case of system crashes?
>
>> It just seems quite suboptimal. There's no need for infinite storage
>> (or an oracle) to avoid this.
> If you're so smart, why don't you try implementing it?  Itt's going to
> be hard for us to convince you why it's going to be non-trivial and
> have huge implementation *and* performance costs,

see above

>   so why don't you
> produce the patches that makes this all work?
>
> 						- Ted
>

Christian Stroetmann

