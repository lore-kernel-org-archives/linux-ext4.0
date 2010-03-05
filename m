From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: dump/restore not supported for ext4
Date: Fri, 5 Mar 2010 09:27:52 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1003050412260.17723@p34.internal.lan>
References: <alpine.DEB.2.00.1003041704230.17723@p34.internal.lan> <4B90A366.9080201@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	stelian@popies.net, Alan Piszcz <ap@solarrain.com>, tytso@mit.edu,
	Eric Sandeen <sandeen@redhat.com>, bdale@gag.com
To: Gertjan van Wingerde <gwingerde@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lucidpixels.com ([75.144.35.66]:47113 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab0CEO1y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Mar 2010 09:27:54 -0500
In-Reply-To: <4B90A366.9080201@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Fri, 5 Mar 2010, Gertjan van Wingerde wrote:

> On 03/04/10 23:05, Justin Piszcz wrote:

[ .. ]

> Hi Justin,
>
> It seems you are using an outdated version of dump.
> The latest version of dump, 0.4b42 does contain support for ext4.
> I've been using it for the last 8 months for my backups of ext4 without
> any problems and restoring is not issue at all with this version.

Hello,

I tried the following package in sid:
http://http.us.debian.org/debian/pool/main/d/dump/dump_0.4b42-2_amd64.deb

Per the changelog:

Changes between versions 0.4b41 and 0.4b42 (released June 18, 2009)
===================================================================
18. Add (preliminary) ext4 support - thanks to libext2fs which does
   all the job for us. Thanks to Gertjan van Wingerde
   <gwingerde@gmail.com> for the patch.

Why Debian does not include this in testing is beyond me..??

BTW: The man page needs to be fixed in dump as well then (in the new version)

Here:
        dump - ext2/3 filesystem backup
Here:
        Dump examines files on an ext2/3 filesystem and determines which  files
Here:
        ext2/3 filesystems.  Specifically, it does not work with  FAT  filesys-
Here:
        disk block and sector number and the ext2/3 logical  block  number.  It


--

OTHER/TESTING:

SIZES:

-rw-r--r-- 1 root root 11900416000 2010-03-05 05:31 root-without-z.ext4dump
-rw-r--r-- 1 root root 4670305765 2010-03-05 05:54 root_with-j=1.ext4dump
-rw-r--r-- 1 root root 4801444167 2010-03-05 04:54 root_with-z=1.ext4dump
-rw-r--r-- 1 root root 4759018091 2010-03-05 04:58 root_with-z=2.ext4dump
-rw-r--r-- 1 root root 4732663941 2010-03-05 05:02 root_with-z=3.ext4dump
-rw-r--r-- 1 root root 4644973699 2010-03-05 05:06 root_with-z=4.ext4dump
-rw-r--r-- 1 root root 4598494695 2010-03-05 05:09 root_with-z=5.ext4dump
-rw-r--r-- 1 root root 4585625035 2010-03-05 05:13 root_with-z=6.ext4dump
-rw-r--r-- 1 root root 4579357817 2010-03-05 05:18 root_with-z=7.ext4dump
-rw-r--r-- 1 root root 4574024703 2010-03-05 05:22 root_with-z=8.ext4dump
-rw-r--r-- 1 root root 4573194841 2010-03-05 05:27 root_with-z=9.ext4dump

TIMES:

-no compression
     dump:   4.87user 34.60system 3:36.72elapsed 18%CPU

-zlib
dump -z1: 241.27user 60.82system 3:35.08elapsed 140%CPU
dump -z2: 248.17user 60.99system 3:41.85elapsed 139%CPU
dump -z3: 257.37user 60.77system 3:47.90elapsed 139%CPU
dump -z4: 326.30user 63.92system 3:54.26elapsed 166%CPU
dump -z5: 346.77user 60.61system 3:50.25elapsed 176%CPU
dump -z6: 367.04user 61.06system 4:02.27elapsed 176%CPU
dump -z7: 388.87user 62.35system 4:10.59elapsed 180%CPU
dump -z8: 454.96user 60.92system 4:28.70elapsed 191%CPU
dump -z9: 539.88user 64.73system 5:06.22elapsed 197%CPU

-bzlib (further testing not needed after -j1, took a long time, got bigger)
dump -j1: 3052.01user 112.34system 20:07.96elapsed 261%CPU

Suffice to say..

The 7z took about 45-60minutes, bzip2 after that and gzip after that.
It appears dump w/-z9 is the best option pertaining to time/space (VERY FAST)

-rw-r--r-- 1 root root  4670305765 2010-03-05 05:54 root_with-j=1.ext4dump
-rw-r--r-- 1 root root 11900416000 2010-03-05 05:31 root-without-z.ext4dump
-rw-r--r-- 1 root root  3032284032 2010-03-05 07:19 root-without-z.ext4dump.7z
-rw-r--r-- 1 root root  3700128170 2010-03-05 06:41 root-without-z.ext4dump.bz2
-rw-r--r-- 1 root root  4079857439 2010-03-05 06:29 root-without-z.ext4dump.gz
-rw-r--r-- 1 root root  4801444167 2010-03-05 04:54 root_with-z=1.ext4dump
-rw-r--r-- 1 root root  4759018091 2010-03-05 04:58 root_with-z=2.ext4dump
-rw-r--r-- 1 root root  4732663941 2010-03-05 05:02 root_with-z=3.ext4dump
-rw-r--r-- 1 root root  4644973699 2010-03-05 05:06 root_with-z=4.ext4dump
-rw-r--r-- 1 root root  4598494695 2010-03-05 05:09 root_with-z=5.ext4dump
-rw-r--r-- 1 root root  4585625035 2010-03-05 05:13 root_with-z=6.ext4dump
-rw-r--r-- 1 root root  4579357817 2010-03-05 05:18 root_with-z=7.ext4dump
-rw-r--r-- 1 root root  4574024703 2010-03-05 05:22 root_with-z=8.ext4dump
-rw-r--r-- 1 root root  4573194841 2010-03-05 05:27 root_with-z=9.ext4dump

And the most important part!

Restoring from backup from two different systems, 12GB and ~30GB:

SYSTEM_1

p34:/x2/bup/p34/2010-03-05/restore# restore -f ../p34-root-2010-03-05.ext4dump -r 
Dump tape is compressed.
./home/user/.local/share/applications/defaults.list: (inode 5898660) not found on tape
expected next file 5770835, got 5770833
expected next file 5898665, got 5898661
p34:/x2/bup/p34/2010-03-05/restore#

For the most part, it worked, obviously this was on a live system so I believe
this is to be expected?

SYSTEM_2 (EXT4 DUMP OVER SSH)

ssh -l root l1 "dump -0f - /boot -z9 -L $today" > "$destdir/$bfile"
ssh -l root l1 "dump -0f - / -z9 -L $today" > "$destdir/$rfile"

p34:/x2/bup/l1/2010-03-05/restore# /usr/bin/time restore -f ../l1-root-2010-03-05.ext4dump  -r
Dump tape is compressed.
112.97user 27.86system 6:18.10elapsed 37%CPU (0avgtext+0avgdata 152432maxresident)k
0inputs+0outputs (5major+12756minor)pagefaults 0swaps
p34:/x2/bup/l1/2010-03-05/restore#

Quite nice!

Thanks,

Justin.

