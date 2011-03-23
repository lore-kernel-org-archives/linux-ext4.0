From: Sedat Dilek <sedat.dilek@googlemail.com>
Subject: Re: [ext4] Multiple page-io submission (Option "mblk_io_submit")
Date: Wed, 23 Mar 2011 08:32:28 +0100
Message-ID: <AANLkTi=4k7QrtPg1B7bbzNzVMjj_aKwq99+DByQo2BP6@mail.gmail.com>
References: <AANLkTinXsDN4Bhp9_kcbeu6BNMADTSBVN_6+nn63w+kW@mail.gmail.com>
	<20110209183816.GD9533@thunk.org>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "s.dilek" <s.dilek@jpberlin.de>
To: "Ted Ts'o" <tytso@mit.edu>, sedat.dilek@gmail.com,
	Curt Wohlgemuth <curtw@google.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vg
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48658 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab1CWHc3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Mar 2011 03:32:29 -0400
In-Reply-To: <20110209183816.GD9533@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 9, 2011 at 7:38 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Tue, Feb 08, 2011 at 06:30:29PM +0100, Sedat Dilek wrote:
>> Hi,
>>
>> while looking at pending patches in ext4.git#{master, for_linus}, I
>> saw "ext4: Fix data corruption with multi-block writepages support"
>> which should fix [2] according to text in the commit-body.
>>
>> Are you planning to turn on "multiple page-io submission" again by
>> default (as is was disabled in "ext4: Turn off multiple page-io
>> submission by default" [3])?
>
> I'm planning on turning it on by default post 2.6.38, during the
> 2.6.39-rc1 merge window. =C2=A0That's me being paranoid, since this i=
s so
> late in the -rc cycle for 2.6.38.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0- Ted
>

Ping!
(As the merge-window is still open.)

- Sedat -
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
