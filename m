From: Nick Piggin <npiggin@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Sun, 26 Dec 2010 04:25:28 +1100
Message-ID: <AANLkTi=g4zvxdQdnS7crg015sexk3NSJ3CaODi_c=6Fv@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Ted Ts'o" <tytso@mit.edu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <AANLkTinjtoF0gOdi6TV+RPjMkeqA8fcrkJBYRBd5WQ==@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Dec 26, 2010 at 2:24 AM, Olaf van der Spek <olafvdspek@gmail.com> wrote:
> On Sat, Dec 25, 2010 at 12:33 PM, Nick Piggin <npiggin@gmail.com> wrote:
>>> It's not just about dpkg, I'm still very interested in answers to my
>>> original questions.
>>
>> Arbitrary atomic but non-durable file write operation?
>
> No, not arbitrary writes. It's about complete file writes.

You still haven't defined exactly what you want.


> Also, don't forget my question about how to preserve meta-data
> including file owner.
>
>> That's significantly
>> different to how any part of the pagecache or filesystem or syscall API
>> is set up. Writes are not atomic, and syncs are only for durability (not
>> atomicity), atomicity is typically built on top of these durable points.
>>
>> That is quite fundamental functionality and suits simple
>> implementations of filesystems and writeback caches.
>>
>> If you start building complex atomicity semantics, then you get APIs
>
> Atomic semantics are not (that) complex.

That is something to be argued over patches. What is not in question
is that an atomic API is more complex than none :)


>> which can't be supported by all filesystems, Linux specific, adds
>> complexity from the API through to the pagecache and to the
>> filesystems, and is Linux specific.
>
>> Compare that to using cross platform, mature and well tested sqlite
>> or bdb, how much reason do we have for implementing such APIs?
>
> Like I said before, it's not about DB-like functionality but about
> complete file writes/updates. For example, I've got a file in an
> editor and I want to save it.

I don't understand your example, because in that case you surely
want durability.


>> It's not that it isn't possible, it's that there is no way we're adding
>> such a thing unless it really helps and is going to be widely used.
>>
>> What exact use case do you have in mind, and what exact API
>> semantics do you want, anyway?
>
> Let me copy the original post:
> Writing a temp file, fsync, rename is often proposed. However, the
> durable aspect of fsync isn't always required

So you want a way to atomically replace the contents of a file with
new contents, in a way which completes asynchronously and lazily,
and your new contents will eventually just appear sometime after
they are guaranteed to be on disk?

You would need to create an unlinked inode with dirty data, and then
have callbacks from pagecache writeback checking when the inode
is cleaned, and then call appropriate filesystem routines to sync and
issue barriers etc, and rename the old name to the new inode.

You will also need to have a chain of inodes representing ordering of
the updates so the renames can be performed in the right order. And
add some hooks to solve the metadata issue.

Then what happens when you fsync the original file? What if the
original file is renamed or unlinked? How do you sync the outstanding
queue of updates?

Once you solve all those problems, then people will ask you to now
solve them for multiple files at once because they also have some
great use-case that is surely nothing like databases.

Please tell us what for. If you have immediate need to replace the
name, then you need the durability of fsync. If you don't have
immediate need, then you can use another name, surely (until it
comes time you want to switch names, at that point you want
durability so you fsync then rename).


> and this way has other
> issues, like losing file meta-data.

Yes that's true, if you're not owner you may not be able to recreate
most of it. Did you need to?


> What is the recommended way for atomic non-durable (complete) file writes?

There really isn't one. Like I said, there is not much atomicity
semantics in the API, which works really well because it is simple
to implement and to use (although apparently still far too complex
for some programmers to get right).

If we start adding atomicity beyond fundamental requirement of
namespace operations, then where does it end? Why would it make
sense to add atomicity for writes to one file, but not writes to 2 files?
What if you require atomic multiple modifications to directory
structure as well as file updates? And why only writes? What about
atomic reads of several things? What isolation level should all of that
have, and how to solve deadlocks?


> I'm also wondering why FSs commit after open/truncate but before
> write/close. AFAIK this isn't necessary and thus suboptimal.

I don't know, can you expand on this? What fses are you talking
about, and what behaviour.

Thanks,
Nick
