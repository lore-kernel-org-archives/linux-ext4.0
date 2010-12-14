From: Stephan Boettcher <boettcher@physik.uni-kiel.de>
Subject: Re: 20TB ext4
Date: Tue, 14 Dec 2010 21:51:35 +0100
Message-ID: <s6noc8oxelk.fsf@blaulicht.switch.brux>
References: <s6nzks9y74l.fsf@falbala.ieap.uni-kiel.de>
	<D46B0853-722D-4337-9561-42CECF7DAF47@dilger.ca>
	<s6nr5dkviez.fsf@falbala.ieap.uni-kiel.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from l5ms.rz.uni-kiel.de ([134.245.11.213]:59896 "EHLO
	l5ms.rz.uni-kiel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758360Ab0LNUvj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Dec 2010 15:51:39 -0500
Received: from localhost ([127.0.0.1])
	by l5ms.rz.uni-kiel.de with esmtp (Exim 4.72)
	(envelope-from <boettcher@physik.uni-kiel.de>)
	id 1PSbqU-0001Dd-0z
	for linux-ext4@vger.kernel.org; Tue, 14 Dec 2010 21:51:38 +0100
In-Reply-To: <s6nr5dkviez.fsf@falbala.ieap.uni-kiel.de> (Stephan Boettcher's
	message of "Tue, 14 Dec 2010 09:59:48 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Stephan Boettcher <boettcher@physik.uni-kiel.de> writes:

> Andreas Dilger <adilger@dilger.ca> writes:
>
>> On 2010-12-13, at 09:23, Stephan Boettcher wrote:
>>> A raid1 (/dev/md1) over three 20GB partitions is the root filesyste=
m,
>>> three 20GB partitions for swap, and a RAID5 (/dev/md0) from the six=
 big
>>> partitions.
>>>=20
>>> The 10TB /dev/md0 is exported via nbd.  I had to patch nbd-client t=
o
>>> import this on a 32-bit machine, so that part works.
>>>=20
>>> The intention was to export two (later three) via nbd to one of the
>>> servers, which combines them to a RAID5=C2=B2 with net capacity 20T=
B.  With
>>> e2fsprogs master branch I could make a filesystem, but dumpe2fs and
>>> fsck failed.  Mounting the filesystem said: EFBIG.

>> If you have dedicated server nodes, and you want to be able to use
>> these 20TB from multiple clients, you might consider using Lustre,
>> which uses ext4 as the back-end storage, and can scale to many PB
>> filesystems (largest known filesystem is 20PB, from 1344 * 8TB
>> separate ext4 filesystems).
>
> I like thinks to be as simple and transparent as possible :-) The pla=
n
> is to export the fs via NFS.  I will hit the 16 TB limit again, will =
I?
> I did not test that part yet.  The NFS clients will then probably be
> required to run 64-bit kernels as well.

Excuse me for not knowing all that much about how linux filesystems
work. I was surprised that I could export the 20TB filesystem via NFS
and mount it on a 32-bit (2.6.31) system.  Do I need to expect failures
when I try to actually use it that way, or does the nfs filesystem not
use the page cache or something, so that the 16TB limit does not apply?

Thanks, Stephan


I guess I should upgrade that kernel ...

(root)informatix:/data/hinkelstein# cat /proc/cpuinfo=20
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Pentium(R) 4 CPU 2.00GHz
stepping        : 4
cpu MHz         : 2020.126
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge =
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pebs bts
bogomips        : 4040.25
clflush size    : 64
power management:

(root)informatix:/data/hinkelstein# cat /proc/version=20
Linux version 2.6.31 (stephan@informatix) (gcc version 4.3.3 (Debian 4.=
3.3-8) ) #2 Fri Oct 2 08:25:51 CEST 2009

(root)informatix:/data/hinkelstein# df .
=46ilesystem           1K-blocks      Used Available Use% Mounted on
falbala:/data/hinkelstein/
                     19021934592 651503616 17404166144   4% /data/hinke=
lstein


--=20
Stephan

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
