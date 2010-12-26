From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Atomic non-durable file write API
Date: Sun, 26 Dec 2010 17:55:23 +0200
Message-ID: <4D17656B.7010603@panasas.com>
References: <1292710543.17128.14.camel@nayuki>	<AANLkTimbkstru_nUxnd7R8Zg=ioB3skTntedq_dLxpZm@mail.gmail.com>	<AANLkTi=BW85d6VpGAt0KaGES+4dRQmsvRyFamE=ChEXE@mail.gmail.com>	<20101224085126.2a7ff187@notabene.brown>	<20101223222206.GD12763@thunk.org>	<4D13E98D.8070105@ontolinux.com>	<20101224004825.GF12763@thunk.org>	<4D13F09D.4010703@ontolinux.com>	<20101224095105.GG12763@thunk.org>	<AANLkTimPZ_Hq2Ye4mc60WKTWZNU4Zz3yZaPzfARYa6jh@mail.gmail.com>	<20101225031529.GA2595@thunk.org>	<AANLkTi=TWjKMfLG0nGGjxvGR87PwNm5NkKYPnsFsLgfZ@mail.gmail.com>	<AANLkTikHMZDyNkaOux5VWUHvC5D1cXHEFKxhvzfVjN+Q@mail.gmail.com>	<AANLkTinjtoF0gOdi6TV+RPjMkeqA8fcrkJBYRBd5WQ==@mail.gmail.com>	<AANLkTi=g4zvxdQdnS7crg015sexk3NSJ3CaODi_c=6Fv@mail.gmail.com> <AANLkTinHa1wLB6hKi_xwiQNwMb1xZs-pa1sLB=ebtjiX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Nick Piggin <npiggin@gmail.com>, Ted Ts'o <tytso@mit.edu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:57632 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab0LZPz0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 26 Dec 2010 10:55:26 -0500
In-Reply-To: <AANLkTinHa1wLB6hKi_xwiQNwMb1xZs-pa1sLB=ebtjiX@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/26/2010 05:08 PM, Olaf van der Spek wrote:
>> Please tell us what for. If you have immediate need to replace the
>> name, then you need the durability of fsync. If you don't have
>> immediate need, then you can use another name, surely (until it
>> comes time you want to switch names, at that point you want
>> durability so you fsync then rename).
> 
> Temp file, rename has issues with losing meta-data.
> 

What if you use a soft link? wouldn't that solve all of your problems?

- do your fsync/fdatasync of choice in a *backend thread* then at the return
- point set to the new link, fsync the link it's very small, therefore fast.
- Then delete the old source file.

You need a simple "name-version" schema and the "name" is kept soft linked.
(You might even skip the last step above and implement an undo stack, some
 background management caps on history size)

>>
>>> and this way has other
>>> issues, like losing file meta-data.
>>

With soft links this is persevered?

Same system can be used with lots of files. where the final switch is
the set of a single soft-link say to a folder of related files.

Just me $0.017
Boaz
