From: Regan Wallace <regan@reganw.com>
Subject: Filesystem recovery - e2fsck seems to have caused my filesystem to
 get wiped
Date: Wed, 30 Oct 2013 07:08:07 -0600 (MDT)
Message-ID: <1829785915.95.1383138487671.JavaMail.root@reganw.com>
References: <868818551.88.1383137282029.JavaMail.root@reganw.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.reganw.com ([209.161.6.2]:35722 "EHLO mail.reganw.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab3J3NI1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Oct 2013 09:08:27 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.reganw.com (Postfix) with ESMTP id 5A22F90EE82
	for <linux-ext4@vger.kernel.org>; Wed, 30 Oct 2013 07:08:26 -0600 (MDT)
Received: from mail.reganw.com ([127.0.0.1])
	by localhost (mail.reganw.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l2n0Gx3Ye45l for <linux-ext4@vger.kernel.org>;
	Wed, 30 Oct 2013 07:08:08 -0600 (MDT)
Received: from mail.reganw.com (mail.reganw.com [209.161.6.2])
	by mail.reganw.com (Postfix) with ESMTP id 02C6990EE81
	for <linux-ext4@vger.kernel.org>; Wed, 30 Oct 2013 07:08:07 -0600 (MDT)
In-Reply-To: <868818551.88.1383137282029.JavaMail.root@reganw.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, 

Emailing this list as a last ditch effort to try and fix my ext4 filesystem. 
If there is a better or more appropriate place to ask this question, I apologize for the inconvenience, I would greatly appreciate being pointed in the right direction. 

I have detailed everything on serverfault here: http://serverfault.com/q/548582/196218 

But long story short, I have an ext4 filesystem on luks on raid 5. I expanded my local storage as I've done many times before, by growing my raid volume, growing the luks container, and lastly resize2fs on the filesystem. 

However, before being able to run resize2fs I was informed to fsck. When I ran e2fsck -y on the unmounted filesystem (big mistake), it deleted several hundred possibly thousands of "unused inodes" before I killed it. It happened fast and under sleep deprivation Now I'm left with a partial filesystem after creating an image and using mkfs.ext4 -S to make it mountable somewhat. 
I'm hoping there is a possible alternate method I haven't tried that may have better chance of recovery of more data. 

If I can be of any use in determining the cause of this to happen, that would at least give me a bit of solace to help prevent it happening to someone else. 


Thanks in advance, 

-Regan 



Below is a copy from serverfault, if one prefers to read it here directly: 

------------------------------------------------------------------------------

I have an ext4 filesystem on luks over software raid5. The filesystem was operating "just fine" for several years when I was beginning to run out of space. I had a 9T volume on 6x2T drives. I began upgrading to 3T drives by doing the mdadm fail, remove, add, rebuild, repeat process until I had a larger array. 
I then grew the luks container, and then when I unmounted and tried to resize2fs I was given the message the filesystem was dirty and needed e2fsck. 

Without thinking I just did e2fsck -y /dev/mapper/candybox and it began spewing all kinds of inode being removed type messages (can't remember exactly) I killed e2fsck and tried to remount the filesystem to backup data I was concerned about. When trying to mount at this point I get: 


> # mount /dev/mapper/candybox /candybox 
> mount: wrong fs type, bad option, bad superblock on /dev/mapper/candybox, 
> missing codepage or helper program, or other error 
> In some cases useful info is found in syslog - try 
> dmesg | tail or so 

Looking back at my older logs I noticed the filesystem was giving this error each time the machine booted: 

> kernel: [79137.275531] EXT4-fs (dm-2): warning: mounting fs with errors, running e2fsck is recommended 

So shame on me for not paying attention :( 

I then tried to mount using every backup superblock (one after another) and each attempt left this in my log: 

> EXT4-fs (dm-2): ext4_check_descriptors: Checksum for group 0 failed (26534!=65440) 
> EXT4-fs (dm-2): ext4_check_descriptors: Checksum for group 1 failed (38021!=36729) 
> EXT4-fs (dm-2): ext4_check_descriptors: Checksum for group 2 failed (18336!=39845) 
> ... 
> EXT4-fs (dm-2): ext4_check_descriptors: Checksum for group 11911 failed (28743!=44098) 
> BUG: soft lockup - CPU#0 stuck for 23s! [mount:2939] 


Attempts to restart e2fsck results in: 

> # e2fsck /dev/mapper/candybox 
> e2fsck 1.41.14 (22-Dec-2010) 
> e2fsck: Group descriptors look bad... trying backup blocks... 
> candy: recovering journal 
> e2fsck: unable to set superblock flags on candy 


At this point, I decided it best to order some more drives and make an image using `ddrescue` 
Now two weeks later I have an image of the luks partition in a .img file. 

> # ls -lh 
> total 14T 
> -rw-r--r-- 1 root root 14T Oct 25 01:57 candybox.img 
> -rw-r--r-- 1 root root 271 Oct 20 14:32 candybox.logfile 


After numerous attempts using everything I could find online I could not coerce e2fsck to do anything on the image, so I used `mkfs.ext4 -L candy candybox.img -m 0 -S` and I was able to mount the dirty filesystem readonly without the journal and recover 960G of data. It gave all kinds of errors of various directories not existing and so forth but I was able to get *some* stuff. Which gave me some hope! 

I then ran e2fsck again and it had to recreate the root inode and gave a massive list of correcting group counts, I accepted the root inode creation and said no to everything else, leaving a completely empty filesystem. Re-ran again and said yes to all questions with the same result but now a "clean" but empty filesystem. 

extundelete gives me `0 recoverable inodes found.` 

And now I'm stuck again, I can't come up with any other methods other than dropping to something like photorec which will give me an absolute mess with how large the filesystem was. 
I'm willing to re-copy the image from the original array and start over, if I can get any suggestions or ideas on a way to get more of my files back. 

I wish I could give more detailed logs of the commands that have run, but the output is long scrolled passed except for what gets logged to syslog and my memory is not as detailed, due to the timeframe this has occurred over. 

Any help is greatly appreciated! 

Update Oct 27 
I've fully recopied the image to start testing on again, and here is the output so far. 

The copy process: 

> [root@gamma rescue]# nbd-client 172.16.10.204 2000 /dev/nbd0 
> Negotiation: ..size = 14307292MB 
> bs=1024, sz=15002283540480 bytes 
> [root@gamma rescue]# cryptsetup luksOpen /dev/nbd0 candybox 
> Enter passphrase for /dev/nbd0: 
> [root@gamma mnt]# pvcreate /dev/md5 
> Physical volume "/dev/md5" successfully created 
> [root@gamma mnt]# pvscan 
> PV /dev/md5 lvm [18.19 TiB] 
> Total: 1 [18.19 TiB] / in use: 0 [0 ] / in no VG: 1 [18.19 TiB] 
> [root@gamma mnt]# vgcreate vg-rescue /dev/md5 
> Volume group "vg-rescue" successfully created 
> [root@gamma mnt]# lvcreate --size 15T --name lv-rescue vg-rescue 
> Logical volume "lv-rescue" created 
> [root@gamma mnt]# mkfs.xfs /dev/vg-rescue/lv-rescue 
> log stripe unit (524288 bytes) is too large (maximum is 256KiB) 
> log stripe unit adjusted to 32KiB 
> meta-data=/dev/vg-rescue/lv-rescue isize=256 agcount=33, agsize=125828992 blks 
> = sectsz=512 attr=2 
> data = bsize=4096 blocks=4026531840, imaxpct=5 
> = sunit=128 swidth=640 blks 
> naming =version 2 bsize=4096 ascii-ci=0 
> log =internal log bsize=4096 blocks=521728, version=2 
> = sectsz=512 sunit=8 blks, lazy-count=1 
> realtime =none extsz=4096 blocks=0, rtextents=0 
> [root@gamma mnt]# mount /dev/vg-rescue/lv-rescue rescue/ 
> [root@gamma rescue]# ddrescue /dev/mapper/candybox candybox.img candybox.ddlog 
> 
> 
> Press Ctrl-C to interrupt 
> Initial status (read from logfile) 
> rescued: 0 B, errsize: 0 B, errors: 0 
> Current status 
> rescued: 13194 GB, errsize: 1807 GB, current rate: 0 B/s 
> ipos: 13194 GB, errors: 1, average rate: 73528 kB/s 
> opos: 13194 GB, time from last successful read: 44 s 
> ^Clitting failed blocks... 
> Interrupted by user 
> ## Network hung, had to try again here 
> [regan@gamma ~]$ sudo nbd-client -d /dev/nbd0 
> Disconnecting: que, disconnect, Error: Ioctl failed: Invalid argument 
> 
> Exiting. 
> [regan@gamma ~]$ sudo nbd-client 172.16.10.204 2000 /dev/nbd0 
> Negotiation: ..size = 14307292MB 
> bs=1024, sz=15002283540480 bytes 
> 
> [root@gamma rescue]# ddrescue -r 2 /dev/mapper/candybox candybox.img candybox.ddlog 
> 
> 
> Press Ctrl-C to interrupt 
> Initial status (read from logfile) 
> rescued: 15002 GB, errsize: 7426 kB, errors: 60 
> Current status 
> rescued: 15002 GB, errsize: 0 B, current rate: 77529 kB/s 
> ipos: 15002 GB, errors: 0, average rate: 69297 kB/s 
> opos: 15002 GB, time from last successful read: 0 s 
> Finished 
> 
> [root@gamma rescue]# lvcreate -l 100%FREE -s -n rescue_snap /dev/vg-rescue/lv-rescue 
> Logical volume "rescue_snap" created 
> [root@gamma rescue]# cd .. 
> [root@gamma mnt]# mount -o remount,ro rescue/ 
> [root@gamma mnt]# mkdir rescue_snap 
> [root@gamma mnt]# mount -o nouuid /dev/vg-rescue/rescue_snap rescue_snap 
> [root@gamma mnt]# cd rescue_snap/ 
> [root@gamma rescue_snap]# ls 
> candybox.ddlog candybox.img 
> 

The mess: 

> [root@gamma rescue_snap]# mkfs.ext4 -L candy candybox.img -m 0 -S 
> mke2fs 1.41.10 (10-Feb-2009) 
> candybox.img is not a block special device. 
> Proceed anyway? (y,n) y 
> Filesystem label=candy 
> OS type: Linux 
> Block size=4096 (log=2) 
> Fragment size=4096 (log=2) 
> Stride=0 blocks, Stripe width=0 blocks 
> 915668992 inodes, 3662666368 blocks 
> 0 blocks (0.00%) reserved for the super user 
> First data block=0 
> Maximum filesystem blocks=4294967296 
> 111776 block groups 
> 32768 blocks per group, 32768 fragments per group 
> 8192 inodes per group 
> Superblock backups stored on blocks: 
> 32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
> 4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968, 
> 102400000, 214990848, 512000000, 550731776, 644972544, 1934917632, 
> 2560000000 
> 
> Skipping journal creation in super-only mode 
> Writing superblocks and filesystem accounting information: done 
> 
> This filesystem will be automatically checked every 26 mounts or 
> 180 days, whichever comes first. Use tune2fs -c or -i to override. 
> 
> [root@gamma rescue_snap]# mount -o loop candybox.img /mnt2 
> [root@gamma rescue_snap]# df -h 
> Filesystem Size Used Avail Use% Mounted on 
> /dev/md2 147G 138G 3.1G 98% / 
> tmpfs 16G 5.7M 16G 1% /dev/shm 
> /dev/md0 494M 199M 276M 42% /boot 
> /dev/sdc1 1.8T 979G 763G 57% /mnt/macmirror 
> /dev/sdj1 1.8T 970G 771G 56% /mnt/usbrescue 
> /dev/mapper/vg--rescue-lv--rescue 
> 15T 14T 1.4T 91% /mnt/rescue 
> /dev/mapper/vg--rescue-rescue_snap 
> 15T 14T 1.4T 91% /mnt/rescue_snap 
> /mnt/rescue_snap/candybox.img 
> 14T 15M 14T 1% /mnt2 
> 
> ## Even though it says only 15M is used, I was able to rsync 960G to /mnt/usbrescue 
> 
> [root@gamma rescue_snap]# cd /mnt2/ 
> [root@gamma mnt2]# ls -l 
> ls: cannot access Fedora-19-x86_64-DVD: Input/output error 
> ls: cannot access rsync_batch: Input/output error 
> ls: cannot access shell1: Input/output error 
> ls: cannot access New Folder (2): Input/output error 
> ls: cannot access shell2: Input/output error 
> ls: cannot access revolution: Input/output error 
> ls: cannot access mail: Input/output error 
> ls: cannot access testing: Input/output error 
> ls: cannot access export: Input/output error 
> ls: cannot access ben_backup_20130903: Input/output error 
> total 160488672 
> drwxr-xr-x 2 regan regan 4096 Sep 3 20:16 100MEDIA 
> drwxr-xr-x 19 regan regan 4096 Sep 26 05:18 android 
> d?????????? ? ? ? ? ? ben_backup_20130903 
> -rw-rw-r-- 1 regan regan 12126 Jan 4 2013 durations.txt 
> d?????????? ? ? ? ? ? export 
> drwxrwxr-x 10 regan regan 4096 Dec 29 2012 family-pc_20121229 
> d?????????? ? ? ? ? ? Fedora-19-x86_64-DVD 
> -rw-r--r-- 1 regan regan 72116729363 Sep 30 04:39 gamma_backup_20130928.tgz 
> -rw-rw-r-- 1 regan regan 55606528323 Jul 27 2011 gamma_tar_20110727.tbz2 
> -rw-rw-r-- 1 regan regan 3839 Sep 27 2012 Good Quality2.plist 
> -rw-rw-r-- 1 regan regan 4663 Oct 7 2012 Good Quality3.plist 
> -rw-rw-r-- 1 regan regan 3852 Sep 26 2012 Good Quality.plist 
> drwxr-xr-x 7 regan regan 4096 Nov 13 2012 grok 
> d?????????? ? ? ? ? ? HardDisks 
> -rwxr--r-- 1 regan regan 54248 Mar 16 2013 IMAG0868.jpg 
> -rwxr--r-- 1 regan regan 51156 Mar 16 2013 IMAG0869.jpg 
> -rwxr--r-- 1 regan regan 85912 Mar 16 2013 IMAG0870.jpg 
> -rwxr--r-- 1 regan regan 76875 Mar 16 2013 IMAG0872.jpg 
> -rwxr--r-- 1 regan regan 68451 Mar 16 2013 IMAG0873.jpg 
> -rwxr--r-- 1 regan regan 59587 Mar 16 2013 IMAG0874.jpg 
> -rwxr--r-- 1 regan regan 81232 Mar 16 2013 IMAG0875.jpg 
> -rwxr--r-- 1 regan regan 44211 Mar 16 2013 IMAG0876.jpg 
> -rwxr--r-- 1 regan regan 41660 Mar 16 2013 IMAG0877.jpg 
> -rwxr--r-- 1 regan regan 36778 Mar 16 2013 IMAG0878.jpg 
> -rwxr--r-- 1 regan regan 76964 Mar 16 2013 IMAG0879.jpg 
> -rwxr--r-- 1 regan regan 81876 Mar 16 2013 IMAG0880.jpg 
> -rwxr--r-- 1 regan regan 1568002 Mar 16 2013 IMAG0953.jpg 
> -rwxr--r-- 1 regan regan 1548566 Mar 16 2013 IMAG0954.jpg 
> -rwxr--r-- 1 regan regan 1351743 Mar 16 2013 IMAG0955.jpg 
> -rwxr--r-- 1 regan regan 1750128 Mar 16 2013 IMAG0956.jpg 
> -rwxr--r-- 1 regan regan 1694378 Mar 16 2013 IMAG0957.jpg 
> -rwxr--r-- 1 regan regan 1277128 Mar 16 2013 IMAG0958.jpg 
> -rwxr--r-- 1 regan regan 1467452 Mar 16 2013 IMAG0965.jpg 
> -rwxr--r-- 1 regan regan 1595903 Mar 16 2013 IMAG0966.jpg 
> -rwxr--r-- 1 regan regan 1372444 Mar 16 2013 IMAG0967.jpg 
> -rwxr--r-- 1 regan regan 1698010 Mar 16 2013 IMAG0968.jpg 
> -rwxr--r-- 1 regan regan 1550641 Mar 16 2013 IMAG0969.jpg 
> -rwxr--r-- 1 regan regan 1333768 Mar 16 2013 IMAG0970.jpg 
> -rwxr--r-- 1 regan regan 1432347 Mar 16 2013 IMAG1010.jpg 
> -rwxr--r-- 1 regan regan 1668159 Mar 16 2013 IMAG1013.jpg 
> -rwxr--r-- 1 regan regan 1657058 Mar 16 2013 IMAG1014.jpg 
> -rwxr--r-- 1 regan regan 1496547 Mar 16 2013 IMAG1016.jpg 
> -rwxr--r-- 1 regan regan 1609156 Mar 16 2013 IMAG1017.jpg 
> -rwxr--r-- 1 regan regan 1604832 Mar 16 2013 IMAG1019.jpg 
> -rwxr--r-- 1 regan regan 2048916 Mar 16 2013 IMAG1073.jpg 
> -rwxr--r-- 1 regan regan 2006024 Mar 16 2013 IMAG1074.jpg 
> -rwxr--r-- 1 regan regan 1926686 Mar 16 2013 IMAG1075.jpg 
> -rw-r--r-- 1 regan regan 1583090 Jul 14 21:15 IMAG1565.jpg 
> -rw-r--r-- 1 regan regan 1435031 Sep 22 05:19 IMAG1762.jpg 
> -rw-r--r-- 1 regan regan 1531602 Sep 22 05:19 IMAG1763.jpg 
> -rw-r--r-- 1 regan regan 1450926 Sep 22 05:19 IMAG1764.jpg 
> -rw-r--r-- 1 regan regan 1336103 Sep 23 21:31 IMAG1765.jpg 
> -rw-r--r-- 1 regan regan 1235885 Sep 23 21:32 IMAG1766.jpg 
> -rw-r--r-- 1 regan regan 1224376 Sep 23 21:32 IMAG1767.jpg 
> -rw-r--r-- 1 regan regan 1235229 Sep 23 21:32 IMAG1768.jpg 
> drwxrwxr-x 2 regan regan 4096 Mar 9 2013 jakeanmal 
> -rw-rw-rw- 1 regan regan 115228 Oct 29 2009 jj_nas 
> drwx------. 2 root root 16384 Nov 8 2012 lost+found 
> -rw-r--r-- 1 regan regan 3123877728 Nov 6 2010 luridmirror_20090806.tar.xz 
> -rw-r--r-- 1 regan regan 2877033943 Mar 1 2013 macabre_20130301.tgz 
> d?????????? ? ? ? ? ? mail 
> -rw-r--r-- 1 root root 6771 Aug 10 2009 mail_mirror 
> -rw------- 1 regan regan 21913047552 Apr 4 2013 mallorys_hdd.vbox.img 
> d?????????? ? ? ? ? ? MSDN 
> -rw-r--r-- 1 regan regan 8572 May 10 2010 Music 
> d?????????? ? ? ? ? ? New Folder (2) 
> drwxrwxrwx 24 regan regan 4096 Mar 22 2013 onyx 
> drwxr-xr-x 231 regan regan 24576 Sep 30 09:29 ptp 
> -rwxr--r-- 1 regan regan 483328 Jan 26 2013 putty.exe 
> d?????????? ? ? ? ? ? revolution 
> -rw-r--r-- 1 root root 6272757760 Oct 16 2012 root.tar 
> d?????????? ? ? ? ? ? rsync_batch 
> drwxrwxr-x 2 regan regan 12288 Oct 6 04:09 saber 
> drwxrwxr-x 2 regan regan 188416 Sep 25 04:20 session_tmp 
> d?????????? ? ? ? ? ? shell1 
> d?????????? ? ? ? ? ? shell2 
> d?????????? ? ? ? ? ? testing 
> drwxrwxr-x 3 regan regan 4096 Oct 7 2012 tofix 
> -rwxr--r-- 1 regan regan 64991966 Jan 2 2013 VIDEO0041.mp4 
> 
> [root@gamma mnt2]# cd .. 
> [root@gamma /]# umount /mnt2 
> [root@gamma /]# cd /mnt/rescue_snap/ 
> [root@gamma rescue_snap]# e2fsck candybox.img 
> e2fsck 1.41.10 (10-Feb-2009) 
> Backing up journal inode block information. 
> 
> candy contains a file system with errors, check forced. 
> Resize inode not valid. Recreate<y>? yes 
> 
> Pass 1: Checking inodes, blocks, and sizes 
> Pass 2: Checking directory structure 
> Pass 3: Checking directory connectivity 
> Root inode not allocated. Allocate<y>? yes 
> 
> /lost+found not found. Create<y>? yes 
> 
> Pass 4: Checking reference counts 
> Pass 5: Checking group summary information 
> Block bitmap differences: -(9252--9255) <Snip a few dozen MB of text> -(3662666237--3662666238) -3662666240 -(3662666242--3662666244) -(3662666247--3662666249) -3662666253 -(3662666255--3662666256) -3662666259 -3662666262 -3662666264 -(3662666268--3662666271) -3662666276 -3662666281 -3662666285 -3662666294 -(3662666296--3662666297) -3662666301 -3662666307 -3662666309 -3662666311 -3662666313 -3662666316 -(3662666318--3662666319) -3662666324 -(3662666326--3662666328) -(3662666331--3662666332) -3662666334 -(3662666341--3662666342) -3662666344 -(3662666346--3662666347) -3662666349 -(3662666351--3662666352) -3662666354 -3662666357 -3662666362 -(3662666366--3662666367) 
> Fix<y>? yes 
> 
> Free blocks count wrong for group #0 (23517, counted=23516). 
> Fix<y>? 
> 
> Free blocks count wrong (3605188902, counted=3605188901). 
> Fix<y>? yes 
> 
> Free inodes count wrong for group #0 (8191, counted=8190). 
> Fix<y>? yes 
> 
> Directories count wrong for group #0 (1, counted=2). 
> Fix<y>? yes 
> 
> Free inodes count wrong (915668991, counted=915668990). 
> Fix<y>? yes 
> 
> 
> candy: ***** FILE SYSTEM WAS MODIFIED ***** 
> candy: 2/915668992 files (0.0% non-contiguous), 57477467/3662666368 blocks 
> [root@gamma rescue_snap]# mount -o loop candybox.img /mnt2 
> [root@gamma rescue_snap]# ls -l /mnt2 
> total 4 
> drwx------ 2 root root 4096 Oct 27 19:33 lost+found 
> [root@gamma rescue_snap]# 
> 

Note that I now have my backup image in a snapshot, so I can try theories over and over if anyone has some ideas... 
