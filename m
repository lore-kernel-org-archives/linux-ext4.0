From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Fri, 7 Jan 2011 15:23:37 +0100
Message-ID: <AANLkTindRb2v8O3+aR6GkCo=xkT6h5rbHDnkF1L5AdKH@mail.gmail.com>
References: <20101224095105.GG12763@thunk.org>
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
	<AANLkTinkHQ2tqAzqo77Bg_iyyYWUE72V85rTQqsEH4Nc@mail.gmail.com>
	<4D1B542B.9030400@ontolinux.com>
	<AANLkTimpsDAUt6KnE=qmcbRLdZdaSaqxvJFh0Ki3iV7B@mail.gmail.com>
	<4D1B621B.5000804@ontolinux.com>
	<AANLkTindNuT0EKkMW1e8syPLEr_j3zRFS++otMQp42B9@mail.gmail.com>
	<20101230115012.07fa8ec8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christian Stroetmann <stroetmann@ontolinux.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	"Ted Ts'o" <tytso@mit.edu>, Nick Piggin <npiggin@gmail.com>
To: Neil Brown <neilb@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58226 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab1AGOXk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Jan 2011 09:23:40 -0500
In-Reply-To: <20101230115012.07fa8ec8@notabene.brown>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 30, 2010 at 1:50 AM, Neil Brown <neilb@suse.de> wrote:
> On Wed, 29 Dec 2010 18:14:04 +0100 Olaf van der Spek <olafvdspek@gmai=
l.com>
> wrote:
>
>> On Wed, Dec 29, 2010 at 5:30 PM, Christian Stroetmann
>> <stroetmann@ontolinux.com> wrote:
>> >> Additional steps compared to what? The temp file, fsync, rename c=
ase?
>> >
>> > read the paragraphs as a whole
>>
>> Reading stuff again isn't going to change my question.
>>
>
> OK, the fun I over. =C2=A0I guess it is time to actually answer your =
question,
> rather than just teasing you with partial answers and hints about per=
formance
> impact ....
>
> Your question, as I understand it is:
>
> =C2=A0 You see a hypothetical problem for which you cannot see a solu=
tion in
> =C2=A0 Linux, but for which you also cannot present a concrete use-ca=
se where
> =C2=A0 this problem needs to be addresses.
> =C2=A0 You want to know what the recommended solution is.
>
>
> =C2=A0 The reality is that the solution was devises and implemented m=
any years ago
> =C2=A0 and is deeply embedded in the core design principles of Unix a=
nd Linux.
> =C2=A0 The reason that you cannot present a use-case is that there is=
n't one.
> =C2=A0 Unix was design so that this hypothetical need will never aris=
e.

It's so hypothetical that a number of other comments on Ted's blog
about this ask the same question:
http://thunk.org/tytso/blog/2009/03/12/delayed-allocation-and-the-zero-=
length-file-problem/#comment-1979
http://thunk.org/tytso/blog/2009/03/12/delayed-allocation-and-the-zero-=
length-file-problem/#comment-1981
http://thunk.org/tytso/blog/2009/03/12/delayed-allocation-and-the-zero-=
length-file-problem/#comment-1990
http://thunk.org/tytso/blog/2009/03/12/delayed-allocation-and-the-zero-=
length-file-problem/#comment-1992
http://thunk.org/tytso/blog/2009/03/12/delayed-allocation-and-the-zero-=
length-file-problem/#comment-2095
http://thunk.org/tytso/blog/2009/03/12/delayed-allocation-and-the-zero-=
length-file-problem/#comment-2099

And many more.

http://thunk.org/tytso/blog/2009/03/12/delayed-allocation-and-the-zero-=
length-file-problem/

Olaf
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
