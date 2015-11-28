From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: found an error that e2fsck does not fix
Date: Sat, 28 Nov 2015 13:49:55 -0800
Message-ID: <20151128214955.GC10580@birch.djwong.org>
References: <alpine.DEB.2.10.1511272003250.1707@suiko.acc.umu.se>
 <20151128122747.GA2836@thunk.org>
 <alpine.DEB.2.10.1511281855120.13844@suiko.acc.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Bo Branten <bosse@acc.umu.se>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35012 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbbK1VuP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 28 Nov 2015 16:50:15 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1511281855120.13844@suiko.acc.umu.se>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 28, 2015 at 07:08:49PM +0100, Bo Branten wrote:
> 
> Hello,
> 
> first I want to say that we have found the bug: ext4_ext_tree_init
> was only called when first extending the file and not at create
> time.

Looks like i_block[] is zeroed, so when e2fsck opens the extent tree in
check_blocks, ext2fs_extent_open2() adds the extent tree header, which causes
the header check to pass.  Nothing ever writes out the inode, so the new header
isn't written to the filesystem.

Since the kernel expects to find an extent header if the inode flag is set,
I'll fix up e2fsck to zap an inode if the flag is set and no header is found.

Thank you for the tiny image file, that makes it very easy to create a
regression test!

--D

> 
> However e2fsck 1.42.13 (17-May-2015) does not fix the error so I
> have created the test images you asked for:
> 
> /* create test fs */
> sudo dd bs=1024 count=1024 if=/dev/zero of=/dev/sdb5
> sudo mke2fs -b 4096 /dev/sdb5 1M
> sudo tune2fs -O extents /dev/sdb5
> 
> /* reboot to Windows and create file 'testa' and 'testb' */
> 
> /* create the images attached */
> sudo dd bs=1024 count=1024 if=/dev/sdb5 of=ext4.img
> sudo e2image -r /dev/sdb5 - | bzip2 > sdb5.e2i.bz2
> 
> /* then try the fs from Linux */
> bo@ubuntu:~$ sudo mount -t ext4 /dev/sdb5 /mnt
> bo@ubuntu:~$ ls -l /mnt
> ls: cannot access /mnt/testa: Input/output error
> total 20
> drwx------ 2 root root 16384 Nov 28 18:09 lost+found
> -????????? ? ?    ?        ?            ? testa
> -rw-r--r-- 1 root root     1 Nov 28 18:15 testb
> bo@ubuntu:~$ cat /mnt/testa
> cat: /mnt/testa: Input/output error
> bo@ubuntu:~$ cat /mnt/testb
> bo@ubuntu:~$ sudo umount /mnt
> bo@ubuntu:~$ sudo ~bo/src/e2fsprogs-1.42.13/e2fsck/e2fsck -fy /dev/sdb5
> e2fsck 1.42.13 (17-May-2015)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> /dev/sdb5: 13/128 files (0.0% non-contiguous), 15/256 blocks
> bo@ubuntu:~$ sudo ~bo/src/e2fsprogs-1.42.13/e2fsck/e2fsck -fy /dev/sdb5
> e2fsck 1.42.13 (17-May-2015)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> /dev/sdb5: 13/128 files (0.0% non-contiguous), 15/256 blocks
> bo@ubuntu:~$ sudo mount -t ext4 /dev/sdb5 /mnt
> bo@ubuntu:~$ ls -l /mnt
> ls: cannot access /mnt/testa: Input/output error
> total 20
> drwx------ 2 root root 16384 Nov 28 18:09 lost+found
> -????????? ? ?    ?        ?            ? testa
> -rw-r--r-- 1 root root     1 Nov 28 18:15 testb
> bo@ubuntu:~$ cat /mnt/testa
> cat: /mnt/testa: Input/output error
> bo@ubuntu:~$ cat /mnt/testb
> bbo@ubuntu:~$ bbo@ubuntu:~$ dmesg|tail
> [ 1376.496018] wlan0: associate with ec:43:f6:37:14:14 (try 1/3)
> [ 1376.501718] wlan0: RX AssocResp from ec:43:f6:37:14:14 (capab=0xc11 status=0 aid=3)
> [ 1376.501967] wlan0: associated
> [ 1407.949284] EXT4-fs (sdb5): mounted filesystem without journal. Opts: (null)
> [ 1420.748311] EXT4-fs error (device sdb5): ext4_ext_check_inode:464: inode #12: comm ls: bad header/extent: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
> [ 1429.169785] EXT4-fs error (device sdb5): ext4_ext_check_inode:464: inode #12: comm bash: bad header/extent: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
> [ 1430.328150] EXT4-fs error (device sdb5): ext4_ext_check_inode:464: inode #12: comm cat: bad header/extent: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
> [ 1457.061338] EXT4-fs (sdb5): mounted filesystem without journal. Opts: (null)
> [ 1469.698684] EXT4-fs error (device sdb5): ext4_ext_check_inode:464: inode #12: comm ls: bad header/extent: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
> [ 1474.838003] EXT4-fs error (device sdb5): ext4_ext_check_inode:464: inode #12: comm cat: bad header/extent: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
> bo@ubuntu:~$



