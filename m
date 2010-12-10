From: Jon Nelson <jnelson@jamponi.net>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Fri, 10 Dec 2010 10:54:40 -0600
Message-ID: <AANLkTinMt6saGeeX3MbwAzZ-+f6AL5BegeFqyPgGwiDo__43581.2545860701$1292000164$gmane$org@mail.gmail.com>
References: <20101207182243.GB21112@redhat.com> <20101207193514.GA2921@thunk.org>
 <AANLkTim8UTkfxXV0AkEfjNq3tcmnrXdh6BQ1ibY5iYPy@mail.gmail.com>
 <20101209180111.GF2921@thunk.org> <AANLkTimAUB5L5Ptm4Fv=sQUmL9_P5azPRCKQnmU89xs8@mail.gmail.com>
 <20101209201359.GG2921@thunk.org> <AANLkTik=ivDrBEzg1wQAp5AFzNtRRq1=NpvnowggU=_0@mail.gmail.com>
 <20101209231616.GA12515@basil.fritz.box> <1291945065-sup-1838@think>
 <AANLkTi=SgzVcOwqJfAHBe5U+1CuhPnm0eKet4hRM2JKz@mail.gmail.com>
 <20101210023852.GB3059@thunk.org> <AANLkTikJ1Q=L15wcMLn=U8-Qx9PbppY-AX=LpmjDkk2V@mail.gmail.com>
 <AANLkTikeiv2jQM5hhghs1Zd2d=5CbRLKMgYvqHqpm76m@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "Ted Ts'o" <tytso@mit.edu>, Matt <jackdachef@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Jon Nelson <jnelson@jamponi.net>,
	Mike Snitzer <snitz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f43.google.com ([209.85.161.43]:40522 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab0LJQzs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Dec 2010 11:55:48 -0500
In-Reply-To: <AANLkTikeiv2jQM5hhghs1Zd2d=5CbRLKMgYvqHqpm76m@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 10, 2010 at 8:58 AM, Jon Nelson <jnelson@jamponi.net> wrote=
:
> On Fri, Dec 10, 2010 at 12:52 AM, Jon Nelson <jnelson@jamponi.net> wr=
ote:
>> On Thu, Dec 9, 2010 at 8:38 PM, Ted Ts'o <tytso@mit.edu> wrote:
>>> On Fri, Dec 10, 2010 at 02:53:30AM +0100, Matt wrote:
>>>>
>>>> Try a kernel before 5a87b7a5da250c9be6d757758425dfeaf8ed3179
>>>>
>>>> from the tests I've done that one showed the least or no corruptio=
n if
>>>> you count the empty /etc/env.d/03opengl as an artefact
>>>
>>> Yes, that's a good test. =C2=A0Also try commit bd2d0210cf. =C2=A0Th=
e patch
>>> series that is most likely to be at fault if there is a regression =
in
>>> between 5a87b7a5d and bd2d0210cf inclusive.
>>>
>>> I did a lot of testing before submitting it, but that wa a tricky
>>> rewrite. =C2=A0If you can reproduce the problem reliably, it might =
be good
>>> to try commit 16828088f9 (the commit before 5a87b7a5d) and commit
>>> bd2d0210cf. =C2=A0If it reliably reproduces on bd2d0210cf, but is c=
lean on
>>> 16828088f9, then it's my ext4 block i/o submission patches, and we'=
ll
>>> need to either figure out what's going on or back out that set of
>>> changes.
>>>
>>> If that's the case, a bisect of those changes (it's only 6 commits,=
 so
>>> it shouldn't take long) would be most appreciated.
>>
>> I observed the behavior on bd2d0210cf in a qemu-kvm install of
>> openSUSE 11.3 (x86_64) on *totally* different host - an AMD quad-cor=
e.
>>
>> I did /not/ observe the behavior on 16828088f9 (yet). I'll run the
>> test a few more times on 1682..
>>
>> Additionally, I am building a bisected kernel now (
>> cb20d5188366f04d96d2e07b1240cc92170ade40 ), but won't be able to get
>> back at it for a while.
>
> cb20d5188366f04d96d2e07b1240cc92170ade40 seems OK so far. I'm going t=
o
> try 1de3e3df917459422cb2aecac440febc8879d410 soon.

Barring false negatives, bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc
appears to be the culprit (according to git bisect).
I will test bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc again, confirm
the behavior, and work backwards to try to reduce the possibility of
false negatives.

--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
