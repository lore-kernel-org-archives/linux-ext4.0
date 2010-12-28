From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Tue, 28 Dec 2010 17:15:57 -0500
Message-ID: <AANLkTinJVJM0Gb2osYQeTUetuVTkJYyXfQR0fkmwS_Pg@mail.gmail.com>
References: <20101224095105.GG12763@thunk.org> <AANLkTimPZ_Hq2Ye4mc60WKTWZNU4Zz3yZaPzfARYa6jh@mail.gmail.com>
 <20101225031529.GA2595@thunk.org> <AANLkTi=TWjKMfLG0nGGjxvGR87PwNm5NkKYPnsFsLgfZ@mail.gmail.com>
 <AANLkTikHMZDyNkaOux5VWUHvC5D1cXHEFKxhvzfVjN+Q@mail.gmail.com>
 <AANLkTinjtoF0gOdi6TV+RPjMkeqA8fcrkJBYRBd5WQ==@mail.gmail.com>
 <AANLkTi=g4zvxdQdnS7crg015sexk3NSJ3CaODi_c=6Fv@mail.gmail.com>
 <AANLkTinHa1wLB6hKi_xwiQNwMb1xZs-pa1sLB=ebtjiX@mail.gmail.com>
 <AANLkTinXd8Zf=13HSYTxsAUc02jbCgV=17UqXQyFxNUG@mail.gmail.com>
 <AANLkTi=ihgiJAsJ+hSeRjhcOTUhY5YC-xPDRPT0ws+oB@mail.gmail.com>
 <20101226221016.GF2595@thunk.org> <AANLkTikS8hJtqxRrc3CqQs591bSkynQT1hg=vR4QBo0J@mail.gmail.com>
 <4D18B106.4010308@ontolinux.com> <AANLkTimMSxGTEcTbsx8MUYVTLhYRxrdDFQsi6Toer_h9@mail.gmail.com>
 <4D18E94C.3080908@ontolinux.com> <AANLkTikW8K4VFLJuYngU64m2vAL1yhA3R=jRt7U6-RRp@mail.gmail.com>
 <20101229075928.6bdafb08@notabene.brown> <AANLkTimxbjEntSBYxzxnHnOOCUkdNyGWJ40HGG=0d0E5@mail.gmail.com>
 <AANLkTin361ZYPc7X5++E0DPZ1_Ndt5naprXeGJJJtgqy@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Neil Brown <neilb@suse.de>,
	Christian Stroetmann <stroetmann@ontolinux.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, "Ted Ts'o" <tytso@mit.edu>,
	Nick Piggin <npiggin@gmail.com>
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56425 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab0L1WQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Dec 2010 17:16:18 -0500
In-Reply-To: <AANLkTin361ZYPc7X5++E0DPZ1_Ndt5naprXeGJJJtgqy@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 28, 2010 at 5:06 PM, Olaf van der Spek <olafvdspek@gmail.co=
m> wrote:
> On Tue, Dec 28, 2010 at 11:00 PM, Greg Freemyer <greg.freemyer@gmail.=
com> wrote:
>> create temp file
>> write out new data
>> delete old file
>> rename temp file to primary name
>> =3D=3D=3D
>>
>> If so there is still a little window of vulnerability where the whol=
e
>> file can be lost. =A0(Or at least only the temp file is present).
>
> Delete isn't used, rename will overwrite the old file. So it's safe.
> Meta-data is probably lost, file owner is certainly lost.
>
> Olaf

So ACLs are lost?

That seems like a potentially bigger issue than loosing the owner/group=
 info.

And I assume if the owner changes, then the new owner has privileges
to modify ACLs he didn't have previously.

So if I want to instigate a simple denial of service in a multi-user
environment, I edit a few key docs that I have privileges to edit.  By
doing so I take ownership.  As owner I  change the permissions and
ACLs so that no one but me can access them.

Seems like a security hole to me.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
