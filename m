From: Nick Piggin <npiggin@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Sat, 25 Dec 2010 22:33:59 +1100
Message-ID: <AANLkTikHMZDyNkaOux5VWUHvC5D1cXHEFKxhvzfVjN+Q@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Ted Ts'o" <tytso@mit.edu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34931 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab0LYLeB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Dec 2010 06:34:01 -0500
In-Reply-To: <AANLkTi=TWjKMfLG0nGGjxvGR87PwNm5NkKYPnsFsLgfZ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 25, 2010 at 9:41 PM, Olaf van der Spek <olafvdspek@gmail.com> wrote:
> On Sat, Dec 25, 2010 at 4:15 AM, Ted Ts'o <tytso@mit.edu> wrote:
>> On Fri, Dec 24, 2010 at 12:14:21PM +0100, Olaf van der Spek wrote:
>>>
>>> Thanks for taking the time to answer. The thread was started due to
>>> the dpkg issue.
>>
>> I've talked to the dpkg folks and I believe they are squared away; for
>> their use case sync_file_range() combined with fsync() should solve
>> their reliability and performance problem.
>
> It's not just about dpkg, I'm still very interested in answers to my
> original questions.

Arbitrary atomic but non-durable file write operation? That's significantly
different to how any part of the pagecache or filesystem or syscall API
is set up. Writes are not atomic, and syncs are only for durability (not
atomicity), atomicity is typically built on top of these durable points.

That is quite fundamental functionality and suits simple
implementations of filesystems and writeback caches.

If you start building complex atomicity semantics, then you get APIs
which can't be supported by all filesystems, Linux specific, adds
complexity from the API through to the pagecache and to the
filesystems, and is Linux specific.

Compare that to using cross platform, mature and well tested sqlite
or bdb, how much reason do we have for implementing such APIs?

It's not that it isn't possible, it's that there is no way we're adding
such a thing unless it really helps and is going to be widely used.

What exact use case do you have in mind, and what exact API
semantics do you want, anyway?
