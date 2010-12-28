From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Tue, 28 Dec 2010 23:28:31 +0100
Message-ID: <AANLkTimQBg-ik=EAN6=tiee2308eQ33jpqu7SnTd08bK@mail.gmail.com>
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
	<AANLkTimMSxGTEcTbsx8MUYVTLhYRxrdDFQsi6Toer_h9@mail.gmail.com>
	<4D18E94C.3080908@ontolinux.com>
	<AANLkTikW8K4VFLJuYngU64m2vAL1yhA3R=jRt7U6-RRp@mail.gmail.com>
	<20101229075928.6bdafb08@notabene.brown>
	<AANLkTimxbjEntSBYxzxnHnOOCUkdNyGWJ40HGG=0d0E5@mail.gmail.com>
	<AANLkTin361ZYPc7X5++E0DPZ1_Ndt5naprXeGJJJtgqy@mail.gmail.com>
	<AANLkTinJVJM0Gb2osYQeTUetuVTkJYyXfQR0fkmwS_Pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Neil Brown <neilb@suse.de>,
	Christian Stroetmann <stroetmann@ontolinux.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, "Ted Ts'o" <tytso@mit.edu>,
	Nick Piggin <npiggin@gmail.com>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56563 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab0L1W2d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Dec 2010 17:28:33 -0500
In-Reply-To: <AANLkTinJVJM0Gb2osYQeTUetuVTkJYyXfQR0fkmwS_Pg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 28, 2010 at 11:15 PM, Greg Freemyer <greg.freemyer@gmail.co=
m> wrote:
> So ACLs are lost?

I'm not sure. Since preserving them might not be easy I think it's
likely they're lost in some cases.

> That seems like a potentially bigger issue than loosing the owner/gro=
up info.
>
> And I assume if the owner changes, then the new owner has privileges
> to modify ACLs he didn't have previously.
>
> So if I want to instigate a simple denial of service in a multi-user
> environment, I edit a few key docs that I have privileges to edit. =C2=
=A0By
> doing so I take ownership. =C2=A0As owner I =C2=A0change the permissi=
ons and
> ACLs so that no one but me can access them.
>
> Seems like a security hole to me.

If you have write access you can clear the data as well, so
effectively the difference is small.

Olaf
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
