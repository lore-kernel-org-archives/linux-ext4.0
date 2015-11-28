From: Bo Branten <bosse@acc.umu.se>
Subject: Re: found an error that e2fsck does not fix
Date: Sat, 28 Nov 2015 19:08:49 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1511281855120.13844@suiko.acc.umu.se>
References: <alpine.DEB.2.10.1511272003250.1707@suiko.acc.umu.se> <20151128122747.GA2836@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-276651502-1242803360-1448734129=:13844"
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.acc.umu.se ([130.239.18.156]:56288 "EHLO mail.acc.umu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbbK1SIx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Nov 2015 13:08:53 -0500
In-Reply-To: <20151128122747.GA2836@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---276651502-1242803360-1448734129=:13844
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII


Hello,

first I want to say that we have found the bug: ext4_ext_tree_init was 
only called when first extending the file and not at create time.

However e2fsck 1.42.13 (17-May-2015) does not fix the error so I have 
created the test images you asked for:

/* create test fs */
sudo dd bs=1024 count=1024 if=/dev/zero of=/dev/sdb5
sudo mke2fs -b 4096 /dev/sdb5 1M
sudo tune2fs -O extents /dev/sdb5

/* reboot to Windows and create file 'testa' and 'testb' */

/* create the images attached */
sudo dd bs=1024 count=1024 if=/dev/sdb5 of=ext4.img
sudo e2image -r /dev/sdb5 - | bzip2 > sdb5.e2i.bz2

/* then try the fs from Linux */
bo@ubuntu:~$ sudo mount -t ext4 /dev/sdb5 /mnt
bo@ubuntu:~$ ls -l /mnt
ls: cannot access /mnt/testa: Input/output error
total 20
drwx------ 2 root root 16384 Nov 28 18:09 lost+found
-????????? ? ?    ?        ?            ? testa
-rw-r--r-- 1 root root     1 Nov 28 18:15 testb
bo@ubuntu:~$ cat /mnt/testa
cat: /mnt/testa: Input/output error
bo@ubuntu:~$ cat /mnt/testb
bo@ubuntu:~$ sudo umount /mnt
bo@ubuntu:~$ sudo ~bo/src/e2fsprogs-1.42.13/e2fsck/e2fsck -fy /dev/sdb5
e2fsck 1.42.13 (17-May-2015)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/sdb5: 13/128 files (0.0% non-contiguous), 15/256 blocks
bo@ubuntu:~$ sudo ~bo/src/e2fsprogs-1.42.13/e2fsck/e2fsck -fy /dev/sdb5
e2fsck 1.42.13 (17-May-2015)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/sdb5: 13/128 files (0.0% non-contiguous), 15/256 blocks
bo@ubuntu:~$ sudo mount -t ext4 /dev/sdb5 /mnt
bo@ubuntu:~$ ls -l /mnt
ls: cannot access /mnt/testa: Input/output error
total 20
drwx------ 2 root root 16384 Nov 28 18:09 lost+found
-????????? ? ?    ?        ?            ? testa
-rw-r--r-- 1 root root     1 Nov 28 18:15 testb
bo@ubuntu:~$ cat /mnt/testa
cat: /mnt/testa: Input/output error
bo@ubuntu:~$ cat /mnt/testb
bbo@ubuntu:~$ 
bbo@ubuntu:~$ dmesg|tail
[ 1376.496018] wlan0: associate with ec:43:f6:37:14:14 (try 1/3)
[ 1376.501718] wlan0: RX AssocResp from ec:43:f6:37:14:14 (capab=0xc11 status=0 aid=3)
[ 1376.501967] wlan0: associated
[ 1407.949284] EXT4-fs (sdb5): mounted filesystem without journal. Opts: (null)
[ 1420.748311] EXT4-fs error (device sdb5): ext4_ext_check_inode:464: inode #12: comm ls: bad header/extent: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
[ 1429.169785] EXT4-fs error (device sdb5): ext4_ext_check_inode:464: inode #12: comm bash: bad header/extent: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
[ 1430.328150] EXT4-fs error (device sdb5): ext4_ext_check_inode:464: inode #12: comm cat: bad header/extent: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
[ 1457.061338] EXT4-fs (sdb5): mounted filesystem without journal. Opts: (null)
[ 1469.698684] EXT4-fs error (device sdb5): ext4_ext_check_inode:464: inode #12: comm ls: bad header/extent: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
[ 1474.838003] EXT4-fs error (device sdb5): ext4_ext_check_inode:464: inode #12: comm cat: bad header/extent: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
bo@ubuntu:~$
---276651502-1242803360-1448734129=:13844
Content-Type: APPLICATION/octet-stream; name=ext4-bb.img.bz2
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.10.1511281908490.13844@suiko.acc.umu.se>
Content-Description: 
Content-Disposition: attachment; filename=ext4-bb.img.bz2

QlpoOTFBWSZTWds2bx4AACb///7/9TDgvQBIdMDLsD9H7kTgAE4CBgAQAEQI
QEDgpqxYsAGNomaGiJqnmpqDRpoyPSaaaAMmBAaNpPQjQaDQfqT1M9Uw00qn
+lTIaaaZNDEMmhkMgZMQGmIGjTEaYQPJBFKKeUNNDQAABoAAAAAAAAAaRNcS
sUyF6F4SVqW+9BBKUV41LeSlFHRDgBZ5ggoyItyBFlgBOGKdneEoAxCg3cIi
qLrUGacKEWgqDWKCSZRSFsQCVoRmcGMgu4FCfhzS46BGzIzqF7RnQRVWeAWl
CbNXIqUIEts2RFFVaqKBDgQMkISwzQyV8SU4UKMI0oRrYRRVWUsKWl44s79f
dYShjEFh3/spNTkDJhsyqL6UkgRiAxEGFUOYGI+C4hBUnK9hf1Qw0oeOtZdg
PtAV46PyyYiwb3r8MMEhnJkfK9dte30XKVQIMtt8PAkAoSCCU3Q7zYxiRii9
Vy/fGPvFjY7HCgSXRGV3UMWBQ/XdV4N2nyEe+3AbiJUCeuihh/R5TaxX+Q5T
IocOWvkShJ2Q/EhBkYw4LqpPUnOmEmhEFVYVeSAAkgAD6Fak2YXckU4UJDbN
m8eA

---276651502-1242803360-1448734129=:13844
Content-Type: APPLICATION/octet-stream; name=sdb5.e2i.bz2
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.10.1511281908491.13844@suiko.acc.umu.se>
Content-Description: 
Content-Disposition: attachment; filename=sdb5.e2i.bz2

QlpoOTFBWSZTWbmXWRsAACT///7/9TDgrQBIdsDLsD9H7kTgAE4CBgAQAEQI
QEDgpqxYsAFto2mGhCm0p6T1NGQDQBoNANPUAaaPU0AaM1MnpPUeKENSp7Sm
NJkwh6T0RkwEMAQAMDSYBDT9UwZQRSQoxA01ME0wBqYACZAwACMAA0BDMtTo
3iFu00UnWOvNq1abBbYjrUUmq+FkQomQDDBFXhQZoUDdivW+xMoJfwiICsqb
PQSGWYgy5QZRhzg2GuEBHXDWSsyhNBBnsC4SGAUdl6+afrmRGKq2UAtWE/dn
IUqQJWzpIoqrPFQhwoGUITQ0QytolkQIWsI1YRpwiiqsxb1dPrx7JselImCu
QW/T7TFGRIMqGsTmDMSgSeAngpUYDUFmLxsMEIKyS35soLGM/98vayL3cVKe
L9LLAa13bNd8AEsk1OBHkGx6YUOhBkZOtuFvIAiBgECNLnESlK4Bei+G1LuE
YIsMbknYgpOCQocgxYGn+OVGibQeISVpvI1pTjV06yRnfOU5o2TkN8yK1cls
fykUcAehRDIxc882ehPQHoZCiEQVVhV4IACUAAWBX4o+RdyRThQkLmXWRsA=

---276651502-1242803360-1448734129=:13844--
