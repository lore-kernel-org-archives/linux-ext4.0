From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v4 0/3] dioread_nolock patch
Date: Fri, 19 Feb 2010 13:25:57 -0800
Message-ID: <20100219212557.GM29604@tux1.beaverton.ibm.com>
References: <1263583812-21355-1-git-send-email-tytso@mit.edu> <20100216210728.GO29569@tux1.beaverton.ibm.com> <5df78e1d1002171134r2b5b46d8hcf37b836f7cca7c6@mail.gmail.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Content-Transfer-Encoding: 8bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:43057 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab0BSV0M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Feb 2010 16:26:12 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o1JLJoq6007190
	for <linux-ext4@vger.kernel.org>; Fri, 19 Feb 2010 14:19:50 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o1JLPwMm102406
	for <linux-ext4@vger.kernel.org>; Fri, 19 Feb 2010 14:25:58 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o1JLPwQv012108
	for <linux-ext4@vger.kernel.org>; Fri, 19 Feb 2010 14:25:58 -0700
Content-Disposition: inline
In-Reply-To: <5df78e1d1002171134r2b5b46d8hcf37b836f7cca7c6@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Feb 17, 2010 at 11:34:32AM -0800, Jiaying Zhang wrote:
> Hi Darrick,
> 
> Thank you for running these tests!

No problem.

> On Tue, Feb 16, 2010 at 1:07 PM, Darrick J. Wong <djwong@us.ibm.com> wrote:
> > On Fri, Jan 15, 2010 at 02:30:09PM -0500, Theodore Ts'o wrote:
> >
> >> The plan is to merge this for 2.6.34.  I've looked this over pretty
> >> carefully, but another pair of eyes would be appreciated, especially if
> >
> > I don't have a high speed disk but it was suggested that I give this patchset a
> > whirl anyway, so down the rabbit hole I went.  I created a 16GB ext4 image in
> > an equally big tmpfs, then ran the read/readall directio tests in ffsb to see
> > if I could observe any difference.  The kernel is 2.6.33-rc8, and the machine
> > in question has 2 Xeon E5335 processors and 24GB of RAM.  I reran the test
> > several times, with varying thread counts, to produce the table below.  The
> > units are MB/s.
> >
> > For the dio_lock case, mount options were: rw,relatime,barrier=1,data=ordered.
> > For the dio_nolock case, they were: rw,relatime,barrier=1,data=ordered,dioread_nolock.
> >
> >        dio_nolock      dio_lock
> > threads read    readall read    readall
> > 1       37.6    149     39      159
> > 2       59.2    245     62.4    246
> > 4       114     453     112     445
> > 8       111     444     115     459
> > 16      109     442     113     448
> > 32      114     443     121     484
> > 64      106     422     108     434
> > 128     104     417     101     393
> > 256     101     412     90.5    366
> > 512     93.3    377     84.8    349
> > 1000    87.1    353     88.7    348
> >
> > It would seem that the old code paths are faster with a small number of
> > threads, but the new patch seems to be faster when the thread counts become
> > very high.  That said, I'm not all that familiar with what exactly tmpfs does,
> > or how well it mimicks an SSD (though I wouldn't be surprised to hear
> > "poorly").  This of course makes me wonder--do other people see results like
> > this, or is this particular to my harebrained setup?
> The dioread_nolock patch set is to eliminate the need of holding i_mutex lock
> during DIO read. That is why we usually see more improvements as the number
> of threads increases on high-speed SSDs. The performance difference is
> also more obvious as the bandwidth of device increases.

Running my streaming profiler, it looks like I can "get" 1500MB/s off the
ramdisk.

> I am surprised to see around 6% performance drop on single thread case.
> The dioread_nolock patches change the ext4 buffer write code path a lot but on
> the dio read code path, the only change is to not grab the i_mutex lock.
> I haven't seen such difference in my tests. I mostly use fio test for
> performance
> comparison. I will give ffsb test a try.

Ok, I'll attach the config file and script I was using.  Make sure /mnt is the
filesystem to test, and then you can run the script via:

$ ./readwrite 1 2 4 8 16 32 64 128 256 512

> Meanwhile, could you also post the stdev numbers?

I don't have that spreadsheet on this computer, but I recall that the std
deviations weren't more than about 10 for the first run.

Oddly, I tried a second computer, and saw very little difference (units MB/s):

threads	lock avg	nolock avg	lock stdev	nolock stdev
1	235		214		1		5.57
2	318		316.67		3		2.52
4	589.67		581.67		8.14		22.14
8	594.67		583		15.7		4
16	596.67		576		8.96		8.72
32	578		576.67		7.81		5.69
64	570.33		575.67		1.15		7.51
128	573.67		573.67		10.69		10.69
256	575.33		570		8.14		6.08
512	539.67		544.33		3.21		4.04
1000	479.33		482		3.21		2

This one has somewhat faster RAM (ECC registered vs FBDIMMs) and 8x 2.5GHz Xeon
L5420 CPUs.

> > For that matter, do I need to have more patches than just 2.6.33-rc8 and the
> > four posted in this thread?
> >
> > I also observed that I could make the kernel spit up "Process hung for more
> > than 120s!" messages if I happened to be running ffsb on a real disk during a
> > heavy directio write load.  I'll poke around on that a little more and write
> > back when I have more details.
> 
> Did the hang happen only with dioread_nolock or it also happened without
> the patches applied? It is not surprising to see such messages on slow disk
> since the processes are all waiting for IOs.

To clarify: Nothing hung; I simply got the "hung task" warning.  It
happened only with the patches applied, though for all I know without the
patches applied the tasks could be starving for 119s.

> > For poweroff testing, could one simulate a power failure by running IO
> > workloads in a VM and then SIGKILLing the VM?  I don't remember seeing any sort
> > of powerfail test suite from the Googlers, but my mail client has been drinking
> > out of firehoses lately. ;)
> As far as I know, these numbers are not posted yet but will come out soon.

Uh... I was more curious if anyone had a testing suite, not results necessarily.

--D

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="djwong-readwrite.ffsb"

# djwong playground

time=300
alignio=1
directio=1

#callout=/usr/local/src/ffsb-6.0-rc2/ltc_tests/dwrite_all

[filesystem0]
	location=/mnt/ffsb1
	num_files=1000
	num_dirs=10
	reuse=1

	# File sizes range from 1kB to 1MB.
#	size_weight 1KB 10
#	size_weight 2KB 15
#	size_weight 4KB 16
#	size_weight 8KB 16
#	size_weight 16KB 15
#	size_weight 32KB 10
#	size_weight 64KB 8
#	size_weight 128KB 4
#	size_weight 256KB 3
#	size_weight 512KB 2
#	size_weight 1MB 1
	size_weight 16MB 1

#	size_weight 1GB 1
#	size_weight 2GB 1
#	size_weight 4GB 1
[end0]

[threadgroup0]
	num_threads=%THREADS%

	readall_weight=4
#	writeall_weight=4
#	create_weight=4
#	delete_weight=4
#	append_weight=4
	read_weight=4
#	write_weight=4

#	write_size=4MB
#	write_blocksize=4KB

	read_size=4MB
	read_blocksize=4KB

	[stats]
		enable_stats=0
		enable_range=0

		msec_range    0.00      0.01
		msec_range    0.01      0.02
		msec_range    0.02      0.05
		msec_range    0.05      0.10
		msec_range    0.10      0.20
		msec_range    0.20      0.50
		msec_range    0.50      1.00
		msec_range    1.00      2.00
		msec_range    2.00      5.00
		msec_range    5.00     10.00
		msec_range   10.00     20.00
		msec_range   20.00     50.00
		msec_range   50.00    100.00
		msec_range  100.00    200.00
		msec_range  200.00    500.00
		msec_range  500.00   1000.00
		msec_range 1000.00   2000.00
		msec_range 2000.00   5000.00
		msec_range 5000.00  10000.00
	[end]
[end0]

--/04w6evG8XlLl3ft
Content-Type: application/x-sh
Content-Disposition: attachment; filename="readwrite.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A=0Aif [ -z "$1" ]; then=0A	echo "Usage: $0 num_threads [num_t=
hreads...]"=0A	exit 1=0Afi=0A=0Afor i in $*; do=0A	sed -e "s|%THREADS%|$i|g=
" < djwong-readwrite.ffsb > /tmp/blargh.ffsb=0A	echo "Running with $i threa=
ds."=0A	ffsb /tmp/blargh.ffsb=0Adone=0A
--/04w6evG8XlLl3ft--
