From: Christian Stroetmann <stroetmann@ontolinux.com>
Subject: Re: Atomic non-durable file write API
Date: Mon, 27 Dec 2010 16:30:14 +0100
Message-ID: <4D18B106.4010308@ontolinux.com>
References: <20101224095105.GG12763@thunk.org>	<AANLkTimPZ_Hq2Ye4mc60WKTWZNU4Zz3yZaPzfARYa6jh@mail.gmail.com>	<20101225031529.GA2595@thunk.org>	<AANLkTi=TWjKMfLG0nGGjxvGR87PwNm5NkKYPnsFsLgfZ@mail.gmail.com>	<AANLkTikHMZDyNkaOux5VWUHvC5D1cXHEFKxhvzfVjN+Q@mail.gmail.com>	<AANLkTinjtoF0gOdi6TV+RPjMkeqA8fcrkJBYRBd5WQ==@mail.gmail.com>	<AANLkTi=g4zvxdQdnS7crg015sexk3NSJ3CaODi_c=6Fv@mail.gmail.com>	<AANLkTinHa1wLB6hKi_xwiQNwMb1xZs-pa1sLB=ebtjiX@mail.gmail.com>	<AANLkTinXd8Zf=13HSYTxsAUc02jbCgV=17UqXQyFxNUG@mail.gmail.com>	<AANLkTi=ihgiJAsJ+hSeRjhcOTUhY5YC-xPDRPT0ws+oB@mail.gmail.com>	<20101226221016.GF2595@thunk.org> <AANLkTikS8hJtqxRrc3CqQs591bSkynQT1hg=vR4QBo0J@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Ted Ts'o <tytso@mit.edu>,
	Nick Piggin <npiggin@gmail.com>
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:60864 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab0L0P3q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Dec 2010 10:29:46 -0500
In-Reply-To: <AANLkTikS8hJtqxRrc3CqQs591bSkynQT1hg=vR4QBo0J@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On the 27.12.2010 11:21, Olaf van der Spek wrote:
> On Sun, Dec 26, 2010 at 11:10 PM, Ted Ts'o<tytso@mit.edu>  wrote:
>> On Sun, Dec 26, 2010 at 07:51:23PM +0100, Olaf van der Spek wrote:
>>> f = open(..., O_ATOMIC, O_CREAT, O_TRUNC);
>> Great, let's rename O_ATOMIC to O_PONIES.  :-)
> If that makes you happy.
>
>>> abort/rollback(...); // optional
>> As I said earlier, "file systems are not databases", and "databases
>> are not file systems".  Oracle tried to foist their database as a file
>> system during the dot.com boom, and everyone laughed at them; the
>> performance was a nightmare.  If Oracle wasn't able to make a
>> transaction engine that supports transactions and rollbacks
>> performant, you really expect that you'll be able to do it?
> Like I've said dozens of times, this is not about full DB functionality.
> Why do you keep making false analogies?

The analogy is not so wrong. The concepts atomicity and abort/rollback 
your are talking about are also concepts of the field of database 
management systems (DBMSs). And once you have established the Atomicity, 
which is the A of the principle ACID of DBMSs, you have the basis for 
establishing the rest, the CID.

And you even went further into this DBMS direction by letting down the 
requirement of non-durability.

<snip>

>>> Providing transaction semantics for multiple files is a far broader
>>> proposal and not necessary for implement this proposal.
>> But providing magic transaction semantics for a single file in the
>> rename is not at all clearly useful.  You need to justify all of this
>> hard effort, and performance loss.  (Well, or if you're so smart you
>> can implement your own file system that does all of this work, and we
>> can benchmark it against a file system that doesn't do all of this
>> work....)
> Still waiting on any hint for why that performance loss would happen.

 From my point of view, the loss of performance depends on what is 
benchmarked in which way.

<snip>

> Olaf
> --

Christian Stroetmann
