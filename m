From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Mon, 27 Dec 2010 12:48:12 +0100
Message-ID: <AANLkTinqRwH2LiFA0HoQFyLrVMGWvxXkSBJYMzCc8UoS@mail.gmail.com>
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
	<AANLkTi=ihgiJAsJ+hSeRjhcOTUhY5YC-xPDRPT0ws+oB@mail.gmail.com>
	<AANLkTi=UGsY_ULZiFG8WHK=n6qKZfTPNq10npkuUjTDP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Nick Piggin <npiggin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39098 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab0L0LsO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Dec 2010 06:48:14 -0500
In-Reply-To: <AANLkTi=UGsY_ULZiFG8WHK=n6qKZfTPNq10npkuUjTDP@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 27, 2010 at 5:12 AM, Nick Piggin <npiggin@gmail.com> wrote:
> On Mon, Dec 27, 2010 at 5:51 AM, Olaf van der Spek <olafvdspek@gmail.=
com> wrote:
>> On Sun, Dec 26, 2010 at 5:43 PM, Nick Piggin <npiggin@gmail.com> wro=
te:
>>>> Do you not understand what is meant by a complete file write?
>>>
>>> It is not a rigourous definition. What I understand it to mean may =
be
>>> different than what you understand it to mean. Particularly when yo=
u
>>> consider what the actual API should look like and interact with the=
 rest
>>> of the apis.
>>
>> f =3D open(..., O_ATOMIC, O_CREAT, O_TRUNC);
>> write(...); // 0+ times
>> abort/rollback(...); // optional
>> close(f);
>
> Sorry, it's still not a rigourous definition, and what you have
> defined indicates it is
> not atomic. You have not done *anything* to specify how the API inter=
acts with
> the rest of the system calls and other calls.
>
> You have a circular definition -- "complete file write means you open=
 the file
> with O_ATOMIC, and O_ATOMIC means you want a complete file write". I'=
m
> afraid you'll have to put in a bit more effort than that.

Semantics:
Old state: data before open
New state: data after open
Others see either the old or the new state.
After close but before a crash, others see the new state.

>> True, but at least each file will be valid by itself. So no broken
>> executables, images or scripts.
>
> So if a script depends on an executable or an executable depends on a
> data file or library that do not exist, they're effectively broken. S=
o you
> need to be able to clean up properly anyway.

If those ifs are true, yes. Otherwise, no.

>
>> Transactions involving multiple files are outside the scope of this =
discussion.
>
> No they are not, because as I understand you want atomicity of some
> file operations so that partially visible error cases do not have to =
be dealt
> with by userspace. The problem is exactly the same when dealing with
> multiple files and directories.

Solving it for a single file does not require solving it for multiple f=
iles.

>>>> Almost. Visibility to other process should be normal (I don't know=
 the
>>>> exact rules), but commit to disk may be deferred.
>>>
>>> That's pretty important detail. What is "normal"? Will a process
>>> see old or new data from the atomic write before atomic write has
>>> committed to disk?
>>
>> New data.
>
> What if the writer subsequently "aborts" or makes more writes to the =
file?

That's all part of the atomic transaction. New data is the state after =
close.

>
>> Isn't that the current rule?
>
> There are no atomic writes, so you can't just say "it's easy, just do=
 writes
> atomically and use 'current' rules for everything else"

I mean the rules that exist to current (non-atomic) stuff.

>> It's about an atomic replace of the entire file data. So it's not li=
ke
>> expecting a single write to be atomic.
>
> You didn't answer what happens. It's pretty important, because if tho=
se
> writes from other processes join the new data from your atomic write,
> and then you subsequently abort it, what happens? If writes are in pr=
ogress
> to the file when it is to be atomically written to, does the atomic w=
rite
> "transaction" see parts of these writes? What sort of isolation level=
 are
> we talking about here? read uncommitted?
>
> It's pretty important details when you're talking about transactions =
and
> atomicity, you can't just say it isn't relevant, out of scope, or jus=
t use
> "existing" semantics.

Ah, yes, that's important. The transaction is defined as beginning
with open and ending with close. Others won't see inconsistent state.
If other (atomic or non-atomic) updates happen they happen either
before or after the transaction. Since this is about replacing the
entire file data, you don't depend on the previous data.

>> Providing transaction semantics for multiple files is a far broader
>> proposal and not necessary for implement this proposal.
>
> The question is, if it makes sense to do it for 1, why does it not ma=
ke sense
> to do it for multiple? If you want to radically change the file
> syscall APIs, you
> need to explore all avenues and come up with something consistent tha=
t
> makes sense.

IMO the single-file case is does not require radical changes.

>
>>>> Temp file, rename has issues with losing meta-data.
>>>
>>> How about solving that easier issue?
>>
>> That would be nice, but it's not the only issue.
>> I'm not sure, but Ted appears to be saying temp file + rename (but n=
o
>> fsync) isn't guaranteed to work either.
>
> The rename obviously happens only *after* you fsync. Like I said,
> at the point when you actually overwrite the old file with new, you d=
o
> really want durability.

There's still the meta-data issue.

>
>> There's also the issue of not having permission to create the temp
>> file, having to ensure the temp file is on the same volume (so the
>> rename can work).
>
> I don't see how those are problems. You can't do an atomic write to
> a file if you don't have permissions to do it, either.

Doh. This is about having permission to write to the file you want to
update but not to write to another file.

>
>
>>>> It's simple to implement but it's not simple to use right.
>>>
>>> You do not have the ability to have arbitrary atomic transactions t=
o the
>>> filesystem. If you show a problem of a half completed write after c=
rash,
>>> then I can show you a problem of any half completed multi-syscall
>>> operation after crash.
>>
>> It's not about arbitrary transactions.
>
> That is my point. This "atomic write complete file" thing solves abou=
t 1% of
> the problem that already has to be solved within the existing posix A=
PI
> anyway.
>
>
>>> The simple thing is to properly clean up such things after a crash,=
 and
>>> just use an atomic commit somewhere to say whether the file operati=
ons
>>> that just completed are now in a durable state. Either that or use =
an
>>> existing code that does it right.
>>
>> That's not simple if you're talking about arbitrary processes and fi=
les.
>> It's not even that simple if you're talking about DBs. They do
>> implement it, but obviously that's not usable for arbitrary files.
>
> I don't see how you can just handwave that something is simple when
> it suits your argument, and something else is not simple when that su=
its
> your argument.

True

> It seems pretty simple to me, when you have several ways to perform
> a visible and durable atomic operation (such as a write+fdatasync on
> file data), then you can use that to checkpoint state of your operati=
ons
> at any point.

True

>>> I'm still not clear what you mean. Filesystem state may get updated
>>> between any 2 syscalls because the kernel has no oracle or infinite
>>> storage.
>>
>> It just seems quite suboptimal. There's no need for infinite storage
>> (or an oracle) to avoid this.
>
> You do, because you can't guarantee to keep arbitrary amount of =C2=A0=
dirty
> data in memory or another location on disk for an indeterminate perio=
d
> of time. What if you have a 1GB filesystem, 128MB memory, you open
> an 800MB file on it, and write 800MB of data to that file before clos=
ing it?

This referred to commiting between truncate and the first write.
You're right about not being able to delay writes in other cases.

> If you have "atomic write of complete file", =C2=A0how would you save=
 your
> "abort/rollback" data on arbitrarily large file and for multiple conc=
urrent
> atomic transactions of indeterminate duration? For that matter, how
> would you even handle the above situation which has no concurrency?

Atomic writes, just like temp file + rename, would require more space.
If you don't have that space, your writes will fail.

> Anyway, it seems you'll just keep arguing about this, so I'm with Ted
> now. It's pointless to keep going back and forth. You're certainly
> welcome to post patches (or even prototypes, modifications to user
> programs, numbers, etc.). Some of us are skeptics, but we'd all
> welcome any work that improves the user API so significantly and
> with such simplicity as you think it's possible.

Let's drop the non-durable aspect and refocus then. I'll create a new t=
hread.

Olaf
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
