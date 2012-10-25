From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH] ext4: do not try to write superblock on journal-less
 readonly remount
Date: Thu, 25 Oct 2012 21:38:20 +0400
Message-ID: <5089790C.8080606@msgid.tls.msk.ru>
References: <1351154397-14743-1-git-send-email-mjt@msgid.tls.msk.ru> <alpine.LFD.2.00.1210251438530.24674@dhcp-1-104.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:47588 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935887Ab2JYRiW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Oct 2012 13:38:22 -0400
In-Reply-To: <alpine.LFD.2.00.1210251438530.24674@dhcp-1-104.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 25.10.2012 16:43, Luk=E1=9A Czerner wrote:
> On Thu, 25 Oct 2012, Michael Tokarev wrote:
>=20
>> Date: Thu, 25 Oct 2012 12:39:57 +0400
>> From: Michael Tokarev <mjt@tls.msk.ru>
>> To: linux-ext4@vger.kernel.org
>> Cc: sandeen@redhat.com, Michael Tokarev <mjt@tls.msk.ru>
>> Subject: [PATCH] ext4: do not try to write superblock on journal-les=
s readonly
>>      remount
>>
>> When a journal-less ext4 filesystem is mounted on a read-only block
>> device (blockdev --setro will do), each remount (for other, unrelate=
d,
>> flags, like suid=3D>nosuid etc) results in a series of scary message=
s
>> from kernel telling about I/O errors on the device.
>=20
> Hi Michael,
>=20
> I am not able to reproduce the problem you're seeing:
>=20
> mkfs.ext4 /dev/sdd1
> tune2fs -O ^has_journal /dev/sdd1
> blockdev --setro /dev/sdd1
> mount /dev/sdd1 /mnt/test
>=20
> and then
>=20
> mount -o remount,suid /dev/sdd1
> mount -o remount,nosuid /dev/sdd1
> mount -o remount,noatime /dev/sdd1
> mount -o remount,relatime /dev/sdd1
> mount -o remount,relatime,commit=3D20 /dev/sdd1
>=20
> just does not produce any errors. Both /var/log/messages and dmesg
> are clear.

Interesting.

Actual situation where I observed this issue was when the device
really was read-only.  In my case it was a virtual machine (kvm)
with a read-only virtio drive (-drive file=3Dfoo,if=3Dvirtio,readonly=3D=
on).
I played with a "live CD"-type system.

Now when I look at it, I'm not sure if I were really able to
reproduce it with regular /dev/sdNN and blockdev --setro.  I
*think* it was reproducible, but actually I can't.  So it looks
like blockdev --setro does not do what it claims to do -- the
actual device isn't really set read-only.

The errors produced at remount are real, when the device in question
really dislikes (reject) writes.  Apparently --setro isn't enough --
somewhere at kernel level write for such device are actually succeeded
instead of being errored out, when the device itself does not reject
writes.  So the impact is even less severe when I initially thought.

Thanks,

/mjt
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
