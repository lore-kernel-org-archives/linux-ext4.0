From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 errors with full filesystem
Date: Fri, 14 Aug 2015 11:51:15 -0400
Message-ID: <20150814155115.GA5201@thunk.org>
References: <20150813082307.GA32614@aepfle.de>
 <20150814024227.GC26095@thunk.org>
 <20150814094831.GA15865@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58942 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585AbbHNPvS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Aug 2015 11:51:18 -0400
Content-Disposition: inline
In-Reply-To: <20150814094831.GA15865@aepfle.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 14, 2015 at 11:48:31AM +0200, Olaf Hering wrote:
> 
> There was just wget writing the iso to it, it was downloaded with about
> 10MB/sec.  The system has 8GB RAM.

How big was the iso file when the disk filled?

If it happens again, can you run the "extents -n" command in debugfs?
So for example, if /dev/mapper/closure-u1 is mounted on /u1, and the
file of interest is /u1/userdata.img, then do something like this:

# debugfs /dev/mapper/closure-u1
debugfs 1.43-WIP (29-Mar-2015)
debugfs:  extents -n userdata.img
Level Entries           Logical            Physical Length Flags
0/ 2   1/  1       0 - 2874363    33987            2874364
1/ 2   1/ 35       0 -  170082    33986            170083
1/ 2   2/ 35  170083 -  178210  6676480              8128
1/ 2   3/ 35  178211 -  201880  6690816             23670
1/ 2   4/ 35  201881 -  214186  6690817             12306
1/ 2   5/ 35  214187 -  233062  6729728             18876
1/ 2   6/ 35  233063 -  254071  6751276             21009
1/ 2   7/ 35  254072 -  261825  6753325              7754
1/ 2   8/ 35  261826 -  284741  6785024             22916
1/ 2   9/ 35  284742 -  292895  6785025              8154
1/ 2  10/ 35  292896 -  314550  6854591             21655
1/ 2  11/ 35  314551 -  326862  6883328             12312
1/ 2  12/ 35  326863 -  345619  6883329             18757
1/ 2  13/ 35  345620 -  361847  6918144             16228
1/ 2  14/ 35  361848 -  376184  6918145             14337
1/ 2  15/ 35  376185 -  401211  6952960             25027
1/ 2  16/ 35  401212 -  408188  6952961              6977
1/ 2  17/ 35  408189 -  430974  6987776             22786
1/ 2  18/ 35  430975 -  443383  6987777             12409
1/ 2  19/ 35  443384 -  462088  7024640             18705
1/ 2  20/ 35  462089 -  480253  7047168             18165
1/ 2  21/ 35  480254 -  490889  7047169             10636
1/ 2  22/ 35  490890 -  513854  7079936             22965
1/ 2  23/ 35  513855 -  520795  7079937              6941
1/ 2  24/ 35  520796 -  543539  7114752             22744
1/ 2  25/ 35  543540 -  555928  7114753             12389
1/ 2  26/ 35  555929 -  572655  7153664             16727
1/ 2  27/ 35  572656 -  584947  7153665             12292
1/ 2  28/ 35  584948 -  604327  7186432             19380
1/ 2  29/ 35  604328 -  625455  7211008             21128
1/ 2  30/ 35  625456 -  634370  7211009              8915
1/ 2  31/ 35  634371 -  656666  7243776             22296
1/ 2  32/ 35  656667 -  664518  7243777              7852
1/ 2  33/ 35  664519 -  685186  7278592             20668
1/ 2  34/ 35  685187 -  699514  7278593             14328
1/ 2  35/ 35  699515 - 2874363  7317504            2174849

>From the above can see that this 1.8G file uses 35 metadata blocks.
How many metadata blocks are needed depends on how fragmented the free
space is.  Each of the metadata blocks can hold up to 340 extents.
Without the -n option, all of the leaf nodes of the extent tree will
be displayed, then you'll likely see a very wide variety of extent
sizes.  For example:

2/ 2 116/340  187478 -  187478  6700118 -  6700118      1
2/ 2 117/340  187480 -  187484  6700120 -  6700124      5
2/ 2 118/340  187486 -  187486  6700126 -  6700126      1
2/ 2 119/340  187488 -  187576  6700128 -  6700216     89
2/ 2 120/340  187579 -  187601  6700219 -  6700241     23
2/ 2 121/340  187603 -  191477  6700243 -  6704117   3875
2/ 2 122/340  191482 -  191483  6704122 -  6704123      2
2/ 2 123/340  191486 -  191486  6704126 -  6704126      1
2/ 2 124/340  191491 -  191494  6704131 -  6704134      4

Last column is the extent size; extents of size 3875 are good.
Extents of size 1 are not so good, both in terms of requiring lots of
seeks when you read the file, and because it burns space in the extent
tree.  (The maximum extent size is 32k blocks, BTW.)

By default, we reserve 4096 blocks for unexpected metadata blocks or
2% of the file system space, which ever number is smaller.  4096
metadata blocks is a lot of space.  Each metadata block can hold 340
extents leaf entries, So even in the worst case, where the file system
free space is completely fragmented, that should still be enough space
for a bit over 5.3 GB of space.

So in order to trigger the problem, there would need to be more than
5.3GB of delayed allocation pages in the page cache, such that when
the writeback daemon force these pages to be written to the file file
system, we would start consuming enough of the metadata blocks that we
could burn through the 4096 block reserve.  Since you have 8GB of
memory, this is possible if there weren't any other large programs
running.

Hmm, the other thing we can do is to disable delayed allocation when
the file system is both (a) close to full, and (b) highly fragmented.
Currenty we only do (a) for SMP kernels, because we use a percpu
counter to estimate the amount of free space.  I suspect using some
algorithm that estimates fragmentation is the right approach, since
just increasing the number of reserved blocks, or disabling delalloc
when the free space drops below some absolute value, such as say 4 MB,
would impact how well ext4 works on smaller devices such as thumb
drives.

						- Ted

	 
