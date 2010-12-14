From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: 20TB ext4
Date: Mon, 13 Dec 2010 22:27:16 -0500
Message-ID: <4D06E414.6060600@redhat.com>
References: <s6nzks9y74l.fsf@falbala.ieap.uni-kiel.de> <D46B0853-722D-4337-9561-42CECF7DAF47@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stephan Boettcher <boettcher@physik.uni-kiel.de>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483Ab0LND1W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Dec 2010 22:27:22 -0500
In-Reply-To: <D46B0853-722D-4337-9561-42CECF7DAF47@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/13/2010 04:57 PM, Andreas Dilger wrote:
> On 2010-12-13, at 09:23, Stephan Boettcher wrote:
>> A raid1 (/dev/md1) over three 20GB partitions is the root filesystem=
,
>> three 20GB partitions for swap, and a RAID5 (/dev/md0) from the six =
big
>> partitions.
>>
>> The 10TB /dev/md0 is exported via nbd.  I had to patch nbd-client to
>> import this on a 32-bit machine, so that part works.
>>
>> The intention was to export two (later three) via nbd to one of the
>> servers, which combines them to a RAID5=B2 with net capacity 20TB.  =
With
>> e2fsprogs master branch I could make a filesystem, but dumpe2fs and
>> fsck failed.  Mounting the filesystem said: EFBIG.
> RAID-5 on top of RAID-5 is going to be VERY SLOW...  Also note that o=
nly a single "nbd client" system will be able to use this storage at on=
e time.  If you have dedicated server nodes, and you want to be able to=
 use these 20TB from multiple clients, you might consider using Lustre,=
 which uses ext4 as the back-end storage, and can scale to many PB file=
systems (largest known filesystem is 20PB, from 1344 * 8TB separate ext=
4 filesystems).
>
>> Obviously, with 32-bit pgoff_t this will not work, and it was said
>> elsewhere that making pgoff_t 64-bit on i386 will require a lot of f=
aith
>> and luck, since there are more than 3000 unsigned longs in the fs tr=
ee.
> I don't think that is going to happen any time soon.  Lustre _can_ ex=
port from a 32-bit server, though it definitely isn't very common anymo=
re.  For the cost of a single 2TB drive you can likely get a new mother=
board + 64-bit CPU + RAM...
>
>> I'd prefer to run the setup selfcontained without an extra 64-bit he=
ad.
>> Maybe I will partition it down to a 16TB and a 4TB partition.  Maybe=
 I
>> just dare to compile a kernel with typedef unsigned long long pgoff_=
t
>> and see what happens, maybe I can help fixing that kind of configura=
tion.
> I would suggest you examine what it is you are really trying to get o=
ut of this system?  Is it just for fun, to test ext4 with>  16TB filesy=
stems?  Great, you can probably do that with the 64-bit nbd client.  Do=
 you actually want to use this for some data you care about?  Then tryi=
ng to get 32-bit kernels to handle>  16TB block devices is a risky stra=
tegy to take for a few hundred USD.  Given that you are willing to spen=
d a few thousand USD for the 2TB drives, you should consider just getti=
ng a 64-bit CPU + RAM to handle it.
>
> Also note that running e2fsck on such a large filesystem will need 6-=
8GB of RAM at a minimum, and can be a lot more if there are serious pro=
blems (e.g. duplicate blocks).  Recently I saw a report of 22GB of RAM =
needed for e2fsck to complete, which is just impossible on a 32-bit mac=
hine.
>
>
> Cheers, Andreas
>

I have to agree here - I do not see this as being a great investment of=
 time.=20
Even low powered CPU's can often run in 64 bit mode these days and as A=
ndreas=20
says, you will need a lot of DRAM to fsck this box :)

Ric


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
