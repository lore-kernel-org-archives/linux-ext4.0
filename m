From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Mon, 27 Dec 2010 11:21:45 +0100
Message-ID: <AANLkTikS8hJtqxRrc3CqQs591bSkynQT1hg=vR4QBo0J@mail.gmail.com>
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
	<20101226221016.GF2595@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Nick Piggin <npiggin@gmail.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46915 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab0L0KVr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Dec 2010 05:21:47 -0500
In-Reply-To: <20101226221016.GF2595@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 26, 2010 at 11:10 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sun, Dec 26, 2010 at 07:51:23PM +0100, Olaf van der Spek wrote:
>> f =3D open(..., O_ATOMIC, O_CREAT, O_TRUNC);
>
> Great, let's rename O_ATOMIC to O_PONIES. =C2=A0:-)

If that makes you happy.

>> abort/rollback(...); // optional
>
> As I said earlier, "file systems are not databases", and "databases
> are not file systems". =C2=A0Oracle tried to foist their database as =
a file
> system during the dot.com boom, and everyone laughed at them; the
> performance was a nightmare. =C2=A0If Oracle wasn't able to make a
> transaction engine that supports transactions and rollbacks
> performant, you really expect that you'll be able to do it?

Like I've said dozens of times, this is not about full DB functionality=
=2E
Why do you keep making false analogies?

>> > If it is a multi-file/dir archive, then you could equally well com=
e back in
>> > an inconsistent state after crashing with some files extracted and
>> > some not, without atomic-write-multiple-files-and-directories API.
>>
>> True, but at least each file will be valid by itself. So no broken
>> executables, images or scripts.
>> Transactions involving multiple files are outside the scope of this
>> discussion.
>
> But what's the use case where this is useful and/or interesting? =C2=A0=
It
> certainly doesn't help in the case of dpkg, because you still have to
> deal with shell scripts that depend on certain executables being
> present, or executables depending on the new version of the shared
> library being present. =C2=A0If we're going to give up huge amounts o=
f file
> system performance for some use case, it's nice to know what the
> real-world use case would actually be. =C2=A0(And again, I believe th=
e dpkg
> folks are squared away at this point.)

Why would this require a huge performance hit? It's comparable to temp
file + rename which doesn't have this performance hit either AFAIK.

> If the use case is really one of replacing the data while maintaining
> the metadata (i.e., ACL's, extended attributes, etc.), we've already
> pointed out that in the case of a file editor, you had better have
> durability. =C2=A0Keep in mind that if you don't eventually call fsyn=
c(),
> you'll never know if the file system is full or the user has hit thei=
r
> quota, and the data can't be lazily written out later. =C2=A0Or in th=
e case
> of a networked file system, what if the network connection disappears
> before you have a chance to lazily update the data and do the rename?
> So before the editor exits, and the last remaining copy of the new
> data (in memory) disappears, you had better call fsync() and check to
> make sure the write can and has succeeded.

Good point. So fsync is still needed in that case. What about the
meta-data though?

> So in the case of replacing the data, what's the use case if it's not
> for a file editor? =C2=A0And note that you've said that you want atom=
icity
> because you want to make sure that after a crash you don't lose data.
> What about the case where the system doesn't crash, but the wireless
> connection goes away, or the user has exceeded his/her quota and they
> were trying to replace 4k worth of data fork with 12k worth of data?
> I can certainly think of scenarios where wireless connection drops an=
d
> quota overruns are far more likely than system crashes. =C2=A0(i.e., =
when
> you're not using proprietary video drivers. =C2=A0:-P)
>
>> Providing transaction semantics for multiple files is a far broader
>> proposal and not necessary for implement this proposal.
>
> But providing magic transaction semantics for a single file in the
> rename is not at all clearly useful. =C2=A0You need to justify all of=
 this
> hard effort, and performance loss. =C2=A0(Well, or if you're so smart=
 you
> can implement your own file system that does all of this work, and we
> can benchmark it against a file system that doesn't do all of this
> work....)

Still waiting on any hint for why that performance loss would happen.

>> I'm not sure, but Ted appears to be saying temp file + rename (but n=
o
>> fsync) isn't guaranteed to work either.
>
> It won't work if you get really unlucky and your system takes a power
> cut right at the wrong moment during or after the rename(). =C2=A0It =
could
> be made to work, but at a performance cost. =C2=A0And the question is
> whether the performance cost is worth it. =C2=A0At the end of the day=
 it's
> all between the tradeoff between performance cost, implementation
> cost, and value to the user and the application programmer. =C2=A0Whi=
ch is
> why you need to articular the use case where this makes sense.
>
> It's not dpkg, and it's not file editors. =C2=A0What is it, specifica=
lly?
> And why can it tolerate data loss in the case of quota overruns and
> wireless connection hits, but not in the case of system crashes?

There are two different kinds of losses here. One is losing the entire
file, the other is losing the update but still having the old file.

>> It just seems quite suboptimal. There's no need for infinite storage
>> (or an oracle) to avoid this.
>
> If you're so smart, why don't you try implementing it? =C2=A0Itt's go=
ing to
> be hard for us to convince you why it's going to be non-trivial and
> have huge implementation *and* performance costs, so why don't you
> produce the patches that makes this all work?

Why is that so hard?
Should be a lot easier then me implementing a FS from scratch.

Olaf
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
