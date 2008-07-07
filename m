From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Performance of ext4
Date: Mon, 7 Jul 2008 13:13:42 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0807071047430.17563@diagnostix.dwd.de>
References: <Pine.LNX.4.64.0806121154090.27806@diagnostix.dwd.de>
 <20080612131928.GB18229@mit.edu> <Pine.LNX.4.64.0806121333480.27806@diagnostix.dwd.de>
 <20080612180605.GD22481@skywalker> <Pine.LNX.4.64.0806121940020.2974@diagnostix.dwd.de>
 <Pine.LNX.4.64.0806130753100.7097@diagnostix.dwd.de>
 <20080616175408.GF3279@atrey.karlin.mff.cuni.cz> <20080616181353.GA20686@skywalker>
 <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de>
 <Pine.LNX.4.64.0806180546370.20901@diagnostix.dwd.de> <20080619110947.GB11516@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>, Solofo.Ramangalahy@bull.net,
	Nick Dokos <nicholas.dokos@hp.com>, linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dwdmx4.dwd.de ([141.38.3.230]:57300 "EHLO dwdmx4.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbYGGNNt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Jul 2008 09:13:49 -0400
In-Reply-To: <20080619110947.GB11516@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 19 Jun 2008, Theodore Tso wrote:

> On Wed, Jun 18, 2008 at 05:58:00AM +0000, Holger Kiehl wrote:
>> For afdbench: 5336.41 files per second 15.63 MiB/s
>>
>> So it seems that for afdbench the ext4-patch-queue is a slowdown.
>
> Can you remind me where afdbench can be downloaded?  And if I remember
> correctly, it creates and deletes large numbers of small files,
> correct?
>
> It would be interesting to see which new feature introduced by the
> ext4 patch queue --- probably dellayed allocation or mballoc --- is
> responsible for the slowdown.  One or the other (or both) can be
> disabled by mounting the filesystem (using a kernel with the ext4
> patch queue) with the mount options -O nomballoc or -O nodelalloc.
>
> If it turns out that nomballoc restores the speed for afdbench, for
> example, then it will tell us where we need to look more closely.
> Ideally we would not want to have one mount option needed to optimize
> filesystem operations for large amoutns of modifications to small
> files, and another mode of operation when mostly writing to large
> files.  So if you could do a round of tests using the ext4 patch queue
> kernel, with -O nomballoc and -O nodelalloc (and if both seem to
> improve things, try "-O nomballoc,nodelalloc" and see if you get back
> to the pre-ext4 patch queue speed), it would be very much appreciated.
>
Here the results:
                                      +---------+------------+
                                      | afdbench|   bonnie++ |
                                      +---------+--------+---+
                                      |file rate| block w|%CP|
-------------------------------------+---------+--------+---+
ext3                                 | 5536.79 | 212350 | 92|
ext4-patch-queue                     | 5054.86 | 244384 | 50|
ext4-patch-queue-nodelalloc          | 4943.78 | 225819 | 92|
ext4-patch-queue-nomballoc           | 3123.49 | 244535 | 52|
ext4-patch-queue-nomballoc-nodelalloc| 4931.09 | 231332 | 91|
-------------------------------------+---------+--------+---+

Test where done with 2.6.26-rc8 and
ext4-patch-queue-52c8a02a8a7b7e5915b9301e9c171b4faf22b928.tar.gz,
e2fsprogs is from git (27th April 2008). ext4 filesystem was created
with 'mke2fs -m 0 -t ext4dev /dev/md7' and ext3 'mke2fs -m 0 -j /dev/md7'.
Common mount options are: noatime,nodiratime,commit=15

Looking at the afdbench results I also notice that when I just take
the FTP results the results look as follows:

ext3                                 : 3465.50
ext4-patch-queue                     : 2785.58
ext4-patch-queue-nodelalloc          : 2677.39
ext4-patch-queue-nomballoc           :  219.12
ext4-patch-queue-nomballoc-nodelalloc: 2566.24

Now one can see the drop with ext4-patch-queue much clearer. The testing
of afdbench is done in two parts, one where we just link lots of small
files locally and the same test is then repeated using a network protocol
in this case FTP. So the difference is that for the filesystem lots
of new files get created. Further testing showed that when I increase
the number FTP process performance decreases in all cases but much more
for ext4-patch-queue (nearly 50% drop against ext3) as the following results
show:

ext3                                 : 2352.89
ext4-patch-queue                     : 1226.55
ext4-patch-queue-nodelalloc          : 1340.80
ext4-patch-queue-nomballoc-nodelalloc: 1181.12

I did not do the ext4-patch-queue-nomballoc test since there is obviously
something wrong here when you look at the numbers above (219.12 fps).
During that test I notice that when you try to open an existing file
with vi it can take several minutes before it opens this file. The strange
thing is that vi was not in D-state but it could not be killed, even root
could not kill it with -9.

There is also some corruption in filesystem during the test with
ext4-patch-queue and ext4-patch-queue-nomballoc. It happens when after
the test I umount the test filesystem and then mount it again the
following message appears:

root@athena:~# umount /home
root@athena:~# mount /home
mount: wrong fs type, bad option, bad superblock on /dev/md7,
        missing codepage or helper program, or other error
        In some cases useful info is found in syslog - try
        dmesg | tail  or so

EXT4-fs: ext4_check_descriptors: Inode bitmap for group 256 not in group (block 117835012)!<3>EXT4-fs: group descriptors corrupted!

Using fsck this problem could be corrected. Now that one does not think I
did those test on a corrupted file system. The filesystem was newly created
for each of the above five test runs.

Regards,
Holger

