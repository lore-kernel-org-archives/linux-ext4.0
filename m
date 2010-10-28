From: Sedat Dilek <sedat.dilek@googlemail.com>
Subject: Re: [next-20101038] Call trace in ext4
Date: Thu, 28 Oct 2010 20:34:19 +0200
Message-ID: <AANLkTi=O1a3ZWg500OgPPLDxQeoEUsRdqGwzcgNmc8RD@mail.gmail.com>
References: <AANLkTi=E_uMj_ndGU86DCjX4aDwjHqg3dkwxjQRSJtq6@mail.gmail.com>
	<20101028175221.GA1578@arch.trippelsdorf.de>
	<AANLkTikOqeT8OznyMvL7XaWS06kh7ZZ+SJLyMfOc32P4@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>, sfr@canb.auug.org.au,
	Arnd Bergmann <arnd@arndb.de>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34796 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761057Ab0J1SeV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Oct 2010 14:34:21 -0400
In-Reply-To: <AANLkTikOqeT8OznyMvL7XaWS06kh7ZZ+SJLyMfOc32P4@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 28, 2010 at 8:20 PM, Sedat Dilek <sedat.dilek@googlemail.co=
m> wrote:
> On Thu, Oct 28, 2010 at 7:52 PM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
>> On Thu, Oct 28, 2010 at 12:05:05PM +0200, Sedat Dilek wrote:
>>> Hi,
>>>
>>> I have built today linux-next as of next-20101028 in a non-BKL conf=
ig
>>> (kernel-config attached) on a Debian i386/sid host.
>>>
>>> When I start my quassel IRC-client I get reproducibly this call-tra=
ce:
>>>
>>> # tail -40 kern.log
>>> Oct 28 11:42:54 tbox kernel: [ =C2=A0 32.872957] EXT3-fs (sdb5): wa=
rning:
>>> maximal mount count reached, running e2fsck is recommended
>>> Oct 28 11:42:54 tbox kernel: [ =C2=A0 32.873621] EXT3-fs (sdb5): us=
ing
>>> internal journal
>>> Oct 28 11:42:54 tbox kernel: [ =C2=A0 32.873635] EXT3-fs (sdb5): mo=
unted
>>> filesystem with ordered data mode
>>> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.480401] ------------[ cut =
here ]------------
>>> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.480598] kernel BUG at
>>> /home/sd/src/linux-2.6/linux-2.6.36/debian/build/source_i386_none/f=
s/ext4/inode.c:2721!
>>
>> The same BUG (inode.c:2721) happend here today running latest vanill=
a
>> git. There is nothing in my logs unfortunately, but I shot a photo o=
f
>> the trace (see attachment).
>>
>> --
>> Markus
>>
>
> Looks like the two patches from ext/for_linus GIT-branch stabilzes
> system, here (2.6.36-git11).
>
> root@tbox:~# uptime
> =C2=A020:19:42 up 19 min, =C2=A04 users, =C2=A0load average: 1.27, 0.=
89, 0.58
>
> - Sedat -
>

One minute after I sent the mail, I ran into the error.
Now, I could start my IRC-client for a while... till crash.


- Sedat -
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
