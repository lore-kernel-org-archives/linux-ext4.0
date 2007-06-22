From: sftf <sftf-misc@mail.ru>
Subject: IRON filesystem papers - development of robust and fault tolerant filesystems
Date: Fri, 22 Jun 2007 10:28:30 +0600
Message-ID: <1823488273.20070622102830@mail.ru>
Reply-To: sftf <sftf-misc@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1251
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fallback.mail.ru ([194.67.57.14]:33378 "EHLO mx4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbXFVD24 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2007 23:28:56 -0400
Received: from mx27.mail.ru (mx27.mail.ru [194.67.23.64])
	by mx4.mail.ru (mPOP.Fallback_MX) with ESMTP id 8C0A334315F
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jun 2007 07:28:54 +0400 (MSD)
Received: from [195.162.52.178] (port=11238 helo=[192.168.2.1])
	by mx27.mail.ru with asmtp
	id 1I1Zp2-0008zF-00
	for linux-ext4@vger.kernel.org; Fri, 22 Jun 2007 07:28:32 +0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello!
I suggest developers to consider ext4 design from the point of view of =
these papers:
IRON FILE SYSTEMS -
http://www.cs.wisc.edu/wind/Publications/vijayan-thesis06.pdf
IMHO - very impressive paper and  developers of close future filesystem=
s can't
ignore these problems and solutions.

and "Failure Analysis of SGI XFS File System"
http://www.cs.wisc.edu/~vshree/xfs.pdf =20

=46rom IRON FILE SYSTEMS:
"Disk drives are widely used as a primary medium for storing informatio=
n.
While commodity file systems trust disks to either work or fail complet=
ely, modern
disks exhibit complex failure modes such as latent sector faults and bl=
ock corruptions,
where only portions of a disk fail.
=2E..
=46irst, we design new low-level redundancy techniques that a file
system can use to handle disk faults.
We begin by qualitatively and quantitatively
evaluating various redundancy information such as checksum, parity, and=
 replica,
=46inally, we describe
two update strategies: a overwrite and no-overwrite approach that a fil=
e system can
use to update its data and parity blocks atomically without NVRAM suppo=
rt.
Over all, we show that low-level redundant information can greatly enha=
nce file system
robustness while incurring modest time and space overheads.

Second, to remedy the problem of failure handling diffusion, we develop=
 amodified
ext3 that unifies all failure handling in a Centralized Failure Handler=
 (CFH).
We then showcase the power of centralized failure handling in ext3c, a =
modified
IRON version of ext3 that uses CFH by demonstrating its support for fle=
xible, consistent,
and fine-grained policies. By carefully separating policy from mechanis=
m,
ext3c demonstrates how a file system can provide a thorough, comprehens=
ive, and
easily understandable failure-handling policy.
=2E..
The importance of building dependable systems cannot be overstated. One=
 of the
fundamental requirements in computer systems is to store and retrieve i=
nformation
reliably.
=2E..
The fault model presented by modern disk drives, however, is much more =
complex.
=46or example, modern drives can exhibit latent sector faults [14, 28, =
45, 60,
100], where a block or set of blocks are inaccessible. Under latent sec=
tor fault,
the sector fault occurs sometime in the past but the fault is detected =
only when the
sector is accessed for storing or retrieving information [59]. Blocks s=
ometimes become
corrupted [16] and worse, this can happen silently without the disk bei=
ng able
to detect it [47, 74, 126]. Finally, disks sometimes exhibit transient =
performance
problems [11, 115].

There are several reasons for these complex disk failure modes. First, =
a trend
that is common in the drive industry is to pack more bits per square in=
ch (BPS)
as the areal densities of disk drives are growing at a rapid rate [48].
=2E..
In addition, increased density can also increase the complexity of the
logic, that is the firmware that manages the data [7], which can result=
 in increased
number of bugs. For example, buggy firmwares are known to issue misdire=
cted
writes [126], where correct data is placed on disk but in the wrong loc=
ation.

Second, increased use of low-end desktop drives such as the IDE/ATA dri=
ves
worsens the reliability problem. Low cost dominates the design of perso=
nal storage
drives [7] and therefore, they are less tested and have less machinery =
to handle
disk errors [56].

=46inally, amount of software used on the storage stack has increased. =
=46irmware
on a desktop drive contains about 400 thousand lines of code [33]. More=
over,
the storage stack consists of several layers of low-level device driver=
 code that
have been considered to have more bugs than the rest of the operating s=
ystem
code [38, 113]. As Jim Gray points out in his study of Tandem Availabil=
ity, =93As the
other components of the system become increasingly reliable, software n=
ecessarily
becomes the dominant cause of outages=94 [44].
=2E..
Our study focuses on four important and substantially different open-so=
urce file
systems, ext3 [121], ReiserFS [89], IBM=92s JFS [19], and XFS [112] and=
 one closedsource
file system, Windows NTFS [109]. From our analysis results, we find tha=
t
the technology used by high-end systems (e.g., checksumming, disk scrub=
bing, and
so on) has not filtered down to the realm of commodity file systems. Ac=
ross all platforms,
we find ad hoc failure handling and a great deal of illogical inconsist=
ency in
failure policy, often due to the diffusion of failure handling code thr=
ough the kernel;
such inconsistency leads to substantially different detection and recov=
ery strategies
under similar fault scenarios, resulting in unpredictable and often und=
esirable
fault-handling strategies. Moreover, failure handling diffusion makes i=
t difficult to
examine any one or few portions of the code and determine how failure h=
andling
is supposed to behave. Diffusion also implies that failure handling is =
inflexible;
policies that are spread across so many locations within the code base =
are hard to
change. In addition, we observe that failure handling is quite coarse-g=
rained; it is
challenging to implement nuanced policies in the current system.

We also discover that most systems implement portions of their failure =
policy
incorrectly; the presence of bugs in the implementations demonstrates t=
he difficulty
and complexity of correctly handling certain classes of disk failure.
=2E..
We show that none of the file
systems can recover from partial disk failures, due to a lack of in-dis=
k redundancy.
=2E..

We found a number of bugs and inconsistencies in the ext3 failure polic=
y.
=46irst,errors are not always propagated to the user (e.g., truncate an=
d rmdir fail
silently).

Second, ext3 does not always perform sanity checking; for example,
unlink does not check the linkscount field before modifying it and ther=
efore
a corrupted value can lead to a system crash.

Third, although ext3 has redundant
copies of the superblock (RRedundancy), these copies are never updated =
after file
system creation and hence are not useful. Finally, there are important =
cases when
ext3 violates the journaling semantics, committing or checkpointing inv=
alid transactions."

Thanks for attention!
