From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Fri, 24 Dec 2010 12:14:21 +0100
Message-ID: <AANLkTimPZ_Hq2Ye4mc60WKTWZNU4Zz3yZaPzfARYa6jh@mail.gmail.com>
References: <AANLkTikhDgJNny74nyBugg9cUmxC9j8Eo8YY4Fr3fm=5@mail.gmail.com>
	<4D0A7278.3080506@gmail.com>
	<1292710543.17128.14.camel@nayuki>
	<AANLkTimbkstru_nUxnd7R8Zg=ioB3skTntedq_dLxpZm@mail.gmail.com>
	<AANLkTi=BW85d6VpGAt0KaGES+4dRQmsvRyFamE=ChEXE@mail.gmail.com>
	<20101224085126.2a7ff187@notabene.brown>
	<20101223222206.GD12763@thunk.org>
	<4D13E98D.8070105@ontolinux.com>
	<20101224004825.GF12763@thunk.org>
	<4D13F09D.4010703@ontolinux.com>
	<20101224095105.GG12763@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56385 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab0LXLOW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Dec 2010 06:14:22 -0500
In-Reply-To: <20101224095105.GG12763@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 24, 2010 at 10:51 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, Dec 24, 2010 at 02:00:13AM +0100, Christian Stroetmann wrote:
>> I really do know what you want to say, despite that this example is
>> based on a bug in another system than the FS. But there will be
>> other examples, for sure.
>
> Sure, but this thread started because someone wanted an "atomic
> non-durable file write API", apparently because it was too slow to us=
e
> fsync(). =C2=A0If people use databases, it's not a problem; databases=
 use
> fsync(), but they use it properly and they provide the proper
> transactional interfaces that people want.
>
> The problem comes when people try to implement their own databases
> using small files for each row and column of the database, or for eac=
h
> registry variable. =C2=A0Then they complain when fsync() is to expens=
ive,
> because they need to use fsync() for every single 3 bytes of data the=
y
> store in their badly implemented database.
>
> The bottom line is that if you want atomic updates of state
> information, you need to use fsync() or fdatasync(). =C2=A0If this is=
 a
> performance bottleneck, then you're doing something wrong. =C2=A0Mayb=
e you
> shouldn't be writing a third of a megabyte on every URL click, on the
> main GUI thread; maybe the user doesn't need to remember every single
> URL that was visited even if the power suddenly fails (maybe it's
> enough if you write that information to disk every 3-5 minutes, and
> less if you're running on battery). =C2=A0Or maybe you shouldn't be u=
sing
> hundreds of small state files, and screw up the dirty flag handling.
> But regardless, you're doing something wrong/stupid.

Hi Ted,

Thanks for taking the time to answer. The thread was started due to
the dpkg issue.
The questions were:
> What is the recommended way for atomic non-durable (complete) file wr=
ites?

It seems you're saying fsync is required, but why can't atomic be
provided without durable? Is it just an API issue?

If rename is recommended, how does one preserve meta-data including fil=
e owner?

> I'm also wondering why FSs commit after open/truncate but before
write/close. AFAIK this isn't necessary and thus suboptimal.

Olaf
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
