From: Jacek Luczak <difrost.kernel@gmail.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Wed, 29 Feb 2012 15:21:18 +0100
Message-ID: <CADDYkjQ2ABuJ-49SToPTYSBdMA-5j8CsryUOJj=-Sf1wZr6kdg@mail.gmail.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
	<CADDYkjRni4i3QvWo+hOn-Ct4mFoTpL1-ydmE7fbzYJmHFhS3_Q@mail.gmail.com>
	<CADDYkjRYrKaBvTQ4Pe6bfemL7r5W=AU468uy0krFAEJD45syow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com, lczerner@redhat.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CADDYkjRYrKaBvTQ4Pe6bfemL7r5W=AU468uy0krFAEJD45syow@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2012/2/29 Jacek Luczak <difrost.kernel@gmail.com>:
> 2012/2/29 Jacek Luczak <difrost.kernel@gmail.com>:
>> Hi Chris,
>>
>> the last one was borked :) Please check this one.
>>
>> -jacek
>>
>> 2012/2/29 Jacek Luczak <difrost.kernel@gmail.com>:
>>> Hi All,
>>>
>>> /*Sorry for sending incomplete email, hit wrong button :) I guess I
>>> can't use Gmail */
>>>
>>> Long story short: We've found that operations on a directory struct=
ure
>>> holding many dirs takes ages on ext4.
>>>
>>> The Question: Why there's that huge difference in ext4 and btrfs? S=
ee
>>> below test results for real values.
>>>
>>> Background: I had to backup a Jenkins directory holding workspace f=
or
>>> few projects which were co from svn (implies lot of extra .svn dirs=
).
>>> The copy takes lot of time (at least more than I've expected) and
>>> process was mostly in D (disk sleep). I've dig more and done some
>>> extra test to see if this is not a regression on block/fs site. To
>>> isolate the issue I've also performed same tests on btrfs.
>>>
>>> Test environment configuration:
>>> 1) HW: HP ProLiant BL460 G6, 48 GB of memory, 2x 6 core Intel X5670=
 HT
>>> enabled, Smart Array P410i, RAID 1 on top of 2x 10K RPM SAS HDDs.
>>> 2) Kernels: All tests were done on following kernels:
>>> =A0- 2.6.39.4-3 -- the build ID (3) is used here for internal tacki=
ng of
>>> config changes mostly. In -3 we've introduced ,,fix readahead pipel=
ine
>>> break caused by block plug'' patch. Otherwise it's pure 2.6.39.4.
>>> =A0- 3.2.7 -- latest kernel at the time of testing (3.2.8 has been
>>> release recently).
>>> 3) A subject of tests, directory holding:
>>> =A0- 54GB of data (measured on ext4)
>>> =A0- 1978149 files
>>> =A0- 844008 directories
>>> 4) Mount options:
>>> =A0- ext4 -- errors=3Dremount-ro,noatime,
>>> data=3Dwriteback
>>> =A0- btrfs -- noatime,nodatacow and for later investigation on
>>> copression effect: noatime,nodatacow,compress=3Dlzo
>>>
>>> In all tests I've been measuring time of execution. Following tests
>>> were performed:
>>> - find . -type d
>>> - find . -type f
>>> - cp -a
>>> - rm -rf
>>>
>>> Ext4 results:
>>> | Type =A0 =A0 | 2.6.39.4-3 =A0 | 3.2.7
>>> | Dir cnt =A0| 17m 40sec =A0| 11m 20sec
>>> | File cnt | =A017m 36sec | 11m 22sec
>>> | Copy =A0 =A0| 1h 28m =A0 =A0 =A0 =A0| 1h 27m
>>> | Remove| 3m 43sec =A0 =A0| 3m 38sec
>>>
>>> Btrfs results (without lzo comression):
>>> | Type =A0 =A0 | 2.6.39.4-3 =A0 | 3.2.7
>>> | Dir cnt =A0| 2m 22sec =A0| 2m 21sec
>>> | File cnt | =A02m 26sec | 2m 23sec
>>> | Copy =A0 =A0| 36m 22sec | 39m 35sec
>>> | Remove| 7m 51sec =A0 | 10m 43sec
>>>
>>> From above one can see that copy takes close to 1h less on btrfs. I=
've
>>> done strace counting times of calls, results are as follows (from
>>> 3.2.7):
>>> 1) Ext4 (only to elements):
>>> % time =A0 =A0 seconds =A0usecs/call =A0 =A0 calls =A0 =A0errors sy=
scall
>>> ------ ----------- ----------- --------- --------- ----------------
>>> =A057.01 =A0 13.257850 =A0 =A0 =A0 =A0 =A0 1 =A015082163 =A0 =A0 =A0=
 =A0 =A0 read
>>> =A023.40 =A0 =A05.440353 =A0 =A0 =A0 =A0 =A0 3 =A0 1687702 =A0 =A0 =
=A0 =A0 =A0 getdents
>>> =A06.15 =A0 =A01.430559 =A0 =A0 =A0 =A0 =A0 0 =A0 3672418 =A0 =A0 =A0=
 =A0 =A0 lstat
>>> =A03.80 =A0 =A00.883767 =A0 =A0 =A0 =A0 =A0 0 =A013106961 =A0 =A0 =A0=
 =A0 =A0 write
>>> =A02.32 =A0 =A00.539959 =A0 =A0 =A0 =A0 =A0 0 =A0 4794099 =A0 =A0 =A0=
 =A0 =A0 open
>>> =A01.69 =A0 =A00.393589 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0843695 =A0 =A0=
 =A0 =A0 =A0 mkdir
>>> =A01.28 =A0 =A00.296700 =A0 =A0 =A0 =A0 =A0 0 =A0 5637802 =A0 =A0 =A0=
 =A0 =A0 setxattr
>>> =A00.80 =A0 =A00.186539 =A0 =A0 =A0 =A0 =A0 0 =A0 7325195 =A0 =A0 =A0=
 =A0 =A0 stat
>>>
>>> 2) Btrfs:
>>> % time =A0 =A0 seconds =A0usecs/call =A0 =A0 calls =A0 =A0errors sy=
scall
>>> ------ ----------- ----------- --------- --------- ----------------
>>> 53.38 =A0 =A09.486210 =A0 =A0 =A0 =A0 =A0 1 =A015179751 =A0 =A0 =A0=
 =A0 =A0 read
>>> 11.38 =A0 =A02.021662 =A0 =A0 =A0 =A0 =A0 1 =A0 1688328 =A0 =A0 =A0=
 =A0 =A0 getdents
>>> =A010.64 =A0 =A01.890234 =A0 =A0 =A0 =A0 =A0 0 =A0 4800317 =A0 =A0 =
=A0 =A0 =A0 open
>>> =A06.83 =A0 =A01.213723 =A0 =A0 =A0 =A0 =A0 0 =A013201590 =A0 =A0 =A0=
 =A0 =A0 write
>>> =A04.85 =A0 =A00.862731 =A0 =A0 =A0 =A0 =A0 0 =A0 5644314 =A0 =A0 =A0=
 =A0 =A0 setxattr
>>> =A03.50 =A0 =A00.621194 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0844008 =A0 =A0=
 =A0 =A0 =A0 mkdir
>>> =A02.75 =A0 =A00.489059 =A0 =A0 =A0 =A0 =A0 0 =A0 3675992 =A0 =A0 =A0=
 =A0 1 lstat
>>> =A01.71 =A0 =A00.303544 =A0 =A0 =A0 =A0 =A0 0 =A0 5644314 =A0 =A0 =A0=
 =A0 =A0 llistxattr
>>> =A01.50 =A0 =A00.265943 =A0 =A0 =A0 =A0 =A0 0 =A0 1978149 =A0 =A0 =A0=
 =A0 =A0 utimes
>>> =A01.02 =A0 =A00.180585 =A0 =A0 =A0 =A0 =A0 0 =A0 5644314 =A0 =A084=
4008 getxattr
>>>
>>> On btrfs getdents takes much less time which prove the bottleneck i=
n
>>> copy time on ext4 is this syscall. In 2.6.39.4 it shows even less t=
ime
>>> for getdents:
>>> % time =A0 =A0 seconds =A0usecs/call =A0 =A0 calls =A0 =A0errors sy=
scall
>>> ------ ----------- ----------- --------- --------- ----------------
>>> =A050.77 =A0 10.978816 =A0 =A0 =A0 =A0 =A0 1 =A015033132 =A0 =A0 =A0=
 =A0 =A0 read
>>> =A014.46 =A0 =A03.125996 =A0 =A0 =A0 =A0 =A0 1 =A0 4733589 =A0 =A0 =
=A0 =A0 =A0 open
>>> =A07.15 =A0 =A01.546311 =A0 =A0 =A0 =A0 =A0 0 =A0 5566988 =A0 =A0 =A0=
 =A0 =A0 setxattr
>>> =A05.89 =A0 =A01.273845 =A0 =A0 =A0 =A0 =A0 0 =A0 3626505 =A0 =A0 =A0=
 =A0 =A0 lstat
>>> =A05.81 =A0 =A01.255858 =A0 =A0 =A0 =A0 =A0 1 =A0 1667050 =A0 =A0 =A0=
 =A0 =A0 getdents
>>> =A05.66 =A0 =A01.224403 =A0 =A0 =A0 =A0 =A0 0 =A013083022 =A0 =A0 =A0=
 =A0 =A0 write
>>> =A03.40 =A0 =A00.735114 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0833371 =A0 =A0=
 =A0 =A0 =A0 mkdir
>>> =A01.96 =A0 =A00.424881 =A0 =A0 =A0 =A0 =A0 0 =A0 5566988 =A0 =A0 =A0=
 =A0 =A0 llistxattr
>>>
>>>
>>> Why so huge difference in the getdents timings?
>>>
>>> -Jacek
>
> I will try to answer the question from the broken email I've sent.
>
> @Lukas, it was always a fresh FS on top of LVM logical volume. I've
> been cleaning cache/remounting to sync all data before (re)doing
> tests.
>
> -Jacek
>
> BTW: Sorry for the email mixture. I just can't get this gmail thing t=
o
> work (why forcing top posting:/). Please use this thread.

More from the observations:
1) 10s dump of the process state during copy shows:
- Ext4: 526 probes done, 34 hits R state, 492 hits D state
- Btrfs (2.6.39.4): 218, 83, 135
- Btrfs (3.2.7): 238, 62, 174, 2 hit sleeping
2) dd write/read of 55GB file to/from volume:
- Ext4: write 127MB/s, read 107MB/s
- Btrfs: 110MB/s, read 176MB/s

-Jacek
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
