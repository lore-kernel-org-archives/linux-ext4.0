From: coly <colyli@gmail.com>
Subject: status update for inode reservation
Date: Tue, 20 Mar 2007 18:32:52 +0800
Message-ID: <1174386772.6673.35.camel@colyT43.site>
References: <1174382533.6673.19.camel@colyT43.site>
	 <20070320095127.GK5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:28536 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbXCTK0y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Mar 2007 06:26:54 -0400
Received: by nf-out-0910.google.com with SMTP id o25so289458nfa
        for <linux-ext4@vger.kernel.org>; Tue, 20 Mar 2007 03:26:53 -0700 (PDT)
In-Reply-To: <20070320095127.GK5967@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas,

1, The size of files I created for benchmark is 0 byte. I created the
files by this script:=20
> for i in `seq 1 50`;do for j in `seq 1 10000`;do touch
`/usr/bin/keygen | head -c 8`;done;done

2, using magic inode will not generate compatibility issues. for fsck d=
o
not understand magic inode can ignore and remove the magic inodes. This
can only happen when fsck is performced and filesystem code can rebuild
the magic inode if it can not be found (this will take a some time for
reading inode table when mount).

Best regards.

Coly


P.S here is the result of my benchmark:
I created 500000 zero byte files in a directory named "sub", record
times for:
1, copy sub to another dir named "ordered1" in another harddisk.
2, copy dir "ordered1" to "ordered2" in another harddisk.
3, reboot the system and repeat 2 (change target to ordered3).
4, remove ordered3, ordered2, ordered 1.
5, remove sub.

>From the benchmark, I found no much performance improved for hash
ordered inode allocating when data=3Djournal and data=3Dordered.



created 500000 new file in dir called "sub" by this script:
for i in `seq 1 50`;do for j in `seq 1 10000`;do touch `/usr/bin/keygen
| head -c 8`;done;done

=3D=3D=3D=3D data=3Dwriteback =3D=3D=3D=3D
copy sub to another dir named "ordered1":
real	7m17.616s
user	0m1.456s
sys	0m27.586s

copy dir "ordered1" to "ordered2":
real	0m45.231s
user	0m1.340s
sys	0m21.233s

reboot
copy dir "ordered2" to "ordered3":
real	1m8.764s
user	0m1.568s
sys	0m26.050s

remove ordered3 by rm -rf ordered3:
real	0m9.200s
user	0m0.168s
sys	0m8.893s

remove ordered2 by rm -rf ordered2:
real	0m12.225s
user	0m0.128s
sys	0m8.857s

remove ordered1 by rm -rf ordered1:
real	0m37.493s
user	0m0.076s
sys	0m11.089s

remove original dir "sub":
real	9m49.902s
user	0m0.220s
sys	0m14.377s

=3D=3D=3D=3D data=3Djournal =3D=3D=3D=3D
copy sub to another dir named "ordered1":
real	6m54.151s
user	0m1.696s
sys	0m22.705s

copy dir "ordered1" to "ordered2":
real	7m7.696s
user	0m1.416s
sys	0m23.541s

reboot
copy dir "ordered1" to "ordered2":
real	10m46.649s
user	0m1.792s
sys	0m28.778s

remove ordered1 by rm -rf ordered1:
real	12m54.271s
user	0m0.192s
sys	0m15.353s

remove ordered2 by rm -rf ordered2:
real	13m37.035s
user	0m0.260s
sys	0m15.009s

remove ordered3 by rm -rf ordered3:
real	7m43.703s
user	0m0.216s
sys	0m12.117s

remove sub by rm -rf sub:
real	10m41.150s
user	0m0.188s
sys	0m13.781s

=3D=3D=3D=3D=3D data=3Dordered =3D=3D=3D=3D
copy sub to another dir named "ordered1":
real	7m57.016s
user	0m1.632s
sys	0m25.558s

copy dir "ordered1" to "ordered2":
real	7m46.037s
user	0m1.604.s
sys	0m24.902s

reboot
copy dir "ordered2" to "ordered3":
real	8m21.952s
user	0m1.720s
sys	0m28.290s

remove ordered1 by rm -rf ordered1:
real	10m12.652s
user	0m0.272s
sys	0m15.049s

remove ordered2 by rm -rf ordered2:
real	9m21.770s
user	0m0.220s
sys	0m15.025s

remove ordered3 by rm -rf ordered3:
real	6m32.278s
user	0m0.176s
sys	0m12.093s

remove sub by rm -rf sub:
real	10m17.966s
user	0m0.236s
sys	0m14.453s




=E5=9C=A8 2007-03-20=E4=BA=8C=E7=9A=84 03:51 -0600=EF=BC=8CAndreas Dilg=
er=E5=86=99=E9=81=93=EF=BC=9A
> On Mar 20, 2007  17:22 +0800, coly wrote:
> > 1, I did benchmark on large number of file copy and remove. The met=
hod
> > is what you did and told me before (create many file in a dir, copy=
 this
> > dir, remove the new and original dirs).
> >    * In data=3Djournal and data=3Dordered, not much performance imp=
rove will
> > be gained from inode reservation. For every inode modification will=
 be
> > submitted into journal at once, no chance to merge multiple inode
> > modification in one inode table into 1 journal submitting.
>=20
> That shouldn't be true.  Whether operation is data=3Djournal or data=3D=
writeback
> the filesystem metadata (i.e. inode table, directory) will always be =
in the
> journal.  Unless operation is always sync'd then it should still be p=
ossible
> to merge many filesystem operations into a single journal transaction=
 (so
> that they can share the changes to the same blocks).
>=20
> Now, whether the implementation matches the theory is a different que=
stion.
> It would be interesting to figure out why your test results are not s=
howing
> the same performance between data=3Dordered and data=3Dwriteback.  Ho=
w large
> are the files being unlinked?  Maybe if they are large the truncate t=
ime is
> long enough that the journal transaction is being committed?  Maybe w=
ith
> data=3Djournal there is so much going into the journal that it also f=
orces a
> commit because the journal is full?
>=20
> > 2, In order to management reserved inode table for each directories=
,
> > especially when files number of a directory exceeded the current
> > reserved limitation, a list is needed to manage the reserved inode
> > tables. I want to use some inode on disk as pointer. I think only b=
y
> > this way, we can avoid to change ext4 on disk meta data format.
> >    For some inodes used as pointers of list, I can assign MAGIC num=
bers
> > for them, identify them from normal inodes. But fsck and mkfs shoul=
d be
> > modified to understand these MAGIC numbers.
> >   With helps for these pointers (inode with special MAGIC number), =
inode
> > reservation can be implemented more easy.
>=20
> If you are making a magic inode, and it needs e2fsck and mke2fs suppo=
rt,
> then this by nature is a change to the filesystem format (though poss=
ibly
> one that allows an easy upgrade from existing filesystems).  If we ne=
ed
> to change the on-disk format then there are a number of other changes=
 we
> could make, including having "inode in directory" format, which will =
avoid
> this problem entirely because readdir and inode order are always the =
same.
>=20
> I would suggest emailing to the linux-ext4 list with details of findi=
ngs
> (performance, tests that have been run) so that everyone can read and
> comment on it.
>=20
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
>=20
