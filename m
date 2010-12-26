From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Atomic non-durable file write API
Date: Sun, 26 Dec 2010 18:27:34 +0200
Message-ID: <4D176CF6.7010208@panasas.com>
References: <1292710543.17128.14.camel@nayuki>	<AANLkTimbkstru_nUxnd7R8Zg=ioB3skTntedq_dLxpZm@mail.gmail.com>	<AANLkTi=BW85d6VpGAt0KaGES+4dRQmsvRyFamE=ChEXE@mail.gmail.com>	<20101224085126.2a7ff187@notabene.brown>	<20101223222206.GD12763@thunk.org>	<4D13E98D.8070105@ontolinux.com>	<20101224004825.GF12763@thunk.org>	<4D13F09D.4010703@ontolinux.com>	<20101224095105.GG12763@thunk.org>	<AANLkTimPZ_Hq2Ye4mc60WKTWZNU4Zz3yZaPzfARYa6jh@mail.gmail.com>	<20101225031529.GA2595@thunk.org>	<AANLkTi=TWjKMfLG0nGGjxvGR87PwNm5NkKYPnsFsLgfZ@mail.gmail.com>	<AANLkTikHMZDyNkaOux5VWUHvC5D1cXHEFKxhvzfVjN+Q@mail.gmail.com>	<AANLkTinjtoF0gOdi6TV+RPjMkeqA8fcrkJBYRBd5WQ==@mail.gmail.com>	<AANLkTi=g4zvxdQdnS7crg015sexk3NSJ3CaODi_c=6Fv@mail.gmail.com>	<AANLkTinHa1wLB6hKi_xwiQNwMb1xZs-pa1sLB=ebtjiX@mail.gmail.com>	<4D
 17656B.7010603@panasas.com> <AANLkTinaAtrCYfusv59T3FE5A45A77R8oTMPpJUJs03p@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Nick Piggin <npiggin@gmail.com>, Ted Ts'o <tytso@mit.edu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:58086 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab0LZQ1h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 26 Dec 2010 11:27:37 -0500
In-Reply-To: <AANLkTinaAtrCYfusv59T3FE5A45A77R8oTMPpJUJs03p@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/26/2010 06:02 PM, Olaf van der Spek wrote:
> On Sun, Dec 26, 2010 at 4:55 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>> What if you use a soft link? wouldn't that solve all of your problems?
>>
>> - do your fsync/fdatasync of choice in a *backend thread* then at the return
>> - point set to the new link, fsync the link it's very small, therefore fast.
>> - Then delete the old source file.
>>
>> You need a simple "name-version" schema and the "name" is kept soft linked.
>> (You might even skip the last step above and implement an undo stack, some
>>  background management caps on history size)
>>
>>>>
>>>>> and this way has other
>>>>> issues, like losing file meta-data.
>>>>
>>
>> With soft links this is persevered?
>>
>> Same system can be used with lots of files. where the final switch is
>> the set of a single soft-link say to a folder of related files.
> 
> Are you proposing to turn every single file into a symlink?

Sure, a symlink and a "versioned" file for every object. Something similar
to the silly rename of nfs.

Even if you have 1000 files that need the same atomicity treatment
that's not that bad. You should be able to devise a namespace policy
that makes all this nit and tidy.

> How would that solve the meta-data issue?
> 

That's what I asked. Do you want to preserve the original's file
metat-data, or the meta-data of the owner of the new content?
In the first case you'll need a metat-data copy like tar is
using.

> Olaf

The point is to fsync/fdatasync on a background thread and continue
from there where the application is free to go on to the next step.
As if you had a notification when the commit was done (in the background).
So you make it an async pipeline model. The version-naming schem is so the
pipeline can get arbitrary big.

Boaz
