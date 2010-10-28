From: Sedat Dilek <sedat.dilek@googlemail.com>
Subject: Re: ext4 patches for 2.6.37-rc1?
Date: Thu, 28 Oct 2010 08:41:56 +0200
Message-ID: <AANLkTinEbCycO+RB82_aB9t6AakDT08AcTYSrzFQJS6g@mail.gmail.com>
References: <AANLkTikXgtFRSZRCjT9skEgsUzTqbuuhO2Cmv4RTrOTM@mail.gmail.com>
	<20101027202933.GD3194@thunk.org>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53726 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab0J1Gl6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Oct 2010 02:41:58 -0400
Received: by qwf7 with SMTP id 7so839679qwf.19
        for <linux-ext4@vger.kernel.org>; Wed, 27 Oct 2010 23:41:58 -0700 (PDT)
In-Reply-To: <20101027202933.GD3194@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

thanks for your explanations.

Just saw your GIT-pull request on LKML [1] and compiling now
linux-next (next-20101028) [2] which includes ext4.
Linus pulled to upstream, so 2.6.36-git11 will have the ext4-patches :-=
).

Thanks all for their work on ext4!

Kind Regards,
- Sedat -

[1] http://lkml.org/lkml/2010/10/28/12
[2] http://lkml.org/lkml/2010/10/27/509

On Wed, Oct 27, 2010 at 10:29 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Wed, Oct 27, 2010 at 12:36:46PM +0200, Sedat Dilek wrote:
>>
>> I was wondering if Ted will send ext4 patches within the open
>> merge-window for 2.6.37-rc1.
>
> Yes, I am planning on sending patches to Linus.
>
> It's a bit late because I've been crazy busy this past few weeks.
>
>> If you plan to send to Linus, can you give a short overview what
>> endusers will expect?
>
> lazy inode table init, improved scalability for buffered writeback (3=
x
> throughput improvement when writing large files in parallel on 48 and
> 192 threads on a 48-core machine), and a bunch of cleanups and bug
> fixes.
>
>> BTW, in which of the GIT trees ([1], [2]) is the ext4 development
>> actually happening?
>>
>> [1] http://git.kernel.org/?p=3Dlinux/kernel/git/tytso/ext4.git;a=3Ds=
ummary
>> [2] http://repo.or.cz/w/ext4-patch-queue.git
>
> Primary development happens in [2], and then it gets mirrored to [1]
> periodically.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0- Ted
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
