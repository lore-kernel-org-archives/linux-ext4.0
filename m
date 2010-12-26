From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Sun, 26 Dec 2010 16:08:12 +0100
Message-ID: <AANLkTinHa1wLB6hKi_xwiQNwMb1xZs-pa1sLB=ebtjiX@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Ted Ts'o" <tytso@mit.edu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Nick Piggin <npiggin@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=g4zvxdQdnS7crg015sexk3NSJ3CaODi_c=6Fv@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Dec 25, 2010 at 6:25 PM, Nick Piggin <npiggin@gmail.com> wrote:
>> No, not arbitrary writes. It's about complete file writes.
>
> You still haven't defined exactly what you want.

Do you not understand what is meant by a complete file write?

>> Atomic semantics are not (that) complex.
>
> That is something to be argued over patches. What is not in question
> is that an atomic API is more complex than none :)

That's implementation complexity, not concept/semantics complexity.

>> Like I said before, it's not about DB-like functionality but about
>> complete file writes/updates. For example, I've got a file in an
>> editor and I want to save it.
>
> I don't understand your example, because in that case you surely
> want durability.

Hmm, true, bad example, although it depends on editor/user.
Let's take archive extraction instead.

>> Let me copy the original post:
>> Writing a temp file, fsync, rename is often proposed. However, the
>> durable aspect of fsync isn't always required
>
> So you want a way to atomically replace the contents of a file with
> new contents, in a way which completes asynchronously and lazily,
> and your new contents will eventually just appear sometime after
> they are guaranteed to be on disk?

Almost. Visibility to other process should be normal (I don't know the
exact rules), but commit to disk may be deferred.

> You would need to create an unlinked inode with dirty data, and then
> have callbacks from pagecache writeback checking when the inode
> is cleaned, and then call appropriate filesystem routines to sync and
> issue barriers etc, and rename the old name to the new inode.

That's an implementation detail, but yes, something like that.

> You will also need to have a chain of inodes representing ordering of
> the updates so the renames can be performed in the right order. And
> add some hooks to solve the metadata issue.
>
> Then what happens when you fsync the original file? What if the
> original file is renamed or unlinked? How do you sync the outstanding
> queue of updates?

Logically those actions would happen after the atomic data update.
The fsync would be done on a now unlinked file (if done via fd). The
rename would be done on the new file. Same for unlink.

> Once you solve all those problems, then people will ask you to now
> solve them for multiple files at once because they also have some
> great use-case that is surely nothing like databases.

I don't want to play the what if game.

> Please tell us what for. If you have immediate need to replace the
> name, then you need the durability of fsync. If you don't have
> immediate need, then you can use another name, surely (until it
> comes time you want to switch names, at that point you want
> durability so you fsync then rename).

Temp file, rename has issues with losing meta-data.

>
>> and this way has other
>> issues, like losing file meta-data.
>
> Yes that's true, if you're not owner you may not be able to recreate
> most of it. Did you need to?

Yes

>
>> What is the recommended way for atomic non-durable (complete) file writes?
>
> There really isn't one. Like I said, there is not much atomicity
> semantics in the API, which works really well because it is simple
> to implement and to use (although apparently still far too complex
> for some programmers to get right).

It's simple to implement but it's not simple to use right.

> If we start adding atomicity beyond fundamental requirement of
> namespace operations, then where does it end? Why would it make
> sense to add atomicity for writes to one file, but not writes to 2 files?
> What if you require atomic multiple modifications to directory
> structure as well as file updates? And why only writes? What about
> atomic reads of several things? What isolation level should all of that
> have, and how to solve deadlocks?
>
>
>> I'm also wondering why FSs commit after open/truncate but before
>> write/close. AFAIK this isn't necessary and thus suboptimal.
>
> I don't know, can you expand on this? What fses are you talking
> about, and what behaviour.

The zero size issues of ext4 (before some patch). Presumably because
some apps do open, truncate, write, close on a file. I'm wondering why
an FS commits between truncate and write.

Olaf
