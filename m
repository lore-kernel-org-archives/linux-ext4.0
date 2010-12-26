From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Sun, 26 Dec 2010 11:59:43 +0200
Message-ID: <AANLkTi=OqXqa+76H2f8oygm1Y6iZUY+NZ=K3Sp_x=AfH@mail.gmail.com>
References: <AANLkTing7+SK+pavFehR4AGDbRRfFwvvzNxgWQ3zRp+O@mail.gmail.com>
	<AANLkTimZtza_t8s1uOrE3BFfb-8FELjW95nrQz3RULWd@mail.gmail.com>
	<AANLkTikhDgJNny74nyBugg9cUmxC9j8Eo8YY4Fr3fm=5@mail.gmail.com>
	<4D0A7278.3080506@gmail.com>
	<1292710543.17128.14.camel@nayuki>
	<AANLkTimbkstru_nUxnd7R8Zg=ioB3skTntedq_dLxpZm@mail.gmail.com>
	<AANLkTi=BW85d6VpGAt0KaGES+4dRQmsvRyFamE=ChEXE@mail.gmail.com>
	<20101223224309.GH18264@dastard>
	<20101223224740.GE12763@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dave Chinner <david@fromorbit.com>, "Ted Ts'o" <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58747 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab0LZJ7o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 26 Dec 2010 04:59:44 -0500
In-Reply-To: <20101223224740.GE12763@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 24, 2010 at 12:47 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, Dec 24, 2010 at 09:43:09AM +1100, Dave Chinner wrote:
>>
>> So you are looking for something like:
>>
>> http://developer.apple.com/library/mac/#DOCUMENTATION/Darwin/Referen=
ce/ManPages/man2/exchangedata.2.html
>>
>
> It doesn't look like the man page for exchangedata() states what
> happens if the system crashes. =A0It says "atomic" the same way the
> rename() system call says it is "atomic".... i.e., from the
> perspective of processes running on the system see either the
> pre-exchange or post-exchange state.
>

Since we already have EXT4_IOC_MOVE_EXT ioctl, it might as well be
used for the purpose of 'safe save'
in the same manner that exachangedata() works.

Whether or not the new data is durable is entirely up to the
programmer to decide.
Perhaps all that is missing is an fdatawait(fd) API or fdatawait_async(=
fd) API,
which should be very simple to implement (right?).

So an editor that doesn't want to be too pushy, will just save a temp f=
ile,
wait for it to sync on the system's free time and then swap the data wi=
th
the original file in an atomic manner, which preserves metadata.

If the system takes too long to sync, the editor can always issue
fdatasync(fd) when it is tired of waiting.

Will that make you happy, Olaf?
If you are not happy from the new copy not being available to all
system users until
fdatasync is done, then we will call it "atomic, isolated non-durable
file write API", OK?

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
