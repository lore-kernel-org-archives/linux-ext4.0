From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Mon, 27 Dec 2010 20:07:01 +0100
Message-ID: <AANLkTimMSxGTEcTbsx8MUYVTLhYRxrdDFQsi6Toer_h9@mail.gmail.com>
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
	<AANLkTikS8hJtqxRrc3CqQs591bSkynQT1hg=vR4QBo0J@mail.gmail.com>
	<4D18B106.4010308@ontolinux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, "Ted Ts'o" <tytso@mit.edu>,
	Nick Piggin <npiggin@gmail.com>
To: Christian Stroetmann <stroetmann@ontolinux.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4D18B106.4010308@ontolinux.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Dec 27, 2010 at 4:30 PM, Christian Stroetmann
<stroetmann@ontolinux.com> wrote:
>> Like I've said dozens of times, this is not about full DB functionality.
>> Why do you keep making false analogies?
>
> The analogy is not so wrong. The concepts atomicity and abort/rollback your
> are talking about are also concepts of the field of database management
> systems (DBMSs). And once you have established the Atomicity, which is the A
> of the principle ACID of DBMSs, you have the basis for establishing the
> rest, the CID.
>
> And you even went further into this DBMS direction by letting down the
> requirement of non-durability.

Of course the concepts are the same. That doesn't mean the analogy is valid.

>> Still waiting on any hint for why that performance loss would happen.
>
> From my point of view, the loss of performance depends on what is
> benchmarked in which way.

Maybe, but still no indication of why.

Olaf
