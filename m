From: Christian Stroetmann <stroetmann@ontolinux.com>
Subject: Re: Atomic non-durable file write API
Date: Wed, 29 Dec 2010 16:30:51 +0100
Message-ID: <4D1B542B.9030400@ontolinux.com>
References: <20101224095105.GG12763@thunk.org>	<AANLkTi=TWjKMfLG0nGGjxvGR87PwNm5NkKYPnsFsLgfZ@mail.gmail.com>	<AANLkTikHMZDyNkaOux5VWUHvC5D1cXHEFKxhvzfVjN+Q@mail.gmail.com>	<AANLkTinjtoF0gOdi6TV+RPjMkeqA8fcrkJBYRBd5WQ==@mail.gmail.com>	<AANLkTi=g4zvxdQdnS7crg015sexk3NSJ3CaODi_c=6Fv@mail.gmail.com>	<AANLkTinHa1wLB6hKi_xwiQNwMb1xZs-pa1sLB=ebtjiX@mail.gmail.com>	<AANLkTinXd8Zf=13HSYTxsAUc02jbCgV=17UqXQyFxNUG@mail.gmail.com>	<AANLkTi=ihgiJAsJ+hSeRjhcOTUhY5YC-xPDRPT0ws+oB@mail.gmail.com>	<20101226221016.GF2595@thunk.org>	<AANLkTikS8hJtqxRrc3CqQs591bSkynQT1hg=vR4QBo0J@mail.gmail.com>	<4D18B106.4010308@ontolinux.com>	<AANLkTimMSxGTEcTbsx8MUYVTLhYRxrdDFQsi6Toer_h9@mail.gmail.com>	<4D18E94C.3080908@ontolinux.com>	<AANLkTikW8K4VFLJuYngU64m2vAL1yhA3R=jRt7U6-RRp@mail.gmail.com>	<20101229075928.6bdafb0
 8@notabene.brown>	<AANLkTikZ5wFf0KHiLFNxUO=0EGTqb5Ce-GDTVnGCCUaD@mail.gmail.com>	<20101229093158.2bfed8ca@notabene.brown> <AANLkTinkHQ2tqAzqo77Bg_iyyYWUE72V85rTQqsEH4Nc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Ted Ts'o <tytso@mit.edu>, Neil Brown <neilb@suse.de>,
	Nick Piggin <npiggin@gmail.com>
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:54039 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab0L2P35 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Dec 2010 10:29:57 -0500
In-Reply-To: <AANLkTinkHQ2tqAzqo77Bg_iyyYWUE72V85rTQqsEH4Nc@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On the 28.12.2010 23:54, Olaf van der Spek wrote:
> On Tue, Dec 28, 2010 at 11:31 PM, Neil Brown<neilb@suse.de>  wrote:
>>> True, but all those exceptions (IMO) should be (proven to be) no problem.
>>> I'd prefer designs that don't have such exceptions. I may not be able
>>> to think of a concrete problem right now, but that doesn't mean such
>>> problems don't exist.
>> Very true.  But until such problems are described an understood, there is not
>> a lot of point trying to implement a solution.  Premature implementation,
>> like premature optimisation, is unlikely to be fruitful.  I know this from
>> experience.
> The problems seem clear. The implications not yet.
>
>>> I also don't understand why providing this feature is such a
>>> (performance) problem.
>>> Surely the people that claim this should be able to explain why.
>> Without a concrete design, it is hard to assess the performance impact.  I
>> would guess that those who anticipate a significant performance impact are
>> assuming a more feature-full implementation than you are, and they are
>> probably doing that because they feel that you need the extra features to
>> meet the actual needs (and so suggest those needs a best met by a DBMS rather
>> than a file-system).
>> Of course this is just guess work.  With concreted reference points it is
>> hard to be sure.
> True, I don't understand why people say it will cause a performance
> hit but then don't want to tell why.

We are talking about atomicity. And it is a simple fact in the field of 
information processing/informatics/computer science that if someone 
wants to give/have the guarantee of atomicity, then she/he has to do 
several additional steps often by using an additional data structure. In 
the end this all costs more time and/or space than doing it without 
atomicity. At this point there is no discussion anymore, because this is 
fully discussed to the maximum in subjects like Efficient Algorithms, 
Special Problem Fields of Operating System Design and Fundamentals of 
DBMS Design (eg. AtomicityCID principle).
And such fundamental points are not (needed to be) discussed here.

Furthermore, due to the competence it is possible for FS gurus like Ted 
to estimate that the additional steps have to be done by several 
functions of an FS, which implies performance loss. And because 
elementary FS functions are involved the performance loss could be and 
in the past have been significant, though in nearly all cases I have 
seen the reason was a very bad implementation. The only exception so far 
is the Reiser4 FS: All of its file operations are atomic, but still to a 
little cost of performance in the most cases and the need of a repacker 
in some few cases which show a significant loss of performance.

And the advice to use a well-known DBMS is simply based on the knowledge 
that it has all the needed functionality already implemented in a highly 
performant way, and on the knowledge that such a solution is used 
oftenly for comparable use cases due to the cost vs. benefit ratio.
To take a look at the Reiser4 FS could also help.

<snip>

> Olaf

The bar is opened
Christian Stroetmann

