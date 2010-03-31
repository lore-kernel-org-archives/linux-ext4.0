From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Ext4 performance regression: Post 2.6.30
Date: Wed, 31 Mar 2010 18:06:28 -0400
Message-ID: <x2i87f94c371003311506w94321779nfc3f48d939073e47@mail.gmail.com>
References: <1269843935.13369.52.camel@keith-laptop>
	 <87f94c371003290810u58f64ce6uc20be6bbac420e73@mail.gmail.com>
	 <1270000565.7193.14.camel@keith-laptop> <4BB2CA41.5050406@redhat.com>
	 <1270072944.7193.29.camel@keith-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Keith Mannthey <kmannth@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f202.google.com ([209.85.223.202]:55463 "EHLO
	mail-iw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab0CaWG2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Mar 2010 18:06:28 -0400
Received: by iwn40 with SMTP id 40so491998iwn.1
        for <linux-ext4@vger.kernel.org>; Wed, 31 Mar 2010 15:06:28 -0700 (PDT)
In-Reply-To: <1270072944.7193.29.camel@keith-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 31, 2010 at 6:02 PM, Keith Mannthey <kmannth@us.ibm.com> wr=
ote:
> On Tue, 2010-03-30 at 23:06 -0500, Eric Sandeen wrote:
>> Keith Mannthey wrote:
>> > On Mon, 2010-03-29 at 11:10 -0400, Greg Freemyer wrote:
>> >> On Mon, Mar 29, 2010 at 2:25 AM, Keith Mannthey <kmannth@us.ibm.c=
om> wrote:
>> >>>
>> >>> After 2.6.30 I am seeing large performance regressions on a raid=
 setup.
>> >>> I am working to publish a larger amount of data but I wanted to =
get some
>> >>> quick data out about what I am seeing.
>> >>>
>> >> Is mdraid involved?
>> >>
>> >> They added barrier support for some configs after 2.6.30 I believ=
e.
>> >> It can cause a drastic perf change, but it increases reliability =
and
>> >> is "correct".
>> >
>> > lvm and device mapper are is involved. =A0The git bisect just took=
 me to:
>> >
>> > 374bf7e7f6cc38b0483351a2029a97910eadde1b is first bad commit
>> > commit 374bf7e7f6cc38b0483351a2029a97910eadde1b
>> > Author: Mikulas Patocka <mpatocka@redhat.com>
>> > Date: =A0 Mon Jun 22 10:12:22 2009 +0100
>> >
>> > =A0 =A0 dm: stripe support flush
>> >
>> > =A0 =A0 Flush support for the stripe target.
>> >
>> > =A0 =A0 This sets ti->num_flush_requests to the number of stripes =
and
>> > =A0 =A0 remaps individual flush requests to the appropriate stripe=
 devices.
>> >
>> > =A0 =A0 Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>> > =A0 =A0 Signed-off-by: Alasdair G Kergon <agk@redhat.com>
>> >
>> > :040000 040000 542f4b9b442d1371c6534f333b7e00714ef98609 d490479b66=
0139fc1b6b0ecd17bb58c9e00e597e M =A0drivers
>> >
>> >
>> > This may be correct behavior but the performance penalty in this t=
est
>> > case is pretty high.
>> >
>> > I am going to move back to current kernels and starting looking in=
to
>> > ext4/dm flushing.
>>
>> It would probably be interesting to do a mount -o nobarrier to see i=
f
>> that makes the regression go away.
>
> -o nobarrier takes the regression away with 2.6.34-rc3:
>
> Default mount: ~27500
>
> -o nobarrier: ~12500
>
> Barriers on this setup cost ALOT during writes.
>
> Interestingly as well the "mailserver" workload regression is also
> removed by mounting with "-o nobarrier".
>
> I am going to see what impact is seen on a single disk setup.
>
> Thanks,
> =A0Keith Mannthey
> =A0LTC FS-Dev

I'm curious if your using an internal or external journal?

I'd guess the cost of barriers is much greater with an internal
journal, but I don't recall seeing any benchmarks one way or the
other.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
