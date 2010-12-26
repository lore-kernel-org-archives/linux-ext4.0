From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Sun, 26 Dec 2010 19:26:23 +0100
Message-ID: <AANLkTimsTF7dvf6yMpkZjJG0HE=cZ0czLyc-Pjjuo_r=@mail.gmail.com>
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
	<4D17656B.7010603@panasas.com>
	<AANLkTinaAtrCYfusv59T3FE5A45A77R8oTMPpJUJs03p@mail.gmail.com>
	<4D176CF6.7010208@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Nick Piggin <npiggin@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63661 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab0LZS0Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 26 Dec 2010 13:26:25 -0500
In-Reply-To: <4D176CF6.7010208@panasas.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 26, 2010 at 5:27 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>> Are you proposing to turn every single file into a symlink?
>
> Sure, a symlink and a "versioned" file for every object. Something similar
> to the silly rename of nfs.
>
> Even if you have 1000 files that need the same atomicity treatment
> that's not that bad. You should be able to devise a namespace policy
> that makes all this nit and tidy.

Nearly all files on the system need the atomicity treatment.

>> How would that solve the meta-data issue?
>>
>
> That's what I asked. Do you want to preserve the original's file
> metat-data, or the meta-data of the owner of the new content?
> In the first case you'll need a metat-data copy like tar is
> using.

The original meta-data, of course. Including file owner. AFAIK not
doable without root access.

>> Olaf
>
> The point is to fsync/fdatasync on a background thread and continue
> from there where the application is free to go on to the next step.

Not if it's the last thing a process does and another processes is
waiting on it.

> As if you had a notification when the commit was done (in the background).
> So you make it an async pipeline model. The version-naming schem is so the
> pipeline can get arbitrary big.
>
> Boaz
>
