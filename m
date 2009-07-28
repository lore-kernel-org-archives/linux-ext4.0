From: Fredrik Pettersson <freppe@deimos.nu>
Subject: ext4 problem (Group descriptor checksum invalid)
Date: Tue, 28 Jul 2009 09:46:10 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0907280913200.10651@deimos.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from proxy1.bredband.net ([195.54.101.71]:46625 "EHLO
	proxy1.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbZG1IGz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Jul 2009 04:06:55 -0400
Received: from iph1.telenor.se (195.54.127.132) by proxy1.bredband.net (7.3.140.3)
        id 49F5A15201FF45B4 for linux-ext4@vger.kernel.org; Tue, 28 Jul 2009 09:46:13 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I have a recurring problem that I've run into a few times now. Every time 
it seems to be fixed but then later turns up again, so I figured I would 
check here if anyone knows of a permanent fix or whether it is perhaps 
caused by a bug somewhere in the ext4 code. Sorry in advance for the 
lengthy writeup but I figured I should try to provide all the details as 
I'm not sure what of it is relevant.

I have a software raid 5 array that originally was created with just 3 
disks, each 1TB large. On this array I created an ext4 filesystem using

mke2fs -t ext4 -b 4096 -E stride=16 /dev/md2

I then grew the array (while mounted and in use) by doing

mdadm --add /dev/md2 /dev/sdX1
mdadm --grow /dev/md2 --raid-devices=4 --backup-file=/root/mdadm_grow_backup

After waiting for completion I grew the filesystem as well (still mounted 
and in use)

resize2fs -p /dev/md2

This all went well and after everything was completed I unmounted and did 
an e2fsck -f /dev/md2 which reported no problems. I repeated the growing 
process twice more so that I now have 6 1TB disks in the array. After the 
2nd growing & resizeing I got an error from e2fsck, it was complaining 
that "Group descriptor 0 checksum is invalid", repeated for every group 
descriptor number. After it was fixed by e2fsck everything mounted fine 
though. The final grow & resize did not generate the error.

Now I often (but not always) seem to get that same error again when I 
reboot my server. During boot there will be a complaint from mount that 
/dev/md2 is the wrong fs type or something similar (sorry, didn't capture 
the exact error), and then I have to run e2fsck manually to get it fixed 
and mounted. The following was reported in the log today when I had my 
most recent occurance of the problem:

----
Jul 28 08:58:39 deimos EXT4-fs: ext4_check_descriptors: Block bitmap for 
group 9088 not in group (block 3632981051)!
Jul 28 08:58:39 deimos EXT4-fs: group descriptors corrupted!
----

I did e2fsck manually:


----
deimos ~ # e2fsck /dev/md2
e2fsck 1.41.3 (12-Oct-2008)
e2fsck: Group descriptors look bad... trying backup blocks...
Group descriptor 0 checksum is invalid.  Fix<y>? yes

Group descriptor 1 checksum is invalid.  Fix<y>? yes

Group descriptor 2 checksum is invalid.  Fix<y>? yes

Group descriptor 3 checksum is invalid.  Fix<y>? yes

...
----

I've seen this before, so I add -y to the e2fsck...

----
...


Group descriptor 37258 checksum is invalid.  Fix? yes

Group descriptor 37259 checksum is invalid.  Fix? yes

Group descriptor 37260 checksum is invalid.  Fix? yes

/dev/md2 contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
----

At this point my terminal was flooded with output, but what I can see in 
my 20k lines scrollback is a whole bunch of:

----
Free blocks count wrong for group #30621 (32254, counted=1912).
Fix? yes

Free blocks count wrong for group #30622 (32254, counted=1625).
Fix? yes

Free blocks count wrong for group #30623 (32254, counted=1849).
Fix? yes

Free blocks count wrong for group #30624 (32254, counted=1456).
Fix? yes
----

Followed by some of these:

----
Free inodes count wrong for group #96 (734, counted=1159).
Fix? yes

Directories count wrong for group #96 (826, counted=836).
Fix? yes

Free inodes count wrong for group #97 (5647, counted=6852).
Fix? yes

Directories count wrong for group #97 (117, counted=86).
Fix? yes
----

e2fsck finally completed:

----
/dev/md2: ***** FILE SYSTEM WAS MODIFIED *****
/dev/md2: 14929/305242112 files (85.3% non-contiguous), 
1149206734/1220949920 blocks
deimos ~ # mount /dev/md2
deimos ~ #
----

Filesystem mounted, everything looks fine and as on the previous times 
I've had the problem it seems like I've had no data loss (I hope that is 
true, at least I've not noticed any missing or corrupted files).

Now the question I have is, what is causing this. Is this a known problem 
that is already fixed? What should I do to avoid running into this in the 
future? Was it something that was caused by resize2fs and then never 
properly fixed by the e2fsck runs which is the reason it keeps popping up 
again?

Some versions:

----
deimos ~ # uname -a
Linux deimos 2.6.29-gentoo-r5 #2 SMP Wed Jun 17 20:55:58 CEST 2009 i686 
Intel(R) Pentium(R) 4 CPU 3.00GHz GenuineIntel GNU/Linux
deimos ~ # mdadm --version
mdadm - v2.6.8 - 28th November 2008
deimos ~ # e2fsck -V
e2fsck 1.41.3 (12-Oct-2008)
         Using EXT2FS Library version 1.41.3, 12-Oct-2008
----

I hope there is some resolution for this, even though it seems like I get 
the FS back every time without data loss it is still a bit scary. Thanks 
in advance for any help, and let me know if there is more data I should 
provide.

BR,

/Fredrik Pettersson
