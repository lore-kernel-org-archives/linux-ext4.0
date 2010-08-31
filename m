From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: [RFC PATCH] ext4: fix 50% disk write performance regression
Date: Mon, 30 Aug 2010 17:51:39 -0700
Message-ID: <AANLkTi=pfVCKmURAnhageAuQFT7yUMy+5NzJ8C9NunXt@mail.gmail.com>
References: <20100829231126.8d8b2086.billfink@mindspring.com>
	<20100830174000.GA6647@thunk.org>
	<20100830164958.edb64c63.bill@wizard.sci.gsfc.nasa.gov>
	<20100831003710.GA4272@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Bill Fink <bill@wizard.sci.gsfc.nasa.gov>,
	Bill Fink <billfink@mindspring.com>,
	"adilger@sun.com" <adilger@sun.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Fink, William E. (GSFC-6061)" <william.e.fink@nasa.gov>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37745 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183Ab0HaAvj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Aug 2010 20:51:39 -0400
Received: by gwj17 with SMTP id 17so2228226gwj.19
        for <linux-ext4@vger.kernel.org>; Mon, 30 Aug 2010 17:51:39 -0700 (PDT)
In-Reply-To: <20100831003710.GA4272@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 30, 2010 at 5:37 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Mon, Aug 30, 2010 at 04:49:58PM -0400, Bill Fink wrote:
>> > Thanks for reporting it. =A0I'm going to have to take a closer loo=
k at
>> > why this makes a difference. =A0I'm going to guess though that wha=
t's
>> > going on is that we're posting writes in such a way that they're n=
o
>> > longer aligned or ending at the end of a RAID5 stripe, causing a
>> > read-modify-write pass. =A0That would easily explain the write
>> > performance regression.
>>
>> I'm not sure I understand. =A0How could calling or not calling
>> ext4_num_dirty_pages() (unpatched versus patched 2.6.35 kernel)
>> affect the write alignment?
>
> Suppose you have 8 disks, with stripe size of 16k. =A0Assuming that
> you're only using one parity disk (i.e., RAID 5) and no spare disks,
> that means the optimal I/O size is 7*16k =3D=3D 112k. =A0If we do a w=
rite
> which is smaller than 112k, or which is not a multiple of 112k, then
> the RAID subsystem will need to do a read-modify-write to update the
> parity disk. =A0Furthermore, the write had better be aligned on an 11=
2k
> byte boundary. =A0The block allocator will guarantee that block #0 is
> aligned on a 112k block, but writes have to also be right size in
> order to avoid the read-modify-write.
>
> If we end up doing very small writes, then it can end up being quite
> disatrous for write performance.

I'd have to agree that this is likely the case.  Just to add a little
more data here, I tried the same 32GB dd test against a 12-disk MD
RAID 6 64k chunk array today with and without the patch (although
against a 2.6.33.7 kernel), and my write performance dropped from
~420MB/sec down to 350MB/sec when I used the patched kernel.

-Justin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
