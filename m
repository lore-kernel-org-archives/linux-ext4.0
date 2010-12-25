From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Sat, 25 Dec 2010 16:24:22 +0100
Message-ID: <AANLkTinjtoF0gOdi6TV+RPjMkeqA8fcrkJBYRBd5WQ==@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Ted Ts'o" <tytso@mit.edu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Nick Piggin <npiggin@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <AANLkTikHMZDyNkaOux5VWUHvC5D1cXHEFKxhvzfVjN+Q@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Dec 25, 2010 at 12:33 PM, Nick Piggin <npiggin@gmail.com> wrote:
>> It's not just about dpkg, I'm still very interested in answers to my
>> original questions.
>
> Arbitrary atomic but non-durable file write operation?

No, not arbitrary writes. It's about complete file writes.
Also, don't forget my question about how to preserve meta-data
including file owner.

> That's significantly
> different to how any part of the pagecache or filesystem or syscall API
> is set up. Writes are not atomic, and syncs are only for durability (not
> atomicity), atomicity is typically built on top of these durable points.
>
> That is quite fundamental functionality and suits simple
> implementations of filesystems and writeback caches.
>
> If you start building complex atomicity semantics, then you get APIs

Atomic semantics are not (that) complex.

> which can't be supported by all filesystems, Linux specific, adds
> complexity from the API through to the pagecache and to the
> filesystems, and is Linux specific.

> Compare that to using cross platform, mature and well tested sqlite
> or bdb, how much reason do we have for implementing such APIs?

Like I said before, it's not about DB-like functionality but about
complete file writes/updates. For example, I've got a file in an
editor and I want to save it.

> It's not that it isn't possible, it's that there is no way we're adding
> such a thing unless it really helps and is going to be widely used.
>
> What exact use case do you have in mind, and what exact API
> semantics do you want, anyway?

Let me copy the original post:
Writing a temp file, fsync, rename is often proposed. However, the
durable aspect of fsync isn't always required and this way has other
issues, like losing file meta-data.
What is the recommended way for atomic non-durable (complete) file writes?

I'm also wondering why FSs commit after open/truncate but before
write/close. AFAIK this isn't necessary and thus suboptimal.

Olaf
