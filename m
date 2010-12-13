From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: 20TB ext4
Date: Mon, 13 Dec 2010 14:57:26 -0700
Message-ID: <D46B0853-722D-4337-9561-42CECF7DAF47@dilger.ca>
References: <s6nzks9y74l.fsf@falbala.ieap.uni-kiel.de>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Stephan Boettcher <boettcher@physik.uni-kiel.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:8688 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594Ab0LMV52 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Dec 2010 16:57:28 -0500
In-Reply-To: <s6nzks9y74l.fsf@falbala.ieap.uni-kiel.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On 2010-12-13, at 09:23, Stephan Boettcher wrote:
> A raid1 (/dev/md1) over three 20GB partitions is the root filesystem,
> three 20GB partitions for swap, and a RAID5 (/dev/md0) from the six b=
ig
> partitions.
>=20
> The 10TB /dev/md0 is exported via nbd.  I had to patch nbd-client to
> import this on a 32-bit machine, so that part works.
>=20
> The intention was to export two (later three) via nbd to one of the
> servers, which combines them to a RAID5=B2 with net capacity 20TB.  W=
ith
> e2fsprogs master branch I could make a filesystem, but dumpe2fs and
> fsck failed.  Mounting the filesystem said: EFBIG.

RAID-5 on top of RAID-5 is going to be VERY SLOW...  Also note that onl=
y a single "nbd client" system will be able to use this storage at one =
time.  If you have dedicated server nodes, and you want to be able to u=
se these 20TB from multiple clients, you might consider using Lustre, w=
hich uses ext4 as the back-end storage, and can scale to many PB filesy=
stems (largest known filesystem is 20PB, from 1344 * 8TB separate ext4 =
filesystems).

> Obviously, with 32-bit pgoff_t this will not work, and it was said
> elsewhere that making pgoff_t 64-bit on i386 will require a lot of fa=
ith
> and luck, since there are more than 3000 unsigned longs in the fs tre=
e.

I don't think that is going to happen any time soon.  Lustre _can_ expo=
rt from a 32-bit server, though it definitely isn't very common anymore=
=2E  For the cost of a single 2TB drive you can likely get a new mother=
board + 64-bit CPU + RAM...

> I'd prefer to run the setup selfcontained without an extra 64-bit hea=
d.
> Maybe I will partition it down to a 16TB and a 4TB partition.  Maybe =
I
> just dare to compile a kernel with typedef unsigned long long pgoff_t
> and see what happens, maybe I can help fixing that kind of configurat=
ion.

I would suggest you examine what it is you are really trying to get out=
 of this system?  Is it just for fun, to test ext4 with > 16TB filesyst=
ems?  Great, you can probably do that with the 64-bit nbd client.  Do y=
ou actually want to use this for some data you care about?  Then trying=
 to get 32-bit kernels to handle > 16TB block devices is a risky strate=
gy to take for a few hundred USD.  Given that you are willing to spend =
a few thousand USD for the 2TB drives, you should consider just getting=
 a 64-bit CPU + RAM to handle it.

Also note that running e2fsck on such a large filesystem will need 6-8G=
B of RAM at a minimum, and can be a lot more if there are serious probl=
ems (e.g. duplicate blocks).  Recently I saw a report of 22GB of RAM ne=
eded for e2fsck to complete, which is just impossible on a 32-bit machi=
ne.


Cheers, Andreas





--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
