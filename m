From: Stephan Boettcher <boettcher@physik.uni-kiel.de>
Subject: Re: 20TB ext4
Date: Tue, 14 Dec 2010 09:59:48 +0100
Message-ID: <s6nr5dkviez.fsf@falbala.ieap.uni-kiel.de>
References: <s6nzks9y74l.fsf@falbala.ieap.uni-kiel.de>
	<D46B0853-722D-4337-9561-42CECF7DAF47@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from l1ms.rz.uni-kiel.de ([134.245.11.86]:51683 "EHLO
	l1ms.rz.uni-kiel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758027Ab0LNJV2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Dec 2010 04:21:28 -0500
Received: from amavis by l1ms.rz.uni-kiel.de with scanned-ok (Exim 4.72)
	(envelope-from <boettcher@physik.uni-kiel.de>)
	id 1PSQjg-00083N-AY
	for linux-ext4@vger.kernel.org; Tue, 14 Dec 2010 09:59:52 +0100
In-Reply-To: <D46B0853-722D-4337-9561-42CECF7DAF47@dilger.ca> (Andreas
	Dilger's message of "Mon, 13 Dec 2010 14:57:26 -0700")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Andreas Dilger <adilger@dilger.ca> writes:

> On 2010-12-13, at 09:23, Stephan Boettcher wrote:
>> A raid1 (/dev/md1) over three 20GB partitions is the root filesystem=
,
>> three 20GB partitions for swap, and a RAID5 (/dev/md0) from the six =
big
>> partitions.
>>=20
>> The 10TB /dev/md0 is exported via nbd.  I had to patch nbd-client to
>> import this on a 32-bit machine, so that part works.
>>=20
>> The intention was to export two (later three) via nbd to one of the
>> servers, which combines them to a RAID5=C2=B2 with net capacity 20TB=
=2E  With
>> e2fsprogs master branch I could make a filesystem, but dumpe2fs and
>> fsck failed.  Mounting the filesystem said: EFBIG.
>
> RAID-5 on top of RAID-5 is going to be VERY SLOW... =20

Speed is not a priority.  But I thought, since it's distributed across
multiple servers, it cannot be that bad.

> Also note that only a single "nbd client" system will be able to use
> this storage at one time.

Yes, this is obvious.  I have several safeguards (e.g., only a single
ip-address in /etc/nbd-server/allow) to make sure I do not accidentally
run a partition concurrently from two servers.

> If you have dedicated server nodes, and you want to be able to use
> these 20TB from multiple clients, you might consider using Lustre,
> which uses ext4 as the back-end storage, and can scale to many PB
> filesystems (largest known filesystem is 20PB, from 1344 * 8TB
> separate ext4 filesystems).

I like thinks to be as simple and transparent as possible :-) The plan
is to export the fs via NFS.  I will hit the 16 TB limit again, will I?
I did not test that part yet.  The NFS clients will then probably be
required to run 64-bit kernels as well.

>> Obviously, with 32-bit pgoff_t this will not work, and it was said
>> elsewhere that making pgoff_t 64-bit on i386 will require a lot of f=
aith
>> and luck, since there are more than 3000 unsigned longs in the fs tr=
ee.
>
> I don't think that is going to happen any time soon.  Lustre _can_
> export from a 32-bit server, though it definitely isn't very common
> anymore.  For the cost of a single 2TB drive you can likely get a new
> motherboard + 64-bit CPU + RAM...

This is an exercise to keep a set of old truty servers usefully
employed, that were supposed to be discarded otherwise.  One aspect of
Linux is it's ability to keep old hardware running.

>> I'd prefer to run the setup selfcontained without an extra 64-bit he=
ad.
>> Maybe I will partition it down to a 16TB and a 4TB partition.  Maybe=
 I
>> just dare to compile a kernel with typedef unsigned long long pgoff_=
t
>> and see what happens, maybe I can help fixing that kind of configura=
tion.
>
> I would suggest you examine what it is you are really trying to get
> out of this system? =20

I see it as a challenge to learn stuff (linux fs, ext4, git) and kind o=
f
like a sport to find out where the limits are. And in the end we may
have a server for backup of some of those new virtual production. And I
hope I can contribute some testing to Linux fs code.

Our computer center throws out all the old servers and replaces them
with virtual machines on that big new system, with virtual disk from
fibre channel connected raids.  Seem to run well, but I also like some
real non-virtual backup. at least for a while.

> Is it just for fun, to test ext4 with > 16TB filesystems?=20

Mostly.

> Great, you can probably do that with the 64-bit nbd client. Do you
> actually want to use this for some data you care about?=20

Maybe, eventually.=20

If I then really need to care about the data, I will probably partition
it to <16TB filesystems.

> Then trying to get 32-bit kernels to handle > 16TB block devices is a
> risky strategy to take for a few hundred USD.=20

No risk, no fun, no progess.

I do see the mismatch, though: the hardware is massively redundant, and
the software highly experimental.

> Given that you are willing to spend a few thousand USD for the 2TB
> drives, you should consider just getting a 64-bit CPU + RAM to handle
> it.

Those disk are incredibly cheep, we spent about $1500 for 20 disks.
On thing I want to test is how often I need to swap out on of those
during the next year.

> Also note that running e2fsck on such a large filesystem will need
> 6-8GB of RAM at a minimum, and can be a lot more if there are serious
> problems (e.g. duplicate blocks).  Recently I saw a report of 22GB of
> RAM needed for e2fsck to complete, which is just impossible on a
> 32-bit machine.

Thank you for these comments, they will certainly influence how I will
proceed, but I don't know yet. =20

=46or a few month I will experiment with the setup.  I am open for
suggestions, patches to test, etc.

--=20
Stephan
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
