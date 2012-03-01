From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Wed, 29 Feb 2012 23:44:31 -0500
Message-ID: <E15A491F-62E2-4518-939F-07B3AB4C3E65@mit.edu>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
To: Jacek Luczak <difrost.kernel@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:42359 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755802Ab2CAEoZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Feb 2012 23:44:25 -0500
In-Reply-To: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

You might try sorting the entries returned by readdir by inode number b=
efore you stat them.    This is a long-standing weakness in ext3/ext4, =
and it has to do with how we added hashed tree indexes to directories i=
n (a) a backwards compatible way, that (b) was POSIX compliant with res=
pect to adding and removing directory entries concurrently with reading=
 all of the directory entries using readdir.

You might try compiling spd_readdir from the e2fsprogs source tree (in =
the contrib directory):

http://git.kernel.org/?p=3Dfs/ext2/e2fsprogs.git;a=3Dblob;f=3Dcontrib/s=
pd_readdir.c;h=3Df89832cd7146a6f5313162255f057c5a754a4b84;hb=3Dd9a5d375=
35794842358e1cfe4faa4a89804ed209

=85 and then using that as a LD_PRELOAD, and see how that changes thing=
s.

The short version is that we can't easily do this in the kernel since i=
t's a problem that primarily shows up with very big directories, and us=
ing non-swappable kernel memory to store all of the directory entries a=
nd then sort them so they can be returned in inode number just isn't pr=
actical.   It is something which can be easily done in userspace, thoug=
h, and a number of programs (including mutt for its Maildir support) do=
es do, and it helps greatly for workloads where you are calling readdir=
() followed by something that needs to access the inode (i.e., stat, un=
link, etc.)

-- Ted


On Feb 29, 2012, at 8:52 AM, Jacek Luczak wrote:

> Hi All,
>=20
> /*Sorry for sending incomplete email, hit wrong button :) I guess I
> can't use Gmail */
>=20
> Long story short: We've found that operations on a directory structur=
e
> holding many dirs takes ages on ext4.
>=20
> The Question: Why there's that huge difference in ext4 and btrfs? See
> below test results for real values.
>=20
> Background: I had to backup a Jenkins directory holding workspace for
> few projects which were co from svn (implies lot of extra .svn dirs).
> The copy takes lot of time (at least more than I've expected) and
> process was mostly in D (disk sleep). I've dig more and done some
> extra test to see if this is not a regression on block/fs site. To
> isolate the issue I've also performed same tests on btrfs.
>=20
> Test environment configuration:
> 1) HW: HP ProLiant BL460 G6, 48 GB of memory, 2x 6 core Intel X5670 H=
T
> enabled, Smart Array P410i, RAID 1 on top of 2x 10K RPM SAS HDDs.
> 2) Kernels: All tests were done on following kernels:
> - 2.6.39.4-3 -- the build ID (3) is used here for internal tacking of
> config changes mostly. In -3 we've introduced ,,fix readahead pipelin=
e
> break caused by block plug'' patch. Otherwise it's pure 2.6.39.4.
> - 3.2.7 -- latest kernel at the time of testing (3.2.8 has been
> release recently).
> 3) A subject of tests, directory holding:
> - 54GB of data (measured on ext4)
> - 1978149 files
> - 844008 directories
> 4) Mount options:
> - ext4 -- errors=3Dremount-ro,noatime,
> data=3Dwriteback
> - btrfs -- noatime,nodatacow and for later investigation on
> copression effect: noatime,nodatacow,compress=3Dlzo
>=20
> In all tests I've been measuring time of execution. Following tests
> were performed:
> - find . -type d
> - find . -type f
> - cp -a
> - rm -rf
>=20
> Ext4 results:
> | Type     | 2.6.39.4-3   | 3.2.7
> | Dir cnt  | 17m 40sec  | 11m 20sec
> | File cnt |  17m 36sec | 11m 22sec
> | Copy    | 1h 28m        | 1h 27m
> | Remove| 3m 43sec    | 3m 38sec
>=20
> Btrfs results (without lzo comression):
> | Type     | 2.6.39.4-3   | 3.2.7
> | Dir cnt  | 2m 22sec  | 2m 21sec
> | File cnt |  2m 26sec | 2m 23sec
> | Copy    | 36m 22sec | 39m 35sec
> | Remove| 7m 51sec   | 10m 43sec
>=20
> From above one can see that copy takes close to 1h less on btrfs. I'v=
e
> done strace counting times of calls, results are as follows (from
> 3.2.7):
> 1) Ext4 (only to elements):
> % time     seconds  usecs/call     calls    errors syscall
> ------ ----------- ----------- --------- --------- ----------------
> 57.01   13.257850           1  15082163           read
> 23.40    5.440353           3   1687702           getdents
> 6.15    1.430559           0   3672418           lstat
> 3.80    0.883767           0  13106961           write
> 2.32    0.539959           0   4794099           open
> 1.69    0.393589           0    843695           mkdir
> 1.28    0.296700           0   5637802           setxattr
> 0.80    0.186539           0   7325195           stat
>=20
> 2) Btrfs:
> % time     seconds  usecs/call     calls    errors syscall
> ------ ----------- ----------- --------- --------- ----------------
> 53.38    9.486210           1  15179751           read
> 11.38    2.021662           1   1688328           getdents
> 10.64    1.890234           0   4800317           open
> 6.83    1.213723           0  13201590           write
> 4.85    0.862731           0   5644314           setxattr
> 3.50    0.621194           1    844008           mkdir
> 2.75    0.489059           0   3675992         1 lstat
> 1.71    0.303544           0   5644314           llistxattr
> 1.50    0.265943           0   1978149           utimes
> 1.02    0.180585           0   5644314    844008 getxattr
>=20
> On btrfs getdents takes much less time which prove the bottleneck in
> copy time on ext4 is this syscall. In 2.6.39.4 it shows even less tim=
e
> for getdents:
> % time     seconds  usecs/call     calls    errors syscall
> ------ ----------- ----------- --------- --------- ----------------
> 50.77   10.978816           1  15033132           read
> 14.46    3.125996           1   4733589           open
> 7.15    1.546311           0   5566988           setxattr
> 5.89    1.273845           0   3626505           lstat
> 5.81    1.255858           1   1667050           getdents
> 5.66    1.224403           0  13083022           write
> 3.40    0.735114           1    833371           mkdir
> 1.96    0.424881           0   5566988           llistxattr
>=20
>=20
> Why so huge difference in the getdents timings?
>=20
> -Jacek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdev=
el" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
