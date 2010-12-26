From: Nick Piggin <npiggin@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Mon, 27 Dec 2010 03:52:03 +1100
Message-ID: <AANLkTin2dLhnWcxvBv4DuMVvNoykg2NEJwTiPc0BLrP+@mail.gmail.com>
References: <AANLkTing7+SK+pavFehR4AGDbRRfFwvvzNxgWQ3zRp+O@mail.gmail.com>
	<AANLkTimZtza_t8s1uOrE3BFfb-8FELjW95nrQz3RULWd@mail.gmail.com>
	<AANLkTikhDgJNny74nyBugg9cUmxC9j8Eo8YY4Fr3fm=5@mail.gmail.com>
	<4D0A7278.3080506@gmail.com>
	<1292710543.17128.14.camel@nayuki>
	<AANLkTimbkstru_nUxnd7R8Zg=ioB3skTntedq_dLxpZm@mail.gmail.com>
	<AANLkTi=BW85d6VpGAt0KaGES+4dRQmsvRyFamE=ChEXE@mail.gmail.com>
	<20101223224309.GH18264@dastard>
	<20101223224740.GE12763@thunk.org>
	<AANLkTi=OqXqa+76H2f8oygm1Y6iZUY+NZ=K3Sp_x=AfH@mail.gmail.com>
	<AANLkTimNK0ku5tBrA0DbSrNZe1jO6LcOobVVMOW2Kmxa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Amir Goldstein <amir73il@gmail.com>,
	Dave Chinner <david@fromorbit.com>, "Ted Ts'o" <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55429 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab0LZQwF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 26 Dec 2010 11:52:05 -0500
In-Reply-To: <AANLkTimNK0ku5tBrA0DbSrNZe1jO6LcOobVVMOW2Kmxa@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 27, 2010 at 2:23 AM, Olaf van der Spek <olafvdspek@gmail.com> wrote:
> On Sun, Dec 26, 2010 at 10:59 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Whether or not the new data is durable is entirely up to the
>> programmer to decide.
>
> Right
>
>> Perhaps all that is missing is an fdatawait(fd) API or fdatawait_async(fd) API,
>> which should be very simple to implement (right?).
>>
>> So an editor that doesn't want to be too pushy, will just save a temp file,
>> wait for it to sync on the system's free time and then swap the data with
>> the original file in an atomic manner, which preserves metadata.
>>
>> If the system takes too long to sync, the editor can always issue
>> fdatasync(fd) when it is tired of waiting.
>>
>> Will that make you happy, Olaf?
>> If you are not happy from the new copy not being available to all
>> system users until
>> fdatasync is done, then we will call it "atomic, isolated non-durable
>> file write API", OK?
>
> No. Take the compiler case. Ideally you'd like file data updates to be
> atomic, but waiting until an update hits disk before it's visible to
> other processes is unacceptable.

How about sending output to an intermediate name, then before it is
used in the next stage of the processor output, fsync+rename to the
expected name? make clean would delete any intermediate names.
