From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Sun, 26 Dec 2010 19:51:23 +0100
Message-ID: <AANLkTi=ihgiJAsJ+hSeRjhcOTUhY5YC-xPDRPT0ws+oB@mail.gmail.com>
References: <1292710543.17128.14.camel@nayuki>
	<AANLkTimbkstru_nUxnd7R8Zg=ioB3skTntedq_dLxpZm@mail.gmail.com>
	<AANLkTi=BW85d6VpGAt0KaGES+4dRQmsvRyFamE=ChEXE@mail.gmail.com>
	<20101224085126.2a7ff187@notabene.brown>
	<20101223222206.GD12763@thunk.org>
	<4D13E98D.8070105@ontolinux.com>
	<20101224004825.GF12763@thunk.org>
	<4D13F09D.4010703@ontolinux.com>
	<20101224095105.GG12763@thunk.org>
	<AANLkTimPZ_Hq2Ye4mc60WKTWZNU4Zz3yZaPzfARYa6jh@mail.gmail.com>
	<20101225031529.GA2595@thunk.org>
	<AANLkTi=TWjKMfLG0nGGjxvGR87PwNm5NkKYPnsFsLgfZ@mail.gmail.com>
	<AANLkTikHMZDyNkaOux5VWUHvC5D1cXHEFKxhvzfVjN+Q@mail.gmail.com>
	<AANLkTinjtoF0gOdi6TV+RPjMkeqA8fcrkJBYRBd5WQ==@mail.gmail.com>
	<AANLkTi=g4zvxdQdnS7crg015sexk3NSJ3CaODi_c=6Fv@mail.gmail.com>
	<AANLkTinHa1wLB6hKi_xwiQNwMb1xZs-pa1sLB=ebtjiX@mail.gmail.com>
	<AANLkTinXd8Zf=13HSYTxsAUc02jbCgV=17UqXQyFxNUG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Ted Ts'o" <tytso@mit.edu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Nick Piggin <npiggin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32965 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab0LZSvZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 26 Dec 2010 13:51:25 -0500
In-Reply-To: <AANLkTinXd8Zf=13HSYTxsAUc02jbCgV=17UqXQyFxNUG@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 26, 2010 at 5:43 PM, Nick Piggin <npiggin@gmail.com> wrote:
>> Do you not understand what is meant by a complete file write?
>
> It is not a rigourous definition. What I understand it to mean may be
> different than what you understand it to mean. Particularly when you
> consider what the actual API should look like and interact with the rest
> of the apis.

f = open(..., O_ATOMIC, O_CREAT, O_TRUNC);
write(...); // 0+ times
abort/rollback(...); // optional
close(f);

> OK, so please show how it helps.
>
> If it is a multi-file/dir archive, then you could equally well come back in
> an inconsistent state after crashing with some files extracted and
> some not, without atomic-write-multiple-files-and-directories API.

True, but at least each file will be valid by itself. So no broken
executables, images or scripts.
Transactions involving multiple files are outside the scope of this discussion.

>> Almost. Visibility to other process should be normal (I don't know the
>> exact rules), but commit to disk may be deferred.
>
> That's pretty important detail. What is "normal"? Will a process
> see old or new data from the atomic write before atomic write has
> committed to disk?

New data. Isn't that the current rule?

> Is the atomic write guaranteed to take an atomic snapshot of file
> and only specified updates?
>
> What happens to subsequent atomic and non atomic writes to the
> file?

It's about an atomic replace of the entire file data. So it's not like
expecting a single write to be atomic.

>>> Once you solve all those problems, then people will ask you to now
>>> solve them for multiple files at once because they also have some
>>> great use-case that is surely nothing like databases.
>>
>> I don't want to play the what if game.
>
> You must if you want to design a sane API.

Providing transaction semantics for multiple files is a far broader
proposal and not necessary for implement this proposal.

>> Temp file, rename has issues with losing meta-data.
>
> How about solving that easier issue?

That would be nice, but it's not the only issue.
I'm not sure, but Ted appears to be saying temp file + rename (but no
fsync) isn't guaranteed to work either.
There's also the issue of not having permission to create the temp
file, having to ensure the temp file is on the same volume (so the
rename can work).

>> It's simple to implement but it's not simple to use right.
>
> You do not have the ability to have arbitrary atomic transactions to the
> filesystem. If you show a problem of a half completed write after crash,
> then I can show you a problem of any half completed multi-syscall
> operation after crash.

It's not about arbitrary transactions.

> The simple thing is to properly clean up such things after a crash, and
> just use an atomic commit somewhere to say whether the file operations
> that just completed are now in a durable state. Either that or use an
> existing code that does it right.

That's not simple if you're talking about arbitrary processes and files.
It's not even that simple if you're talking about DBs. They do
implement it, but obviously that's not usable for arbitrary files.

>>> If we start adding atomicity beyond fundamental requirement of
>> The zero size issues of ext4 (before some patch). Presumably because
>> some apps do open, truncate, write, close on a file. I'm wondering why
>> an FS commits between truncate and write.
>
> I'm still not clear what you mean. Filesystem state may get updated
> between any 2 syscalls because the kernel has no oracle or infinite
> storage.

It just seems quite suboptimal. There's no need for infinite storage
(or an oracle) to avoid this.

Olaf
