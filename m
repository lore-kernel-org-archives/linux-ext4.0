From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH v4 0/3] dioread_nolock patch
Date: Wed, 17 Feb 2010 11:34:32 -0800
Message-ID: <5df78e1d1002171134r2b5b46d8hcf37b836f7cca7c6@mail.gmail.com>
References: <1263583812-21355-1-git-send-email-tytso@mit.edu>
	 <20100216210728.GO29569@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:10024 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab0BQTei convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Feb 2010 14:34:38 -0500
Received: from kpbe20.cbf.corp.google.com (kpbe20.cbf.corp.google.com [172.25.105.84])
	by smtp-out.google.com with ESMTP id o1HJYYuN007141
	for <linux-ext4@vger.kernel.org>; Wed, 17 Feb 2010 19:34:35 GMT
Received: from vws7 (vws7.prod.google.com [10.241.21.135])
	by kpbe20.cbf.corp.google.com with ESMTP id o1HJYUcg003012
	for <linux-ext4@vger.kernel.org>; Wed, 17 Feb 2010 11:34:33 -0800
Received: by vws7 with SMTP id 7so849384vws.34
        for <linux-ext4@vger.kernel.org>; Wed, 17 Feb 2010 11:34:33 -0800 (PST)
In-Reply-To: <20100216210728.GO29569@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Darrick,

Thank you for running these tests!

On Tue, Feb 16, 2010 at 1:07 PM, Darrick J. Wong <djwong@us.ibm.com> wr=
ote:
> On Fri, Jan 15, 2010 at 02:30:09PM -0500, Theodore Ts'o wrote:
>
>> The plan is to merge this for 2.6.34. =A0I've looked this over prett=
y
>> carefully, but another pair of eyes would be appreciated, especially=
 if
>
> I don't have a high speed disk but it was suggested that I give this =
patchset a
> whirl anyway, so down the rabbit hole I went. =A0I created a 16GB ext=
4 image in
> an equally big tmpfs, then ran the read/readall directio tests in ffs=
b to see
> if I could observe any difference. =A0The kernel is 2.6.33-rc8, and t=
he machine
> in question has 2 Xeon E5335 processors and 24GB of RAM. =A0I reran t=
he test
> several times, with varying thread counts, to produce the table below=
=2E =A0The
> units are MB/s.
>
> For the dio_lock case, mount options were: rw,relatime,barrier=3D1,da=
ta=3Dordered.
> For the dio_nolock case, they were: rw,relatime,barrier=3D1,data=3Dor=
dered,dioread_nolock.
>
> =A0 =A0 =A0 =A0dio_nolock =A0 =A0 =A0dio_lock
> threads read =A0 =A0readall read =A0 =A0readall
> 1 =A0 =A0 =A0 37.6 =A0 =A0149 =A0 =A0 39 =A0 =A0 =A0159
> 2 =A0 =A0 =A0 59.2 =A0 =A0245 =A0 =A0 62.4 =A0 =A0246
> 4 =A0 =A0 =A0 114 =A0 =A0 453 =A0 =A0 112 =A0 =A0 445
> 8 =A0 =A0 =A0 111 =A0 =A0 444 =A0 =A0 115 =A0 =A0 459
> 16 =A0 =A0 =A0109 =A0 =A0 442 =A0 =A0 113 =A0 =A0 448
> 32 =A0 =A0 =A0114 =A0 =A0 443 =A0 =A0 121 =A0 =A0 484
> 64 =A0 =A0 =A0106 =A0 =A0 422 =A0 =A0 108 =A0 =A0 434
> 128 =A0 =A0 104 =A0 =A0 417 =A0 =A0 101 =A0 =A0 393
> 256 =A0 =A0 101 =A0 =A0 412 =A0 =A0 90.5 =A0 =A0366
> 512 =A0 =A0 93.3 =A0 =A0377 =A0 =A0 84.8 =A0 =A0349
> 1000 =A0 =A087.1 =A0 =A0353 =A0 =A0 88.7 =A0 =A0348
>
> It would seem that the old code paths are faster with a small number =
of
> threads, but the new patch seems to be faster when the thread counts =
become
> very high. =A0That said, I'm not all that familiar with what exactly =
tmpfs does,
> or how well it mimicks an SSD (though I wouldn't be surprised to hear
> "poorly"). =A0This of course makes me wonder--do other people see res=
ults like
> this, or is this particular to my harebrained setup?
The dioread_nolock patch set is to eliminate the need of holding i_mute=
x lock
during DIO read. That is why we usually see more improvements as the nu=
mber
of threads increases on high-speed SSDs. The performance difference is
also more obvious as the bandwidth of device increases.

I am surprised to see around 6% performance drop on single thread case.
The dioread_nolock patches change the ext4 buffer write code path a lot=
 but on
the dio read code path, the only change is to not grab the i_mutex lock=
=2E
I haven't seen such difference in my tests. I mostly use fio test for
performance
comparison. I will give ffsb test a try.

Meanwhile, could you also post the stdev numbers?

>
> For that matter, do I need to have more patches than just 2.6.33-rc8 =
and the
> four posted in this thread?
>
> I also observed that I could make the kernel spit up "Process hung fo=
r more
> than 120s!" messages if I happened to be running ffsb on a real disk =
during a
> heavy directio write load. =A0I'll poke around on that a little more =
and write
> back when I have more details.

Did the hang happen only with dioread_nolock or it also happened withou=
t
the patches applied? It is not surprising to see such messages on slow =
disk
since the processes are all waiting for IOs.

>
> For poweroff testing, could one simulate a power failure by running I=
O
> workloads in a VM and then SIGKILLing the VM? =A0I don't remember see=
ing any sort
> of powerfail test suite from the Googlers, but my mail client has bee=
n drinking
> out of firehoses lately. ;)
As far as I know, these numbers are not posted yet but will come out so=
on.

Jiaying
>
> --D
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
