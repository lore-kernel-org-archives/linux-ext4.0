From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Tue, 28 Dec 2010 23:54:33 +0100
Message-ID: <AANLkTinkHQ2tqAzqo77Bg_iyyYWUE72V85rTQqsEH4Nc@mail.gmail.com>
References: <20101224095105.GG12763@thunk.org>
	<20101225031529.GA2595@thunk.org>
	<AANLkTi=TWjKMfLG0nGGjxvGR87PwNm5NkKYPnsFsLgfZ@mail.gmail.com>
	<AANLkTikHMZDyNkaOux5VWUHvC5D1cXHEFKxhvzfVjN+Q@mail.gmail.com>
	<AANLkTinjtoF0gOdi6TV+RPjMkeqA8fcrkJBYRBd5WQ==@mail.gmail.com>
	<AANLkTi=g4zvxdQdnS7crg015sexk3NSJ3CaODi_c=6Fv@mail.gmail.com>
	<AANLkTinHa1wLB6hKi_xwiQNwMb1xZs-pa1sLB=ebtjiX@mail.gmail.com>
	<AANLkTinXd8Zf=13HSYTxsAUc02jbCgV=17UqXQyFxNUG@mail.gmail.com>
	<AANLkTi=ihgiJAsJ+hSeRjhcOTUhY5YC-xPDRPT0ws+oB@mail.gmail.com>
	<20101226221016.GF2595@thunk.org>
	<AANLkTikS8hJtqxRrc3CqQs591bSkynQT1hg=vR4QBo0J@mail.gmail.com>
	<4D18B106.4010308@ontolinux.com>
	<AANLkTimMSxGTEcTbsx8MUYVTLhYRxrdDFQsi6Toer_h9@mail.gmail.com>
	<4D18E94C.3080908@ontolinux.com>
	<AANLkTikW8K4VFLJuYngU64m2vAL1yhA3R=jRt7U6-RRp@mail.gmail.com>
	<20101229075928.6bdafb08@notabene.brown>
	<AANLkTikZ5wFf0KHiLFNxUO=0EGTqb5Ce-GDTVnGCCUaD@mail.gmail.com>
	<20101229093158.2bfed8ca@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christian Stroetmann <stroetmann@ontolinux.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, "Ted Ts'o" <tytso@mit.edu>,
	Nick Piggin <npiggin@gmail.com>
To: Neil Brown <neilb@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101229093158.2bfed8ca@notabene.brown>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 28, 2010 at 11:31 PM, Neil Brown <neilb@suse.de> wrote:
>> True, but all those exceptions (IMO) should be (proven to be) no pro=
blem.
>> I'd prefer designs that don't have such exceptions. I may not be abl=
e
>> to think of a concrete problem right now, but that doesn't mean such
>> problems don't exist.
>
> Very true. =C2=A0But until such problems are described an understood,=
 there is not
> a lot of point trying to implement a solution. =C2=A0Premature implem=
entation,
> like premature optimisation, is unlikely to be fruitful. =C2=A0I know=
 this from
> experience.

The problems seem clear. The implications not yet.

>>
>> I also don't understand why providing this feature is such a
>> (performance) problem.
>> Surely the people that claim this should be able to explain why.
>
> Without a concrete design, it is hard to assess the performance impac=
t. =C2=A0I
> would guess that those who anticipate a significant performance impac=
t are
> assuming a more feature-full implementation than you are, and they ar=
e
> probably doing that because they feel that you need the extra feature=
s to
> meet the actual needs (and so suggest those needs a best met by a DBM=
S rather
> than a file-system).
> Of course this is just guess work. =C2=A0With concreted reference poi=
nts it is
> hard to be sure.

True, I don't understand why people say it will cause a performance
hit but then don't want to tell why.

>>
>> > You seem to be asking for the ability to atomically change the dat=
a in a file
>> > without changing the metadata. =C2=A0I cannot see why you would wa=
nt this. =C2=A0Maybe
>> > you could give an explicit use-case??
>>
>> Where losing meta-data is bad? That should be obvious.
>> Or where losing file owner is bad? Still thinking about that one.
>
> This is a bit left-field, but I think that losing metadata is always =
a good
> thing. =C2=A0A file should contain data - nothing else. =C2=A0At all.=
 =C2=A0Owner and access
> permissions should be based on location as dictated by external polic=
y....
> but yeah - off topic.

In that case meta-data shouldn't be supported in the first place.

> Clearly maintaining metadata by creating a new file and renaming in-p=
lace is
> easy for root (chown/chmod/etc). =C2=A0So you are presumably envisagi=
ng situations
> where a non-root user has write access to a file that they don't own,=
 and
> they want to make an atomic data-update to that file.
> Sorry, but I think that allowing non-owners to write to a file is a r=
eally
> really bad idea and providing extra support for that use-case is comp=
letely
> unjustifiable.

Isn't it quite common?
Is preserving other meta-data really easy enough to be sure most apps d=
o it?

> If you want multiple people to be able to update some data you should=
 have
> some way to ask the owner to make an update. =C2=A0That could be:
> =C2=A0- setuid program
> =C2=A0- daemon which authenticates requests
> =C2=A0- distributed workflow tool like 'git' where you speak to the o=
wner
> =C2=A0 =C2=A0and ask them to pull updates.
>
> and there are probably other options. =C2=A0But un-mediated writes to=
 a file you
> don't own? =C2=A0Just say NO!

Wouldn't that make Linux user groups quite useless?

Olaf
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
